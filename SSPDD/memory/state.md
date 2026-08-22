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
- **Task implementada:** TASK-06.6 — Fixtures valid/invalid para 8 skills (prd, techspec, tasks, discovery, spdd-canvas, spdd-sync, guidelines, code-review); corrigidos 2 bugs no validate.py engine descobertos pelos testes (regex de id_patterns não capturava IDs com ponto, ex. TASK-01.1; cwd de custom_steps impedia localizar scripts) — 2026-08-22
- **Arquivos:** .agents/scripts/validate.py, .agents/skills/{prd,techspec,tasks,discovery,spdd-canvas,spdd-sync,guidelines,code-review}/scripts/tests/fixtures/*.md
- **Testes:** cada valid_*.md → exit 0; cada invalid_*.md → exit 1 com erros esperados; validate_skills.py — 15 skills válidas
- **Etapa concluída:** TASK-07.1 — Templates e schema de DRs — 2026-08-22
- **Arquivos:** .agents/skills/decision-record/validate-rules.json, .agents/skills/decision-record/scripts/check_dr_status.py, .agents/scripts/validate_skills.py (validate_dr + chamada no main), fixtures valid_dr.md/invalid_dr.md
- **Testes:** valid_dr.md → exit 0; invalid_dr.md → exit 1 (status inválido + seção ausente)
- **Etapa concluída:** TASK-07.2 — Índice de DRs em constitution.md — 2026-08-22
- **Arquivos:** .agents/templates/{pt_BR,en_US}/memory/constitution-template.md (nota de formato de link), .agents/skills/decision-record/README.md (helper: como criar DR e atualizar índice)
- **Testes:** validate_dr_index (já existente desde TASK-02.4) confirmado detectando link quebrado → AVISO
- **Etapa concluída:** TASK-07.3 — Integração DRs no canvas — 2026-08-22
- **Arquivos:** SKILL.md de designer, techspec, code-review, tasks, discovery, clarify (instrução de referenciar DRs na linha `> Decisões:` de cada dimensão que atualizam). canvas-template já tinha a linha (TASK-03.3) e validate-rules.json/check_canvas_decisions.py do spdd-canvas já existiam (TASK-06.x) — critérios confirmados por teste.
- **Testes:** valid_canvas.md → exit 0; invalid_canvas.md → exit 1 (seção ausente + ownership + linha `> Decisões:` ausente)
- **EPIC-07 concluído** (TASK-07.1, 07.2, 07.3)
- **Próxima task:** TASK-08.1 (EPIC-08 — Agents e Documentação do Framework)

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