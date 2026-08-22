# Tasks — SSPDD Framework
_Versão: 1.0 | Data: 2026-08-22 | Autor: Thiago Cavalcante_
_PRD: docs/prd/sspdd-framework-prd.md v1.1_
_TechSpec: docs/techspec/sspdd-framework-techspec.md v1.0_

---

## Sumário de Epics

| ID | Epic | Tasks | Estimativa total | Pode iniciar |
|----|------|-------|-----------------|-------------|
| EPIC-01 | Infraestrutura Base | 4 | 2G + 2M | Imediatamente |
| EPIC-02 | Engine de Validação | 4 | 1G + 2M + 1P | Após EPIC-01 |
| EPIC-03 | Templates de Artefatos | 5 | 3G + 2M | Paralelo com EPIC-02 |
| EPIC-04 | Skills do Pipeline Core | 9 | 4G + 5M | Após EPIC-01, 02, 03 |
| EPIC-05 | Skills SPDD | 3 | 2G + 1M | Após EPIC-04 |
| EPIC-06 | Skills Opcionais | 6 | 2G + 4M | Paralelo com EPIC-05 |
| EPIC-07 | Sistema de Decision Records | 3 | 1G + 2M | Paralelo com EPIC-04 |
| EPIC-08 | Agents e Documentação | 3 | 1G + 2M | Paralelo com EPIC-04 |
| EPIC-09 | Integração RTK | 1 | 1M | Após EPIC-01 |
| EPIC-10 | Testes e CI | 4 | 2G + 2M | Após EPIC-01..09 |
| **Total** | | **42** | | |

**Legenda:** P ≤ 4h | M 4–8h | G 1–2 dias

---

## Grafo de Dependências

```
EPIC-01 (Infra)
  ├── EPIC-02 (Validate engine)  ┐
  ├── EPIC-03 (Templates)        ├─ [P] paralelos
  ├── EPIC-09 (RTK)              ┘
  └── EPIC-01 completo
        ├── EPIC-04 (Skills core)  ┐
        ├── EPIC-05 (Skills SPDD)  │ após EPIC-02+03
        ├── EPIC-06 (Skills opt)   ├─ [P] paralelos após 02+03
        ├── EPIC-07 (DRs)          │
        └── EPIC-08 (Agents/Docs)  ┘
              └── EPIC-10 (CI) — após todos
```

---

## EPIC-01 — Infraestrutura Base

### US-01.1 — Estrutura de workspace inicializável

#### TASK-01.1 — Implementar init.py [G]
**Sistema:** SSPDD | **RF:** RF-010, RF-007 | **Dependências:** nenhuma

**Contexto:**
Script Python (stdlib apenas) que cria workspace SSPDD completo a partir do repositório do framework. Interface: `python init.py --project NAME --path PATH --lang pt_BR|en_US [--platform P] [--skip-rtk]`. Contrato completo em `docs/techspec/sspdd-framework/script-contracts/init.md`.

**O que deve ser feito:**
- [ ] Implementar validação de pré-condições (Python ≥ 3.10, path vazio)
- [ ] Implementar criação da estrutura de diretórios (ver TechSpec seção 4.2)
- [ ] Implementar cópia de `.agents/` com seleção de `--lang` (de `templates/pt_BR/` ou `templates/en_US/`)
- [ ] Implementar geração de `AGENTS.md` e `CLAUDE.md` com substituição de `{{PROJECT_NAME}}` e `{{DATE}}`
- [ ] Implementar geração de `memory/state.md` e `memory/constitution.md` inicializados
- [ ] Implementar chamada a `generate_platform.py` para arquivos de plataforma
- [ ] Implementar output final com próximos passos

**Guia técnico:**
- Arquivo: `scripts/init.py`
- Use `pathlib.Path` para todas operações de arquivo — não `os.path`
- Use `shutil.copytree` para copiar `.agents/` com `dirs_exist_ok=True`
- Substituição de placeholders: `content.replace("{{PROJECT_NAME}}", project_name)`
- Sem dependências externas — apenas stdlib

**Critérios de aceite:**
- `python init.py --project "Teste" --path /tmp/teste --lang pt_BR` cria estrutura completa
- Executa em Linux, macOS e Windows com Python 3.10+
- Exit 0 em sucesso, Exit 1 com mensagem clara em erro

---

#### TASK-01.2 — Implementar generate_platform.py [M]
**Sistema:** SSPDD | **RF:** RF-007 | **Dependências:** TASK-01.1

**Contexto:**
Script que gera arquivos específicos de cada plataforma de IA a partir de `.agents/skills/`. Plataformas: `claude | cursor | copilot | opencode | all`. Contrato em `docs/techspec/sspdd-framework/script-contracts/init.md` seção "generate_platform.py".

**O que deve ser feito:**
- [ ] Implementar leitura de todos os `SKILL.md` em `.agents/skills/*/SKILL.md`
- [ ] Para `claude`: gerar `.claude/commands/[skill].md` com `@.agents/skills/[skill]/SKILL.md`
- [ ] Para `cursor`: gerar `.cursor/rules/sspdd-[skill].mdc` com conteúdo do SKILL.md + frontmatter cursor
- [ ] Para `copilot`: gerar `.github/copilot-instructions.md` concatenando skills relevantes
- [ ] Para `opencode`: gerar `.opencode/commands/[skill].md` (idem claude)
- [ ] Para `all`: executar todos os geradores acima

**Guia técnico:**
- Arquivo: `.agents/scripts/generate_platform.py`
- Ler frontmatter YAML do SKILL.md com regex (sem PyYAML): `re.search(r'^---\n(.*?)\n---', content, re.DOTALL)`
- Claude: arquivo com uma linha `@.agents/skills/[skill]/SKILL.md`
- Cursor: frontmatter `.mdc` = `---\ndescription: [description do SKILL.md]\n---\n[conteúdo]`

