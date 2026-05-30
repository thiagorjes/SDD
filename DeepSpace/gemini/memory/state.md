# Estado Operacional — Banestes SDD
_Atualizado em: 2026-05-30_

> Estado atual do toolset e dos projetos em andamento. Atualizado a cada interação que altera o estado do projeto.
> Para princípios estáveis e ADRs, veja [`memory/constitution.md`](constitution.md).

---

## Toolset Atual

| Componente | Qtd | Localização |
|---|---|---|
| Skills agnósticos | 11 | `skills/` |
| Commands Claude | 11 | `.claude/commands/` |
| Commands Gemini | 11 | `.gemini/commands/` |
| Scripts de custo | 2 | `scripts/` |

**Skills disponíveis:** guidelines, prd, clarify, checklist, techspec, tasks, analyze, implement, tdd, tests, code_review

---

## Features Ativas

_Registre aqui as features em desenvolvimento usando este projeto SDD._

| Feature | PRD | TechSpec | Tasks | Status |
|---|---|---|---|---|
| KingPong Core Gameplay | [v1.0](../docs/prd/kingpong-core-gameplay-prd.md) | [v1.0](../docs/techspec/kingpong-core-gameplay-techspec.md) | [v1.1](../docs/tasks/kingpong-core-gameplay-tasks.md) | Especificada |

**RFs Must Have (KingPong Core Gameplay):**
- RF-001: Renderização da Área de Jogo
- RF-002: Controle do Paddle
- RF-003: Movimentação e Colisão da Bolinha
- RF-004: Sistema de Pontuação (Goal)
- RF-005: Sistema de Vidas e Fim de Jogo

*Nota: PRD clarificado em 29/05/2026 — 8 ambiguidades e gaps resolvidos (incluindo cores hex, colisões seguras e dimensões de tela).*

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
| KingPong Core Gameplay | 9 | 2 | 0 | `docs/tasks/kingpong-core-gameplay-tasks.md` |

---

## Qualidade

_Registre resultados de `/analyze`, `/tests` e `/code_review`._

| Data | Skill | Feature/Task | Veredicto | Findings |
|---|---|---|---|---|
| 29/05/2026 | `/analyze` | KingPong Core Gameplay | ✅ Aprovado | 0 Críticos, Cobertura RF→Tasks: 100% (9 tasks) |

---

## Evolução 

