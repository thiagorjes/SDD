# Arquitetura — SSPDD Framework
_Atualizado em: 2026-08-22_

## Visão Geral

SSPDD é um framework de pipeline de desenvolvimento com IA que combina:
- **SDD** (Specification-Driven Development): pipeline business → spec → impl com artefatos rastreáveis
- **SPDD** (Structured-Prompt-Driven Development): prompts estruturados (REASONS Canvas) como artefatos de primeira classe

## Pipeline Completo

```
/guidelines  →  /prd  →  [/clarify]  →  [/checklist]
     ↓                                        ↓
  (por sistema)                          /techspec
                                             ↓
                                      /spdd-canvas  ← INOVAÇÃO SSPDD
                                             ↓
                                         /tasks
                                             ↓
                                        [/analyze]
                                             ↓
                                   /implement  (por task)
                                             ↓
                                       [/spdd-sync]  ← INOVAÇÃO SSPDD
                                             ↓
                                       /code-review
```

Skills entre `[colchetes]` são opcionais mas recomendados.

## Inovações SSPDD vs SDD

### /spdd-canvas (novo)
- **Gatilho:** executado automaticamente ao final de `/techspec`
- **Input:** PRD + TechSpec
- **Output:** `docs/spdd/[feature]-canvas.md` (REASONS Canvas)
- **Papel:** transforma spec técnica em prompt estruturado para guiar implementação

### /spdd-sync (novo)
- **Gatilho:** pós-implementação, quando código diverge do canvas
- **Input:** diff de código + canvas atual
- **Output:** canvas atualizado + registro de desvio em `docs/spdd/[feature]-deviations.md`
- **Princípio:** "when reality diverges, fix the prompt first — then update the code"

## Estrutura de Diretórios do Framework

```
sspdd/
├── AGENTS.md                    # Declaração de agents (canônico cross-vendor)
├── CLAUDE.md                    # Declaração Claude Code (referencia .agents/)
├── .agents/
│   ├── skills/                  # Skills do pipeline (SKILL.md por skill)
│   │   ├── guidelines/
│   │   ├── prd/
│   │   ├── clarify/
│   │   ├── checklist/
│   │   ├── techspec/
│   │   ├── spdd-canvas/         # NOVO
│   │   ├── tasks/
│   │   ├── analyze/
│   │   ├── implement/
│   │   ├── tdd/
│   │   ├── tests/
│   │   ├── spdd-sync/           # NOVO
│   │   └── code-review/
│   ├── agents/                  # Definições de agents especializados
│   │   ├── architect.md
│   │   ├── database.md
│   │   ├── designer.md
│   │   ├── devops.md
│   │   ├── qa.md
│   │   └── security.md
│   ├── scripts/                 # Scripts globais (não específicos a skill)
│   │   └── llm_costs.py
│   └── templates/               # Templates globais reutilizáveis
├── .claude/
│   ├── commands/                # Espelhos minimalistas de .agents/skills/
│   └── agents/                  # Espelhos de .agents/agents/
├── scripts/                     # Scripts de setup e utilitários do workspace
│   ├── init.py                  # Bootstrap de novo workspace
│   └── update.py                # Atualiza toolset
└── cli/                         # Código-fonte do CLI Go
    ├── cmd/
    │   ├── init.go
    │   ├── generate.go
    │   └── sync.go
    └── main.go
```

## Estrutura por Skill

Cada skill em `.agents/skills/[nome]/` segue o layout:

```
[nome]/
├── SKILL.md          # Prompt + instruções + workflow completo
├── scripts/          # Scripts Python específicos da skill
│   └── validate.py   # Validação estrutural do artefato gerado
└── templates/        # Templates de artefatos gerados pela skill
    └── [artefato]-template.md
```

## Relação .agents/ ↔ .claude/

- `.agents/` é a **fonte de verdade** — contém conteúdo completo
- `.claude/` **referencia** via diretivas `@` o que existe em `.agents/`
- Nunca duplicar conteúdo entre os dois

## REASONS Canvas — Estrutura

O canvas gerado por `/spdd-canvas` segue as 7 dimensões:

| Sigla | Dimensão | Conteúdo |
|-------|---------|----------|
| R | Requirements | Objetivos de negócio e escopo (do PRD) |
| E | Entities | Modelos de domínio em Mermaid (do TechSpec) |
| A | Approach | Estratégia de solução e trade-offs (do TechSpec) |
| S | Structure | Arquitetura, herança, dependências |
| O | Operations | Tasks de implementação em ordem (do /tasks) |
| N | Norms | Padrões de código (das guidelines) |
| S | Safeguards | Restrições e guardrails |

## Princípios Arquiteturais

1. **Skill-first:** toda funcionalidade do framework é uma skill com `SKILL.md` canônico
2. **Template-driven:** todo artefato gerado tem template em `templates/`
3. **Script-validated:** todo artefato tem `validate.py` que checa estrutura sem IA
4. **Progressive persistence:** artefatos salvos incrementalmente — nunca perder progresso por exaustão de contexto
5. **One question at a time:** skills interativas jamais agrupam perguntas dependentes
6. **Canvas-as-prompt:** REASONS Canvas é o elo entre spec e implementação — não documentação, mas instrução executável
