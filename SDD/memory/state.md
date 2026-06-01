# Estado Operacional — Banestes SDD
_Atualizado em: 2026-06-01_

> Estado atual do toolset e dos projetos em andamento. Atualizado a cada interação que altera o estado do projeto.
> Para princípios estáveis e ADRs, veja [`memory/constitution.md`](constitution.md).

---

## Toolset Atual

| Componente | Qtd | Localização |
|---|---|---|
| Skills agnósticos | 12 | `skills/` |
| Commands Claude | 11* | `.claude/commands/` |
| Commands Gemini | 11* | `.gemini/commands/` |
| Scripts de custo | 2 | `scripts/` |
| Scripts de bootstrap | 1 | `scripts/` |

**Skills disponíveis:** guidelines, prd, clarify, checklist, techspec, tasks, analyze, implement, tdd, tests, code_review, **designer**

> *`designer` command gerado por `init.ps1` ao inicializar projetos com design ativo.

---

## Features Ativas

_Registre aqui as features em desenvolvimento usando este projeto SDD._

| Feature | PRD | TechSpec | Tasks | Status |
|---|---|---|---|---|
| _(nenhuma ativa)_ | — | — | — | — |

---

## Especificações Técnicas em Andamento

_Registre TechSpecs geradas pelo `/techspec`._

| Feature | TechSpec | ADRs chave | Artefatos |
|---|---|---|---|
| _(nenhuma)_ | — | — | — |

---

## Tasks em Andamento

_Registre progresso de tasks do `/tasks`._

| Feature | Total tasks | Concluídas | Em progresso | Caminho |
|---|---|---|---|---|
| _(nenhuma)_ | — | — | — | — |

---

## Qualidade

_Registre resultados de `/analyze`, `/tests` e `/code_review`._

| Data | Skill | Feature/Task | Veredicto | Findings |
|---|---|---|---|---|
| _(nenhum)_ | — | — | — | — |

---

## Evolução do SDD

| Data | Mudança |
|---|---|
| 2026-06-01 | Skill `designer` adicionado ao pipeline |
| 2026-06-01 | Script `init.ps1` criado (bootstrap de projetos) |
| 2026-06-01 | Estrutura `design/flows`, `design/tokens`, `design/prototypes` definida |
| 2026-06-01 | Template `GUIDELINE_DESIGN_SYSTEM.md` gerado pelo bootstrap quando design ativo |