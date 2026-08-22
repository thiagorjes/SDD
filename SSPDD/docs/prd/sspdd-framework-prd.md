# PRD — SSPDD Framework
**Versão:** 1.0 | **Status:** Aprovado para Especificação | **Data:** 2026-08-22 | **Autor:** Thiago Cavalcante

---

## 1. Visão Geral

### 1.1 Contexto
SSPDD (Structured Specification & Prompt-Driven Development) é um framework de pipeline de desenvolvimento com IA que unifica o melhor do SDD (Specification-Driven Development) com o SPDD (Structured-Prompt-Driven Development). Resolve três dores simultaneamente: falta de rastreabilidade do discovery à implementação, prompts ad-hoc que geram saídas inconsistentes entre desenvolvedores, e especificações que ficam obsoletas assim que o código evolui.

### 1.2 Objetivo Principal
Entregar um conjunto de artefatos (skills, templates, scripts, agents) que permite a qualquer desenvolvedor ou time seguir um pipeline estruturado de desenvolvimento com IA, produzindo tanto especificações (negócio, UX/UI, TI) quanto prompts estruturados (REASONS Canvas) como artefatos de primeira classe — possibilitando recriar ou migrar o sistema em qualquer plataforma de IA sem repetir o processo de discovery.

### 1.3 Escopo

**IN:**
- Pipeline completo de skills: `/discovery` → `/prd` → `/techspec` → `/tasks` → `/implement`/`/tdd` → `/code-review` → `/tests`
- Skills opcionais: `/clarify`, `/checklist`, `/designer`, `/analyze`, `/spdd-sync`
- REASONS Canvas progressivo como artefato SPDD vivo, iniciado no `/discovery` e enriquecido até `/code-review`
- Validação dual (input + output) via `validate.py` por skill, executável sem LLM
- Cascade de conflitos com versionamento de artefatos e stale markers
- Memory/Handoff: `memory/state.md` + `memory/constitution.md` + Artifact Registry
- Estrutura canônica `.agents/` (cross-vendor) + `.claude/` (Claude Code nativo)
- `AGENTS.md` + `CLAUDE.md` como entry points
- Templates Markdown para todos os artefatos com placeholders `{{CAMPO}}`
- Scripts Python (3.10+, stdlib apenas) portáveis para Linux/macOS/Windows
- Script de inicialização `init.py` para novo workspace
- Suporte a features multi-sistema com contratos de integração e opção de mock/abstração
- Pré-condições de TechSpec: validação de guidelines por tipo de sistema (novo vs. feature existente) e detecção de dependências inter-sistemas

**OUT:**
- CLI Go ou binário distribuído
- Interface web ou desktop
- Persistência em banco de dados
- Integração com CI/CD (fora do escopo do framework em si)
- Geração automática de código (o framework orquestra prompts, não gera código diretamente)
- Suporte a sistemas legados sem guidelines (o framework interrompe o fluxo e informa)

### 1.4 Sistemas Afetados
| Sistema | Papel |
|---------|-------|
| SSPDD | Sistema único — o próprio framework |

---

## 2. Usuários e Stakeholders

### 2.1 Personas

| Persona | Descrição | Necessidade principal |
|---------|-----------|----------------------|
| Desenvolvedor solo com IA | Usa Claude Code / Cursor / Codex para desenvolver produtos individualmente | Pipeline guiado que substitui a necessidade de um arquiteto humano |
| Tech Lead / Arquiteto | Define padrões e pipeline para o time adotar | Framework configurável que se adapta a contextos de projeto distintos |
| Time de engenharia (2-8 devs) | Time pequeno que quer padronizar uso de IA | Artefatos rastreáveis que garantem consistência entre membros |
| Contribuidor open-source | Quer adicionar skills ou melhorar o framework | Estrutura clara e contrato de skill bem definido para contribuição |

### 2.2 Nível Técnico
Avançado. Todos os usuários primários têm familiaridade com ferramentas de linha de comando, git e CLIs de IA. O framework não precisa proteger usuários de decisões técnicas.

### 2.3 Acessibilidade / Internacionalização
N/A — ferramenta de linha de comando voltada a desenvolvedores. Documentação em português do Brasil (com inglês em AGENTS.md / CLAUDE.md para compatibilidade cross-vendor).

