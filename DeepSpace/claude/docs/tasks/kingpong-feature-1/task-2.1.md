# TASK-2.1 — Implementar useGameState (useReducer com todas as transições)

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-2 — Lógica de Estado de Jogo | **US:** US-2 — Máquina de estados de jogo
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-1.2
**Bloqueia:** TASK-3.1, TASK-4.3, TASK-4.4, TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-3.1, TASK-3.2, TASK-4.1 (após TASK-1.2)
**Status:** `Pendente`

---

## Contexto

O `useGameState` é o coração da lógica de negócio do jogo. Implementa a máquina de estados do PRD (§2.3): `LAUNCHING → PLAYING → LIFE_LOST → LAUNCHING | GAME_OVER`. O estado `launchLabel` (iniciar/continuar/reiniciar) é derivado do contexto de cada transição para `LAUNCHING`. Este hook é chamado pelo `GameScreen` e os valores derivados são passados como props para os overlays e HUD. Todos os eventos de gameplay (gol, vida perdida) chegam a este hook via `runOnJS` — por isso os callbacks devem ser `useCallback` estáveis.

**Referências:**
- PRD: §2.3 (tabela de estados); RF-005 ("vidas ≥ 1 → LAUNCHING, vidas = 0 → GAME_OVER"); RF-006 ("play again → score=0, lives=3"); RF-008 (rótulos: "iniciar", "continuar", "reiniciar"); RN-008, RN-009
- TechSpec: Seção 3.1 (GameStatus, GameAction, tabela de transições completa)
- Guidelines: `guidelines/coding-standards.md` — hooks camelCase com prefixo `use`

---

## O que deve ser feito

- [ ] Criar `src/features/game/hooks/useGameState.ts`
- [ ] Implementar o reducer com todas as transições: `START_PLAY`, `SCORE`, `LIFE_LOST`, `PLAY_AGAIN`
- [ ] Derivar `launchLabel` automaticamente em cada ação que leva a `LAUNCHING`
- [ ] Retornar `gameStatus` e callbacks memoizados com `useCallback`

---

## Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/hooks/useGameState.ts  — hook completo com reducer
```

**Padrão a seguir:**

```typescript
// src/features/game/hooks/useGameState.ts
import { useCallback, useReducer } from 'react'
import type { GameAction, GameStatus } from '../types'

const INITIAL_LIVES = 3

const initialState: GameStatus = {
  gameState: 'LAUNCHING',
  score: 0,
  lives: INITIAL_LIVES,
  launchLabel: 'iniciar',
}

function gameReducer(state: GameStatus, action: GameAction): GameStatus {
  switch (action.type) {
    case 'START_PLAY':
      return { ...state, gameState: 'PLAYING' }

    case 'SCORE':
      return { ...state, score: state.score + 1 }

    case 'LIFE_LOST': {
      const newLives = state.lives - 1
      if (newLives <= 0) {
        return { ...state, lives: 0, gameState: 'GAME_OVER' }
      }
      return { ...state, lives: newLives, gameState: 'LAUNCHING', launchLabel: 'continuar' }
    }

    case 'PLAY_AGAIN':
      return { ...initialState, gameState: 'LAUNCHING', launchLabel: 'reiniciar' }

    default:
      return state
  }
}

export function useGameState() {
  const [gameStatus, dispatch] = useReducer(gameReducer, initialState)

  const onGoalScored = useCallback(() => dispatch({ type: 'SCORE' }), [])
  const onLifeLost = useCallback(() => dispatch({ type: 'LIFE_LOST' }), [])
  const onPlayAgain = useCallback(() => dispatch({ type: 'PLAY_AGAIN' }), [])
  const onStartPlay = useCallback(() => dispatch({ type: 'START_PLAY' }), [])

  return { gameStatus, onGoalScored, onLifeLost, onPlayAgain, onStartPlay }
}
```

**Pontos de atenção:**
- `LIFE_LOST` com `lives = 1` → `lives = 0, gameState = 'GAME_OVER'` (nunca `LAUNCHING`)
- `'LIFE_LOST'` nunca é retornado como `gameState` — é transitório no reducer
- `onGoalScored` e `onLifeLost` serão wrappados com `runOnJS` dentro do `useGameLoop` — devem ser `useCallback` estáveis
- `PLAY_AGAIN` usa `{ ...initialState, ... }` para garantir que score retorna a 0 e lives a 3 (RN-008)
- `launchLabel: 'iniciar'` existe apenas no `initialState` — representa a 1ª abertura do app

---

## Critérios de Aceite

- [ ] Inicialização: `{ gameState: 'LAUNCHING', lives: 3, score: 0, launchLabel: 'iniciar' }`
- [ ] `START_PLAY` → `gameState = 'PLAYING'`
- [ ] `SCORE` → `score + 1`, `gameState` permanece `'PLAYING'`
- [ ] `LIFE_LOST` (lives=3) → `lives=2, gameState='LAUNCHING', launchLabel='continuar'`
- [ ] `LIFE_LOST` (lives=1) → `lives=0, gameState='GAME_OVER'`
- [ ] `PLAY_AGAIN` → `score=0, lives=3, gameState='LAUNCHING', launchLabel='reiniciar'`
- [ ] Testes TDD antes da implementação: testar o reducer puro `gameReducer` com todas as transições e edge cases (lives=2 após LIFE_LOST, lives=0 na última vida, score acumulação, reset total)
- [ ] `npx tsc --noEmit` sem erros
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
