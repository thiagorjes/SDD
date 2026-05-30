# TASK-5.1 — Persistência de Recordes (SQLite)

**Feature:** KingPong Core Gameplay
**Documento principal:** [docs/tasks/kingpong-core-gameplay-tasks.md]
**Epic:** EPIC-5 — Persistence | **US:** US-6 — Recordes Locais (SQLite)
**Labels:** `[core]` `[database]`
**Estimativa:** M
**Depende de:** TASK-4.1
**Bloqueia:** nenhuma
**Paralelo `[P]`:** Sim
**Status:** `Pendente`

---

## Contexto

Implementar a persistência local dos recordes de pontuação utilizando SQLite para garantir que os High Scores do jogador sejam mantidos entre as sessões do aplicativo.

**Referências:**
- TechSpec: [Seção 3 — Modelagem de Dados] e [Seção 1.3 — Stack Tecnológica (SQLite)]
- Guidelines: [banco-dados.md] (se disponível)

---

## O que deve ser feito

- [ ] Instalar e configurar `react-native-quick-sqlite` ou similar.
- [ ] Criar script de migração inicial para criar a tabela `Score`.
- [ ] Implementar serviço de banco de dados com as funções:
    - `saveScore(points: number)`: Insere novo registro.
    - `getHighScores(limit: number)`: Retorna os maiores scores.
- [ ] Integrar o salvamento automático ao disparar o estado de Game Over.

---

## Guia técnico de implementação

A tabela deve seguir estritamente o modelo de dados definido no TechSpec.

**Schema da Tabela:**
```sql
CREATE TABLE IF NOT EXISTS Score (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    points INTEGER NOT NULL,
    achieved_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Pontos de atenção:**
- Garantir que a conexão com o banco seja inicializada no bootstrap do app.
- O campo `achieved_at` deve registrar o momento exato do recorde.

---

## Critérios de Aceite

- [ ] Tabela `Score` criada com sucesso na inicialização.
- [ ] Pontuação salva no banco de dados ao final de cada Game Over.
- [ ] Possibilidade de recuperar o Top 5 recordes via consulta SQL.
- [ ] Verificação de persistência após fechar e reabrir o app.
- [ ] Code review aprovado.

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