---

## 3. Requisitos Funcionais

### RF-001 — Pipeline Completo de Skills
**Prioridade:** Must Have

O framework entrega um pipeline de skills sequenciais com pontos de entrada bem definidos e handoff rastreável entre etapas.

**Pipeline:**
```
/discovery → /prd → [/clarify] → [/checklist] → [/designer] → /techspec → /tasks → [/analyze] → /implement ou /tdd → /code-review → /tests → conclusão
```
Skills entre `[colchetes]` são opcionais mas recomendadas em contextos específicos.

**Critérios de Aceite:**

**Dado que** o usuário executa `/discovery` com contexto de uma nova feature
**Quando** conclui o levantamento interativo
**Então** `docs/discovery/[feature]-discovery.md` é criado com seções de problema, personas e contexto de negócio preenchidas, e `docs/spdd/[feature]-canvas.md` é inicializado com dimensões R e E em status DRAFT

**Dado que** o usuário executa qualquer skill do pipeline em sequência
**Quando** a skill conclui com sucesso
**Então** `memory/state.md` é atualizado com o bloco de handoff da etapa, incluindo artefato gerado, versão, status e próximo comando recomendado

---

### RF-002 — REASONS Canvas Progressivo (SPDD)
**Prioridade:** Must Have

O REASONS Canvas (7 dimensões: Requirements, Entities, Approach, Structure, Operations, Norms, Safeguards) é um artefato vivo iniciado no `/discovery` e enriquecido por cada fase do pipeline.

| Fase | Dimensões atualizadas |
|------|-----------------------|
| `/discovery` | R (objetivos), E (entidades de domínio — rascunho) |
| `/prd` | R (RFs validados com Gherkin) |
| `/designer` | E (entidades UX/UI, fluxos visuais) |
| `/techspec` | E (modelo de dados final), A (approach), S (estrutura) |
| `/tasks` | O (operações em ordem) |
| `/guidelines` (leitura) | N (normas — extraídas dos guidelines do sistema) |
| `/code-review` | S (safeguards — guardrails validados na revisão) |

**Critérios de Aceite:**

**Dado que** uma skill que contribui com o canvas é concluída
**Quando** o artefato de saída da skill é salvo
**Então** as dimensões correspondentes no canvas são atualizadas automaticamente e o status do canvas reflete `DRAFT` (O não preenchido) ou `READY` (todas as dimensões preenchidas)

**Dado que** o canvas está com status `READY`
**Quando** um desenvolvedor em outra plataforma de IA recebe apenas o arquivo `[feature]-canvas.md`
**Então** consegue implementar a feature seguindo as instruções das 7 dimensões sem necessidade de repetir o processo de discovery

---

### RF-003 — Validação Dual por Skill (Input + Output)
**Prioridade:** Must Have

Cada skill com artefatos de entrada e/ou saída possui `validate.py` com dois modos: `--mode input` (antes de executar) e `--mode output` (após concluir). Execução sem LLM em menos de 5 segundos.

**O que valida:**

*Input:*
- Artefatos de entrada existem no disco
- Versão do artefato é compatível com o que a skill espera
- Artefato não está marcado como `stale` no Artifact Registry de `memory/state.md`

*Output:*
- Todas as seções obrigatórias presentes
- Nenhum placeholder `{{CAMPO}}` remanescente
- IDs no formato correto (RF-001, TASK-001, etc.)
- Critérios de aceite em formato Gherkin (por RF)
- Semântica determinística: IDs referenciados em artefato downstream existem no artefato upstream

**Critérios de Aceite:**

**Dado que** o usuário inicia uma skill que requer artefatos de entrada
**Quando** `validate.py --mode input` é executado
**Então** em menos de 5 segundos (sem chamada a LLM) reporta em stderr: artefatos ausentes, artefatos stale, incompatibilidade de versão — e interrompe o fluxo se encontrar erro crítico

**Dado que** uma skill conclui a geração de seu artefato de saída
**Quando** `validate.py --mode output [artefato]` é executado
**Então** retorna exit 0 se válido ou exit 1 com lista de erros específicos (um por linha em stderr)