**Critérios de aceite:**
- `python generate_platform.py --platform all --path . --source .agents/` gera arquivos para todas as plataformas
- Arquivo `.claude/commands/prd.md` contém exatamente `@.agents/skills/prd/SKILL.md`

---

#### TASK-01.3 — Criar templates de memory/ e estrutura base [M]
**Sistema:** SSPDD | **RF:** RF-006 | **Dependências:** nenhuma | **[P] com TASK-01.1**

**Contexto:**
Templates para `memory/state.md` e `memory/constitution.md` que o `init.py` usa ao criar um novo workspace. Devem ter estrutura do Artifact Registry (schema ADR-007) e seções iniciais corretas.

**O que deve ser feito:**
- [ ] Criar `.agents/templates/pt_BR/memory/state-template.md` com seções: Toolset, Sistemas (tabela), Features Ativas, Artifact Registry, Evolução
- [ ] Criar `.agents/templates/pt_BR/memory/constitution-template.md` com seções: Contexto, ADRs (índice), BDRs, SDRs, DDRs, Princípios Estáveis
- [ ] Criar versões `en_US/` equivalentes
- [ ] Garantir que Artifact Registry usa schema: `| Artefato | v | Status |` (ADR-007)

**Critérios de aceite:**
- `memory/state.md` gerado por `init.py` contém seção `## Artifact Registry` com tabela 3 colunas
- `memory/constitution.md` gerado contém índices separados por tipo de DR (ADR, BDR, SDR, DDR)

---

#### TASK-01.4 — Criar .gitignore template e estrutura de docs/ [P]
**Sistema:** SSPDD | **RF:** RF-010 | **Dependências:** nenhuma | **[P] com TASK-01.1, 01.3**

**Contexto:**
Template de `.gitignore` para workspaces SSPDD e estrutura inicial de `docs/` gerada pelo `init.py`.

**O que deve ser feito:**
- [ ] Criar `.agents/templates/gitignore-template` com: `systems/`, `.env`, `*.key`, `*.pem` ignorados; `docs/`, `memory/constitution.md`, `memory/state.md` explicitamente não ignorados
- [ ] Garantir que `init.py` cria subdiretórios: `docs/prd/`, `docs/techspec/`, `docs/tasks/`, `docs/spdd/`, `docs/decisions/`, `docs/contracts/`, `docs/checklists/`, `docs/design/`, `docs/discovery/`
- [ ] Criar `.gitkeep` em cada subdiretório vazio

**Critérios de aceite:**
- Workspace criado por `init.py` tem todos os subdiretórios de `docs/` presentes
- `systems/` está no `.gitignore` gerado

---

## EPIC-02 — Engine de Validação

### US-02.1 — Validação automatizada de artefatos

#### TASK-02.1 — Implementar validate.py engine [G]
**Sistema:** SSPDD | **RF:** RF-003, RF-004 | **Dependências:** EPIC-01

**Contexto:**
Engine compartilhada de validação. Interface: `python .agents/scripts/validate.py --mode input|output --rules [json] --artifact [md] [--system S]`. Contrato completo em `docs/techspec/sspdd-framework/script-contracts/validate-engine.md`.

**O que deve ser feito:**
- [ ] Implementar parsing de `validate-rules.json` (stdlib `json`)
- [ ] Implementar modo `--mode input`: verificar existência de artefatos + leitura do Artifact Registry + detecção de stale
- [ ] Implementar parsing do Artifact Registry em `memory/state.md` (regex: `r'^\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|'`)
- [ ] Implementar modo `--mode output`: required_sections, no_empty_placeholders, id_patterns, gherkin_required_for_ids
- [ ] Implementar execução de `custom_steps` via `subprocess.run` com captura de stderr
- [ ] Implementar saída em stderr no formato `ERRO: ...` / `AVISO: ...`
- [ ] Garantir: exit 0 = válido, exit 1 = inválido, exit 2 = erro de configuração

**Guia técnico:**
- Arquivo: `.agents/scripts/validate.py`
- Gherkin detection: buscar `**Dado que**` OU `Given` dentro de 10 linhas após o ID do RF
- Stale parsing: `status.startswith("stale:")` → extrair `stale:prd@1.1` → fonte=`prd`, versão=`1.1`
- Substituição de variáveis no JSON: `json_str.replace("{{SYSTEM}}", system).replace("{{FEATURE}}", feature)`
- `custom_steps` executados com `subprocess.run(["python", script, *args], capture_output=True, text=True)`

**Critérios de aceite:**
- `python validate.py --mode output --rules prd/validate-rules.json --artifact docs/prd/valid.md` → exit 0
- `python validate.py --mode output --rules prd/validate-rules.json --artifact docs/prd/invalid.md` → exit 1 com ERROs em stderr
- `python validate.py --mode input --rules techspec/validate-rules.json --artifact docs/prd/stale.md` → exit 1 com `ERRO: Artefato stale: ...`
- Executa em < 5s para arquivo de 500 linhas

---

#### TASK-02.2 — Criar validate-rules.json para skills core [M]
**Sistema:** SSPDD | **RF:** RF-003 | **Dependências:** TASK-02.1 | **[P] com TASK-02.3**

**Contexto:**
Arquivos `validate-rules.json` declarativos para as skills do pipeline core. Um arquivo por skill com as regras específicas do artefato gerado pela skill.

**O que deve ser feito:**
- [ ] Criar `.agents/skills/prd/validate-rules.json` — required_sections de PRD, RF-NNN pattern, Gherkin por RF
- [ ] Criar `.agents/skills/techspec/validate-rules.json` — required_sections de TechSpec, traceability matrix obrigatória; input requer PRD + guidelines
- [ ] Criar `.agents/skills/tasks/validate-rules.json` — required_sections de Tasks, TASK-NNN pattern; input requer TechSpec
- [ ] Criar `.agents/skills/guidelines/validate-rules.json` — required_sections dos 9 arquivos de guidelines; input requer `memory/state.md`
- [ ] Criar `.agents/skills/discovery/validate-rules.json` — required_sections de discovery.md + canvas.md; seções R e E presentes

