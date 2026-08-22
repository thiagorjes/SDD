---
id: ADR-013
type: ADR
status: accepted
date: 2026-08-22
supersedes: —
superseded-by: —
---

# ADR-013 — comportamento.md como template gerado por init.py

## Decisão

`comportamento.md` passa a ser um template versionado por idioma em `.agents/templates/[lang]/comportamento.md-template`, gerado na raiz de todo workspace por `init.py` e referenciado via `@comportamento.md` no `CLAUDE.md-template`.

## Motivação

O arquivo existia apenas na raiz do próprio repositório SSPDD (meta-projeto), sem vínculo com `.agents/templates/`; workspaces gerados por `init.py` ficavam sem essas regras de comportamento (idioma, verbosidade, formato de output no chat, travas de segurança).

**Problema que resolve:**
Regras de interação (idioma, proibição de exibir código/output bruto no chat, travas de segurança para ações destrutivas, economia de tokens em tool calls e separação constitution/state) são genéricas e valiosas para qualquer workspace SSPDD, não apenas para o desenvolvimento do próprio framework.

**Restrições consideradas:**
- ADR-009 já estabelece `AGENTS.md`/`CLAUDE.md` sempre em inglês, com templates de conteúdo duplicados por idioma — `comportamento.md` segue o mesmo padrão de duplicação por idioma (diferente de AGENTS.md/CLAUDE.md, o conteúdo de comportamento.md é majoritariamente instrução ao usuário/IA em linguagem natural, então acompanha `--lang`).

## Consequências

**Positivas:**
- Todo workspace novo já nasce com regras de comportamento consistentes com o framework.
- Segue o padrão arquitetural existente (ADR-004: `.agents/` como fonte canônica; ADR-009: templates por idioma).

**Negativas / trade-offs:**
- Mais um arquivo a manter em duas versões de idioma.

**Downstream afetado:**
- `scripts/init.py` (nova função `generate_comportamento_md`), `.agents/templates/CLAUDE.md-template`, testes em `scripts/tests/test_init.py`.

## Alternativas Consideradas

### Alternativa 1 — Mesclar conteúdo em AGENTS.md/CLAUDE.md-template
**Descartada porque:** infla um arquivo que ADR-009 mantém deliberadamente enxuto e sempre em inglês; comportamento.md tem ciclo de vida e escopo semântico próprios (regras de interação, não inventário de skills/agents).

### Alternativa 2 — Não incluir a seção "economia de tokens/claude_costs.ps1"
**Decisão tomada:** a seção "economia de tokens" (formato compacto de tool calls + separação constitution/state) foi mantida no template por ser genérica; apenas a chamada a `scripts/claude_costs.ps1` (específica deste meta-repo, script que nem existe no SSPDD) não foi replicada — não estava em `comportamento.md`, e sim isolada em `CLAUDE.md`, então não havia nada a remover do novo template.
