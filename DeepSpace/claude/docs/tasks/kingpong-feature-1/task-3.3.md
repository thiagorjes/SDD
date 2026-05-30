# TASK-3.3 — useGameLoop: colisão com paddle e física de rebate

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-3 — Física e Controles | **US:** US-4 — Física da bolinha
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-3.2
**Bloqueia:** TASK-3.4
**Paralelo `[P]`:** Não — estende o mesmo hook de TASK-3.2
**Status:** `Pendente`

---

## Contexto

Esta task adiciona ao `useGameLoop` a detecção de colisão bola × paddle e o cálculo de ângulo de rebate baseado no ponto de impacto. O ângulo varia linearmente entre `BALL_BOUNCE_ANGLE_CENTER` (80°, quase reto para cima — rebate central) e `BALL_BOUNCE_ANGLE_EDGE` (20°, rasante — rebate nas extremidades). Cada colisão com o paddle incrementa a velocidade. O paddle (`paddleX: SharedValue<number>`) é recebido como parâmetro do hook.

**Referências:**
- PRD: RF-003 — "ao contato com o paddle, rebate para cima com variação angular conforme ponto de impacto: centro → BALL_BOUNCE_ANGLE_CENTER, extremidades → BALL_BOUNCE_ANGLE_EDGE"; "velocidade incrementada em valor fixo após cada rebate"
- TechSpec: Seção 2.3 (Fluxo RF-003 — passo f), Seção 3.3 (BALL_BOUNCE_ANGLE_CENTER=80°, BALL_BOUNCE_ANGLE_EDGE=20°, BALL_SPEED_INCREMENT_PADDLE=5, BALL_SPEED_MAX=500, PADDLE_Y_OFFSET, PADDLE_HEIGHT, PADDLE_WIDTH)
- Guidelines: `guidelines/coding-standards.md`

---

## O que deve ser feito

- [ ] Adicionar `paddleX: SharedValue<number>` como parâmetro do hook `useGameLoop`
- [ ] Declarar `ballSpeed: SharedValue<number>` para rastrear a velocidade escalar atual
- [ ] Dentro do `useFrameCallback`, detectar colisão bola × paddle (hitbox círculo × retângulo)
- [ ] Calcular `impactRatio` (centro da bola em relação ao centro do paddle) no intervalo [-1, +1]
- [ ] Interpolar ângulo entre `BALL_BOUNCE_ANGLE_CENTER` e `BALL_BOUNCE_ANGLE_EDGE`
- [ ] Recalcular `vx` e `vy` com base no ângulo e na nova velocidade
- [ ] Incrementar `ballSpeed` em `BALL_SPEED_INCREMENT_PADDLE` com cap em `BALL_SPEED_MAX`

---

## Guia técnico de implementação

**Adições ao `useFrameCallback` do useGameLoop (após colisões de borda, antes de atualizar ballX/ballY):**

```typescript
import type { SharedValue } from 'react-native-reanimated'
import {
  BALL_BOUNCE_ANGLE_CENTER, BALL_BOUNCE_ANGLE_EDGE,
  BALL_SPEED_INCREMENT_PADDLE, BALL_SPEED_MAX,
  PADDLE_Y_OFFSET, PADDLE_HEIGHT, PADDLE_WIDTH, BALL_RADIUS,
} from '../constants'

// Adicionar ao useGameLoop params:
// paddleX: SharedValue<number>
// onGoalScored e onLifeLost serão adicionados em TASK-3.4

// Declarar junto com outros shared values:
const ballSpeed = useSharedValue(INITIAL_BALL_SPEED)

// --- Dentro do useFrameCallback (após colisões de borda) ---

const paddleTop = gameAreaHeight - PADDLE_Y_OFFSET - PADDLE_HEIGHT
const paddleBottom = gameAreaHeight - PADDLE_Y_OFFSET
const paddleLeft = paddleX.value - PADDLE_WIDTH / 2
const paddleRight = paddleX.value + PADDLE_WIDTH / 2

const ballBottom = nextY + BALL_RADIUS
const ballLeft = nextX - BALL_RADIUS
const ballRight = nextX + BALL_RADIUS

if (
  vy.value > 0 &&                    // bola descendo
  ballBottom >= paddleTop &&         // atingiu o topo do paddle
  ballBottom <= paddleBottom &&      // ainda dentro do paddle (não ultrapassou)
  ballRight >= paddleLeft &&         // sobreposição horizontal
  ballLeft <= paddleRight
) {
  const halfWidth = PADDLE_WIDTH / 2
  const impactRatio = Math.max(-1, Math.min(1, (nextX - paddleX.value) / halfWidth))

  const centerRad = BALL_BOUNCE_ANGLE_CENTER * (Math.PI / 180)
  const edgeRad = BALL_BOUNCE_ANGLE_EDGE * (Math.PI / 180)
  const angle = centerRad + (edgeRad - centerRad) * Math.abs(impactRatio)

  const newSpeed = Math.min(ballSpeed.value + BALL_SPEED_INCREMENT_PADDLE, BALL_SPEED_MAX)
  ballSpeed.value = newSpeed

  const direction = impactRatio >= 0 ? 1 : -1
  vx.value = direction * newSpeed * Math.sin(angle)
  vy.value = -newSpeed * Math.cos(angle)  // negativo = para cima

  nextY = paddleTop - BALL_RADIUS  // evitar re-colisão no próximo frame
}
```

**Pontos de atenção:**
- `vy.value > 0` (bola descendo) evita colisão dupla quando a bola sobe através do paddle
- `nextY = paddleTop - BALL_RADIUS` corrige a posição imediatamente após a colisão — essencial para evitar que a bola fique "presa" no paddle
- Para impacto perfeitamente central (`impactRatio === 0`), `direction = 1` por convenção — a bola vai ligeiramente para a direita
- Os ângulos `BALL_BOUNCE_ANGLE_CENTER = 80°` e `BALL_BOUNCE_ANGLE_EDGE = 20°` estão marcados como ⚠️ calibrar — ajuste durante gameplay

---

## Critérios de Aceite

- [ ] Bola descendo colide com paddle → `vy` inverte para negativo (para cima)
- [ ] Impacto central → ângulo próximo a 80° (quase reto)
- [ ] Impacto na extremidade → ângulo próximo a 20° (rasante)
- [ ] `ballSpeed` incrementa em `BALL_SPEED_INCREMENT_PADDLE` a cada colisão
- [ ] `ballSpeed` nunca ultrapassa `BALL_SPEED_MAX`
- [ ] Bola subindo não dispara colisão com paddle
- [ ] Posição corrigida após colisão (sem re-colisão no próximo frame)
- [ ] Testes TDD: testar cálculo de `impactRatio` e interpolação de ângulo com valores puros
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
