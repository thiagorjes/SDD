# Data Model — SSPDD Framework
_Versão: 1.0 | Atualizado em: 2026-08-22_

> Fonte de verdade para todos os schemas de artefatos do framework. Referenciado pelo TechSpec e pelos validate-rules.json.

---

## 1. Artifact Registry (memory/state.md)

Tabela Markdown de 3 colunas mantida na seção `## Artifact Registry` de `memory/state.md`.

```
| Artefato | v | Status |
|---|---|---|
| prd/sspdd-framework-prd.md | 1.1 | ok |
| techspec/sspdd-framework-techspec.md | 1.0 | draft |
| spdd/sspdd-framework-canvas.md | — | draft |
```

**Campos:**

| Campo | Tipo | Valores | Regra |
|-------|------|---------|-------|
| Artefato | string | caminho relativo sem prefixo `docs/` | único por linha |
| v | string | `MAJOR.MINOR` ou `—` (não gerado) | bump MAJOR: mudança estrutural; MINOR: detalhe |
| Status | enum | `ok \| draft \| stale:FONTE@V` | `stale:prd@1.1` = stale causado por prd v1.1 |

**Parsing (validate.py engine):**
```python
REGISTRY_ROW = re.compile(r'^\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|')
```

---

## 2. Decision Record (docs/decisions/)

**Localização:** `docs/decisions/[TIPO]-[NNN]-[slug].md`

**Exemplos:** `docs/decisions/ADR-001-canvas-push-ownership.md`, `docs/decisions/BDR-001-escopo-mvp.md`

**Sequências por tipo (contadores em memory/constitution.md):**
| Tipo | Prefixo | Domínio |
|------|---------|---------|
| Architecture Decision Record | ADR | Stack, padrões técnicos, infraestrutura |
| Business Decision Record | BDR | Escopo, prioridade, regras de negócio |
| Strategic Decision Record | SDR | Público-alvo, distribuição, idioma |
| Design Decision Record | DDR | Canvas, nomenclatura, templates |

**Schema (frontmatter YAML + corpo Markdown):**

```yaml
---
id: ADR-001
type: ADR
status: accepted
date: 2026-08-22
supersedes: —
superseded-by: —
---
```

**Seções obrigatórias no corpo:**
1. `## Decisão` — o que foi decidido (1-3 frases)
2. `## Motivação` — por que (contexto, restrições, trade-offs)
3. `## Consequências` — o que muda / impactos downstream
4. `## Alternativas Consideradas` — o que foi descartado e por quê

**Status lifecycle:**
```
accepted → superseded (quando nova DR substitui)
accepted → deprecated (quando decisão cai sem substituta)
```

---

## 3. REASONS Canvas (docs/spdd/)

**Localização:** `docs/spdd/[feature]-canvas.md`

**Status possíveis:** `DRAFT | READY | ARCHIVED`
- `DRAFT`: dimensão O (Operations) ainda não preenchida
- `READY`: todas as 7 dimensões preenchidas — canvas executável por outro agente
- `ARCHIVED`: feature concluída, canvas movido para `docs/spdd/archive/`

**Schema por dimensão:**

```markdown
# REASONS Canvas — {{FEATURE_NAME}}
_Status: DRAFT | Idioma: pt_BR | Iniciado em: {{DATE}}_

## R — Requirements
_Atualizado por: /discovery v1.0 — {{DATE}}_
> Decisões: BDR-001, SDR-001
{{OBJETIVOS_DE_NEGOCIO}}
{{SCOPE_IN_OUT}}

## E — Entities
_Atualizado por: /prd v1.0 — {{DATE}}_
> Decisões: DDR-001
{{DIAGRAMA_MERMAID_DOMINIO}}

## A — Approach
_Atualizado por: /techspec v1.0 — {{DATE}}_
> Decisões: ADR-001, ADR-002
{{ESTRATEGIA_DE_SOLUCAO}}
{{TRADEOFFS}}

## S — Structure
_Atualizado por: /techspec v1.0 — {{DATE}}_
> Decisões: ADR-003, ADR-004
{{ARQUITETURA}}
{{DEPENDENCIAS}}

## O — Operations
_Atualizado por: /tasks v1.0 — {{DATE}}_
{{LISTA_TASKS_ORDENADA}}

## N — Norms
_Atualizado por: /guidelines v1.0 — {{DATE}}_
> Decisões: ADR-011, ADR-012
{{PADROES_RELEVANTES_DA_FEATURE}}

## S — Safeguards
_Atualizado por: /code-review v1.0 — {{DATE}}_
{{RESTRICOES}}
{{O_QUE_NAO_FAZER}}
```

