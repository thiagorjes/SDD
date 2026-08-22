# Observabilidade — SSPDD Framework
_Atualizado em: 2026-08-22_

## Rastreamento de Custos de LLM

> **Fora do escopo v1.0** — será implementado em momento futuro de forma independente. Nenhum script de costs no framework inicial.

---

## Logging do CLI

### Níveis de log
| Nível | Quando usar |
|-------|------------|
| INFO | Ações concluídas normalmente |
| WARN | Condições recuperáveis (arquivo não encontrado mas opcional) |
| ERROR | Falhas que impedem execução — terminar com exit 1 |
| DEBUG | Detalhes internos — apenas com flag `--debug` |

### Formato
```
2026-08-22T14:30:00Z INFO  sspdd/init workspace criado em ./meu-projeto
2026-08-22T14:30:01Z INFO  sspdd/generate canvas gerado: docs/spdd/auth-canvas.md
2026-08-22T14:30:02Z WARN  sspdd/sync  dimensão O vazia no canvas — verifique tasks
2026-08-22T14:30:05Z ERROR sspdd/validate PRD inválido: 3 erros encontrados
```

Saída em stderr para logs, stdout para output estruturado (JSON/tabelas).

---

## Rastreamento de Artefatos

### memory/state.md como painel de controle
O arquivo `memory/state.md` é o único painel de observabilidade operacional do workspace:
- Quais features estão em andamento
- Em qual etapa do pipeline cada feature está
- Quais artefatos foram gerados e onde
- Questões em aberto que bloqueiam progresso

### Validação de integridade
`sspdd validate` percorre `memory/state.md` e verifica:
- Cada artefato referenciado existe no disco
- Nenhum artefato existe sem entrada correspondente no state.md
- Todas as features "em andamento" têm próximo passo definido

---

## Métricas de Qualidade do Framework

Opcionalmente, ao concluir uma feature completa (prd→implement→code-review), registrar em `memory/state.md`:

| Métrica | O que mede |
|--------|-----------|
| Número de iterações de /clarify | Ambiguidade do PRD inicial |
| Número de divergências no /spdd-sync | Aderência canvas→implementação |
| Achados de /code-review (críticos/warnings) | Qualidade da implementação |
| Custo total da feature | Eficiência do pipeline |
