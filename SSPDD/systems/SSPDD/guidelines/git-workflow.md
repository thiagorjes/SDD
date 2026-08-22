# Git Workflow — SSPDD Framework
_Atualizado em: 2026-08-22_

## Estratégia de Branches

```
main          ← release estável do framework
  └── develop ← integração contínua
        ├── feature/[skill-name]     ← nova skill ou melhoria de skill existente
        ├── feature/[artefato]-template  ← novo template
        ├── fix/[descricao-curta]    ← correção em skill ou script
        └── chore/[descricao-curta]  ← atualização de deps, CI, docs
```

**Regra:** nenhum commit direto em `main` ou `develop` — sempre via PR.

## Commits — Conventional Commits

Formato: `<tipo>(<escopo>): <descrição imperativa>`

| Tipo | Quando usar |
|------|------------|
| `feat` | Nova skill, novo template, novo comando CLI |
| `fix` | Correção de bug em skill, script ou CLI |
| `docs` | Guidelines, README, comentários |
| `chore` | CI, dependências, configurações |
| `refactor` | Reestruturação sem mudança de comportamento |
| `test` | Fixtures, testes de validate.py, testes Go |

**Escopo:** nome da skill ou componente afetado.

Exemplos:
```
feat(spdd-canvas): implementar geração de REASONS Canvas a partir do TechSpec
fix(prd/validate): corrigir detecção de IDs RF no formato RFnnn
docs(guidelines): adicionar convenções de skill-conventions.md
test(techspec): adicionar fixtures válidos e inválidos para validate.py
chore(ci): adicionar job de lint Python com ruff
```

## Pull Requests

### Template de PR
```markdown
## O que muda
[1-3 bullets do que foi adicionado/corrigido]

## Skill(s) afetada(s)
[nome da skill ou "N/A"]

## Artefato(s) impactado(s)
[tipo de artefato gerado ou "N/A"]

## Checklist
- [ ] validate.py atualizado (se skill com artefato)
- [ ] fixtures de teste atualizados
- [ ] SKILL.md seções obrigatórias presentes
- [ ] memory/state.md não incluído no commit (arquivo de workspace)
```

### Tamanho de PR
- 1 skill completa (SKILL.md + templates + validate.py + fixtures) por PR
- Não misturar skills diferentes no mesmo PR
- Exceção: PRs de setup inicial (`sspdd init`) podem conter múltiplas skills de uma vez

## Tags e Releases

- Tags semânticas: `v1.0.0`, `v1.1.0`, `v2.0.0`
- MAJOR: mudança de pipeline incompatível (ex: renomear skill, mudar formato de artefato)
- MINOR: nova skill ou comando CLI retrocompatível
- PATCH: fix em skill ou script existente

## .gitignore do Workspace SSPDD

```gitignore
# Gerado pelo framework — não versionar
systems/
.env
memory/costs.md

# Exceções: artefatos SDD são versionados
!docs/
!memory/constitution.md
!memory/state.md
```

**Nota:** `systems/` contém repositórios dos sistemas do usuário — cada um tem seu próprio git. O workspace SSPDD versiona apenas artefatos SDD (`docs/`, `memory/`).

## CI Checks (obrigatórios para merge em develop)

```yaml
required:
  - build-cli         # go build ./...
  - test-cli          # go test ./...
  - lint-python       # ruff check .agents/
  - validate-skills   # checa seções obrigatórias em todo SKILL.md
```
