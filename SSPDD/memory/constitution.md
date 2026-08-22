# Constituicao — SSPDD
_Criado em: 2026-08-22_

> Principios estaveis, ADRs e decisoes de design do workspace.
> Atualizado apenas quando os fundamentos mudarem.

---

## Contexto do Workspace

- **SSPDD** — cenario: Novo (greenfield)
- **Propósito:** Framework híbrido SDD + SPDD para pipeline de desenvolvimento com IA
- **Referências base:** thiagorjes/SDD (pipeline), gszhangwei/open-spdd (REASONS Canvas)

---

## Decisoes de Arquitetura (ADRs)

### ADR-001 — REASONS Canvas como artefato de primeira classe
- **Decisão:** O REASONS Canvas (OpenSPDD) é gerado automaticamente ao final de `/techspec` e usado como contexto de implementação pelo `/implement`.
- **Motivação:** Preenche a lacuna entre especificação técnica e instrução executável para IA — o canvas é o elo entre spec e código.
- **Consequência:** Nova skill `/spdd-canvas` no pipeline; novo comando `sspdd generate canvas`.

### ADR-002 — Python para scripts de validação (portabilidade)
- **Decisão:** Todos os `validate.py` e scripts de skill usam Python 3.10+ stdlib apenas.
- **Motivação:** Portabilidade Linux/macOS/Windows sem dependência de PowerShell ou bash.
- **Consequência:** Substituição dos `.ps1` de validação do SDD original por `.py` equivalentes.

### ADR-003 — Python para distribuição (sem CLI Go)
- **Decisão:** Distribuição via `init.py` (Python) + GitHub template. Não há CLI Go.
- **Motivação:** O "CLI" é o próprio CLI da plataforma de IA (Claude Code, Codex, etc.). Framework é um conjunto de arquivos, não uma ferramenta compilada.
- **Consequência:** `init.py` (stdlib apenas) cria o workspace; `validate.py` por skill valida artefatos. Sem módulo Go.

### ADR-004 — .agents/ como fonte de verdade cross-vendor
- **Decisão:** `.agents/skills/`, `.agents/agents/`, `.agents/templates/` são a fonte canônica. `.claude/` é espelho que referencia via diretivas `@` — nunca duplica conteúdo.
- **Motivação:** Agnóstico de plataforma; compatível com AGENTS.md (padrão emergente cross-vendor).
- **Consequência:** Qualquer nova plataforma de IA adiciona apenas um mapeamento — o conteúdo já existe em `.agents/`.

### ADR-005 — Progressive persistence obrigatória
- **Decisão:** Toda skill com artefato deve salvar parcialmente a cada seção, não ao final.
- **Motivação:** Evitar perda de trabalho por exaustão de contexto em sessões longas.
- **Consequência:** SKILL.md de todas as skills inclui instrução explícita de salvamento incremental.

### ADR-010 — Canvas push com dimension ownership
- **Decisão:** Cada skill escreve suas dimensões no canvas ao concluir, marcando `_Atualizado por: /[skill] v[x.y] — [data]_` por dimensão.
- **Motivação:** Progressivo e natural — canvas cresce junto com o pipeline sem trigger explícito.
- **Consequência:** Cada SKILL.md declara explicitamente quais dimensões do canvas atualiza e em qual fase do workflow.

### ADR-011 — validate.py: engine híbrida
- **Decisão:** Engine compartilhada em `.agents/scripts/validate.py` lê `validate-rules.json` por skill. JSON pode declarar `custom_steps` com scripts Python adicionais (`.agents/skills/[skill]/scripts/[script].py`) executados após as regras padrão.
- **Motivação:** Zero duplicação do engine Python; flexibilidade por skill quando regras declarativas não bastam. stdlib `json` cobre 3.10+.
- **Consequência:** validate-rules.json é o contrato de validação por skill; scripts custom são exceção, não regra.