---

### RF-004 — Cascade de Conflitos com Versionamento
**Prioridade:** Must Have

Quando uma skill detecta inconsistência em artefato de etapa anterior, devolve o fluxo à skill responsável. A correção é feita com bump de versão; artefatos downstream são marcados como `stale` em cascata no Artifact Registry.

**Protocolo de versão:** `MAJOR.MINOR` — MAJOR quando estrutura muda (RF adicionado/removido), MINOR quando detalhes mudam (AC refinado, typo corrigido).

**Critérios de Aceite:**

**Dado que** `/techspec` detecta um RF do PRD ambíguo que impede a especificação técnica
**Quando** o usuário confirma que deseja corrigir o artefato upstream
**Então** o fluxo retorna ao `/prd`; após correção com bump de versão, os artefatos downstream (TechSpec, Canvas, Tasks) são marcados como `stale (PRD v1.1)` no Artifact Registry; na próxima execução de cada skill downstream, `validate.py --mode input` detecta o stale e alerta o usuário antes de prosseguir

**Dado que** um artefato upstream recebe bump de versão MAJOR
**Quando** artefatos downstream são reexecutados
**Então** as alterações propagam em cascata respeitando a ordem do pipeline (PRD → TechSpec → Canvas → Tasks → Implement)

---

### RF-005 — Templates para Todos os Artefatos
**Prioridade:** Must Have

Cada skill que gera artefato possui template Markdown em `.agents/skills/[skill]/templates/[artefato]-template.md` com placeholders `{{CAMPO}}` padronizados. A saída gerada pela IA deve seguir o template — garantindo consistência independente do modelo ou plataforma.

**Critérios de Aceite:**

**Dado que** uma skill é invocada para gerar um artefato
**Quando** a IA preenche o template
**Então** o artefato gerado contém todas as seções do template, nenhum placeholder `{{CAMPO}}` permanece substituído por vazio, e `validate.py --mode output` retorna exit 0

**Dado que** um contribuidor cria uma nova skill
**Quando** a skill gera artefato sem template correspondente
**Então** o script de validação de estrutura de skills (`validate_skills.py`) reporta erro: "Template ausente para skill [nome]"

---

### RF-006 — Memory e Artifact Registry
**Prioridade:** Must Have

`memory/state.md` mantém Artifact Registry com versão, hash curto (SHA256 primeiros 8 chars) e status (`ok | stale | draft`) de cada artefato. `memory/constitution.md` armazena ADRs e princípios estáveis. Juntos, garantem handoff completo entre sessões, terminais e plataformas de IA.

**Critérios de Aceite:**

**Dado que** uma skill gera ou atualiza um artefato
**Quando** o artefato é salvo no disco
**Então** o Artifact Registry em `memory/state.md` é atualizado com: caminho, versão atual, hash SHA256 (8 chars), status `ok`, e data de atualização

**Dado que** um desenvolvedor abre uma nova sessão de IA (diferente terminal, dia ou plataforma)
**Quando** lê `memory/state.md`
**Então** consegue identificar: quais features estão ativas, em qual etapa do pipeline cada uma está, quais artefatos estão ok vs. stale, e qual o próximo comando recomendado — sem contexto de sessão anterior

---

### RF-007 — Estrutura Canônica Cross-Vendor
**Prioridade:** Must Have

O framework é distribuído com estrutura `.agents/` como fonte de verdade cross-vendor e `.claude/` como espelho nativo Claude Code. A estrutura é compatível com qualquer CLI de IA que suporte AGENTS.md (formato emergente cross-vendor).

**Estrutura mínima entregue:**
```
AGENTS.md
CLAUDE.md
.agents/
  skills/[nome]/SKILL.md + scripts/ + templates/
  agents/[persona].md
  scripts/
  templates/
.claude/
  commands/[nome].md  ← referencia .agents/skills/[nome]/SKILL.md via @
  agents/[persona].md ← referencia .agents/agents/[persona].md via @
```

**Critérios de Aceite:**

**Dado que** o framework é instalado em um projeto via `init.py`
**Quando** um usuário abre o projeto no Claude Code
**Então** todas as skills do pipeline estão disponíveis como slash commands sem configuração adicional

