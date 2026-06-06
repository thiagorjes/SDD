# Processo de Desenvolvimento SDD — KingPong

## Estrutura

- **`.agents/skills/`** — Skills do pipeline SDD (agnosticos ao LLM, descobertos nativamente pelo Antigravity)
- **`.claude/commands/`** — Commands Claude
- **`.agents/agents/`** — Subagentes do Comite de Analise (architect, security, database)
- **`guidelines/`** — Padroes tecnicos deste projeto
- **`docs/prd/`** — Product Requirements Documents
- **`docs/techspec/`** — Especificacoes tecnicas
- **`docs/tasks/`** — Plano de tasks
- **`docs/checklists/`** — Checklists de qualidade
- **`design/flows/`** — Diagramas de jornada e navegacao (Mermaid)
- **`design/tokens/`** — Design system tokens (JSON)
- **`design/prototypes/`** — Prototipos de alta fidelidade (HTML)
- **`KingPong/`** — Source do projeto
- **`memory/constitution.md`** — Principios estaveis e ADRs. Leia antes de qualquer acao.
- **`memory/state.md`** — Estado operacional atual. Atualizado a cada interacao.
- **`scripts/`** — Scripts utilitarios

---

## Pipeline SDD

```
/guidelines → /prd → [/clarify] → [/checklist] → [/designer] → /techspec → /tasks → [/analyze] → /implement (por task)
```

**Skills entre colchetes `[/skill]`** sao opcionais mas recomendados.

---

## Projeto

**Nome:** KingPong
**Iniciado em:** 2026-06-06