**Critérios de aceite:**
- `python validate.py --mode output --rules .agents/skills/prd/validate-rules.json --artifact docs/prd/sspdd-framework-prd.md` → exit 0
- validate-rules.json de techspec tem `required_artifacts` incluindo guidelines do sistema

---

#### TASK-02.3 — Criar validate-rules.json para skills SPDD e opcionais [M]
**Sistema:** SSPDD | **RF:** RF-003 | **Dependências:** TASK-02.1 | **[P] com TASK-02.2**

**O que deve ser feito:**
- [ ] Criar `.agents/skills/spdd-canvas/validate-rules.json` — 7 dimensões presentes, ownership por dimensão (linha `_Atualizado por:`), nenhuma dimensão vazia
- [ ] Criar `.agents/skills/spdd-sync/validate-rules.json` — deviations.md: DEV-NNN pattern, campos obrigatórios (dimensão, descrição, direção, status)
- [ ] Criar `.agents/skills/code-review/validate-rules.json` — relatório com seções de findings por categoria
- [ ] Criar `.agents/skills/implement/validate-rules.json` — input: task file + canvas READY

**Critérios de aceite:**
- validate-rules.json do spdd-canvas verifica que todas as 7 dimensões têm conteúdo não-vazio
- validate-rules.json do spdd-canvas verifica presença de `_Atualizado por:` em cada dimensão

---

#### TASK-02.4 — Implementar validate_skills.py [P]
**Sistema:** SSPDD | **RF:** RNF-004, RNF-007 | **Dependências:** TASK-02.1

**Contexto:**
Script de CI que valida estrutura de todos os `SKILL.md` em `.agents/skills/`. Valida: frontmatter obrigatório + 6 seções obrigatórias + `canvas-dimensions` contra conjunto válido `[R,E,A,S,O,N,S]` (ADR-012, Q-TS-001).

**O que deve ser feito:**
- [ ] Implementar leitura de todos os SKILL.md recursivamente
- [ ] Validar frontmatter: `name`, `description`, `canvas-dimensions`, `input-artifacts`, `output-artifacts` presentes
- [ ] Validar `canvas-dimensions`: cada valor em `[R, E, A, S, O, N, S]`
- [ ] Validar 6 seções obrigatórias: Objetivo, Pré-condições, Workflow, Artefatos, Canvas, Handoff
- [ ] Output: um erro por linha em stderr; exit 0 se todos válidos

**Critérios de aceite:**
- `python validate_skills.py .agents/skills/` → exit 0 após todas as skills implementadas
- SKILL.md com `canvas-dimensions: [R, X]` → exit 1 com `ERRO: [skill] canvas-dimensions inválido: X`

---

## EPIC-03 — Templates de Artefatos

### US-03.1 — Templates padronizados por artefato

#### TASK-03.1 — Templates PRD e Discovery [G]
**Sistema:** SSPDD | **RF:** RF-005, RF-012 | **Dependências:** nenhuma | **[P] com TASK-03.2..05**

**O que deve ser feito:**
- [ ] Criar `.agents/templates/pt_BR/prd-template.md` — 11 seções, placeholders RF-NNN, Gherkin obrigatório, tabela de stakeholders
- [ ] Criar `.agents/templates/pt_BR/discovery-template.md` — seções: Problema, Personas, Objetivos de Negócio, Hipótese de Solução, Contexto Adicional
- [ ] Criar versões `en_US/` equivalentes
- [ ] Garantir que todos os placeholders usam formato `{{SCREAMING_SNAKE_CASE}}`

**Critérios de aceite:**
- `validate.py --mode output` com artefato gerado a partir do template → exit 0 sem erros de placeholder
- Template PRD tem seção `## 3. Requisitos Funcionais` com exemplo RF-001 completo com Gherkin

---

#### TASK-03.2 — Templates TechSpec e Contratos [G]
**Sistema:** SSPDD | **RF:** RF-005, RF-009 | **Dependências:** nenhuma | **[P] com TASK-03.1**

**O que deve ser feito:**
- [ ] Criar `.agents/templates/pt_BR/techspec-template.md` — seções: visão geral, decisões arquiteturais, data model (link), contratos (link), teste, rastreabilidade
- [ ] Criar `.agents/templates/pt_BR/contracts-template.md` — para contratos de integração inter-sistemas
- [ ] Criar `.agents/templates/pt_BR/mock-contract-template.md` — contrato marcado como `PENDENTE DE VALIDAÇÃO`
- [ ] Criar versões `en_US/`

**Critérios de aceite:**
- Template TechSpec tem seção `## Matriz de Rastreabilidade` com tabela RF → implementação
- Template contracts tem campos: Interface, Direção, Campos, Responsável, Versão

---

#### TASK-03.3 — Template REASONS Canvas [G]
**Sistema:** SSPDD | **RF:** RF-002, RF-005 | **Dependências:** nenhuma | **[P] com TASK-03.1**

**Contexto:**
Template do REASONS Canvas com as 7 dimensões, campo de ownership por dimensão (`_Atualizado por: /[skill] v[x.y] — [data]_`) e referência a DRs. Schema completo em `docs/techspec/sspdd-framework/data-model.md` seção 3.

**O que deve ser feito:**
- [ ] Criar `.agents/templates/pt_BR/canvas-template.md` com as 7 dimensões
- [ ] Cada dimensão tem: heading `## [LETRA] — [Nome]`, linha de ownership, linha `> Decisões:`, área de conteúdo
- [ ] Adicionar cabeçalho com `_Status: DRAFT_`, data de início, idioma
- [ ] Criar versão `en_US/`