**Dado que** o framework é instalado em um projeto via `init.py`
**Quando** um usuário abre o projeto em outra plataforma compatível com AGENTS.md
**Então** todas as skills estão disponíveis como comandos da plataforma sem duplicação de conteúdo em `.agents/`

---

### RF-008 — /spdd-sync: Sincronização Reversa Canvas↔Código
**Prioridade:** Should Have

Skill `/spdd-sync` detecta divergências entre o REASONS Canvas e o código implementado, apresenta cada divergência ao usuário e oferece resolução bidirecional (corrigir canvas ou reverter código). Todo desvio é registrado em `docs/spdd/[feature]-deviations.md`.

**Critérios de Aceite:**

**Dado que** o código implementado diverge de uma ou mais dimensões do REASONS Canvas
**Quando** `/spdd-sync` é executado
**Então** apresenta cada divergência com: dimensão afetada, descrição do desvio, e opções "corrigir canvas" ou "reverter código"

**Dado que** o usuário escolhe uma direção de resolução para uma divergência
**Quando** a resolução é aplicada
**Então** a divergência é registrada em `docs/spdd/[feature]-deviations.md` com: data, dimensão, descrição, direção de resolução e justificativa informada pelo usuário

---

### RF-009 — Suporte a Features Multi-Sistema
**Prioridade:** Should Have

Features que afetam múltiplos sistemas geram contratos de integração em `docs/contracts/` e o pipeline rastreia a ordem de implementação entre repositórios no documento de tasks.

**Critérios de Aceite:**

**Dado que** um `/prd` identifica feature que afeta 2 ou mais sistemas
**Quando** o usuário confirma os sistemas afetados
**Então** o PRD declara o papel de cada sistema e o `/techspec` gera contratos de integração em `docs/contracts/[sistema-a]-[sistema-b]-contract.md` com: interface (REST/SOAP/arquivo/etc), direção do fluxo, campos, e responsável

---

### RF-010 — Script de Inicialização de Workspace
**Prioridade:** Must Have

`init.py` (Python 3.10+, stdlib apenas) cria a estrutura completa do workspace SSPDD em um diretório alvo: copia skills, templates, agents, scripts e gera `AGENTS.md` e `CLAUDE.md` configurados.

**Critérios de Aceite:**

**Dado que** o usuário executa `python init.py --project "Nome do Projeto" --path ./meu-projeto --lang pt_BR`
**Quando** o script conclui
**Então** o diretório alvo contém: `AGENTS.md`, `CLAUDE.md`, `.agents/` completo, `.claude/` completo, `memory/state.md` e `memory/constitution.md` inicializados, `docs/` com subdiretórios, e `scripts/` com utilitários — pronto para execução de `/guidelines`

**Dado que** o script é executado em Linux, macOS ou Windows com Python 3.10+
**Quando** concluir
**Então** todos os arquivos são criados corretamente sem erros e sem dependências externas além da stdlib

**Dado que** o usuário executa `init.py` e RTK está instalado no sistema
**Quando** o script detecta `rtk` disponível no PATH
**Então** executa `rtk init -g` no diretório do projeto, habilitando o hook de compressão de tokens para a plataforma configurada (`--lang` define plataforma padrão: Claude Code)

**Dado que** o usuário executa `init.py` e RTK não está instalado
**Quando** o script não detecta `rtk` no PATH
**Então** exibe instrução de instalação (`brew install rtk` ou URL do install.sh), informa que RTK é opcional mas recomendado (reduz consumo de tokens em 60-90%), e prossegue com `--skip-rtk` implícito sem interromper o fluxo

---

### RF-011 — Skills Opcionais do Pipeline
**Prioridade:** Should Have

Skills opcionais que enriquecem o pipeline quando aplicáveis: `/clarify` (resolução de ambiguidades no PRD), `/checklist` (validação de qualidade de requisitos), `/designer` (UX/UI discovery e design brief), `/analyze` (consistência cross-artefato), `/tdd` (ciclo Red-Green-Refactor integrado), `/tests` (suite de testes a partir dos ACs).

**Critérios de Aceite:**

