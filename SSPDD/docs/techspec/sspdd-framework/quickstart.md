# Quickstart — SSPDD Framework
_Versão: 1.0 | Atualizado em: 2026-08-22_

---

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Scripts | Python 3.10+ (stdlib apenas) |
| Artefatos | Markdown (CommonMark) |
| Skills | SKILL.md (formato canônico) |
| Plataforma primária | Claude Code |
| Plataformas adicionais | Cursor, GitHub Copilot, OpenCode |
| Token optimization | RTK (opcional, recomendado) |

---

## Setup de Novo Workspace

```bash
# 1. Clonar o framework
git clone https://github.com/[org]/sspdd .sspdd-source

# 2. Inicializar workspace no projeto
python .sspdd-source/scripts/init.py \
  --project "Meu Projeto" \
  --path ./meu-projeto \
  --lang pt_BR \
  --platform claude

# 3. Entrar no workspace
cd meu-projeto

# 4. Começar o pipeline
# No Claude Code: /guidelines
```

---

## Pipeline Completo

```
/discovery   → docs/discovery/[feature]-discovery.md
               docs/spdd/[feature]-canvas.md (DRAFT, R+E)
     ↓
/prd         → docs/prd/[feature]-prd.md
               canvas R atualizado
     ↓
[/clarify]   → docs/prd/[feature]-prd.md (versão atualizada)
[/checklist] → docs/checklists/[feature]-prd.md
[/designer]  → docs/design/[feature]-design-brief.md
               canvas E atualizado
     ↓
/techspec    → docs/techspec/[feature]-techspec.md
               docs/techspec/[feature]/data-model.md
               docs/techspec/[feature]/skill-contracts/
               canvas A, S, N atualizados
     ↓
/tasks       → docs/tasks/[sistema]-[feature]-tasks.md
               canvas O atualizado
     ↓
[/analyze]   → relatório de consistência cross-artefato
     ↓
/implement   → código implementado (task por task)
  ou /tdd    → código com TDD (Red→Green→Refactor)
     ↓
/code-review → relatório de revisão
               canvas S (Safeguards) atualizado
               canvas status: READY
     ↓
/tests       → suite de testes completa
     ↓
[/spdd-sync] → docs/spdd/[feature]-deviations.md (se divergências)
```

---

## Cenários Principais

### Cenário 1 — Nova feature em sistema novo

**Dado que** o workspace está vazio e não há guidelines para o sistema
**Quando** o usuário executa `/guidelines`
**Então** é conduzido por levantamento interativo que gera 9 arquivos em `systems/[sistema]/guidelines/`; estado registrado em `memory/state.md` com Guidelines = ok

---

### Cenário 2 — validate.py detecta artefato stale

**Dado que** o PRD foi atualizado para v1.1 após o TechSpec já ter sido gerado (v1.0)
**Quando** o usuário tenta executar `/tasks`
**Então** `validate.py --mode input` detecta `techspec/[feature]-techspec.md` com status `stale:prd@1.1` no Artifact Registry, reporta o stale em stderr e interrompe o fluxo com instrução: "Execute /techspec novamente para atualizar a especificação técnica com o PRD v1.1"

---

### Cenário 3 — Feature com sistema integrado sem guidelines

**Dado que** a feature consome uma API de sistema externo sem guidelines no workspace
**Quando** `/techspec` detecta a dependência e o path `systems/[sistema-externo]/guidelines/` não existe
**Então** a skill instrui: "Clone o repositório do sistema externo: `git clone <URL> systems/[sistema-externo]`" e aguarda; ao retornar, `validate.py --mode input` re-verifica o path

---

### Cenário 4 — Recriar feature em outra plataforma

**Dado que** o canvas de uma feature tem status `READY` (todas as 7 dimensões preenchidas)
**Quando** um desenvolvedor abre o arquivo `docs/spdd/[feature]-canvas.md` em qualquer LLM
**Então** o canvas é suficiente para implementar a feature — dimensões R (o quê), A (como), S (estrutura), O (tasks), N (normas) e S (guardrails) cobrem todas as decisões necessárias sem consultar outros artefatos

---

## Validação de Artefatos

```bash
# Validar input antes de iniciar uma skill
python .agents/scripts/validate.py \
  --mode input \
  --rules .agents/skills/techspec/validate-rules.json \
  --artifact docs/prd/minha-feature-prd.md \
  --system MeuSistema

# Validar output após skill concluir
python .agents/scripts/validate.py \
  --mode output \
  --rules .agents/skills/prd/validate-rules.json \
  --artifact docs/prd/minha-feature-prd.md
```

---

## Criação de Decision Record

```bash
# DRs são criados pelas skills automaticamente.
# Para criar manualmente:
# 1. Copie o template
cp .agents/templates/pt_BR/decision-record-template.md \
   docs/decisions/ADR-001-minha-decisao.md

# 2. Preencha o frontmatter e as 4 seções obrigatórias
# 3. Referencie no canvas da feature correspondente
```

---

## Caveats

1. **RTK não disponível no Windows via brew** — use o install.sh ou instale via cargo
2. **Templates pt_BR e en_US são cópias independentes** — atualizações no framework precisam ser aplicadas em ambos os idiomas
3. **Canvas READY não significa código pronto** — significa que o canvas é autossuficiente como instrução; a implementação ainda precisa ser executada
4. **validate.py não valida semântica de negócio** — verifica estrutura e formato; a semântica é responsabilidade do /checklist e /analyze com revisão humana
5. **Stale em cascata é informativo, não bloqueante** — o usuário pode confirmar `--force` para prosseguir com artefato stale com desvio registrado conscientemente
