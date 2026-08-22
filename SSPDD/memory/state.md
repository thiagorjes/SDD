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
- **Etapa concluída:** TASK-08.1 — Agent definitions — 2026-08-22
- **Arquivos:** .agents/agents/{architect,database,designer,devops,qa,security}.md; .agents/scripts/generate_platform.py (generate_claude agora gera .claude/agents/[nome].md referenciando .agents/agents/; fix de UnicodeEncodeError no print final)
- **Testes:** geração manual em diretório temporário confirma 6 agents referenciados corretamente
- **Etapa concluída:** TASK-08.2 — Templates AGENTS.md e CLAUDE.md — 2026-08-22
- **Arquivos:** .agents/templates/AGENTS.md-template, .agents/templates/CLAUDE.md-template, scripts/init.py (read_agents_info + placeholders {{SKILLS_LIST}}/{{AGENTS_LIST}} aplicados também quando template existe, antes só no fallback)
- **Testes:** init.py executado em diretório temporário (--platform claude) — AGENTS.md gerado lista 15 skills + 6 agents com description/role reais; CLAUDE.md referencia @AGENTS.md, @memory/constitution.md, @memory/state.md
- **Etapa concluída:** TASK-08.3 — README.md do framework — 2026-08-22
- **Arquivos:** README.md (reescrito: o que é, badges, pipeline com canvas progressivo em ASCII, quick start de 3 comandos, estrutura de diretórios, seção Decision Records com os 4 tipos)
- **Testes:** quick start validado manualmente via `scripts/init.py` em diretório temporário (task 08.2) — fluxo completo funcional
- **EPIC-08 concluído** (TASK-08.1, 08.2, 08.3)
- **Etapa concluída:** TASK-06.3, TASK-06.4 — checkboxes retificados (implementação já existente: designer SKILL.md canvas-dimensions [E] + DDR, check_rf_coverage.py em analyze/techspec) — 2026-08-22
- **Etapa concluída:** TASK-09.1 — Integração RTK no init.py — 2026-08-22
- **Arquivos:** scripts/init.py (check_rtk/init_rtk/--skip-rtk já existiam; corrigido UnicodeEncodeError no print final em console cp1252 — trocado ✓/⚠ por OK-/AVISO-)
- **Testes:** init.py executado em diretório temporário com e sem --skip-rtk — ambos exit 0, workspace completo gerado
- **EPIC-09 concluído** (TASK-09.1)
- **Etapa concluída:** TASK-10.1 — Suite de testes do validate.py engine — 2026-08-22
- **Arquivos:** .agents/scripts/tests/test_validate.py (31 testes); fix em .agents/scripts/validate.py — `load_rules` não substitui mais `{{INPUT_ARTIFACT}}` no JSON bruto (bug real: paths Windows com `\` quebravam o parse JSON de techspec e spdd-canvas validate-rules.json; substituição correta já ocorria em `run_custom_steps`)
- **Testes:** `pytest .agents/scripts/tests/ -v` — 31/31 passando (unitários: registry/stale, id_patterns, gherkin, placeholders, custom_steps mockado; integração: 8 skills × valid/invalid fixture; benchmark: p95 < 5s para 500 linhas)
- **Etapa concluída:** TASK-10.2 — Suite de testes do init.py — 2026-08-22
- **Arquivos:** scripts/tests/test_init.py (15 testes)
- **Testes:** `pytest scripts/tests/ -v` — 15/15 passando (estrutura de diretórios, AGENTS.md/CLAUDE.md/memory gerados, seleção de template por --lang pt_BR/en_US, RTK mockado ausente/presente/skip, subprocess de rtk init -g)
- **Melhoria fora do plano de tasks:** comportamento.md incorporado ao framework como template gerado por init.py — 2026-08-22
- **Arquivos:** .agents/templates/{pt_BR,en_US}/comportamento.md-template, .agents/templates/CLAUDE.md-template (+`@comportamento.md`), scripts/init.py (generate_comportamento_md), scripts/tests/test_init.py (+4 testes), docs/decisions/ADR-013-comportamento-md-template.md, memory/constitution.md (índice ADR)
- **Testes:** 49/49 passando (pytest scripts/tests/ + .agents/scripts/tests/); validate_skills.py — 15 skills válidas
- **Etapa concluída:** TASK-10.3 — Suite de testes de validate_skills.py e fixture de referência — 2026-08-22
- **Arquivos:** .agents/scripts/tests/test_validate_skills.py (7 testes), .agents/scripts/tests/fixtures/SKILL.md.example
- **Testes:** `pytest .agents/scripts/tests/ scripts/tests/ -v` — 56/56 passando
- **EPIC-10 concluído** (TASK-10.1, 10.2, 10.3, 10.4)
- **Etapa concluída:** TASK-10.4 — GitHub Actions CI workflow — 2026-08-22
- **Arquivos:** .github/workflows/ci.yml (jobs lint-python, test-scripts, validate-skills, test-init; matrix 3 SOs × 3 versões Python), README.md (+badge CI), fix de lint (validate.py: variável ambígua `l`→`line`) e formatação ruff em 7 arquivos Python
- **Testes:** `ruff check` e `ruff format --check` sem erros; `pytest .agents/scripts/tests/ scripts/tests/ -v` — 56/56 passando
- **Code review:** EPIC-10 (TASK-10.1..10.4) — APROVADO — 2026-08-22
- **Findings:** 0 críticos, 0 importantes, 0 sugestões. `.github/workflows/ci.yml` permanece em `SSPDD/` (correto — `meuSDD/` é apenas workspace local de dev; `SSPDD/` é o root do repo quando adotado por um usuário). Um finding crítico levantado nesta revisão (mover CI para `meuSDD/`) foi revertido por estar baseado em premissa equivocada sobre a estrutura de repositório.
- **Artefato:** docs/checklists/sspdd-framework-epic10-review.md
- **Observação:** canvas `docs/spdd/sspdd-framework-canvas.md` inexistente — `/spdd-canvas` nunca foi executado nesta feature; dimensão S não pôde ser atualizada
- **Próxima task:** Todas as tasks do backlog concluídas — aguardando orientação do usuário (ex: nova feature ou executar /spdd-canvas retroativo)

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