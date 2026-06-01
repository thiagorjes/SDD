# Processo de Desenvolvimento SDD

## Estrutura do Repositório

- **`skills/`** — Skills do pipeline SDD (agnósticos ao LLM)
- **`.claude/commands/`** / **`.gemini/commands/`** — Commands de cada LLM que ativam os skills
- **`guidelines/`** — Padrões técnicos deste projeto
- **`memory/constitution.md`** — Princípios estáveis, ADRs e decisões de design do toolset. Leia antes de qualquer ação.
- **`memory/state.md`** — Estado operacional atual: features ativas, tasks, qualidade. Atualizado a cada interação.
- **`scripts/`** — Scripts utilitários (cálculo de tokens, bootstrap de projetos)
- **`scripts/init.ps1`** — Bootstrap interativo: cria a estrutura de um novo projeto SDD

---

## Inicializando um Novo Projeto

```powershell
.\SDD\scripts\init.ps1
```

O script pergunta: nome do projeto, pasta de destino, se há source existente, se inclui design, se há guidelines já definidas e qual(is) LLM(s) usar. Depois cria toda a estrutura e inicializa os arquivos de memória.

---

## Pipeline SDD

```
/guidelines → /prd → [/clarify] → [/checklist] → [/designer] → /techspec → /tasks → [/analyze] → /implement (por task)
                         ↑               ↑               ↑         ↑ (Fase 0)    ↑              ├── RED:    /tests
                      ambiguidades   qualidade      UX/design  incertezas    consistência       ├── GREEN:  /implement
                      do PRD         do PRD         protótipos técnicas      PRD×TS×Tasks       ├── REFACTOR
                                                                                                └── REVIEW: /code_review
```

**Skills entre colchetes `[/skill]`** são opcionais mas recomendados — aumentam a qualidade dos artefatos subsequentes.

> `/designer` é configurado no bootstrap (`init.ps1`). Se ativo, gera artefatos em `design/flows/`, `design/tokens/` e `design/prototypes/`.

---

# Descrição do Projeto

