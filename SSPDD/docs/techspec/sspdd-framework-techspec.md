# TechSpec — SSPDD Framework
_Versão: 1.0 | Status: Em Revisão | Data: 2026-08-22 | Autor: Thiago Cavalcante_
_PRD: docs/prd/sspdd-framework-prd.md v1.1_

---

## 1. Visão Geral Técnica

SSPDD é um framework de arquivos (não um binário) que habilita um pipeline de desenvolvimento guiado por IA. É composto por duas camadas:

- **Camada de prompts** — `SKILL.md` files, templates Markdown, `AGENTS.md`, `CLAUDE.md`
- **Camada de scripts** — Python 3.10+ stdlib: `validate.py` (engine), `init.py`, `generate_platform.py`

As camadas interagem apenas via sistema de arquivos — nenhuma chamada entre elas em tempo de execução. A camada de prompts é executada pelo LLM; a camada de scripts é executada pelo usuário (ou pelo LLM via tool use).

→ Artefatos detalhados: [data-model.md](sspdd-framework/data-model.md) | [quickstart.md](sspdd-framework/quickstart.md)

---

## 2. Decisões Arquiteturais

> Decisões: ADR-010, ADR-011, ADR-012, ADR-003, ADR-004, ADR-007, ADR-008, ADR-009

| ADR | Decisão | Impacto |
|-----|---------|---------|
| ADR-003 | Distribuição via `init.py` Python (sem CLI Go) | Sem runtime externo além de Python 3.10+ |
| ADR-004 | `.agents/` canônico; `.claude/` espelho via `@` | Zero duplicação; nova plataforma = novo mapeamento |
| ADR-007 | Artifact Registry: 3 colunas, stale inline (`stale:FONTE@V`) | Parsing com regex simples, sem YAML |
| ADR-008 | Repositórios externos sempre locais em `systems/` | Scripts offline; skill instrui git clone |
| ADR-009 | Templates pt_BR/en_US selecionáveis no `init.py --lang` | Duas cópias independentes de templates |
| ADR-010 | Canvas push com dimension ownership | Canvas cresce com o pipeline; cada dimensão tem skill owner |
| ADR-011 | validate.py engine + JSON rules + custom_steps opcionais | Zero duplicação Python; flexibilidade via scripts custom |
| ADR-012 | DR numbering por tipo (ADR-NNN, BDR-NNN, SDR-NNN, DDR-NNN) | Recuperação semântica por domínio |

---

## 3. Modelo de Dados

→ Documento completo: [data-model.md](sspdd-framework/data-model.md)

**Schemas definidos:**
- Artifact Registry (tabela 3 colunas em `memory/state.md`)
- Decision Record (frontmatter YAML + 4 seções Markdown)
- REASONS Canvas (7 dimensões com ownership por skill)
- SKILL.md (frontmatter + 6 seções obrigatórias)
- validate-rules.json (campos engine + custom_steps)
- Deviations Record (`docs/spdd/[feature]-deviations.md`)

---

## 4. Contratos de Scripts

→ Documentos completos: [script-contracts/](sspdd-framework/script-contracts/)

### 4.1 validate.py (engine compartilhada)
**Localização:** `.agents/scripts/validate.py`
**Interface:** `python validate.py --mode input|output --rules [json] --artifact [md] [--system S]`
**Exit:** 0 = válido, 1 = inválido, 2 = erro de configuração
**Dependências:** stdlib apenas (`re`, `json`, `pathlib`, `subprocess`, `sys`)
**SLA:** < 5s para artefatos até 500 linhas

### 4.2 init.py
**Localização:** `scripts/init.py`
**Interface:** `python init.py --project NAME --path PATH --lang LANG [--platform P] [--skip-rtk]`
**7 etapas:** validação → RTK check → estrutura de dirs → AGENTS.md/CLAUDE.md → plataformas → RTK init → output
**Dependências:** stdlib apenas + RTK opcional (detectado via `shutil.which`)

### 4.3 generate_platform.py
**Localização:** `.agents/scripts/generate_platform.py`
**Interface:** `python generate_platform.py --platform P --path PATH --source .agents/`
**Plataformas:** `claude | cursor | copilot | opencode | all`

---

## 5. Arquitetura de Skills

### 5.1 Pipeline e Ownership do Canvas