**Critérios de aceite:**
- Canvas gerado a partir do template tem todas as 7 dimensões com ownership placeholder
- validate-rules.json do spdd-canvas valida canvas gerado → exit 0

---

#### TASK-03.4 — Template Decision Record e Tasks [M]
**Sistema:** SSPDD | **RF:** RF-005, RF-015 | **Dependências:** nenhuma | **[P] com TASK-03.1**

**O que deve ser feito:**
- [ ] Criar `.agents/templates/pt_BR/decision-record-template.md` — frontmatter YAML (id, type, status, date, supersedes, superseded-by) + 4 seções obrigatórias
- [ ] Criar `.agents/templates/pt_BR/tasks-template.md` — estrutura de Epics → User Stories → Tasks com tabela de metadados por task
- [ ] Criar versões `en_US/`

**Critérios de aceite:**
- DR template tem frontmatter YAML com todos os campos do schema (data-model.md seção 2)
- Tasks template tem tabela de dependências e campo `[P]` de paralelismo

---

#### TASK-03.5 — Templates auxiliares (Design Brief, Checklist, Deviations) [M]
**Sistema:** SSPDD | **RF:** RF-005, RF-011 | **Dependências:** nenhuma | **[P] com TASK-03.1**

**O que deve ser feito:**
- [ ] Criar `.agents/templates/pt_BR/design-brief-template.md` — tokens de cor, tipografia, componentes, padrões de interação
- [ ] Criar `.agents/templates/pt_BR/checklist-template.md` — checklist de qualidade para PRD e TechSpec
- [ ] Criar `.agents/templates/pt_BR/deviations-template.md` — DEV-NNN, dimensão afetada, direção, justificativa, status
- [ ] Criar versões `en_US/`

**Critérios de aceite:**
- Cada template tem pelo menos um exemplo preenchido para orientar a IA
- Todos os placeholders em `{{SCREAMING_SNAKE_CASE}}`

---

## EPIC-04 — Skills do Pipeline Core

### US-04.1 — Skills de discovery e especificação

#### TASK-04.1 — SKILL.md: /discovery [G]
**Sistema:** SSPDD | **RF:** RF-012 | **Dependências:** EPIC-01, 02, 03

**Contexto:**
Nova skill (não existe no SDD original). Conduz levantamento leve focado em problema, personas e contexto de negócio. Inicializa o REASONS Canvas com dimensões R e E em DRAFT. É a porta de entrada do pipeline.

**O que deve ser feito:**
- [ ] Definir frontmatter: `canvas-dimensions: [R, E]`, input: nenhum, output: `discovery.md` + `canvas.md` (DRAFT)
- [ ] Escrever workflow em 5 fases: pré-condições → entrevista (problema, personas, objetivos, hipótese) → consolidação → geração progressiva dos dois artefatos → handoff
- [ ] Garantir: pula perguntas redundantes quando `/prd` é executado logo após
- [ ] Escrever seção Canvas: atualiza R com objetivos e E com entidades de domínio rascunho
- [ ] Escrever bloco de Handoff para `memory/state.md`

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow define claramente quais perguntas são feitas e em que ordem
- Seção Canvas especifica exatamente o que escrever em R e E

---

#### TASK-04.2 — SKILL.md: /prd [M]
**Sistema:** SSPDD | **RF:** RF-001 | **Dependências:** EPIC-01, 02, 03

**Contexto:**
Migrar e adaptar o `/prd` do SDD para o SSPDD com: canvas-dimensions no frontmatter, integração com discovery (pular perguntas já respondidas), validação dual e atualização do Artifact Registry.

**O que deve ser feito:**
- [ ] Adicionar frontmatter com `canvas-dimensions: [R]`, input/output artifacts declarados
- [ ] Adaptar Fase 0 para ler discovery.md se existir e pular módulos A, B já respondidos
- [ ] Adicionar chamada a `validate.py --mode output` ao final da geração
- [ ] Adicionar atualização do Artifact Registry em state.md ao handoff
- [ ] Documentar seção Canvas: atualiza dimensão R com RFs validados com Gherkin

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Fase de geração inclui instrução de salvamento progressivo (seção por seção)
- Seção Handoff inclui entrada no Artifact Registry com versão e status

---

#### TASK-04.3 — SKILL.md: /guidelines [M]
**Sistema:** SSPDD | **RF:** RF-001 | **Dependências:** EPIC-01, 02, 03

**O que deve ser feito:**
- [ ] Adicionar frontmatter completo com `canvas-dimensions: [N]` (Norms extraídas para canvas)
- [ ] Adaptar workflow para criar DRs tipo ADR para decisões de stack e arquitetura
- [ ] Adicionar geração de DR (ADR-NNN) para cada decisão técnica significativa tomada na entrevista
- [ ] Adicionar chamada a `validate.py --mode output` ao final
- [ ] Adicionar atualização do Artifact Registry

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow cria pelo menos um ADR por decisão de stack confirmada pelo usuário

---

#### TASK-04.4 — SKILL.md: /techspec [G]
**Sistema:** SSPDD | **RF:** RF-001, RF-013, RF-014 | **Dependências:** EPIC-01, 02, 03

**Contexto:**
Skill mais complexa do pipeline. Deve incluir: validação de guidelines por tipo de sistema (RF-013), detecção de dependências inter-sistemas com opção de mock (RF-014), atualização das dimensões E, A, S, N do canvas, e criação de DRs técnicos.

