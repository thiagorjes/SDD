# Data Model: KingPong — Feature 1: Tela de Jogo

**TechSpec:** [docs/techspec/kingpong-feature-1-techspec.md — Seção 3](../kingpong-feature-1-techspec.md#3-modelagem-de-dados)
**Gerado em:** 2026-05-30

> Feature sem persistência — toda modelagem é in-memory. Não há migrations ou banco de dados.

---

## Estado React (JS Thread)

Gerenciado via `useReducer` no `GameScreen.tsx`.

```typescript
// src/features/game/types.ts

type GameState = 'LAUNCHING' | 'PLAYING' | 'LIFE_LOST' | 'GAME_OVER'
type LaunchLabel = 'iniciar' | 'continuar' | 'reiniciar'

interface GameStatus {
  gameState: GameState
  score: number          // sem limite superior (RN-003)
  lives: number          // 0–3 (RN-001)
  launchLabel: LaunchLabel
}

type GameAction =
  | { type: 'START_PLAY' }
  | { type: 'SCORE' }
  | { type: 'LIFE_LOST' }
  | { type: 'PLAY_AGAIN' }
```

---

## Ciclo de Vida de Estados

### GameState

```
LAUNCHING → PLAYING → LIFE_LOST* → LAUNCHING   (lives ≥ 1)
                                  → GAME_OVER   (lives = 0)
GAME_OVER → LAUNCHING ("reiniciar")
```

> *`LIFE_LOST` é transitório — o reducer nunca persiste este estado; a transição para `LAUNCHING` ou `GAME_OVER` ocorre na mesma dispatch.

| Estado | Transições permitidas | Condição / Evento |
|--------|----------------------|-------------------|
| `LAUNCHING` | → `PLAYING` | Toque no botão de lançamento (action: `START_PLAY`) |
| `PLAYING` | → `LAUNCHING` (lives ≥ 1) | Bola cruza borda inferior (action: `LIFE_LOST`) |
| `PLAYING` | → `GAME_OVER` (lives = 1) | Bola cruza borda inferior — última vida (action: `LIFE_LOST`) |
| `PLAYING` | score + 1 | Bola atravessa goal zone (action: `SCORE`) |
| `GAME_OVER` | → `LAUNCHING` | Toque em "play again" (action: `PLAY_AGAIN`) |

**Invariantes:**
- `lives` nunca é decrementado além de 0
- `score` nunca é decrementado (apenas resetado para 0 em `PLAY_AGAIN`)
- `launchLabel` é sempre determinado pelo contexto: 'iniciar' (primeiro `LAUNCHING` da sessão), 'continuar' (após `LIFE_LOST`), 'reiniciar' (após `PLAY_AGAIN`)

---

## Estado de Física (UI Thread — Reanimated SharedValues)

Gerenciado via `useSharedValue` dentro de `useGameLoop.ts` e `usePaddleControl.ts`.

| SharedValue | Tipo | Valor inicial | Descrição |
|-------------|------|---------------|-----------|
| `ballX` | `number` | `gameAreaWidth / 2` | Centro X da bola (px) |
| `ballY` | `number` | `BALL_START_Y` | Centro Y da bola (px a partir do topo da game area) |
| `vx` | `number` | calculado no launch | Velocidade horizontal (px/s; + = direita) |
| `vy` | `number` | calculado no launch | Velocidade vertical (px/s; + = baixo) |
| `paddleX` | `number` | `gameAreaWidth / 2` | Centro X do paddle (px) |
| `isGameActive` | `boolean` | `false` | Liga/desliga o `useFrameCallback` |
| `inGoalZone` | `boolean` | `false` | Flag de travessia — previne múltiplas pontuações por passagem |
| `lifeLostLock` | `boolean` | `false` | Debounce — previne duplo decremento de vida no mesmo frame |

---

## Constantes de Jogo

**Arquivo:** `src/features/game/constants.ts`

| Constante | Valor | Unidade | Observação |
|-----------|-------|---------|-----------|
| `BALL_RADIUS` | 10 | px | — |
| `BALL_START_Y` | 30 | px | A partir do topo da game area |
| `INITIAL_BALL_SPEED` | 20 | px/s | Definido no PRD |
| `BALL_SPEED_INCREMENT_PADDLE` | 5 | px/s | ⚠️ calibrar durante implementação |
| `BALL_SPEED_INCREMENT_GOAL` | 3 | px/s | ⚠️ calibrar durante implementação |
| `BALL_SPEED_MAX` | 500 | px/s | Cap; garante ≤ 8.3 px/frame a 60fps (anti-tunneling) |
| `BALL_LAUNCH_ANGLE_MIN` | 30 | graus | Eixo horizontal positivo = 0°, sentido descendente |
| `BALL_LAUNCH_ANGLE_MAX` | 150 | graus | — |
| `BALL_FREEZE_OFFSET` | 10 | px | Abaixo da borda inferior ao congelar |
| `PADDLE_WIDTH` | 60 | px | Definido no PRD (RN-007) |
| `PADDLE_HEIGHT` | 15 | px | Decisão visual do TechSpec |
| `PADDLE_Y_OFFSET` | 20 | px | Acima da borda inferior da game area |
| `PADDLE_SENSITIVITY` | 1.0 | — | 1:1 drag → movement; ⚠️ calibrar |
| `BALL_BOUNCE_ANGLE_CENTER` | 80 | graus | Rebate central (quase reto para cima) |
| `BALL_BOUNCE_ANGLE_EDGE` | 20 | graus | Rebate nas extremidades (rasante); ⚠️ calibrar |
| `GOAL_ZONE_WIDTH` | 60 | px | Definido no PRD |
| `GOAL_ZONE_HEIGHT` | 20 | px | = diâmetro da bola (zona precisa, interseção parcial conta) |
| `HEADER_HEIGHT_RATIO` | 0.08 | razão | 8% da safe area height |
| `FOOTER_HEIGHT_RATIO` | 0.22 | razão | 22% da safe area height |
| `LAUNCH_BUTTON_DEBOUNCE_MS` | 300 | ms | — |

---

## Estratégia de Migrations

Não aplicável — sem banco de dados nesta feature. SQLite será utilizado em features futuras (ranking, configurações do jogador).
