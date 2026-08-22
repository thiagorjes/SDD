"""
SSPDD workspace initializer.
Usage: python init.py --project NAME --path PATH --lang pt_BR|en_US [--platform P] [--skip-rtk]
"""

import argparse
import shutil
import subprocess
import sys
from datetime import date
from pathlib import Path

MIN_PYTHON = (3, 10)

DOCS_SUBDIRS = [
    "prd", "techspec", "tasks", "spdd", "decisions",
    "contracts", "checklists", "design", "discovery",
]


def check_python_version():
    if sys.version_info < MIN_PYTHON:
        print(f"ERRO: Python {MIN_PYTHON[0]}.{MIN_PYTHON[1]}+ necessário. "
              f"Versão atual: {sys.version_info.major}.{sys.version_info.minor}")
        sys.exit(1)


def resolve_source() -> Path:
    return Path(__file__).parent.parent.resolve()


def validate_args(args) -> tuple[Path, Path, str, str, bool]:
    dest = Path(args.path).resolve()

    lang = args.lang
    if lang not in ("pt_BR", "en_US"):
        print(f"[AVISO] Idioma '{lang}' inválido. Usando pt_BR.")
        lang = "pt_BR"

    if dest.exists() and any(dest.iterdir()):
        answer = input(f"[AVISO] '{dest}' já contém arquivos. Continuar? [s/N] ").strip().lower()
        if answer != "s":
            print("Inicialização cancelada.")
            sys.exit(1)

    platform = args.platform or "claude"

    return dest, Path(args.path), lang, platform, args.skip_rtk


def check_rtk(skip: bool) -> str | None:
    if skip:
        return None
    rtk = shutil.which("rtk")
    if rtk is None:
        print(
            "[AVISO] RTK não encontrado. Recomendado para reduzir consumo de tokens em 60-90%.\n"
            "Instale com: brew install rtk  OU  "
            "curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh\n"
            "Execute novamente ou use --skip-rtk para pular."
        )
    return rtk


def create_directory_structure(dest: Path):
    dest.mkdir(parents=True, exist_ok=True)

    for sub in DOCS_SUBDIRS:
        d = dest / "docs" / sub
        d.mkdir(parents=True, exist_ok=True)
        gitkeep = d / ".gitkeep"
        if not gitkeep.exists():
            gitkeep.touch()

    (dest / "memory").mkdir(exist_ok=True)
    (dest / "scripts").mkdir(exist_ok=True)


def copy_agents(source: Path, dest: Path, lang: str):
    agents_src = source / ".agents"
    if not agents_src.exists():
        print(f"[AVISO] Diretório .agents não encontrado em {source}. Pulando cópia.")
        return

    agents_dest = dest / ".agents"

    for subdir in ("skills", "agents", "scripts"):
        src = agents_src / subdir
        dst = agents_dest / subdir
        if src.exists():
            shutil.copytree(src, dst, dirs_exist_ok=True)

    templates_src = agents_src / "templates" / lang
    templates_dest = agents_dest / "templates"
    if templates_src.exists():
        shutil.copytree(templates_src, templates_dest, dirs_exist_ok=True)
    elif (agents_src / "templates").exists():
        shutil.copytree(agents_src / "templates", agents_dest / "templates", dirs_exist_ok=True)


def read_template(source: Path, lang: str, name: str) -> str | None:
    candidates = [
        source / ".agents" / "templates" / lang / name,
        source / ".agents" / "templates" / name,
    ]
    for c in candidates:
        if c.exists():
            return c.read_text(encoding="utf-8")
    return None


def read_skills_info(source: Path) -> list[dict]:
    skills = []
    skills_dir = source / ".agents" / "skills"
    if not skills_dir.exists():
        return skills
    import re
    for skill_dir in sorted(skills_dir.iterdir()):
        skill_md = skill_dir / "SKILL.md"
        if not skill_md.exists():
            continue
        content = skill_md.read_text(encoding="utf-8")
        m = re.search(r'^---\n(.*?)\n---', content, re.DOTALL)
        if not m:
            continue
        fm = m.group(1)
        name_m = re.search(r'^name:\s*(.+)$', fm, re.MULTILINE)
        desc_m = re.search(r'^description:\s*(.+)$', fm, re.MULTILINE)
        if name_m and desc_m:
            skills.append({"name": name_m.group(1).strip(), "description": desc_m.group(1).strip()})
    return skills


