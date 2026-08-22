# Padrões de Código — SSPDD Framework
_Atualizado em: 2026-08-22_

## Markdown (Artefatos e Templates)

### Estrutura de IDs
- Requisitos funcionais: `RF-001`, `RF-002`, ...
- Requisitos não-funcionais: `RNF-001`, `RNF-002`, ...
- Tasks: `TASK-001`, `TASK-002`, ...
- Riscos: `RISK-001`, `RISK-002`, ...
- ADRs: `ADR-000`, `ADR-001`, ...
- Dimensões REASONS: `R`, `E`, `A`, `S`, `O`, `N`, `S` (prefixadas por seção)

### Critérios de Aceite
Formato Gherkin obrigatório — nunca prosa livre:
```
**Dado que** [contexto]
**Quando** [ação]
**Então** [resultado esperado]
```

### Placeholders em Templates
Formato: `{{NOME_DO_CAMPO}}` — SCREAMING_SNAKE_CASE com chaves duplas.

Exemplos: `{{FEATURE_NAME}}`, `{{DATE}}`, `{{RF_ID}}`.

### Headings
- Nível 1 (`#`): título do documento — exatamente 1 por arquivo
- Nível 2 (`##`): seções principais
- Nível 3 (`###`): subseções
- Nível 4+ (`####`): apenas dentro de seções muito densas

### Listas
- Prosa em itens de lista: sem ponto final
- Sentenças completas em itens: com ponto final
- Aninhamento máximo: 2 níveis

---

## Python (Scripts de Validação)

### Convenções Gerais
- Versão mínima: Python 3.10
- Sem dependências externas — apenas stdlib
- Encoding: UTF-8 em todos os arquivos

### Estilo
- Formatador: `ruff format` (substitui black)
- Linter: `ruff check`
- Tipo de hints: obrigatório em funções públicas
- Docstrings: apenas quando a lógica não é óbvia pelo nome

### Interface dos Scripts de Validação
Todo `validate.py` de skill deve seguir esta interface:

```
Uso: python validate.py <caminho-do-artefato>
Exit 0: artefato válido
Exit 1: artefato inválido (erros impressos em stderr)
```

Saída em stderr, uma linha por erro:
```
ERRO: Seção "Requisitos Funcionais" ausente
ERRO: RF-002 não possui critérios de aceite no formato Gherkin
AVISO: Campo {{FEATURE_NAME}} não foi substituído
```

### Nomenclatura
- Funções: `snake_case`
- Classes: `PascalCase`
- Constantes: `SCREAMING_SNAKE_CASE`
- Arquivos: `snake_case.py`

---

## Go (CLI)

### Estrutura de Comandos
```
sspdd <comando> [flags]

Comandos:
  init        Inicializa workspace SSPDD em diretório corrente
  generate    Gera arquivos de plataforma a partir de .agents/
  sync        Sincroniza REASONS Canvas com mudanças de código
  validate    Valida artefatos de uma feature
```

### Estilo
- Formatador: `gofmt` (padrão Go)
- Linter: `golangci-lint`
- Erros: retornar sempre, nunca panic em código de produção
- Logs: `log/slog` com saída estruturada

### Versionamento
- Semântico: `MAJOR.MINOR.PATCH`
- Tags Git: `v1.0.0`
- Compatibilidade: manter CLI estável entre MINOR versions

---

## SKILL.md (Definições de Skills)

### Frontmatter obrigatório
```yaml
---
name: nome-da-skill
description: Uma frase descrevendo quando usar esta skill (usada pelo LLM para decidir quando acionar).
---
```

### Seções obrigatórias no corpo
1. **Objetivo** — o que a skill produz e para quem
2. **Pré-condições** — o que deve existir antes de executar
3. **Workflow** — fases numeradas com responsabilidades claras
4. **Artefatos gerados** — lista de arquivos criados/modificados com caminho
5. **Handoff** — o que registrar em `memory/state.md` ao concluir

### Seções opcionais
- **Módulos de entrevista** (para skills interativas)
- **Tabela de aplicabilidade** (quando comportamento varia por tipo)
- **Checklist de qualidade** (critérios de auto-validação antes de encerrar)

### Regras de escrita
- Sem blocos de código nos outputs ao usuário (regra do `comportamento.md`)
- Toda instrução de persistência deve ser "progressiva" — salvar parciais
- Referências a outros artefatos: sempre por caminho relativo, nunca colado inline
