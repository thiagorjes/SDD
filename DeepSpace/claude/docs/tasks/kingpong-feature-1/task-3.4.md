# TASK-3.4 — useGameLoop: detecção goal zone, borda inferior e callbacks runOnJS

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-3 — Física e Controles | **US:** US-5 — Goal zone e vida perdida
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-3.3
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Não — estende o mesmo hook de TASK-3.3
**Status:** `Pendente`

---

## Contexto

Última adição ao `useGameLoop`. Implementa dois mecanismos de detecção no worklet com `runOnJS` para notificar o React state: (1) interseção bola × goal zone — ponto marcado exatamente 1× por travessia via flag `inGoalZone`; (2) bola ultrapassando a borda inferior — vida perdida com debounce via `lifeLostLock`. São os únicos dois pontos de comunicação entre UI thread e JS thread no game loop. Os callbacks `onGoalScored` e `onLifeLost` são os retornados por `useGameState` (TASK-2.1).

**Referências:**
- PRD: RF-004 — "ponto quando qualquer parte do hitbox intersecciona a goal zone"; "apenas 1× por travessia (entrada→saída)"; "trajetória não alterada"; RF-003 — "bola cruza borda inferior → congela 10px abaixo da borda"; RF-005 — "múltiplos eventos no mesmo frame → apenas 1 vida decrementada"
- TechSpec: Seção 2.3 (Fluxos RF-003 passos g/h, RF-004, RF-005/006), Seção 3.2 (inGoalZone, lifeLostLock SharedValues), Seção 3.3 (GOAL_ZONE_WIDTH=60, GOAL_ZONE_HEIGHT=20, BALL_FREEZE_OFFSET=10, BALL_SPEED_INCREMENT_GOAL=3)
- Guidelines: `guidelines/coding-standards.md`

---

## O que deve ser feito

- [ ] Adicionar parâmetros `onGoalScored: () => void` e `onLifeLost: () => void` ao hook
- [ ] Declarar SharedValues: `inGoalZone`, `lifeLostLock`
- [ ] Calcular posição da goal zone (centralizada na game area) como constantes closured
- [ ] Detectar interseção bola × goal zone com flag `inGoalZone`
- [ ] Detectar bola ultrapassando borda inferior com `lifeLostLock`
- [ ] Usar `runOnJS` para os dois callbacks
- [ ] Exportar `inGoalZone`, `lifeLostLock` e função `resetBallState`

---

## Guia técnico de implementação

**Adições ao useGameLoop (após colisão com paddle, antes de atualizar ballX/ballY):**

```typescript
import { runOnJS } from 'react-native-reanimated'
import { GOAL_ZONE_WIDTH, GOAL_ZONE_HEIGHT, BALL_FREEZE_OFFSET, BALL_SPEED_INCREMENT_GOAL } from '../constants'

// Adicionar ao useGameLoop params:
// onGoalScored: () => void
// onLifeLost: () => void

// Declarar SharedValues adicionais:
const inGoalZone = useSharedValue(false)
const lifeLostLock = useSharedValue(false)

// Calcular posição da goal zone UMA VEZ (closured — valores fixos para o jogo):
const goalLeft = gameAreaWidth / 2 - GOAL_ZONE_WIDTH / 2
const goalRight = gameAreaWidth / 2 + GOAL_ZONE_WIDTH / 2
const goalTop = gameAreaHeight / 2 - GOAL_ZONE_HEIGHT / 2
const goalBottom = gameAreaHeight / 2 + GOAL_ZONE_HEIGHT / 2

// --- Dentro do useFrameCallback (após paddle collision, antes de atualizar ballX/ballY) ---

// Goal zone detection
const ballInGoal =
  nextX + BALL_RADIUS > goalLeft &&
  nextX - BALL_RADIUS < goalRight &&
  nextY + BALL_RADIUS > goalTop &&
  nextY - BALL_RADIUS < goalBottom

if (ballInGoal && !inGoalZone.value) {
  inGoalZone.value = true
  ballSpeed.value = Math.min(ballSpeed.value + BALL_SPEED_INCREMENT_GOAL, BALL_SPEED_MAX)
  runOnJS(onGoalScored)()
}
if (!ballInGoal) {
  inGoalZone.value = false
}

// Borda inferior
if (nextY + BALL_RADIUS >= gameAreaHeight) {
  if (!lifeLostLock.value) {
    lifeLostLock.value = true
    isGameActive.value = false
    ballY.value = gameAreaHeight + BALL_FREEZE_OFFSET
    runOnJS(onLifeLost)()
  }
  return  // não atualizar ballX/ballY normalmente
}

// Atualizar posições (somente se não houve perda de vida)
ballX.value = nextX
ballY.value = nextY
```

**`resetBallState` (adicionar ao retorno do hook):**

```typescript
function resetBallState(areaWidth: number) {
  lifeLostLock.value = false
  inGoalZone.value = false
  ballSpeed.value = INITIAL_BALL_SPEED
  // launchBall define ballX, ballY, vx, vy e ativa isGameActive
}
```

**Pontos de atenção:**
- `runOnJS(onGoalScored)()` — a dupla chamada `()()` é necessária: `runOnJS(fn)` retorna um wrapper, e o segundo `()` o executa
- `runOnJS` só pode ser chamado de dentro de worklets — ✓ estamos dentro de `useFrameCallback`
- `goalLeft`, `goalRight`, `goalTop`, `goalBottom` devem ser calculados FORA do `useFrameCallback` (são constantes por jogo, não por frame) e closured no worklet — reduz trabalho por frame
- `lifeLostLock.value` deve ser resetado em `launchBall` antes de cada nova jogada
- A bola não altera trajetória ao passar pela goal zone (RF-004: pass-through) — nenhuma inversão de velocidade

---

## Critérios de Aceite

- [ ] Bola entra na goal zone → `onGoalScored` chamado 1× (transição `inGoalZone: false → true`)
- [ ] Bola permanece na goal zone por N frames → `onGoalScored` chamado 1× no total
- [ ] Bola sai e re-entra na goal zone → `onGoalScored` chamado novamente (1×)
- [ ] Trajetória NÃO alterada ao passar pela goal zone
- [ ] Bola atinge borda inferior → `onLifeLost` chamado 1×; bola congela em `gameAreaHeight + BALL_FREEZE_OFFSET`
- [ ] `lifeLostLock` previne múltiplas chamadas a `onLifeLost` no mesmo evento
- [ ] `ballSpeed` incrementa em `BALL_SPEED_INCREMENT_GOAL` ao marcar ponto (com cap)
- [ ] Testes TDD: testar lógica de interseção AABB (bola vs goal zone rect) com valores numéricos — bola completamente dentro, parcialmente sobreposta, completamente fora
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