**O que deve ser feito:**
- [ ] Adicionar frontmatter: `canvas-dimensions: [E, A, S, N]`
- [ ] Implementar Fase 0 de pré-condições: verificar guidelines locais (`systems/[sistema]/guidelines/`); se ausentes, instrui clone e aguarda
- [ ] Implementar detecção de interfaces inter-sistemas: para cada sistema integrado, verificar path local → se ausente, instrui clone → se terceiro, solicita documentação → oferece mock
- [ ] Ao gerar mock: criar `docs/contracts/[sistema]-mock-contract.md` com `PENDENTE DE VALIDAÇÃO`
- [ ] Atualizar canvas dimensões E, A, S após geração de artefatos; N extraída dos guidelines
- [ ] Criar DRs tipo ADR para decisões técnicas da feature
- [ ] Adicionar validação dual e atualização do Artifact Registry

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Fase 0 instrui corretamente para guidelines ausentes (sistema próprio vs. terceiro)
- Mock contract é criado com marcação `PENDENTE DE VALIDAÇÃO` e task de substituição referenciada

---

#### TASK-04.5 — SKILL.md: /tasks [M]
**Sistema:** SSPDD | **RF:** RF-001 | **Dependências:** EPIC-01, 02, 03

**O que deve ser feito:**
- [ ] Adicionar frontmatter: `canvas-dimensions: [O]`
- [ ] Adaptar workflow para atualizar dimensão O do canvas com lista de tasks ordenada após geração
- [ ] Adicionar verificação de stale no input (TechSpec deve estar ok no Artifact Registry)
- [ ] Adicionar criação de DRs tipo BDR para decisões de priorização/escopo tomadas durante o planejamento
- [ ] Adicionar validação dual e atualização do Artifact Registry

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Seção Canvas descreve exatamente o que escrever na dimensão O (lista de tasks com TASK-NNN)

---

#### TASK-04.6 — SKILL.md: /implement [M]
**Sistema:** SSPDD | **RF:** RF-001 | **Dependências:** EPIC-01, 02, 03

**O que deve ser feito:**
- [ ] Adicionar frontmatter: `canvas-dimensions: []` (não atualiza canvas diretamente)
- [ ] Adaptar Fase 0 para ler canvas da feature e verificar status `READY`; se `DRAFT`, alertar usuário
- [ ] Adicionar leitura das dimensões N (Norms) e S (Safeguards) do canvas como contexto de implementação
- [ ] Após implementação, sugerir execução de `validate.py` e `/spdd-sync`
- [ ] Adicionar atualização do Artifact Registry para a task implementada

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow inclui leitura explícita das dimensões N e S do canvas antes de gerar código

---

#### TASK-04.7 — SKILL.md: /code-review [M]
**Sistema:** SSPDD | **RF:** RF-001 | **Dependências:** EPIC-01, 02, 03

**O que deve ser feito:**
- [ ] Adicionar frontmatter: `canvas-dimensions: [S]` (Safeguards)
- [ ] Adaptar workflow para ao final: extrair guardrails identificados na revisão e atualizar dimensão S do canvas
- [ ] Após atualização de S: verificar se canvas está READY (todas as dimensões preenchidas) e atualizar status
- [ ] Criar DRs tipo ADR para decisões de refatoração ou debt técnico aceito conscientemente
- [ ] Adicionar validação dual e atualização do Artifact Registry

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow atualiza status do canvas para `READY` quando S é a última dimensão preenchida

---

#### TASK-04.8 — SKILL.md: /tdd [M]
**Sistema:** SSPDD | **RF:** RF-011 | **Dependências:** EPIC-01, 02, 03

**O que deve ser feito:**
- [ ] Adicionar frontmatter: `canvas-dimensions: []`, input: task file + canvas
- [ ] Adaptar workflow para ciclo Red (testes falhando) → Green (implementação mínima) → Refactor → Review integrado
- [ ] Incluir leitura de dimensões N e S do canvas como /implement
- [ ] Ao finalizar: sugerir `/spdd-sync`

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow tem as 4 fases do ciclo TDD claramente separadas com outputs de cada fase

---

#### TASK-04.9 — SKILL.md: /tests [M]
**Sistema:** SSPDD | **RF:** RF-011 | **Dependências:** EPIC-01, 02, 03

**O que deve ser feito:**
- [x] Adicionar frontmatter: `canvas-dimensions: []`, input: task file + código implementado
- [x] Workflow: ler critérios de aceite da task → gerar suite de testes → executar → reportar cobertura
- [x] Gerar testes com base nos blocos Gherkin dos RFs da task
- [x] Suporte a TDD mode (gerar antes do código) e audit mode (gerar após código)

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow diferencia claramente TDD mode vs. audit mode

---

## EPIC-05 — Skills SPDD

### US-05.1 — Canvas progressivo e sincronização

#### TASK-05.1 — SKILL.md: /spdd-canvas [G]
**Sistema:** SSPDD | **RF:** RF-002 | **Dependências:** EPIC-04

**Contexto:**
Skill que gera o REASONS Canvas completo a partir do PRD + TechSpec (para features que não passaram pelo /discovery). Também responsável pela atualização manual do canvas quando necessário.

**O que deve ser feito:**
- [x] Definir frontmatter: `canvas-dimensions: [R, E, A, S, O, N, S]`
- [x] Workflow: ler PRD + TechSpec + Tasks (se existir) → preencher cada dimensão com ownership → salvar progressivamente dimensão por dimensão
- [x] Regra: nunca publicar canvas com dimensão O vazia (status permanece DRAFT)
- [x] Ao final: verificar completude → se todas 7 preenchidas → status `READY`
- [x] Adicionar validate-rules.json já criado na TASK-02.3

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow inclui instrução explícita de salvamento progressivo (uma dimensão por vez)
- Canvas não transita para READY sem dimensão O preenchida

---

#### TASK-05.2 — SKILL.md: /spdd-sync [G]
**Sistema:** SSPDD | **RF:** RF-008 | **Dependências:** EPIC-05 (TASK-05.1)

