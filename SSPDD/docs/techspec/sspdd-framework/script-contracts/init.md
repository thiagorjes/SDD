# Script Contract — init.py
_Versão: 1.0 | Atualizado em: 2026-08-22_

**Localização:** `scripts/init.py` (na raiz do repositório SSPDD)

---

## Interface

```
python init.py \
  --project "Nome do Projeto" \
  --path ./destino \
  --lang pt_BR|en_US \
  [--platform claude|cursor|copilot|opencode|all] \
  [--skip-rtk]

Exit 0 → workspace criado com sucesso
Exit 1 → erro (path já existe com conteúdo, Python < 3.10, permissão negada)
```

## Fluxo de Execução (em ordem)

### Etapa 1 — Validação de pré-condições
- Python ≥ 3.10 → se não, aborta com mensagem de upgrade
- `--path` não existe ou está vazio → se existe com conteúdo, pede confirmação antes de continuar
- `--lang` em `[pt_BR, en_US]` → se inválido, usa `pt_BR` com aviso

### Etapa 2 — Verificação do RTK
- `shutil.which("rtk")` → detecta RTK no PATH
- Se encontrado: registra para habilitar após cópia dos arquivos
- Se não encontrado e não `--skip-rtk`: exibe:
  ```
  [AVISO] RTK não encontrado. Recomendado para reduzir consumo de tokens em 60-90%.
  Instale com: brew install rtk  OU  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
  Execute novamente ou use --skip-rtk para pular.
  ```
  → prossegue sem RTK (não aborta)

### Etapa 3 — Criação da estrutura de diretórios
```
{path}/
├── AGENTS.md
├── CLAUDE.md
├── .agents/
│   ├── skills/          ← copiado de source/.agents/skills/ com lang selecionado
│   ├── agents/          ← copiado de source/.agents/agents/
│   ├── scripts/         ← copiado de source/.agents/scripts/
│   └── templates/       ← copiado de source/.agents/templates/{lang}/
├── .claude/
│   ├── commands/        ← gerado por generate_platform.py --platform claude
│   └── agents/          ← links via @ para .agents/agents/
├── docs/
│   ├── prd/
│   ├── techspec/
│   ├── tasks/
│   ├── spdd/
│   ├── decisions/
│   ├── contracts/
│   ├── checklists/
│   └── design/
├── memory/
│   ├── constitution.md  ← gerado com projeto e data
│   └── state.md         ← gerado com sistema vazio
└── scripts/             ← utilitários futuros
```

### Etapa 4 — Geração de AGENTS.md e CLAUDE.md
- `AGENTS.md`: lista todas as skills de `.agents/skills/` com nome e description do frontmatter do `SKILL.md`
- `CLAUDE.md`: referencia `AGENTS.md` via `@AGENTS.md` + referencia `memory/constitution.md` e `memory/state.md`
- Substitui `{{PROJECT_NAME}}`, `{{DATE}}`, `{{LANG}}` nos templates

### Etapa 5 — Geração de arquivos de plataforma
- Chama `generate_platform.py --platform {platform} --path {path}`
- `--platform all`: gera para todas as plataformas suportadas
- Default: gera apenas para a plataforma inferida do `--lang` (claude para pt_BR, all para en_US)

### Etapa 6 — Inicialização do RTK (se disponível)
- `subprocess.run(["rtk", "init", "-g"], cwd=path)`
- Plataforma passada conforme `--platform`
- Captura stderr — qualquer erro é reportado como AVISO, não aborta

### Etapa 7 — Output final
```
✓ Workspace "{project}" criado em {path}
✓ Idioma: {lang}
✓ Plataforma: {platform}
✓ RTK: habilitado  OU  ⚠ RTK: não instalado (opcional)

Próximos passos:
  1. cd {path}
  2. Execute /guidelines para configurar o sistema
```

## generate_platform.py — Interface

```
python .agents/scripts/generate_platform.py \
  --platform claude|cursor|copilot|opencode|all \
  --path ./destino \
  --source .agents/

Exit 0 → arquivos gerados
Exit 1 → source inválido
```

**O que gera por plataforma:**

| Plataforma | Arquivos gerados | Estratégia |
|-----------|-----------------|-----------|
| claude | `.claude/commands/[skill].md` | Arquivo com `@.agents/skills/[skill]/SKILL.md` |
| cursor | `.cursor/rules/sspdd-[skill].mdc` | Markdown com conteúdo do SKILL.md + frontmatter cursor |
| copilot | `.github/copilot-instructions.md` | Concatenação das skills relevantes |
| opencode | `.opencode/commands/[skill].md` | Idem claude |

## Dependências

- Python 3.10+ stdlib apenas: `pathlib`, `shutil`, `subprocess`, `argparse`, `sys`, `re`
- RTK opcional (detectado via `shutil.which`)
- Sem chamadas de rede
