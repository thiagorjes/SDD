# TASK-1.2 — Criar types.ts e constants.ts

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-1 — Infraestrutura e Fundação | **US:** US-1 — Ambiente de desenvolvimento configurado
**Labels:** `frontend`
**Estimativa:** P (até 4h)
**Depende de:** nenhuma
**Bloqueia:** TASK-2.1, TASK-3.1, TASK-3.2, TASK-4.1, TASK-4.2, TASK-4.3, TASK-4.4
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-1.1
**Status:** `Pendente`

---

## Contexto

Todas as tasks de implementação dependem dos tipos TypeScript (`GameState`, `LaunchLabel`, `GameAction`) e das constantes de jogo (`BALL_RADIUS`, `INITIAL_BALL_SPEED`, etc.). Centralizar tudo em dois arquivos garante que qualquer alteração de calibração ou tipagem seja feita em um único lugar. As constantes marcadas com `⚠️ calibrar` terão seus valores ajustados durante testes de gameplay; os valores iniciais definidos aqui são o ponto de partida.

**Referências:**
- TechSpec: Seção 3.1 (GameStatus, GameAction), Seção 3.3 (constantes completas com valores e unidades)
- Guidelines: `guidelines/coding-standards.md` — constantes UPPER_SNAKE_CASE, tipos PascalCase, `strict: true`, sem `any`

---

## O que deve ser feito

- [ ] Criar `src/features/game/types.ts` com `GameState`, `LaunchLabel`, `GameStatus`, `GameAction`
- [ ] Criar `src/features/game/constants.ts` com todas as constantes do TechSpec seção 3.3
- [ ] Garantir que `npx tsc --noEmit` passa sem erros

---

## Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/types.ts      — tipos TypeScript da feature
src/features/game/constants.ts  — constantes UPPER_SNAKE_CASE
```

**Padrão a seguir:**

```typescript
// src/features/game/types.ts
export type GameState = 'LAUNCHING' | 'PLAYING' | 'LIFE_LOST' | 'GAME_OVER'
export type LaunchLabel = 'iniciar' | 'continuar' | 'reiniciar'

export interface GameStatus {
  gameState: GameState
  score: number
  lives: number
  launchLabel: LaunchLabel
}

export type GameAction =
  | { type: 'START_PLAY' }
  | { type: 'SCORE' }
  | { type: 'LIFE_LOST' }
  | { type: 'PLAY_AGAIN' }
```

```typescript
// src/features/game/constants.ts

// Bola
export const BALL_RADIUS = 10
export const BALL_START_Y = 30
export const INITIAL_BALL_SPEED = 20              // px/s
export const BALL_SPEED_INCREMENT_PADDLE = 5      // px/s por rebate ⚠️ calibrar
export const BALL_SPEED_INCREMENT_GOAL = 3        // px/s por ponto ⚠️ calibrar
export const BALL_SPEED_MAX = 500                 // px/s — cap (anti-tunneling: ≤ raio/frame a 60fps)
export const BALL_LAUNCH_ANGLE_MIN = 30           // graus a partir do eixo horizontal positivo
export const BALL_LAUNCH_ANGLE_MAX = 150          // graus
export const BALL_FREEZE_OFFSET = 10              // px abaixo da borda ao congelar

// Paddle
export const PADDLE_WIDTH = 60
export const PADDLE_HEIGHT = 15
export const PADDLE_Y_OFFSET = 20                 // px acima da borda inferior da game area
export const PADDLE_SENSITIVITY = 1.0             // 1:1 drag → movement ⚠️ calibrar

// Ângulos de rebate (graus; converter para rad nos worklets com * Math.PI / 180)
export const BALL_BOUNCE_ANGLE_CENTER = 80        // quase reto para cima ⚠️ calibrar
export const BALL_BOUNCE_ANGLE_EDGE = 20          // rasante nas extremidades ⚠️ calibrar

// Goal Zone
export const GOAL_ZONE_WIDTH = 60
export const GOAL_ZONE_HEIGHT = 20

// Layout (razões relativas à safe area height)
export const HEADER_HEIGHT_RATIO = 0.08
export const FOOTER_HEIGHT_RATIO = 0.22

// Cores
export const COLOR_CRT_GREEN = '#00FF41'
export const COLOR_BG_GAME = '#0A0A0A'
export const COLOR_BG_HEADER = '#1A1A1A'
export const COLOR_BG_FOOTER = '#111111'
export const COLOR_BALL = '#FFFFFF'
export const COLOR_GOAL_ZONE_FILL = 'rgba(0, 255, 65, 0.12)'
export const COLOR_GOAL_ZONE_BORDER = '#00FF41'

// UX
export const LAUNCH_BUTTON_DEBOUNCE_MS = 300
```

**Pontos de atenção:**
- `GameState` inclui `'LIFE_LOST'` mas o reducer nunca persiste este estado — a transição é imediata para `LAUNCHING` ou `GAME_OVER`
- Ângulos estão em graus; conversão para radianos é feita nos worklets: `angle * Math.PI / 180`
- `BALL_SPEED_MAX = 500` garante movimento ≤ 8.3px/frame a 60fps com raio de 10px — anti-tunneling sem swept detection (ADR-004)

---

## Critérios de Aceite

- [ ] `npx tsc --noEmit` sem erros após criar os dois arquivos
- [ ] Todos os tipos exportados e importáveis por outros módulos
- [ ] Todas as constantes do TechSpec seção 3.3 presentes
- [ ] Sem `any` ou `as` nos arquivos criados
- [ ] Code review aprovado seguindo `guidelines/coding-standards.md`

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