**Contexto:**
Skill que detecta divergências entre o REASONS Canvas e o código implementado. Oferece resolução bidirecional. Registra todo desvio em `docs/spdd/[feature]-deviations.md`.

**O que deve ser feito:**
- [x] Definir frontmatter: `canvas-dimensions: []`, input: canvas + diff de código
- [x] Workflow: ler canvas → ler diff → para cada dimensão afetada, identificar divergência → apresentar ao usuário → aguardar decisão → aplicar resolução → registrar em deviations.md
- [x] Detecção por dimensão: E (nova entidade), S (nova dependência), O (task implementada diferente), S-safeguards (violação)
- [x] Formato de deviations: DEV-NNN com campos do schema (data-model.md seção 6)

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow apresenta cada divergência individualmente (não em bloco) aguardando decisão

---

#### TASK-05.3 — SKILL.md: /analyze [M]
**Sistema:** SSPDD | **RF:** RF-011, RNF-005 | **Dependências:** EPIC-04

**Contexto:**
Skill de consistência cross-artefato. Detecta: RFs sem task, tasks sem RF origem, canvas divergindo de TechSpec, contradições entre artefatos.

**O que deve ser feito:**
- [x] Definir frontmatter: `canvas-dimensions: []`, input: PRD + TechSpec + Tasks + Canvas
- [x] Workflow: ler todos os artefatos → mapear RF→Task (detectar gaps) → mapear canvas dimensões→artefatos (detectar divergências) → gerar relatório
- [x] Adicionar custom_step no validate-rules.json: `check_rf_coverage.py` que verifica RF→Task coverage
- [x] Relatório: agrupado por tipo de achado (gap, divergência, contradição)

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow detecta 100% dos RFs sem task correspondente

---

## EPIC-06 — Skills Opcionais

#### TASK-06.1 — SKILL.md: /clarify [M]
**Sistema:** SSPDD | **RF:** RF-011 | **Dependências:** EPIC-04 | **[P] com TASK-06.2..06**

**O que deve ser feito:**
- [x] Frontmatter: `canvas-dimensions: [R]`, input: PRD com questões em aberto
- [x] Workflow: identificar ambiguidades no PRD → apresentar uma por vez → atualizar PRD → bump versão MINOR → atualizar Artifact Registry → marcar downstream como stale

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow faz bump de versão do PRD e propaga stale ao TechSpec no Artifact Registry

---

#### TASK-06.2 — SKILL.md: /checklist [M]
**Sistema:** SSPDD | **RF:** RF-011 | **Dependências:** EPIC-04 | **[P] com TASK-06.1**

**O que deve ser feito:**
- [ ] Frontmatter: `canvas-dimensions: []`, input: PRD ou TechSpec
- [ ] Workflow: aplicar checklist de qualidade ao artefato → listar itens críticos (bloqueantes) e não-críticos → gerar `docs/checklists/[feature]-[tipo].md`

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow diferencia itens críticos (bloqueiam próxima etapa) de não-críticos (melhorias)

---

#### TASK-06.3 — SKILL.md: /designer [M]
**Sistema:** SSPDD | **RF:** RF-011 | **Dependências:** EPIC-04 | **[P] com TASK-06.1**

**O que deve ser feito:**
- [ ] Frontmatter: `canvas-dimensions: [E]`, input: PRD, output: design-brief.md
- [ ] Workflow: levantamento de tokens visuais → componentes → padrões de interação → atualizar dimensão E do canvas com entidades UX/UI → criar DRs tipo DDR

**Critérios de aceite:**
- SKILL.md passa `validate_skills.py`
- Workflow cria DDR para decisões de design system

---

#### TASK-06.4 — Scripts custom para /analyze e /techspec [M]
**Sistema:** SSPDD | **RF:** RNF-005, RF-014 | **Dependências:** EPIC-02 | **[P] com TASK-06.1**

**O que deve ser feito:**
- [ ] Implementar `.agents/skills/analyze/scripts/check_rf_coverage.py` — lê tasks.md e PRD, verifica RF sem task, retorna exit 1 com lista de gaps
- [ ] Implementar `.agents/skills/techspec/scripts/check_rf_coverage.py` — verifica RF do PRD sem cobertura na traceability matrix do TechSpec
- [ ] Garantir interface: `python script.py --prd [path] [--tasks [path]]` com saída em stderr

**Critérios de aceite:**
- `check_rf_coverage.py` detecta RF-999 fictício não coberto em tasks → exit 1 com mensagem
- Scripts são standalone (não dependem do validate.py engine)

---

#### TASK-06.5 — SKILL.md: /clarify skill para DRs [P]
**Sistema:** SSPDD | **RF:** RF-015 | **Dependências:** EPIC-07 | **[P] com TASK-06.1**

**O que deve ser feito:**
- [ ] Adicionar ao workflow de todas as skills core (guidelines, prd, techspec) instrução de criação de DRs nos momentos de decisão
- [ ] Definir helper de criação de DR: verificar próximo número da sequência no índice de constitution.md, criar arquivo, adicionar ao índice

**Critérios de aceite:**
- Toda skill core menciona explicitamente quando e como criar DRs no seu workflow
- Helper de DR verifica o índice de constitution.md antes de atribuir NNN

---

#### TASK-06.6 — Fixtures de teste para skills [M]
**Sistema:** SSPDD | **RF:** RNF-007 | **Dependências:** EPIC-03, 04 | **[P] com TASK-06.1**

**O que deve ser feito:**
- [ ] Para cada skill com validate-rules.json: criar `scripts/tests/fixtures/valid_[artefato].md`
- [ ] Para cada skill com validate-rules.json: criar `scripts/tests/fixtures/invalid_[artefato].md` com erros conhecidos documentados em comentário
- [ ] Skills com fixture: prd, techspec, tasks, discovery, spdd-canvas, spdd-sync, guidelines, code-review

