# SSPDD — Spec + Prompt Driven Development

[![CI](https://github.com/thiagorjes/SDD/actions/workflows/sspdd-ci.yml/badge.svg)](https://github.com/thiagorjes/SDD/actions/workflows/sspdd-ci.yml)
![Python](https://img.shields.io/badge/python-3.10%2B-blue)
![Plataformas](https://img.shields.io/badge/plataformas-linux%20%7C%20macos%20%7C%20windows-lightgrey)
![Licença](https://img.shields.io/badge/licença-MIT-green)

Framework híbrido que une **SDD** (Spec-Driven Development — pipeline `/prd → /techspec → /tasks → /implement`) com **SPDD** (Prompt-Driven Development via [REASONS Canvas](https://github.com/gszhangwei/open-spdd)) em um único workspace agnóstico de plataforma de IA.

O REASONS Canvas é o elo entre a especificação técnica e o código: ele nasce em `/techspec`, cresce dimensão por dimensão a cada skill do pipeline, e é lido por `/implement` como instrução executável — não como documentação.

---

## Como funciona

```
/guidelines → /prd → [/clarify] → [/checklist] → /techspec → /spdd-canvas → /tasks → [/analyze] → /implement → [/spdd-sync] → /code-review
                                          │              │         │            │
                                          ▼              ▼         ▼            ▼
                                   canvas: DRAFT   canvas: E,A,S,N canvas: O   canvas: READY
                                   (R, E)           preenchidas    preenchida  (implementação
                                                                                habilitada)
```

Skills entre colchetes `[/skill]` são opcionais mas recomendadas. Cada skill do pipeline "empurra" suas dimensões do canvas ao concluir — o canvas nunca é preenchido de uma vez, ele acompanha o avanço do pipeline (ADR-010).

**Dimensões REASONS:** Roles, Environment, Actions, Steps, Objectives, Norms, Safeguards.

---

## Quick start

```bash
# 1. Clonar o template e inicializar um novo workspace
git clone <URL-do-template> meu-workspace && cd meu-workspace
python scripts/init.py --project "Meu Projeto" --path . --lang pt_BR --platform claude

# 2. Gerar guidelines do primeiro sistema
# (no Claude Code, Cursor ou plataforma escolhida)
/guidelines

# 3. Iniciar a primeira feature
/prd
```

Em menos de 5 minutos você tem um workspace pronto com skills, agents, templates e memória (`memory/constitution.md` + `memory/state.md`) configurados para a plataforma de IA escolhida.

---

## Estrutura de diretórios

- **`.agents/`** — fonte canônica cross-vendor (ADR-004)
  - `skills/` — skills do pipeline, cada uma com `SKILL.md` + `validate-rules.json`
  - `agents/` — especialistas invocáveis (architect, database, designer, devops, qa, security)
  - `templates/[lang]/` — templates de artefatos por idioma (pt_BR / en_US)
  - `scripts/` — engine de validação (`validate.py`) e gerador de plataforma (`generate_platform.py`)
- **`.claude/`** (ou `.cursor/`, `.github/`, `.opencode/`) — espelho gerado por plataforma, referencia `.agents/` via `@`
- **`systems/`** — um subdiretório por sistema afetado, cada um com `guidelines/` próprios e repositório git independente
- **`docs/`** — artefatos do pipeline: `prd/`, `techspec/`, `tasks/`, `checklists/`, `spdd/` (canvas), `decisions/` (DRs), `contracts/`
- **`memory/constitution.md`** — princípios estáveis, ADRs e índice de Decision Records
- **`memory/state.md`** — estado operacional: sistemas, features ativas, progresso
- **`scripts/init.py`** — cria um novo workspace a partir do template
- **`scripts/generate_platform.py`** — regenera os espelhos de plataforma a partir de `.agents/`

---

## Decision Records

Toda decisão significativa e duradoura é registrada como Decision Record (DR) em `docs/decisions/`, indexada por tipo em `memory/constitution.md`. Cada tipo tem sequência numérica própria (ADR-012):

| Tipo | Domínio | Exemplo |
|---|---|---|
| **ADR** | Arquitetura/técnico | Escolha de padrão de persistência |
| **BDR** | Negócio | Priorização de RF por impacto |
| **SDR** | Segurança | Estratégia de autenticação |
| **DDR** | Design/UX | Sistema de cores e navegação |

Skills do pipeline (`/guidelines`, `/prd`, `/techspec`, `/designer`, etc.) criam DRs conforme decisões emergem e referenciam o ID na linha `> Decisões:` da dimensão do canvas correspondente (TASK-07.3) — a rastreabilidade decisão → dimensão → código é auditável do início ao fim.

Ver `.agents/skills/decision-record/README.md` para o passo a passo de criação.

---

**Referências base:** [thiagorjes/SDD](https://github.com/thiagorjes/SDD) (pipeline SDD), [gszhangwei/open-spdd](https://github.com/gszhangwei/open-spdd) (REASONS Canvas)
