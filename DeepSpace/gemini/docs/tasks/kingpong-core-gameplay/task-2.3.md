# TASK-2.3 — Goal Detection e Reset de Round

**Feature:** KingPong Core Gameplay
**Documento principal:** [docs/tasks/kingpong-core-gameplay-tasks.md]
**Epic:** EPIC-2 — Core Physics | **US:** US-4 — Sistema de Pontuação (Goal)
**Labels:** `[core]` `[logic]`
**Estimativa:** M
**Depende de:** TASK-2.1, TASK-2.2
**Bloqueia:** TASK-4.1
**Paralelo `[P]`:** Não
**Status:** `Pendente`

---

## Contexto

Implementar a detecção lógica de quando a bolinha atravessa a área de gol no topo da tela. Diferente das paredes, o gol não deve causar colisão elástica, permitindo que a bola "saia" da tela por aquela região específica para contabilizar o ponto.

**Referências:**
- PRD: [RF-004 — Sistema de Pontuação (Goal)] e [P10 — Goal terá exatos 60px de largura]
- TechSpec: [Seção 2.3 — Fluxo de Dados: Movimentação (Detecção de goal)]

---

## O que deve ser feito

- [ ] Implementar zona de detecção de goal no topo central da tela (largura: 60px).
- [ ] Configurar bypass de colisão na área de goal (a bola deve atravessar sem rebater).
- [ ] Implementar trigger de pontuação quando o centro da bola ultrapassar o limite do teto dentro da área de 60px.
- [ ] Lógica de reset da bola para a posição inicial (20% do topo) após a marcação do ponto.

---

## Guia técnico de implementação

A detecção deve ser feita dentro do loop de física no thread de UI (Reanimated).

**Lógica sugerida:**
```typescript
const isGoal = ballX > (screenWidth / 2 - 30) && 
               ballX < (screenWidth / 2 + 30) && 
               ballY <= 0;
```

**Pontos de atenção:**
- A bola deve ser renderizada com Z-index superior ao gol (P6).
- Garantir que a pontuação não seja disparada múltiplas vezes no mesmo atravessamento.

---

## Critérios de Aceite

- [ ] Bola atravessa a área central de 60px no topo sem ricochetear.
- [ ] Incremento de 1 ponto no estado do jogo ao atravessar.
- [ ] Bola reseta para a posição de saque (20% do topo) após o ponto.
- [ ] Testes unitários para a lógica de detecção de bordas vs goal.
- [ ] Code review aprovado.

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
