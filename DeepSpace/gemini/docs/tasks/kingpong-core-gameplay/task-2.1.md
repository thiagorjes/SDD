# TASK-2.1 — Motor de Vetores e Ângulo Mínimo

**Feature:** KingPong Core Gameplay
**Documento principal:** [docs/tasks/kingpong-core-gameplay-tasks.md]
**Epic:** EPIC-2 — Core Physics | **US:** US-3 — Movimento da Bolinha (Física)
**Labels:** `[core]` `[logic]`
**Estimativa:** G
**Depende de:** TASK-1.1
**Bloqueia:** TASK-2.2
**Paralelo `[P]`:** Sim — com TASK-3.1
**Status:** `Pendente`

---

## Contexto

Implementar a lógica matemática que move a bola e garante que ela nunca fique presa em loops horizontais (trava de 15 graus).

**Referências:**
- PRD: [RF-003 — A bolinha deve manter um ângulo mínimo de 15 graus com a horizontal] e [P12 — Se a bola colidir nos cantos... os dois vetores de direção invertem simultaneamente]
- TechSpec: [Seção 2.3 — Fluxo de Dados: Movimentação (Atualiza BallPosition x/y em cada frame)]
- Guidelines: [architecture.md — isolar lógica em core/physics]

---

## O que deve ser feito

- [ ] Criar hook ou utilitário de física para cálculo de reflexão elástica.
- [ ] Implementar trava matemática para ângulos < 15° com a horizontal.
- [ ] Implementar lógica de inversão dupla em colisões de quina (P12).

---

## Guia técnico de implementação

Utilizar Worklets do Reanimated para garantir que o cálculo de física ocorra no UI Thread.

**Estrutura de arquivos esperada:**
```
src/core/physics/vectorEngine.ts  — Lógica pura de vetores
src/core/hooks/usePhysics.ts      — Hook para integrar com SharedValues
```

**Padrão a seguir:**
```typescript
// Exemplo de inversão de vetor com trava de ângulo
const MIN_ANGLE = Math.PI / 12; // 15 graus
```

**Pontos de atenção:**
- A trava de 15 graus deve ser aplicada em relação à horizontal para evitar que a bola fique rebatendo infinitamente entre as paredes laterais com pouca progressão vertical.

---

## Critérios de Aceite

- [ ] A bolinha reflete corretamente nas bordas (teto e laterais).
- [ ] Colisões em cantos invertem X e Y (Double Bounce).
- [ ] Testes unitários validam a trava de 15 graus.
- [ ] Testes TDD escritos antes da implementação
- [ ] Sem regressões nos testes existentes
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
