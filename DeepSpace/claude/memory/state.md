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

## Projeto Ativo — KingPong

Jogo mobile React Native para Android e iOS. Solo developer, greenfield, offline.

### Status do Pipeline SDD

| Etapa | Status | Artefato |
|---|---|---|
| `/guidelines` | ✅ Concluído | `guidelines/*.md` (6 arquivos) |
| `/prd` | ✅ Concluído | `docs/prd/kingpong-feature-1-prd.md` |
| `/clarify` | ✅ Concluído | PRD v1.1 — 5 ambiguidades resolvidas |
| `/checklist` | ✅ Gate Aprovado | `docs/checklists/kingpong-feature-1-prd-geral.md` — 50/50 ✓ (PRD v1.4) |
| `/techspec` | ✅ Concluído | `docs/techspec/kingpong-feature-1-techspec.md` |
| `/tasks` | ✅ Concluído | `docs/tasks/kingpong-feature-1-tasks.md` |
| `/implement` | ⬜ Pendente | — |

### Features

| Feature | PRD | TechSpec | Tasks | Status |
|---|---|---|---|---|
| Feature-1: Tela de Jogo | v1.4 `kingpong-feature-1-prd.md` | v1.0 `kingpong-feature-1-techspec.md` | — | TechSpec concluído |

**RFs Must Have (Feature-1):** RF-001 a RF-008 (todos especificados)

---

## Especificações Técnicas em Andamento

| Feature | TechSpec | ADRs chave | Artefatos |
|---|---|---|---|
| Feature-1: Tela de Jogo | `kingpong-feature-1-techspec.md` | ADR-001: Reanimated 3 (worklets UI thread); ADR-002: RNGH Gesture.Pan (≤16ms); ADR-003: useReducer local sem Zustand; ADR-004: colisão frame-by-frame (BALL_SPEED_MAX=500px/s anti-tunneling) | data-model.md, quickstart.md (sem contracts — sem API) |

---

## Tasks em Andamento

| Feature | Total tasks | Concluídas | Em progresso | Caminho |
|---|---|---|---|---|
| Feature-1: Tela de Jogo | 14 | 1 | TASK-1.1 concluída | `docs/tasks/kingpong-feature-1/` |

---

## Qualidade

| Data | Skill | Feature/Task | Veredicto | Findings |
|---|---|---|---|---|
| _(nenhum)_ | — | — | — | — |

---

## Evolução do SDD

| Data | Mudança |
|---|---|
| 2026-05-29 | PRD Feature-1 (Tela de Jogo) gerado — 7 RFs Must Have, 4 questões em aberto |
| 2026-05-30 | PRD clarificado (v1.1) — 5 ambiguidades resolvidas; 0 categorias adiadas para /techspec |
| 2026-05-30 | Checklist geral gerado — 38 itens, gate formal antes do /techspec |
| 2026-05-30 | Checklist gate aprovado 38/38 — PRD v1.3: RF-008 criado, portrait-only, ângulo 30°-150°, bolinha congela na borda, constantes nomeadas |
| 2026-05-30 | PRD v1.4: paddle=60px, 3 rótulos (iniciar/continuar/reiniciar), congelamento 10px, eixo angular explicitado, RN-009, checklist 50/50 |
| 2026-05-29 | Guidelines do KingPong criadas (6 arquivos) — stack, architecture, coding-standards, testing, security, observability |
| 2026-05-30 | TechSpec Feature-1 gerado (v1.0) — 4 ADRs, 10 áreas de trabalho, 4 questões em aberto; artefatos: data-model.md, quickstart.md |
| 2026-05-30 | Tasks Feature-1 geradas (v1.0) — 5 EPICs, 10 USs, 14 tasks; caminho crítico: 1.2→3.2→3.3→3.4→4.5→5.1→5.2; 3 grupos de paralelismo identificados |
| 2026-05-30 | TASK-1.1 concluída — Projeto KingPong inicializado em D:\CobraKai\SDD\DeepSpace\KingPong (RN 0.76.0); Reanimated 3.19.5, RNGH 2.22.1, safe-area-context 4.14.1 instalados; portrait-only configurado |