def read_agents_info(source: Path) -> list[dict]:
    agents = []
    agents_dir = source / ".agents" / "agents"
    if not agents_dir.exists():
        return agents
    import re
    for agent_md in sorted(agents_dir.glob("*.md")):
        content = agent_md.read_text(encoding="utf-8")
        role_m = re.search(r'^##\s*Role\s*\n(.+)$', content, re.MULTILINE)
        agents.append({
            "name": agent_md.stem,
            "role": role_m.group(1).strip() if role_m else "",
        })
    return agents


def generate_agents_md(source: Path, dest: Path, project_name: str, today: str, lang: str):
    template = read_template(source, lang, "AGENTS.md-template")
    skills = read_skills_info(source)
    agents = read_agents_info(source)

    skills_block = "\n".join(
        f"- **/{s['name']}** — {s['description']}" for s in skills
    ) or "_(skills serão listadas após geração)_"
    agents_block = "\n".join(
        f"- **{a['name']}** — {a['role']}" for a in agents
    ) or "_(agents serão listados após geração)_"

    if template:
        content = (template
                   .replace("{{PROJECT_NAME}}", project_name)
                   .replace("{{DATE}}", today)
                   .replace("{{LANG}}", lang)
                   .replace("{{SKILLS_LIST}}", skills_block)
                   .replace("{{AGENTS_LIST}}", agents_block))
    else:
        content = f"""# AGENTS.md — {project_name}

## Skills disponíveis

{skills_block}

## Pipeline

/guidelines → /prd → [/clarify] → [/checklist] → /techspec → /spdd-canvas → /tasks → [/analyze] → /implement → [/spdd-sync] → /code-review
"""

    (dest / "AGENTS.md").write_text(content, encoding="utf-8")


def generate_claude_md(source: Path, dest: Path, project_name: str, today: str, lang: str):
    template = read_template(source, lang, "CLAUDE.md-template")

    if template:
        content = (template
                   .replace("{{PROJECT_NAME}}", project_name)
                   .replace("{{DATE}}", today)
                   .replace("{{LANG}}", lang))
    else:
        content = f"""# CLAUDE.md — {project_name}

@AGENTS.md
@memory/constitution.md
@memory/state.md
"""

    (dest / "CLAUDE.md").write_text(content, encoding="utf-8")


def generate_comportamento_md(source: Path, dest: Path, project_name: str, today: str, lang: str):
    template = read_template(source, lang, "comportamento.md-template")

    if template:
        content = (template
                   .replace("{{PROJECT_NAME}}", project_name)
                   .replace("{{DATE}}", today)
                   .replace("{{LANG}}", lang))
    else:
        content = "# comportamento.md\n\n_(template não encontrado — preencher manualmente)_\n"

    (dest / "comportamento.md").write_text(content, encoding="utf-8")


def generate_memory(source: Path, dest: Path, project_name: str, today: str, lang: str):
    memory_dir = dest / "memory"

    state_template = read_template(source, lang, "memory/state-template.md")
    if state_template:
        state_content = (state_template
                         .replace("{{PROJECT_NAME}}", project_name)
                         .replace("{{DATE}}", today)
                         .replace("{{LANG}}", lang))
    else:
        state_content = f"""# Estado Operacional — {project_name}
_Atualizado em: {today}_

> Estado atual do workspace e das features em andamento.
> Para princípios estáveis e ADRs, veja [memory/constitution.md](constitution.md).

---

## Toolset

**Versão:** {today}
**Pipeline SSPDD:** /guidelines → /prd → [/clarify] → [/checklist] → /techspec → /spdd-canvas → /tasks → [/analyze] → /implement → [/spdd-sync] → /code-review

---

## Sistemas

| Sistema | Caminho | Cenário | Guidelines | Observações |
|---|---|---|---|---|
| {project_name} | `systems/{project_name}/` | Novo (greenfield) | pendente | — |

---

## Features Ativas

| Feature | Sistemas afetados | PRD | TechSpec | Tasks | Status |
|---|---|---|---|---|---|

---

## Artifact Registry

| Artefato | v | Status |
|---|---|---|

---

## Evolução do SDD

| Data | Mudança |
|---|---|
| {today} | Workspace inicializado via init.py |
"""

    (memory_dir / "state.md").write_text(state_content, encoding="utf-8")

    constitution_template = read_template(source, lang, "memory/constitution-template.md")
    if constitution_template:
        constitution_content = (constitution_template
                                .replace("{{PROJECT_NAME}}", project_name)
                                .replace("{{DATE}}", today)
                                .replace("{{LANG}}", lang))
    else:
        constitution_content = f"""# Constituição — {project_name}
_Criada em: {today}_

> Princípios estáveis, ADRs e decisões de design do workspace.
> Atualizado apenas quando os fundamentos mudarem.

---

## Contexto do Workspace

- **{project_name}** — cenário: Novo (greenfield)
- **Propósito:** _(preencher após /guidelines)_

---

## Decision Records

### ADR

### BDR

### SDR

### DDR

---

## Princípios Estáveis

_(preencher após /guidelines)_
"""

    (memory_dir / "constitution.md").write_text(constitution_content, encoding="utf-8")


