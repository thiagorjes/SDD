# Processo de Desenvolvimento SDD

## Estrutura do Repositório

- **`skills/`** — Skills do pipeline SDD (agnósticos ao LLM)
- **`.claude/commands/`** / **`.gemini/commands/`** — Commands de cada LLM que ativam os skills
- **`guidelines/`** — Padrões técnicos deste projeto
- **`memory/constitution.md`** — Princípios estáveis, ADRs e decisões de design do toolset. Leia antes de qualquer ação.
- **`memory/state.md`** — Estado operacional atual: features ativas, tasks, qualidade. Atualizado a cada interação.
- **`scripts/`** — Scripts utilitários (cálculo de tokens, etc.)

---

## Pipeline SDD

```
/guidelines → /prd → [/clarify] → [/checklist] → /techspec → /tasks → [/analyze] → /implement (por task)
                         ↑               ↑           ↑ (Fase 0)           ↑              ├── RED:    /tests
                      ambiguidades   qualidade    incertezas          consistência       ├── GREEN:  /implement
                      do PRD         do PRD       técnicas            PRD×TS×Tasks       ├── REFACTOR
                                                                                         └── REVIEW: /code_review
```

**Skills entre colchetes `[/skill]`** são opcionais mas recomendados — aumentam a qualidade dos artefatos subsequentes.

---

## Descrição do Projeto

**KingPong** — jogo mobile para Android e iOS desenvolvido com React Native CLI (TypeScript).

Projeto solo, greenfield, totalmente offline. Persistência local via SQLite. Testes E2E com Detox cobrindo 90% dos fluxos críticos.

O pipeline SDD está em uso para guiar o desenvolvimento: guidelines configuradas, aguardando `/prd` para início do levantamento de requisitos.