**Critérios de aceite:**
- `python validate.py --mode output --rules [skill]/validate-rules.json --artifact valid_[artefato].md` → exit 0
- `python validate.py --mode output --rules [skill]/validate-rules.json --artifact invalid_[artefato].md` → exit 1 com erros esperados

---

## EPIC-07 — Sistema de Decision Records

#### TASK-07.1 — Templates e schema de DRs [M]
**Sistema:** SSPDD | **RF:** RF-015 | **Dependências:** EPIC-03 | **[P] com EPIC-04, 05, 06**

**O que deve ser feito:**
- [ ] Garantir que `decision-record-template.md` está em pt_BR e en_US (verificar TASK-03.4)
- [ ] Criar `validate-rules.json` para DRs: frontmatter YAML com campos obrigatórios, 4 seções presentes, status em `[accepted, superseded, deprecated]`
- [ ] Adicionar DR ao `validate_skills.py` como tipo especial (não é SKILL.md mas tem schema)

**Critérios de aceite:**
- DR template gerado por skill passa `validate.py --mode output` com rules de DR
- Status inválido `in-progress` → exit 1 com `ERRO: status inválido`

---

#### TASK-07.2 — Índice de DRs em constitution.md [M]
**Sistema:** SSPDD | **RF:** RF-015 | **Dependências:** TASK-07.1

**O que deve ser feito:**
- [ ] Atualizar template de `constitution.md` (TASK-01.3) para incluir índice de DRs por tipo com links relativos
- [ ] Documentar no helper de DR (TASK-06.5) como atualizar o índice ao criar nova DR
- [ ] Adicionar verificação de integridade no `validate_skills.py`: DRs referenciados no índice existem em `docs/decisions/`

**Critérios de aceite:**
- constitution.md gerado tem seções `### ADR`, `### BDR`, `### SDR`, `### DDR` com contador separado
- Link quebrado no índice detectado por `validate_skills.py` → AVISO

---

#### TASK-07.3 — Integração DRs no canvas [P]
**Sistema:** SSPDD | **RF:** RF-015 | **Dependências:** TASK-05.1, TASK-07.1

**O que deve ser feito:**
- [ ] Garantir que canvas-template.md tem linha `> Decisões: ` em cada dimensão (verificar TASK-03.3)
- [ ] Documentar no SKILL.md de cada skill: ao atualizar dimensão do canvas, adicionar referências às DRs criadas na mesma fase
- [ ] Adicionar ao validate-rules.json do canvas: verificar que linha `> Decisões:` existe em cada dimensão (pode ser vazia `> Decisões: —` se nenhuma DR)

**Critérios de aceite:**
- Canvas com dimensão sem linha `> Decisões:` → exit 1 no validate output
- Canvas com `> Decisões: —` → exit 0 (DR explicitamente vazia é válida)

---

## EPIC-08 — Agents e Documentação do Framework

#### TASK-08.1 — Agent definitions [M]
**Sistema:** SSPDD | **RF:** RF-007 | **Dependências:** EPIC-01 | **[P] com EPIC-04**

**O que deve ser feito:**
- [ ] Criar `.agents/agents/architect.md` — papel, especialidade, quando invocar, formato de output esperado
- [ ] Criar `.agents/agents/database.md`
- [ ] Criar `.agents/agents/designer.md`
- [ ] Criar `.agents/agents/devops.md`
- [ ] Criar `.agents/agents/qa.md`
- [ ] Criar `.agents/agents/security.md`
- [ ] Cada agente referencia as skills do pipeline que ele complementa

**Critérios de aceite:**
- Todos os 6 agentes têm: Role, Especialidade, Quando Invocar, Outputs Esperados
- `generate_platform.py` gera `.claude/agents/[nome].md` referenciando o arquivo em `.agents/agents/`

---

#### TASK-08.2 — Templates AGENTS.md e CLAUDE.md [M]
**Sistema:** SSPDD | **RF:** RF-007 | **Dependências:** TASK-08.1

**O que deve ser feito:**
- [ ] Criar `.agents/templates/AGENTS.md-template` — lista todas as skills com nome, description e quando usar; lista todos os agents; pipeline completo em uma seção
- [ ] Criar `.agents/templates/CLAUDE.md-template` — referencia AGENTS.md via `@`; comportamento.md inline ou referenciado; memory references
- [ ] Garantir que `init.py` popula esses templates com skills reais lidas dos SKILL.md (frontmatter name + description)

**Critérios de aceite:**
- AGENTS.md gerado lista todas as skills com description correta extraída do frontmatter
- CLAUDE.md gerado referencia `@AGENTS.md`, `@memory/constitution.md`, `@memory/state.md`

---

#### TASK-08.3 — README.md do framework [G]
**Sistema:** SSPDD | **RF:** RF-007 | **Dependências:** TASK-08.1, 08.2

**O que deve ser feito:**
- [ ] Criar `README.md` na raiz do repositório SSPDD com: o que é, pipeline visual, quick start (3 comandos), estrutura de diretórios, como contribuir
- [ ] Incluir badges: Python 3.10+, plataformas suportadas, licença
- [ ] Incluir seção "Como funciona" com diagrama ASCII do pipeline + canvas progressivo
- [ ] Incluir seção "Decision Records" explicando os 4 tipos

**Critérios de aceite:**
- Quick start funciona do zero em menos de 5 minutos seguindo apenas o README
- Pipeline diagram mostra corretamente o canvas progressivo por fase

---

## EPIC-09 — Integração RTK

#### TASK-09.1 — Integração RTK no init.py [M]
**Sistema:** SSPDD | **RF:** RF-016 | **Dependências:** TASK-01.1