```
Skill           Dimensões Canvas    Artefatos Gerados
────────────────────────────────────────────────────────
/discovery      R, E (rascunho)     discovery.md, canvas.md (DRAFT)
/prd            R (refinado)        prd.md
/clarify        R (atualizado)      prd.md (versão bump)
/checklist      —                   checklists/[feature]-prd.md
/designer       E (UX/UI)           design-brief.md
/techspec       E, A, S, N          techspec.md, data-model.md, quickstart.md
/tasks          O                   tasks.md
/analyze        —                   relatório (sem artefato permanente)
/implement      —                   código (fora do workspace de artefatos)
/tdd            —                   código + testes
/code-review    S (Safeguards)      relatório; canvas → READY
/tests          —                   suite de testes
/spdd-sync      —                   deviations.md (se divergências)
```

### 5.2 Estrutura de Diretório por Skill

```
.agents/skills/[nome]/
├── SKILL.md                    # Prompt + workflow completo
├── validate-rules.json         # Regras declarativas de validação
└── scripts/
    └── [custom].py             # Scripts opcionais referenciados em custom_steps
```

Templates ficam em `.agents/templates/[lang]/[nome]/`:
```
.agents/templates/
├── pt_BR/
│   ├── prd-template.md
│   ├── techspec-template.md
│   ├── canvas-template.md
│   ├── decision-record-template.md
│   └── ...
└── en_US/
    └── (mesmos arquivos)
```

### 5.3 Cascade de Stale

```
PRD v1.0 → TechSpec v1.0 → Tasks v1.0
    ↓ (bump para v1.1)
Artifact Registry:
  techspec/[f]-techspec.md | 1.0 | stale:prd@1.1
  tasks/[s]-[f]-tasks.md   | 1.0 | stale:prd@1.1

→ validate.py --mode input detecta stale antes de /tasks
→ usuário executa /techspec novamente
→ TechSpec bump para v1.1
→ tasks.md atualizado para stale:techspec@1.1
→ usuário executa /tasks novamente
→ todos ok
```

Stale com `--force`: usuário pode prosseguir com artefato stale; skill registra desvio consciente em `memory/state.md`.

---

## 6. Integração com Decision Records

### 6.1 Criação por Skills

| Skill | Tipo de DR criado | Quando |
|-------|------------------|--------|
| /guidelines | ADR | Decisões de stack e arquitetura do sistema |
| /prd | BDR, SDR | Decisões de escopo, público, priorização |
| /designer | DDR | Decisões de design system e componentes |
| /techspec | ADR | Decisões técnicas da feature |
| /code-review | ADR | Decisões de refatoração ou debt técnico aceito |

### 6.2 Referência no Canvas
Cada dimensão do canvas inclui linha `> Decisões: [TIPO]-[NNN], ...` com as DRs que fundamentam aquela dimensão. O leitor do canvas sabe exatamente onde buscar o raciocínio por trás de cada decisão.

### 6.3 Índice em constitution.md
`memory/constitution.md` mantém índice por tipo:
```markdown
## Decision Records

### ADR
- [ADR-001](../docs/decisions/ADR-001-canvas-push.md) — Canvas push com dimension ownership
- [ADR-002](../docs/decisions/ADR-002-validate-engine.md) — Engine híbrida de validação

### BDR
- [BDR-001](../docs/decisions/BDR-001-escopo-mvp.md) — Escopo do MVP
```

---

## 7. Integração com RTK

RTK integra via hook nativo da plataforma gerado por `rtk init -g`. Para Claude Code, adiciona PreToolUse hook que prefixa comandos bash com `rtk`. O SSPDD não controla nem mantém o RTK — apenas verifica sua presença no `init.py` e o habilita se disponível.

Impacto no framework: nenhum. O RTK é transparente — comprime output de shell antes que o LLM leia, sem alterar comportamento das skills ou scripts.

---

## 8. Estratégia de Testes

### 8.1 Scripts Python (validate.py, init.py, generate_platform.py)

| Tipo | Ferramenta | Cobertura alvo |
|------|-----------|----------------|
| Unitário (engine) | pytest | validate.py: parsing de registry, id_patterns, gherkin detection |
| Integração (init.py) | pytest + tmp_path | Estrutura criada corretamente para cada --platform |
| Fixtures | Markdown files | valid_[artefato].md + invalid_[artefato].md por skill |

**Localização dos testes:** `.agents/scripts/tests/` + `.agents/skills/[nome]/scripts/tests/`

### 8.2 Skills (SKILL.md)