### ADR-012 — DR numbering por tipo
- **Decisão:** Cada tipo de Decision Record tem sequência própria: ADR-001, BDR-001, SDR-001, DDR-001.
- **Motivação:** Recuperação por domínio semântico — `ADR-*` são sempre técnicos, `BDR-*` sempre de negócio.
- **Consequência:** Quatro contadores independentes mantidos no índice de `memory/constitution.md`.

### ADR-009 — Idioma dos templates
- **Decisão:** `init.py --lang pt_BR|en_US` seleciona o idioma no momento de criação do workspace. Templates em duas versões: `.agents/skills/[skill]/templates/pt_BR/` e `en_US/`. `AGENTS.md` e `CLAUDE.md` sempre em inglês.
- **Motivação:** Equipes brasileiras trabalham em pt-BR; projetos open-source ou times internacionais usam en-US. A seleção no init evita manutenção de duas versões do workspace após criação.
- **Consequência:** Cada skill mantém templates duplicados por idioma; `validate.py` é independente de idioma (valida estrutura, não conteúdo).

### ADR-008 — Protocolo de repositórios externos
- **Decisão:** Framework sempre opera sobre path local `systems/[sistema]/guidelines/`. Se ausente, a skill instrui o usuário a clonar manualmente (`git clone <URL> systems/[sistema]`) e aguarda antes de prosseguir. `validate.py` nunca faz chamadas de rede.
- **Motivação:** Mantém RNF-006 (scripts offline) e o princípio de segurança (scripts sem execução de rede). Skills (LLM) podem orquestrar o usuário; scripts não.
- **Consequência:** RF-014 (dependências inter-sistemas) implementado sem exceção ao modelo offline.

### ADR-007 — Schema do Artifact Registry
- **Decisão:** Tabela Markdown de 3 colunas: `Artefato` (caminho sem prefixo `docs/`), `v` (versão semântica), `Status` (`ok | draft | stale:FONTE@V`).
- **Motivação:** Hash e timestamp são redundantes (git cobre integridade; validate.py cobre estrutura). Upstream implícito na ordem do pipeline — não precisa de coluna extra.
- **Consequência:** validate.py lê a coluna Status via regex; stale com fonte e versão inline é suficiente para o usuário e para o script tomarem decisão.

### ADR-006 — /spdd-sync bidirecional
- **Decisão:** `sspdd sync` detecta divergência código↔canvas e oferece resolução em ambas as direções (corrigir canvas ou reverter código).
- **Motivação:** Respeitar o princípio OpenSPDD "fix the prompt first" mas permitir evolução legítima de design durante implementação.
- **Consequência:** Todo desvio deve ser registrado em `docs/spdd/[feature]-deviations.md`, independente da direção de resolução.

---

### ADR-013 — comportamento.md como template gerado por init.py
- **Decisão:** `comportamento.md` passa a ser template versionado por idioma (`.agents/templates/[lang]/comportamento.md-template`), gerado na raiz de todo workspace por `init.py` e referenciado via `@comportamento.md` no `CLAUDE.md-template`.
- **Motivação:** regras de interação (idioma, formato de output no chat, travas de segurança, economia de tokens) são genéricas e valiosas para qualquer workspace SSPDD, não só para o desenvolvimento do próprio framework.
- **Consequência:** nova função `generate_comportamento_md` em `init.py`; todo workspace novo nasce com essas regras. Ver [docs/decisions/ADR-013-comportamento-md-template.md](../docs/decisions/ADR-013-comportamento-md-template.md).

## Principios Estaveis

1. **Business-first:** PRD captura o quê e por quê; TechSpec decide o como. Nunca misturar.
2. **Skill-first:** toda funcionalidade do framework é uma skill com SKILL.md canônico.
3. **Template-driven:** todo artefato tem template; padronização nunca é negociável.
4. **Script-validated:** toda skill tem `validate.py` que checa estrutura sem IA.
5. **One question at a time:** interatividade nunca sobrecarrega o usuário com perguntas dependentes simultâneas.
6. **Canvas-as-prompt:** REASONS Canvas é instrução executável, não documentação — deve ser preciso e acionável.