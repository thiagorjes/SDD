# Estado Operacional — Banestes SDD
_Atualizado em: 2026-06-06_

> Estado atual do toolset e dos projetos em andamento. Atualizado a cada interação que altera o estado do projeto.
> Para princípios estáveis e ADRs, veja [`memory/constitution.md`](constitution.md).

---

## Toolset Atual

| Componente | Qtd | Localização |
|---|---|---|
| Skills agnósticos | 12 | `.agents/skills/` |
| Commands Claude | 11* | `.claude/commands/` |
| Scripts de custo | 2 | `scripts/` |
| Scripts de bootstrap | 1 | `scripts/` |

**Skills disponíveis:** guidelines, prd, clarify, checklist, techspec, tasks, analyze, implement, tdd, tests, code_review, **designer**

> *`designer` command gerado por `init.ps1` ao inicializar projetos com design ativo.

---

## Features Ativas

_Registre aqui as features em desenvolvimento usando este projeto SDD._

| Feature | PRD | TechSpec | Tasks | Status |
|---|---|---|---|---|
| _(nenhuma ativa)_ | — | — | — | — |

---

## Especificações Técnicas em Andamento

_Registre TechSpecs geradas pelo `/techspec`._

| Feature | TechSpec | ADRs chave | Artefatos |
|---|---|---|---|
| _(nenhuma)_ | — | — | — |

---

## Tasks em Andamento

_Registre progresso de tasks do `/tasks`._

| Feature | Total tasks | Concluídas | Em progresso | Caminho |
|---|---|---|---|---|
| _(nenhuma)_ | — | — | — | — |

---

## Qualidade

_Registre resultados de `/analyze`, `/tests` e `/code_review`._

| Data | Skill | Feature/Task | Veredicto | Findings |
|---|---|---|---|---|
| _(nenhum)_ | — | — | — | — |

---

## Evolução do SDD

| Data | Mudança |
|---|---|
| 2026-06-01 | Skill `designer` adicionado ao pipeline |
| 2026-06-01 | Script `init.ps1` criado (bootstrap de projetos) |
| 2026-06-01 | Estrutura `design/flows`, `design/tokens`, `design/prototypes` definida |
| 2026-06-01 | Template `GUIDELINE_DESIGN_SYSTEM.md` gerado pelo bootstrap quando design ativo |
| 2026-06-06 | Fix no script `init.ps1` (bug ao copiar `AGENTS.md`) |
| 2026-06-06 | Script `init.ps1` atualizado para gerar os arquivos `CLAUDE.md`, `GEMINI.md` e `AGENTS.md` dinamicamente se não existirem |
| 2026-06-06 | Skill `/prd` atualizado para suportar divisão em fases (`negocio`, `ti`, `full`) |
| 2026-06-06 | Refatoração do `designer`: dividido entre Entrevistador (`skills/designer.md`) e Agente Autônomo Prototipador (`.claude/agents/designer.md`) |
| 2026-06-06 | Skill `/guidelines` atualizada para mapear o status de design e UI/UX (Módulo J e `design.md`) |
| 2026-06-06 | Script `init.ps1` limpo: removida a geração estática do `GUIDELINE_DESIGN_SYSTEM.md` (agora dinâmico via `/guidelines`) |
| 2026-06-06 | Módulo J do `/guidelines` expandido com perguntas sobre ícones, responsividade e animações para um `design.md` completo |
| 2026-06-06 | Implementado o conceito de "Comitê de Análise Assíncrono" como penúltima fase nos skills `/guidelines` e `/techspec` |
| 2026-06-06 | Alterado fluxo do `/guidelines` e `/techspec` para salvar artefatos no disco **antes** da revisão do Comitê, economizando tokens e contexto |
| 2026-06-06 | Criados os arquivos agnósticos dos subagentes do Comitê (`architect.md`, `security.md`, `database.md`, `devops.md`, `qa.md`) em `.agents/agents/` |
| 2026-06-06 | Skill `/prd` atualizado: adicionadas FASE 6 (Comitê: QA, Segurança, Arquitetura, DevOps) e FASE 7 (Próximos Passos) |
| 2026-06-06 | Skill `/tasks` atualizado: adicionadas FASE 7 (Comitê: QA, Arquitetura) e FASE 8 (Conclusão) |
| 2026-06-06 | Migração para Agent Skills Standard: `.agent/skills/` renomeado para `.agents/skills/` (plural), `.toml` removidos, `.gemini/commands/` descontinuado |