**O que deve ser feito:**
- [ ] Implementar detecção: `shutil.which("rtk")` → None se não instalado
- [ ] Se não instalado: exibir mensagem de aviso com instrução de instalação (brew + curl alternativas)
- [ ] Se instalado: `subprocess.run(["rtk", "init", "-g"], cwd=path, capture_output=True)`
- [ ] Capturar stderr do rtk e reportar como AVISO se qualquer erro; não abortar o init
- [ ] Implementar flag `--skip-rtk` que bypassa as etapas 2 e 6

**Critérios de aceite:**
- `init.py` com RTK ausente: exibe aviso e prossegue normalmente
- `init.py` com RTK presente: executa `rtk init -g` e reporta sucesso/falha
- `init.py --skip-rtk`: não verifica nem executa RTK

---

## EPIC-10 — Testes e CI

#### TASK-10.1 — Suite de testes do validate.py engine [G]
**Sistema:** SSPDD | **RF:** RF-003, RNF-002 | **Dependências:** EPIC-02, 03, 06

**O que deve ser feito:**
- [ ] Configurar pytest em `.agents/scripts/tests/`
- [ ] Testes unitários: parsing de Artifact Registry, detecção de stale, id_patterns, gherkin detection, placeholder detection
- [ ] Testes de integração: validate engine com fixtures de cada skill (valid + invalid)
- [ ] Benchmark: verificar que p95 < 5s para arquivo de 500 linhas
- [ ] Testar custom_steps: mock de subprocess para simular script custom

**Critérios de aceite:**
- `pytest .agents/scripts/tests/ -v` → 100% dos testes passam
- Benchmark confirma < 5s para fixture de 500 linhas

---

#### TASK-10.2 — Suite de testes do init.py [M]
**Sistema:** SSPDD | **RF:** RF-010, RF-016 | **Dependências:** EPIC-01, 09

**O que deve ser feito:**
- [ ] Testes usando `tmp_path` do pytest para criar workspace em diretório temporário
- [ ] Testar: estrutura de diretórios criada, AGENTS.md gerado, CLAUDE.md gerado, Artifact Registry inicializado
- [ ] Testar com `--lang pt_BR` e `--lang en_US`
- [ ] Testar RTK: mock `shutil.which` → None e → `/usr/bin/rtk`; verificar chamada a subprocess
- [ ] Testar `--skip-rtk`

**Critérios de aceite:**
- `pytest scripts/tests/ -v` → 100% passam
- Teste com `--lang en_US` verifica que templates copiados são da pasta `en_US/`

---

#### TASK-10.3 — validate_skills.py e CI check [M]
**Sistema:** SSPDD | **RF:** RNF-004, RNF-007 | **Dependências:** EPIC-02, 04, 05, 06

**O que deve ser feito:**
- [ ] Implementar `validate_skills.py` conforme TASK-02.4
- [ ] Testes: SKILL.md válido → exit 0; canvas-dimensions inválido → exit 1; seção ausente → exit 1
- [ ] Criar fixture de SKILL.md mínimo válido para referência de contributors

**Critérios de aceite:**
- `python validate_skills.py .agents/skills/` → exit 0 com todas as skills do framework
- `python validate_skills.py .agents/skills/` com SKILL.md de teste inválido → exit 1 com mensagem específica

---

#### TASK-10.4 — GitHub Actions CI workflow [G]
**Sistema:** SSPDD | **RF:** RNF-001, RNF-003 | **Dependências:** EPIC-10 (TASK-10.1..03)

**O que deve ser feito:**
- [ ] Criar `.github/workflows/ci.yml` com jobs: lint-python, test-scripts, validate-skills, test-init
- [ ] Configurar matrix de SOs: `ubuntu-latest`, `macos-latest`, `windows-latest`
- [ ] Configurar matrix de Python: `3.10`, `3.11`, `3.12`
- [ ] Job lint-python: `ruff check .agents/scripts/ scripts/` + `ruff format --check`
- [ ] Job test-scripts: `pytest .agents/scripts/tests/ scripts/tests/ --tb=short`
- [ ] Job validate-skills: `python .agents/scripts/validate_skills.py .agents/skills/`
- [ ] Adicionar badge de CI no README.md

**Critérios de aceite:**
- CI passa em todos os 9 combinações (3 SOs × 3 Python versions) após EPIC-10 completo
- Falha em qualquer job bloqueia merge para `develop`

---

## Backlog Priorizado (Ordem de Início)

| Prioridade | Task | Motivo |
|-----------|------|--------|
| 1 | TASK-01.1 (init.py) | Desbloqueia tudo |
| 2 | TASK-02.1 (validate engine) | Desbloqueia todas as skills |
| 2 | TASK-03.1..05 (templates) [P] | Paralelo com TASK-02 |
| 2 | TASK-01.2..04 [P] | Paralelo com TASK-02 |
| 3 | TASK-04.1 (/discovery) | Nova skill crítica — RF-012 |
| 3 | TASK-04.4 (/techspec) | Mais complexa — RF-013, RF-014 |
| 3 | TASK-02.2..03 (rules.json) [P] | Paralelo com skills |
| 4 | TASK-04.2..09 (skills restantes) [P] | Paralelas entre si |
| 4 | TASK-05.1..03 [P] | Paralelas |
| 4 | TASK-06.1..06 [P] | Paralelas |
| 4 | TASK-07.1..03 [P] | Paralelas |
| 4 | TASK-08.1..03 [P] | Paralelas |
| 4 | TASK-09.1 (RTK) | Paralela com skills |
| 5 | TASK-10.1..04 (CI) | Após tudo |

## Fora do Escopo (Backlog Futuro)

- Rastreamento de custos de LLM (Q-TS-002 — fora do escopo v1.0)
- Plugin para IDEs (VS Code, JetBrains)
- Dashboard web de progresso de features
- Integração nativa com Linear/Jira para tasks
- GitHub Issues automáticos por task (RF-011 fase 5 do /tasks — opcional, não implementar agora)
