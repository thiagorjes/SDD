# Stack — SSPDD Framework
_Atualizado em: 2026-08-22_

## Distribuição

| Camada | Tecnologia | Versão mínima |
|--------|-----------|---------------|
| Script de inicialização | Python | 3.10+ |
| GitHub template | Markdown / git | — |

**Justificativa:** O "CLI" é o próprio CLI da plataforma de IA (Claude Code, Codex, Cursor, etc.). O framework é um conjunto de arquivos — não há binário compilado. `init.py` cria a estrutura do workspace usando apenas stdlib.

## Scripts de Validação

| Camada | Tecnologia | Versão mínima |
|--------|-----------|---------------|
| Scripts de validação | Python | 3.10+ |
| Estilo de código | ruff (linting + format) | — |
| Dependências externas | nenhuma (stdlib apenas) | — |

**Justificativa:** Python 3.10+ disponível nativamente na maioria dos ambientes de CI e nos três sistemas operacionais-alvo. Stdlib suficiente para parsing de Markdown e validação estrutural.

## Artefatos e Templates

| Tipo | Formato |
|------|---------|
| Todos os artefatos (PRD, TechSpec, Tasks, REASONS Canvas, etc.) | Markdown (CommonMark) |
| Templates de artefatos | Markdown com placeholders `{{CAMPO}}` |
| Skill definitions | `SKILL.md` (formato canônico [agentskills.io](https://agentskills.io/)) |
| Agent definitions | Markdown |

## Plataformas de IA

| Canal | Formato | Localização |
|-------|---------|-------------|
| Canônico cross-vendor | AGENTS.md + `.agents/` | raiz do projeto |
| Claude Code (nativo) | CLAUDE.md + `.claude/` | raiz do projeto |

O diretório `.claude/` referencia arquivos em `.agents/` — nunca duplica conteúdo.

## Automação Auxiliar

| Finalidade | Tecnologia |
|-----------|-----------|
| Rastreamento de custos de LLM | Python (`scripts/llm_costs.py`) |
| Inicialização de workspace | Python (`init.py`, stdlib apenas) |
| Geração de comandos por plataforma | Python (`scripts/generate_platform.py`) |
| Validação de artefatos por skill | Python (`validate.py --mode input|output` por skill) |
| Validação da estrutura de skills | Python (`scripts/validate_skills.py`) |

## Ferramentas de Desenvolvimento do Framework

| Ferramenta | Uso |
|-----------|-----|
| `ruff check` + `ruff format` | Linting e formatação de todos os scripts Python |
| `python -m pytest` | Testes dos scripts com fixtures |
| GitHub Actions | CI: lint + testes + validação de estrutura de skills |