**Dado que** o usuário executa `/designer` após `/prd`
**Quando** conclui o levantamento visual interativo
**Então** gera `docs/design/[feature]-design-brief.md` com tokens de cor, tipografia, componentes e padrões de interação, e atualiza a dimensão E do REASONS Canvas com entidades visuais

**Dado que** o usuário executa `/tdd` no lugar de `/implement`
**Quando** completa o ciclo Red-Green-Refactor
**Então** entrega: testes escritos antes do código (Red), implementação mínima (Green), refatoração (Refactor) e revisão integrada — tudo rastreado no Artifact Registry

---

### RF-012 — /discovery: Etapa de Discovery de Produto
**Prioridade:** Must Have

Skill `/discovery` conduz levantamento leve focado em problema, personas e contexto de negócio — sem entrar em RFs detalhados. Inicializa o REASONS Canvas com dimensões R e E em rascunho. É a porta de entrada do pipeline para features completamente novas.

**Critérios de Aceite:**

**Dado que** o usuário executa `/discovery` sem contexto prévio
**Quando** responde às perguntas sobre problema, usuários e objetivos de negócio
**Então** `docs/discovery/[feature]-discovery.md` é criado com: problema declarado, personas identificadas, objetivos de negócio e hipótese de solução; e `docs/spdd/[feature]-canvas.md` é criado com dimensões R e E preenchidas em status DRAFT

**Dado que** o usuário executa `/prd` após `/discovery`
**Quando** `/prd` valida suas entradas (`--mode input`)
**Então** lê o discovery como contexto e pula as perguntas já respondidas (A1, A3, B1-B2), evitando redundância na entrevista

---

### RF-013 — TechSpec: Pré-condições por Tipo de Sistema
**Prioridade:** Must Have

Antes de iniciar a especificação técnica, `/techspec` valida guidelines disponíveis conforme o tipo de sistema e feature.

**Regras:**
- Sistema novo (greenfield): lê guidelines de `.agents/skills/guidelines/templates/` ou `systems/[sistema]/guidelines/`
- Feature em sistema existente: lê guidelines do repositório do sistema (`systems/[sistema]/guidelines/`)
- Guidelines ausentes: interrompe o fluxo e informa o usuário para solicitar ao time responsável

**Critérios de Aceite:**

**Dado que** `/techspec` é iniciado para uma feature em sistema existente sem guidelines
**Quando** `validate.py --mode input` verifica os guidelines
**Então** o fluxo é interrompido com mensagem: "Guidelines não encontradas para o sistema [nome]. Solicite ao time responsável ou execute /guidelines primeiro."

**Dado que** `/techspec` é iniciado para sistema completamente novo (greenfield)
**Quando** guidelines padrão são identificadas em `.agents/`
**Então** utiliza os templates de guidelines como base e prossegue sem interrupção

---

### RF-014 — Detecção e Resolução de Dependências Inter-Sistemas
**Prioridade:** Must Have

Durante `/techspec`, se a feature tem interface com outros sistemas (REST, SOAP, arquivo, evento, etc.), o framework identifica os sistemas afetados e valida seus artefatos. Oferece opção de criar abstração (mock/interface) quando artefatos estão ausentes ou o sistema é de terceiros.

**Critérios de Aceite:**

**Dado que** `/techspec` detecta que a feature consome ou expõe interface com sistema externo
**Quando** pergunta ao usuário sobre os sistemas afetados
**Então** para cada sistema: (a) verifica guidelines e artefatos; (b) se ausentes e sistema interno, interrompe com instrução de como fornecê-los; (c) se sistema de terceiros, solicita documentação (PDF, TXT ou URL); (d) oferece opção de criar abstração/mock para prosseguir sem os artefatos reais

**Dado que** o usuário opta por criar abstração para sistema sem documentação
**Quando** `/techspec` prossegue com o mock
**Então** registra em `docs/contracts/[sistema]-mock-contract.md` a interface mockada, marcada como `PENDENTE DE VALIDAÇÃO`, e adiciona task no documento de tasks para substituir o mock pela integração real

---

### RF-015 — Decision Records como Artefato de Primeira Classe
**Prioridade:** Must Have

