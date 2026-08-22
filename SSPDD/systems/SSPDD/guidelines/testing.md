# Estratégia de Testes — SSPDD Framework
_Atualizado em: 2026-08-22_

## Camadas de Validação

O framework usa três camadas complementares — nenhuma usa IA, exceto onde explicitado.

### Camada 1: Validação Estrutural (automatizada, sem IA)
Cada skill com artefato gerado possui `scripts/validate.py`:

| O que valida | Exemplos |
|-------------|---------|
| Seções obrigatórias presentes | "## Requisitos Funcionais" existe no PRD |
| IDs no formato correto | RF-001, não "RF1" ou "rf-001" |
| Placeholders substituídos | Nenhum `{{CAMPO}}` remanescente |
| Critérios de aceite em Gherkin | "Dado que / Quando / Então" presentes por RF |
| Referências cruzadas | IDs citados na TechSpec existem no PRD |
| REASONS Canvas completo | Todas as 7 dimensões preenchidas (não vazias) |

**Interface padrão:**
```
python validate.py <arquivo.md>
# Exit 0 → válido
# Exit 1 → imprime erros em stderr, um por linha
```

**Quando executar:** ao final de cada skill, antes de atualizar `memory/state.md`.

### Camada 2: Consistência Cross-Artefato (skill /analyze)
Revisão cross-artefato que detecta:
- RFs no PRD não cobertos na TechSpec
- Tasks sem RF de origem rastreável
- REASONS Canvas com dimensão divergindo do TechSpec
- Contradições entre artefatos de sistemas diferentes

**Quando executar:** após `/tasks`, antes de `/implement`. Opcional mas recomendado em features complexas.

### Camada 3: Checklist de Qualidade (skill /checklist)
Revisão guiada por humano que verifica:
- Clareza e mensurabilidade dos requisitos
- Completude dos critérios de aceite
- Identificação de ambiguidades não capturadas

**Quando executar:** após `/prd` ou `/techspec`, especialmente em features de alto risco.

---

## Testes do CLI Go

### Estrutura
```
cli/
├── cmd/
│   ├── init_test.go
│   ├── generate_test.go
│   └── sync_test.go
└── testdata/
    ├── workspace_minimal/    # Workspace mínimo válido
    └── workspace_full/       # Workspace completo para testes de geração
```

### Cobertura mínima
- Comandos `init`, `generate`, `sync`: testes de integração com `testdata/`
- Parsing de flags: testes unitários
- Não testar internals de geração de Markdown — testar output end-to-end

### Execução
```bash
go test ./...
```

---

## Testes dos Scripts Python

### Executar todos os validate.py
```bash
python -m pytest .agents/skills/*/scripts/validate.py --collect-only  # listar
python .agents/skills/prd/scripts/validate.py tests/fixtures/prd_valid.md
python .agents/skills/prd/scripts/validate.py tests/fixtures/prd_invalid.md
```

### Fixtures de Teste
Cada skill com `validate.py` mantém em `scripts/tests/`:
- `fixtures/valid_[artefato].md` — artefato bem formado (deve passar)
- `fixtures/invalid_[artefato].md` — artefato com erros conhecidos (deve falhar com mensagens específicas)

---

## CI (GitHub Actions)

```yaml
# .github/workflows/ci.yml — mínimo
jobs:
  cli:
    - go build ./...
    - go test ./...
    - golangci-lint run

  scripts:
    - ruff check .agents/
    - ruff format --check .agents/
    - python validate_all.py  # script que roda todos os validate.py contra fixtures
```

---

## O que NÃO testar automaticamente
- Qualidade do output de LLM (subjetivo — coberto por /checklist e /analyze)
- Fluxo interativo das skills (testado manualmente em sessões de QA)
- Compatibilidade com plataformas de IA além de Claude (testado por contributors da plataforma)