def copy_gitignore(source: Path, dest: Path, project_name: str, today: str):
    template_path = source / ".agents" / "templates" / "gitignore-template"
    if template_path.exists():
        content = (template_path.read_text(encoding="utf-8")
                   .replace("{{PROJECT_NAME}}", project_name)
                   .replace("{{DATE}}", today))
    else:
        content = """# SSPDD workspace .gitignore

# Sistemas externos (cada um tem seu próprio repositório)
systems/

# Segredos
.env
.env.*
*.key
*.pem
*.p12

# Artefatos de IDE
.idea/
.vscode/
__pycache__/
*.pyc
.pytest_cache/

# Mantidos explicitamente (não ignorar)
# docs/
# memory/constitution.md
# memory/state.md
"""

    (dest / ".gitignore").write_text(content, encoding="utf-8")


def call_generate_platform(source: Path, dest: Path, platform: str):
    script = source / ".agents" / "scripts" / "generate_platform.py"
    if not script.exists():
        print(f"[AVISO] generate_platform.py não encontrado. Pulando geração de plataforma.")
        return
    result = subprocess.run(
        [sys.executable, str(script), "--platform", platform, "--path", str(dest), "--source", str(source / ".agents")],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"[AVISO] generate_platform.py: {result.stderr.strip()}")


def init_rtk(rtk_path: str | None, dest: Path, platform: str):
    if rtk_path is None:
        return False
    result = subprocess.run(
        [rtk_path, "init", "-g"],
        cwd=str(dest), capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"[AVISO] RTK init falhou: {result.stderr.strip()}")
        return False
    return True


def main():
    check_python_version()

    parser = argparse.ArgumentParser(description="Inicializa workspace SSPDD")
    parser.add_argument("--project", required=True, help="Nome do projeto")
    parser.add_argument("--path", required=True, help="Caminho de destino do workspace")
    parser.add_argument("--lang", default="pt_BR", choices=["pt_BR", "en_US"], help="Idioma dos templates")
    parser.add_argument("--platform", default="claude",
                        choices=["claude", "cursor", "copilot", "opencode", "all"],
                        help="Plataforma de IA alvo")
    parser.add_argument("--skip-rtk", action="store_true", help="Pular verificação e inicialização do RTK")
    args = parser.parse_args()

    source = resolve_source()
    dest, _, lang, platform, skip_rtk = validate_args(args)
    today = date.today().isoformat()

    rtk_path = check_rtk(skip_rtk)

    print(f"Criando workspace '{args.project}' em {dest}...")

    create_directory_structure(dest)
    copy_agents(source, dest, lang)
    generate_comportamento_md(source, dest, args.project, today, lang)
    generate_agents_md(source, dest, args.project, today, lang)
    generate_claude_md(source, dest, args.project, today, lang)
    generate_memory(source, dest, args.project, today, lang)
    copy_gitignore(source, dest, args.project, today)

    call_generate_platform(source, dest, platform)

    rtk_ok = init_rtk(rtk_path, dest, platform)

    print(f"\nOK - Workspace \"{args.project}\" criado em {dest}")
    print(f"OK - Idioma: {lang}")
    print(f"OK - Plataforma: {platform}")
    if skip_rtk:
        print("  RTK: ignorado (--skip-rtk)")
    elif rtk_ok:
        print("OK - RTK: habilitado")
    else:
        print("AVISO - RTK: nao instalado (opcional)")

    print(f"""
Próximos passos:
  1. cd {dest}
  2. Execute /guidelines para configurar o sistema
""")


if __name__ == "__main__":
    main()
