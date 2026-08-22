# Workspace SDD — SSPDD

## Estrutura

- **`systems/`** — Um subdiretorio por sistema (cada um pode ter seu proprio repositorio git)
  - **`systems/SSPDD/`** — Novo (greenfield); guidelines proprios em `systems/SSPDD/guidelines/`
- **`.agents/skills/`** — Skills do pipeline SDD (agnosticos ao LLM)
- **`docs/prd/`** — Product Requirements Documents (unicos por feature, mesmo multi-sistema)
- **`docs/contracts/`** — Contratos de integracao entre sistemas (fonte de verdade compartilhada)
- **`docs/techspec/`** — Especificacoes tecnicas (uma por sistema afetado, em features multi-sistema)
- **`docs/tasks/`** — Plano de tasks (agrupadas por sistema)
- **`docs/checklists/`** — Checklists de qualidade
- **`memory/constitution.md`** — Principios estaveis e ADRs. Leia antes de qualquer acao.
- **`memory/state.md`** — Estado operacional (sistemas, features, progresso). Atualizado a cada etapa.
- **`scripts/`** — Utilitarios (`update.ps1` re-sincroniza o toolset)

---

## Git

- O workspace versiona **artefatos SDD** (docs/, memory/, guidelines nao — estes ficam nos sistemas).
- `systems/` esta no `.gitignore` do workspace: cada sistema mantem seu proprio repositorio, remote e CI.
- Em features multi-sistema, a ordem de merge entre repositorios e definida no documento de tasks.

---

## Pipeline SDD

```
/guidelines (por sistema) → /prd → [/clarify] → [/checklist] → /techspec → /tasks → [/analyze] → /implement (por task)
```

**Skills entre colchetes `[/skill]`** sao opcionais mas recomendados.

---

**Workspace:** SSPDD | **Iniciado em:** 2026-08-22 | **Toolset:** 2026-08-22 (fc3b641)