**Ownership por skill:**

| Dimensão | Skill responsável | Fase de atualização |
|----------|------------------|---------------------|
| R | /discovery, /prd | Ao concluir levantamento |
| E | /prd, /designer, /techspec | Ao salvar artefato principal |
| A | /techspec | Fase de decisões técnicas |
| S | /techspec | Fase de geração de artefatos |
| O | /tasks | Ao gerar documento de tasks |
| N | /guidelines (leitura) | Ao iniciar /techspec |
| S (Safeguards) | /code-review | Ao concluir revisão |

---

## 4. SKILL.md Schema

**Localização:** `.agents/skills/[nome]/SKILL.md`

**Frontmatter obrigatório:**
```yaml
---
name: nome-da-skill
description: Uma frase — quando usar esta skill.
canvas-dimensions: [R, E]        # dimensões que esta skill atualiza
input-artifacts:                  # artefatos que esta skill lê
  - memory/state.md
  - docs/prd/{{FEATURE}}-prd.md
output-artifacts:                 # artefatos que esta skill gera/modifica
  - docs/discovery/{{FEATURE}}-discovery.md
  - docs/spdd/{{FEATURE}}-canvas.md
---
```

**Seções obrigatórias no corpo (em ordem):**
1. `## Objetivo`
2. `## Pré-condições`
3. `## Workflow` (fases numeradas)
4. `## Artefatos` (lista de entrada e saída com caminhos)
5. `## Canvas` (quais dimensões atualiza e quando)
6. `## Handoff` (bloco a escrever em memory/state.md)

---

## 5. validate-rules.json Schema

**Localização:** `.agents/skills/[nome]/validate-rules.json`

```json
{
  "skill": "prd",
  "artifact_pattern": "docs/prd/*-prd.md",
  "modes": {
    "input": {
      "check_registry": true,
      "required_artifacts": [
        "memory/state.md",
        "systems/{{SYSTEM}}/guidelines/stack.md"
      ]
    },
    "output": {
      "required_sections": [
        "## 1. Visão Geral",
        "## 3. Requisitos Funcionais",
        "## 4. Requisitos Não-Funcionais"
      ],
      "id_patterns": {
        "RF": "RF-\\d{3}",
        "RNF": "RNF-\\d{3}"
      },
      "gherkin_required_for_ids": ["RF"],
      "no_empty_placeholders": true,
      "custom_steps": []
    }
  }
}
```

**Campo `custom_steps` (opcional):**
```json
"custom_steps": [
  {
    "name": "check_cross_refs",
    "script": ".agents/skills/techspec/scripts/check_rf_coverage.py",
    "args": ["--prd", "{{INPUT_ARTIFACT}}"],
    "on_failure": "error"
  }
]
```

`on_failure` aceita: `"error"` (bloqueia) ou `"warning"` (reporta sem bloquear).

---

## 6. Deviations Record (docs/spdd/)

**Localização:** `docs/spdd/[feature]-deviations.md`

Gerado e atualizado pelo `/spdd-sync`.

```markdown
# Deviations — {{FEATURE_NAME}}

## DEV-001 — {{DATE}}
- **Dimensão afetada:** O (Operations)
- **Descrição:** Task TASK-003 implementada com cache em memória em vez de Redis conforme canvas
- **Direção de resolução:** canvas corrigido (canvas reflete realidade do código)
- **Justificativa:** Redis não disponível no ambiente de staging
- **Status:** resolved
```