Toda decisão relevante (arquitetural, de negócio, estratégica ou de design) é registrada como um Decision Record (DR) em `docs/decisions/[TIPO]-[NNN]-[slug].md`. O REASONS Canvas referencia as DRs pertinentes inline em cada dimensão. O `memory/constitution.md` funciona como índice de links — não contém o corpo das decisões.

**Tipos de DR:**
| Tipo | Sigla | Domínio |
|------|-------|---------|
| Architecture Decision Record | ADR | Stack, padrões técnicos, infraestrutura |
| Business Decision Record | BDR | Escopo, prioridade, regras de negócio |
| Strategic Decision Record | SDR | Público-alvo, modelo de distribuição, idioma |
| Design Decision Record | DDR | Estrutura de canvas, nomenclatura, templates |

**Status possíveis:** `accepted`, `superseded`, `deprecated`

**Critérios de Aceite:**

**Dado que** uma decisão relevante é tomada em qualquer etapa do pipeline
**Quando** a skill correspondente conclui a fase onde a decisão foi feita
**Então** um arquivo `docs/decisions/[TIPO]-[NNN]-[slug].md` é criado com: id, type, status, date, motivação, consequências e alternativas consideradas

**Dado que** o REASONS Canvas está sendo gerado ou atualizado
**Quando** uma dimensão é preenchida com base em decisões registradas
**Então** a dimensão inclui referência inline às DRs pertinentes no formato `> Decisões: [TIPO]-[NNN], [TIPO]-[NNN]`

**Dado que** uma decisão anterior é revista ou substituída
**Quando** nova DR é criada em substituição
**Então** a DR antiga tem status alterado para `superseded` e campo `superseded-by: [TIPO]-[NNN]` — nunca deletada

---

### RF-016 — Integração com RTK no init.py
**Prioridade:** Should Have