| Tipo | Ferramenta | O que valida |
|------|-----------|-------------|
| Estrutura do SKILL.md | `validate_skills.py` | Frontmatter + 6 seções obrigatórias |
| Qualidade dos prompts | /checklist (humano) | Clareza, completude, critérios mensuráveis |
| Fluxo integrado | QA manual | Execução real em projeto de teste |

### 8.3 CI (GitHub Actions)

```yaml
jobs:
  lint-python:     ruff check + ruff format --check
  test-scripts:    pytest .agents/scripts/tests/ --tb=short
  validate-skills: python validate_skills.py .agents/skills/
  test-init:       pytest scripts/tests/ --tmp-path
```

---

## 9. Matriz de Rastreabilidade

| RF/RNF | Implementado em | Validado por |
|--------|----------------|-------------|
| RF-001 Pipeline completo | SKILL.md de cada skill + canvas ownership table | validate_skills.py |
| RF-002 Canvas progressivo | Frontmatter canvas-dimensions nas skills; canvas-template.md | validate.py output (canvas) |
| RF-003 Validação dual | validate.py engine + validate-rules.json por skill | pytest (validate engine) |
| RF-004 Cascade de conflitos | validate.py --mode input verifica stale no Artifact Registry | pytest (stale detection) |
| RF-005 Templates | .agents/templates/[lang]/ com template por artefato | validate.py output (no placeholders) |
| RF-006 Memory/Registry | memory/state.md + Artifact Registry schema | validate.py input (check_registry) |
| RF-007 Estrutura canônica | .agents/ + .claude/ gerados por init.py | pytest (init integration) |
| RF-008 /spdd-sync | SKILL.md do spdd-sync + deviations-template.md | validate.py output (deviations) |
| RF-009 Multi-sistema | contracts-template.md + techspec multi-system flow | validate.py output (contracts) |
| RF-010 init.py | scripts/init.py | pytest (init integration) |
| RF-011 Skills opcionais | SKILL.md de clarify, checklist, designer, analyze, tdd, tests | validate_skills.py |
| RF-012 /discovery | SKILL.md do discovery + discovery-template.md | validate.py output (discovery) |
| RF-013 TechSpec pré-condições | validate-rules.json do techspec (required_artifacts com guidelines) | pytest (fixture sem guidelines) |
| RF-014 Dependências inter-sistemas | SKILL.md do techspec (Fase 0 de integração) + mock-contract-template.md | validate.py output (contracts) |
| RF-015 Decision Records | decision-record-template.md + SKILL.md de cada skill (seção Canvas) | validate.py output (DR format) |
| RF-016 RTK no init.py | init.py Etapa 2 + 6 | pytest (mock RTK present/absent) |
| RNF-001 Portabilidade Python | init.py + validate.py stdlib apenas | CI matrix Linux/macOS/Windows |
| RNF-002 Performance < 5s | validate.py sem chamadas de rede | pytest benchmark |
| RNF-003 Agnóstico de plataforma | generate_platform.py multi-plataforma | pytest (todas as plataformas) |
| RNF-004 Extensibilidade | validate_skills.py valida nova skill automaticamente | validate_skills.py |
| RNF-005 Rastreabilidade | validate.py custom_step: check_rf_coverage.py | pytest (fixture com RF sem task) |
| RNF-006 Offline | Nenhuma chamada de rede em validate.py e init.py | CI sem internet |
| RNF-007 Maturidade dos prompts | /checklist aplicado a cada SKILL.md | Revisão humana + checklist report |

---

## 10. Questões em Aberto

| # | Questão | Resolução |
|---|---------|-----------|
| ~~Q-TS-001~~ | validate_skills.py: estrutura vs. semântica leve | **Resolvido 2026-08-22:** estrutura + semântica leve — valida `canvas-dimensions` contra conjunto fixo `[R,E,A,S,O,N,S]`. Restante estrutural. Regras em JSON (mesmo padrão do validate-rules.json). |
| ~~Q-TS-002~~ | `memory/costs.md` e rastreamento de custos | **Resolvido 2026-08-22:** conceito de costs removido do framework — será implementado de outra forma em momento futuro. `llm_costs.py` e `memory/costs.md` fora do escopo. |

---

## 11. Histórico de Revisões

| Versão | Data | Autor | Alteração |
|--------|------|-------|-----------|
| 1.0 | 2026-08-22 | Thiago Cavalcante | Versão inicial |
