"""
Suite de testes para scripts/init.py (TASK-10.2).
Executar: pytest scripts/tests/ -v
"""

import importlib.util
import subprocess
from pathlib import Path

import pytest

SCRIPT_PATH = Path(__file__).resolve().parent.parent / "init.py"

spec = importlib.util.spec_from_file_location("init", SCRIPT_PATH)
init = importlib.util.module_from_spec(spec)
spec.loader.exec_module(init)


class _Args:
    def __init__(self, path, lang="pt_BR", platform="claude", skip_rtk=True):
        self.project = "Teste"
        self.path = str(path)
        self.lang = lang
        self.platform = platform
        self.skip_rtk = skip_rtk


def _run_full_init(tmp_path, lang="pt_BR", platform="claude", skip_rtk=True):
    dest = tmp_path / "workspace"
    source = init.resolve_source()
    today = "2026-08-22"

    init.create_directory_structure(dest)
    init.copy_agents(source, dest, lang)
    init.generate_agents_md(source, dest, "Teste", today, lang)
    init.generate_claude_md(source, dest, "Teste", today, lang)
    init.generate_memory(source, dest, "Teste", today, lang)
    init.copy_gitignore(source, dest, "Teste", today)
    return dest


# ---------------------------------------------------------------------------
# Estrutura de diretorios
# ---------------------------------------------------------------------------

def test_create_directory_structure_cria_docs_subdirs(tmp_path):
    dest = tmp_path / "ws"
    init.create_directory_structure(dest)
    for sub in init.DOCS_SUBDIRS:
        d = dest / "docs" / sub
        assert d.is_dir()
        assert (d / ".gitkeep").exists()
    assert (dest / "memory").is_dir()
    assert (dest / "scripts").is_dir()


def test_check_python_version_ok(capsys):
    # Ambiente de teste ja roda em Python >= 3.10 (requisito do proprio repo)
    init.check_python_version()  # nao deve sair/abortar


# ---------------------------------------------------------------------------
# AGENTS.md / CLAUDE.md / memory
# ---------------------------------------------------------------------------

def test_generate_agents_md_lista_skills_reais(tmp_path):
    dest = _run_full_init(tmp_path)
    content = (dest / "AGENTS.md").read_text(encoding="utf-8")
    assert "prd" in content
    assert "techspec" in content


def test_generate_claude_md_referencia_arquivos_esperados(tmp_path):
    dest = _run_full_init(tmp_path)
    content = (dest / "CLAUDE.md").read_text(encoding="utf-8")
    assert "@AGENTS.md" in content
    assert "@memory/constitution.md" in content
    assert "@memory/state.md" in content


def test_generate_memory_cria_state_com_artifact_registry(tmp_path):
    dest = _run_full_init(tmp_path)
    state = (dest / "memory" / "state.md").read_text(encoding="utf-8")
    assert "## Artifact Registry" in state
    constitution = (dest / "memory" / "constitution.md").read_text(encoding="utf-8")
    assert "constitution" in str((dest / "memory" / "constitution.md")).lower()
    assert constitution  # gerado e nao vazio


def test_workspace_completo_sem_placeholders_nao_substituidos(tmp_path):
    dest = _run_full_init(tmp_path)
    for name in ("AGENTS.md", "CLAUDE.md"):
        content = (dest / name).read_text(encoding="utf-8")
        assert "{{PROJECT_NAME}}" not in content
        assert "{{DATE}}" not in content


# ---------------------------------------------------------------------------
# Idiomas
# ---------------------------------------------------------------------------

@pytest.mark.parametrize("lang", ["pt_BR", "en_US"])
def test_copy_agents_usa_pasta_do_idioma(tmp_path, lang):
    dest = tmp_path / "ws"
    source = init.resolve_source()
    init.create_directory_structure(dest)
    init.copy_agents(source, dest, lang)

    templates_dest = dest / ".agents" / "templates"
    templates_src_lang = source / ".agents" / "templates" / lang
    if templates_src_lang.exists():
        # ao menos um arquivo da pasta de idioma correta deve ter sido copiado
        sample = next(templates_src_lang.rglob("*"), None)
        if sample and sample.is_file():
            rel = sample.relative_to(templates_src_lang)
            assert (templates_dest / rel).exists()


def test_validate_args_lang_invalido_usa_pt_br(tmp_path, capsys):
    args = _Args(tmp_path / "ws", lang="fr_FR")
    dest, _, lang, platform, skip_rtk = init.validate_args(args)
    assert lang == "pt_BR"


# ---------------------------------------------------------------------------
# RTK
# ---------------------------------------------------------------------------

def test_check_rtk_ausente_retorna_none(monkeypatch, capsys):
    monkeypatch.setattr(init.shutil, "which", lambda name: None)
    result = init.check_rtk(skip=False)
    assert result is None
    assert "AVISO" in capsys.readouterr().out


def test_check_rtk_presente_retorna_path(monkeypatch):
    monkeypatch.setattr(init.shutil, "which", lambda name: "/usr/bin/rtk")
    result = init.check_rtk(skip=False)
    assert result == "/usr/bin/rtk"


def test_check_rtk_skip_nao_verifica(monkeypatch):
    called = []
    monkeypatch.setattr(init.shutil, "which", lambda name: called.append(name) or "/usr/bin/rtk")
    result = init.check_rtk(skip=True)
    assert result is None
    assert called == []  # shutil.which nunca foi chamado


def test_init_rtk_chama_subprocess_quando_path_presente(tmp_path, monkeypatch):
    calls = []

    def fake_run(cmd, cwd, capture_output, text):
        calls.append((cmd, cwd))
        return subprocess.CompletedProcess(cmd, 0, stdout="", stderr="")

    monkeypatch.setattr(init.subprocess, "run", fake_run)
    ok = init.init_rtk("/usr/bin/rtk", tmp_path, "claude")
    assert ok is True
    assert calls[0][0] == ["/usr/bin/rtk", "init", "-g"]
    assert calls[0][1] == str(tmp_path)


def test_init_rtk_none_nao_chama_subprocess(monkeypatch):
    called = []
    monkeypatch.setattr(init.subprocess, "run", lambda *a, **k: called.append(1))
    ok = init.init_rtk(None, Path("."), "claude")
    assert ok is False
    assert called == []


def test_init_rtk_falha_retorna_false(tmp_path, monkeypatch, capsys):
    def fake_run(cmd, cwd, capture_output, text):
        return subprocess.CompletedProcess(cmd, 1, stdout="", stderr="erro simulado")

    monkeypatch.setattr(init.subprocess, "run", fake_run)
    ok = init.init_rtk("/usr/bin/rtk", tmp_path, "claude")
    assert ok is False
    assert "AVISO" in capsys.readouterr().out