`init.py` detecta e habilita o RTK (https://github.com/rtk-ai/rtk) no projeto inicializado. RTK é um proxy CLI que comprime outputs de shell antes que a IA os leia, reduzindo consumo de tokens em 60-90% em comandos dev comuns.

**Critérios de Aceite:**

**Dado que** o usuário executa `init.py` e RTK está instalado no sistema
**Quando** o script detecta `rtk` disponível no PATH
**Então** executa `rtk init -g` no diretório do projeto, habilitando o hook de compressão de tokens para a plataforma de IA configurada

**Dado que** o usuário executa `init.py` e RTK não está instalado
**Quando** o script não detecta `rtk` no PATH
**Então** exibe instrução de instalação, informa que RTK é opcional mas recomendado (reduz consumo de tokens em 60-90%), e prossegue sem interromper o fluxo

---

## 4. Requisitos Não-Funcionais

### RNF-001 — Portabilidade de Scripts
**Prioridade:** Must Have
Scripts de validação (`validate.py`) e utilitários executam em Linux, macOS e Windows com Python 3.10+ sem dependências externas além da stdlib.
**Métrica:** `python validate.py [arquivo]` executa sem erros de import em Python 3.10+ limpo nos três SOs.

### RNF-002 — Performance de Validação
**Prioridade:** Must Have
Toda execução de `validate.py` (input ou output) conclui em menos de 5 segundos sem chamada a LLM, independente do tamanho do artefato.
**Métrica:** p95 < 5s em artefato de até 500 linhas de Markdown.

### RNF-003 — Agnóstico de Plataforma de IA
**Prioridade:** Must Have
O framework funciona com qualquer plataforma de IA que suporte AGENTS.md ou que permita injeção de contexto via arquivos Markdown. Skills não dependem de features exclusivas de um único LLM.
**Métrica:** pipeline completo executável no Claude Code, Cursor e OpenCode sem modificação de conteúdo em `.agents/`.

### RNF-004 — Extensibilidade
**Prioridade:** Should Have
Adicionar uma nova skill ao framework requer apenas: criar `.agents/skills/[nome]/SKILL.md` + `templates/` + `scripts/validate.py`. Não requer modificação de nenhuma outra skill existente.
**Métrica:** `validate_skills.py` valida estrutura da nova skill em menos de 10 linhas de configuração.

### RNF-005 — Rastreabilidade Completa
**Prioridade:** Must Have
Todo RF do PRD deve ser rastreável até: critério de aceite Gherkin → task de implementação → código → teste. Gaps de rastreabilidade são detectados por `/analyze` e reportados antes de `/implement`.
**Métrica:** `/analyze` detecta 100% dos RFs sem task correspondente.

### RNF-006 — Ausência de Dependências de Runtime
**Prioridade:** Must Have
O framework instalado não requer ferramentas além de: Python 3.10+, git e um CLI de IA compatível. Scripts de validação rodam sem internet.
**Métrica:** `python init.py` e todos os `validate.py` executam em ambiente sem internet e sem pip install.

### RNF-007 — Maturidade dos Prompts (Skills)
**Prioridade:** Must Have
Toda SKILL.md define completamente: objetivo, pré-condições, workflow por fase, artefatos de entrada e saída, e bloco de handoff para `memory/state.md`. Skills são avaliadas pelo `/checklist` antes de serem consideradas estáveis.
**Métrica:** `/checklist` aplicado a qualquer SKILL.md retorna 0 itens críticos abertos.

---

## 5. Regras de Negócio

### RN-001 — Progressividade Obrigatória
Toda skill que gera artefato deve salvar parcialmente a cada seção concluída — nunca construir o documento completo em memória e salvar de uma vez. Protege contra exaustão de contexto em sessões longas.

### RN-002 — Uma Pergunta por Vez
Skills interativas jamais emitem múltiplas perguntas dependentes no mesmo bloco. Perguntas independentes podem ser agrupadas (máximo 3). A resposta deve ser aguardada antes de avançar.

### RN-003 — Stale Blocks Downstream
Um artefato marcado como `stale` no Artifact Registry bloqueia a execução da skill downstream correspondente até que: (a) o artefato upstream seja corrigido e versionado, ou (b) o usuário confirme explicitamente que quer prosseguir com o artefato stale (registrado como desvio consciente).

### RN-004 — Canvas Nunca Publicado Incompleto
O REASONS Canvas não pode transitar de `DRAFT` para `READY` enquanto a dimensão O (Operations) não estiver preenchida. O status `READY` significa que o canvas é suficiente para um agente reimplementar a feature sem contexto adicional.

### RN-005 — Sem Duplicação .agents/ ↔ .claude/
O diretório `.claude/` referencia conteúdo via diretivas `@` — nunca duplica. Qualquer atualização de skill é feita exclusivamente em `.agents/` e automaticamente refletida em `.claude/`.

### RN-006 — Sistema Sem Guidelines Bloqueia TechSpec
Nenhuma TechSpec pode ser gerada para um sistema que não possui guidelines. O único caminho de contorno é: executar `/guidelines` para o sistema, ou fornecer URL/arquivo de guidelines do time responsável.

### RN-007 — Mock Deve Ter Task de Substituição
Todo contrato marcado como `PENDENTE DE VALIDAÇÃO` (mock) gera automaticamente uma task de substituição no documento de tasks. A conclusão da feature só é registrada quando essa task estiver completa ou explicitamente descartada com justificativa.

---

## 6. Integrações Externas

### 6.1 Plataformas de IA
| Plataforma | Tipo de integração | Responsável pelo mapeamento |
|-----------|-------------------|----------------------------|
| Claude Code | Nativo via `.claude/commands/` + CLAUDE.md | SSPDD (entregue no framework) |
| Cursor | Via `.cursor/rules/` (gerado por `init.py --platform cursor`) | SSPDD (gerado no init) |
| Copilot | Via `.github/copilot-instructions.md` (gerado por `init.py --platform copilot`) | SSPDD (gerado no init) |
| OpenCode / Codex | Via `.agents/skills/` (canônico) | Nativo — sem mapeamento adicional |

### 6.2 Repositórios de Sistemas Integrados
Quando uma feature afeta sistemas externos (RF-014), o framework lê guidelines e artefatos do repositório do sistema afetado. A URL do repositório é fornecida pelo usuário; o framework não faz clone automático — apenas instrui o caminho local.

---

## 7. Premissas e Restrições

### 7.1 Premissas
- O usuário tem acesso de escrita ao diretório do workspace
- Python 3.10+ está disponível no PATH
- O usuário tem uma conta ativa em pelo menos uma plataforma de IA compatível
- Features com sistemas integrados: o usuário consegue fornecer guidelines ou documentação dos sistemas afetados

### 7.2 Restrições
- Scripts de validação não podem fazer chamadas de rede
- O framework não persiste estado em serviços externos (tudo em arquivos locais)
- Skills não executam código do projeto do usuário — apenas analisam e geram artefatos
- O framework não garante qualidade do output do LLM — apenas estrutura e valida o artefato gerado

---

## 8. Métricas de Sucesso

| KPI | Baseline | Meta | Como medir |
|-----|---------|------|-----------|
| Canvas completo (READY) ao final do pipeline | 0% (não existe hoje) | 90% das features | % de features com canvas em status READY ao concluir /code-review |
| Gaps de rastreabilidade RF→Task detectados por /analyze | Manual / não detectados | 100% detectados automaticamente | /analyze retorna 0 falsos negativos em suite de teste |
| Validação sem LLM < 5s | N/A | p95 < 5s | Benchmark com artefatos de 500 linhas |
| Artefatos stale detectados antes de downstream | 0% (não existe hoje) | 100% dos casos | validate.py --mode input detecta todos os stale markers em state.md |
| Portabilidade de scripts | PS1 (Windows only) | Linux + macOS + Windows | CI matrix nos 3 SOs |

---

## 9. Riscos

| ID | Risco | Probabilidade | Impacto | Mitigação |
|----|-------|--------------|---------|-----------|
| RISK-001 | Mudança no formato AGENTS.md (padrão emergente) quebra compatibilidade | Média | Alto | Manter versão do AGENTS.md no `memory/constitution.md`; monitorar spec |
| RISK-002 | LLM ignora instruções do SKILL.md e gera artefato fora do template | Alta | Médio | validate.py --mode output detecta e reporta; usuário corrige antes de avançar |
| RISK-003 | Canvas progressivo com muitas atualizações gera conflitos de versão | Média | Médio | Canvas versionado como artefato; cada update registrado com hash; conflito resolvido via /spdd-sync |
| RISK-004 | Complexidade de cascade desencoraja adoção | Média | Alto | Cascade é transparente para usuário — detectado e apresentado pela skill; usuário decide ação |
| RISK-005 | Skills com maturidade desigual reduzem confiança no framework | Alta | Alto | /checklist avalia toda skill antes de marcar como estável; skills instáveis marcadas como [BETA] |

---

## 10. Questões em Aberto

| # | Questão | Responsável | Prazo |
|---|---------|------------|-------|
| ~~Q-001~~ | ~~Definir formato exato do Artifact Registry em state.md~~ | — | **Resolvido 2026-08-22:** tabela 3 colunas (Artefato, v, Status). Caminho abreviado sem `docs/`. Status: `ok \| draft \| stale:FONTE@V`. Sem hash, sem timestamp, sem coluna upstream. |
| ~~Q-002~~ | ~~Protocolo de repositórios externos para guidelines de sistemas integrados~~ | — | **Resolvido 2026-08-22:** framework espera sempre path local `systems/[sistema]/guidelines/`. Se ausente, a skill instrui o usuário a executar `git clone <URL> systems/[sistema]` e aguarda. `validate.py` verifica apenas path local — sem chamadas de rede. |
| ~~Q-003~~ | ~~Idioma dos templates~~ | — | **Resolvido 2026-08-22:** `init.py --lang pt_BR\|en_US` seleciona o idioma. Templates mantidos em duas versões (`templates/pt_BR/` e `templates/en_US/`). `CLAUDE.md` e `AGENTS.md` sempre em inglês (compatibilidade cross-vendor). |

---

## 11. Histórico de Revisões

| Versão | Data | Autor | Alteração |
|--------|------|-------|-----------|
| 1.0 | 2026-08-22 | Thiago Cavalcante | Versão inicial — 14 RFs, 7 RNFs, 7 RNs |
| 1.1 | 2026-08-22 | Thiago Cavalcante | +RF-015 (Decision Records), +RF-016 (RTK), Q-001/002/003 resolvidas, RF-010 atualizado com --lang |


