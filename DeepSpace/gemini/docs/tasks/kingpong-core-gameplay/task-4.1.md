# TASK-4.1 — Máquina de Estados (Round Control)

**Feature:** KingPong Core Gameplay
**Documento principal:** [docs/tasks/kingpong-core-gameplay-tasks.md]
**Epic:** EPIC-4 — Game State | **US:** US-5 — Ciclo de Jogo e Vidas
**Labels:** `[logic]` `[frontend]`
**Estimativa:** G
**Depende de:** TASK-2.2
**Bloqueia:** TASK-4.2
**Paralelo `[P]`:** Não
**Status:** `Pendente`

---

## Contexto

Gerenciar os estados PAUSED, PLAYING, LIFE_LOST e GAME_OVER.

**Referências:**
- PRD: [RF-005 — O jogador inicia com 3 vidas. Caso atinja o limite inferior... vida subtraída e pausa] e [P5 — O jogo inicia pausado. Botão Iniciar inicia a rodada]
- TechSpec: [Seção 2.3 — Fluxo: Se impacto no limite inferior -> Subtrai Vida]

---

## O que deve ser feito

- [ ] Implementar enum/tipo para GameStates.
- [ ] Criar lógica de transição entre estados (ex: PLAYING -> LIFE_LOST).
- [ ] Integrar contador de vidas (iniciando em 3).
- [ ] Implementar reset de rodada (bola volta para posição inicial pausada).

---

## Guia técnico de implementação

Usar um estado centralizado (Context API ou Hook customizado) para que os componentes (Ball, Paddle, Modals) reajam ao estado atual.

**Estrutura de arquivos esperada:**
```
src/core/gameState.ts — Definição de tipos e lógica de transição
src/features/Game/hooks/useGameState.ts — Hook para consumo dos componentes
```

**Pontos de atenção:**
- Ao perder uma vida, a bola deve parar e o modal de saque deve reaparecer antes do próximo lançamento (P5).

---

## Critérios de Aceite

- [ ] O jogo inicia no estado PAUSED.
- [ ] Perder a bola remove 1 vida e pausa o jogo.
- [ ] Chegar a 0 vidas ativa o estado GAME_OVER.
- [ ] Testes TDD escritos antes da implementação
- [ ] Sem regressões nos testes existentes
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
