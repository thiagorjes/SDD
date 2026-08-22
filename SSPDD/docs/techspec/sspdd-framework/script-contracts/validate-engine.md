# Script Contract — validate.py (Engine)
_Versão: 1.0 | Atualizado em: 2026-08-22_

**Localização:** `.agents/scripts/validate.py`

---

## Interface

```
python .agents/scripts/validate.py \
  --mode input|output \
  --rules .agents/skills/[skill]/validate-rules.json \
  --artifact docs/[tipo]/[arquivo].md \
  [--system SISTEMA]

Exit 0 → válido
Exit 1 → inválido (erros em stderr)
Exit 2 → erro de configuração (rules ausente, artifact não existe)
```

## Fluxo de Execução

### Modo `--mode input`
1. Carrega `validate-rules.json` da skill
2. Lê `memory/state.md` — seção `## Artifact Registry`
3. Para cada `required_artifacts` do JSON:
   - Verifica existência no disco
   - Busca status no Artifact Registry: `ok | draft | stale:*`
   - Se `stale:*` → registra ERRO com fonte e versão do stale
   - Se ausente no disco → registra ERRO
4. Executa `custom_steps` de input (se definidos)
5. Retorna exit 0 se sem ERROs, exit 1 caso contrário

### Modo `--mode output`
1. Carrega `validate-rules.json` da skill
2. Lê conteúdo do artifact
3. Verifica `required_sections` — cada seção deve existir (heading exato)
4. Verifica `no_empty_placeholders` — regex `\{\{[A-Z_]+\}\}`
5. Verifica `id_patterns` — cada ID declarado deve estar no formato correto
6. Verifica `gherkin_required_for_ids` — para cada ID do tipo declarado, busca bloco Gherkin (`**Dado que**`, `**Quando**`, `**Então**`)
7. Executa `custom_steps` de output em ordem:
   - Chama `python [script] [args]` via subprocess
   - Captura stderr do script custom
   - `on_failure: "error"` → propaga como ERRO; `"warning"` → propaga como AVISO
8. Retorna exit 0 se sem ERROs (avisos não bloqueiam)

## Formato de Saída (stderr)

```
ERRO: Seção obrigatória ausente: "## 3. Requisitos Funcionais"
ERRO: Artefato stale: prd/auth-prd.md (stale:prd@1.0 — aguardando prd@1.1)
ERRO: RF-003 não possui critério de aceite Gherkin
AVISO: RNF-002 sem métrica mensurável detectada
```

## Substituição de Variáveis no JSON

O engine substitui `{{SYSTEM}}`, `{{FEATURE}}` e `{{INPUT_ARTIFACT}}` nos campos do JSON usando o contexto passado via `--system` e o nome do artifact resolvido.

## Dependências

- Python 3.10+ stdlib apenas: `re`, `json`, `pathlib`, `subprocess`, `sys`
- Nenhuma chamada de rede
- Execução < 5s para artefatos de até 500 linhas
