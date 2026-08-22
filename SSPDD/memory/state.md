# Estado Operacional — SSPDD
_Atualizado em: 2026-08-22_

> Estado atual do workspace e das features em andamento.
> Para principios estaveis e ADRs, veja [memory/constitution.md](constitution.md).

---

## Toolset

**Versao:** 2026-08-22 (fc3b641) — atualize com `scripts/update.ps1`
**Pipeline SSPDD:** /guidelines → /prd → [/clarify] → [/checklist] → /techspec → **/spdd-canvas** → /tasks → [/analyze] → /implement → [**/spdd-sync**] → /code-review

---

## Sistemas

| Sistema | Caminho | Cenario | Guidelines | Observacoes |
|---|---|---|---|---|
| SSPDD | `systems/SSPDD/` | Novo (greenfield) | **ok** | Framework híbrido SDD+SPDD |

---

## Features Ativas

| Feature | Sistemas afetados | PRD | TechSpec | Tasks | Status |
|---|---|---|---|---|---|
| SSPDD Framework | SSPDD | v1.1 ✓ | v1.0 ✓ | v1.0 ✓ | Pronto para implementação |

### SSPDD Framework
- **Etapa concluída:** /prd (v1.0) — 2026-08-22
- **Artefato:** docs/prd/sspdd-framework-prd.md
- **Sistemas afetados:** SSPDD (sistema único — o próprio framework)
- **Status:** Em especificação
- **RFs Must Have:** RF-001 (pipeline), RF-002 (canvas progressivo), RF-003 (validação dual), RF-004 (cascade conflitos), RF-005 (templates), RF-006 (memory/registry), RF-007 (estrutura canônica), RF-010 (init.py), RF-012 (/discovery), RF-013 (TechSpec pré-condições), RF-014 (dependências inter-sistemas)
- **RFs Should Have:** RF-008 (/spdd-sync), RF-009 (multi-sistema), RF-011 (skills opcionais)
- **Questões em aberto:** Q-001 (schema Artifact Registry), Q-002 (protocolo repositórios externos), Q-003 (idiomas templates)
- **Etapa concluída:** /techspec (v1.0) — 2026-08-22
- **Artefatos:** docs/techspec/sspdd-framework-techspec.md + data-model.md + script-contracts/ + quickstart.md
- **Etapa concluída:** /tasks (v1.0) — 2026-08-22
- **Artefato:** docs/tasks/sspdd-framework-tasks.md
- **Task implementada:** TASK-06.4 — Scripts custom check_rf_coverage.py para /analyze e /techspec, com referência explícita no SKILL.md do /techspec — 2026-08-22
- **Arquivos:** .agents/skills/techspec/SKILL.md
- **Testes:** manual — RF-999 fictício não coberto → exit 1 confirmado em analyze/ e techspec/
- **Próxima task:** TASK-06.3

## Artifact Registry

| Artefato | Versão | Status | Atualizado |
|----------|--------|--------|-----------|
| docs/prd/sspdd-framework-prd.md | 1.1 | ok | 2026-08-22 |
| techspec/sspdd-framework-techspec.md | 1.0 | ok | 2026-08-22 |
| techspec/sspdd-framework/data-model.md | 1.0 | ok | 2026-08-22 |
| techspec/sspdd-framework/quickstart.md | 1.0 | ok | 2026-08-22 |
| techspec/sspdd-framework/script-contracts/validate-engine.md | 1.0 | ok | 2026-08-22 |
| techspec/sspdd-framework/script-contracts/init.md | 1.0 | ok | 2026-08-22 |
| tasks/sspdd-framework-tasks.md | 1.0 | ok | 2026-08-22 |
| systems/SSPDD/guidelines/stack.md | 1.0 | ok | 2026-08-22 |
| systems/SSPDD/guidelines/architecture.md | 1.0 | ok | 2026-08-22 |
| systems/SSPDD/guidelines/coding-standards.md | 1.0 | ok | 2026-08-22 |
| systems/SSPDD/guidelines/testing.md | 1.0 | ok | 2026-08-22 |
| systems/SSPDD/guidelines/skill-conventions.md | 1.0 | ok | 2026-08-22 |
| systems/SSPDD/guidelines/security.md | 1.0 | ok | 2026-08-22 |
| systems/SSPDD/guidelines/observability.md | 1.0 | ok | 2026-08-22 |
| systems/SSPDD/guidelines/git-workflow.md | 1.0 | ok | 2026-08-22 |
| systems/SSPDD/guidelines/spdd-integration.md | 1.0 | ok | 2026-08-22 |

---

## Evolucao do SDD

| Data | Mudanca |
|---|---|
| 2026-08-22 | Workspace inicializado via init.ps1 |
| 2026-08-22 | Guidelines do sistema SSPDD geradas — 7 arquivos em systems/SSPDD/guidelines/ |