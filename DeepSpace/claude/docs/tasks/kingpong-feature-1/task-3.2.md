# TASK-3.2 — useGameLoop: movimento e colisões com bordas

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-3 — Física e Controles | **US:** US-4 — Física da bolinha
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-1.1, TASK-1.2
**Bloqueia:** TASK-3.3
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-2.1, TASK-3.1, TASK-4.1
**Status:** `Pendente`

---

## Contexto

Esta task cria o núcleo do game loop: `useFrameCallback` do Reanimated 3, executado a cada frame no UI thread (~60fps) sem bloquear o JS thread. A física usa delta time (`timeSincePreviousFrame`) para ser independente do frame rate. A bola se move e rebate nas bordas laterais e superior. Colisão com paddle, goal zone e borda inferior são implementadas nas TASK-3.3 e TASK-3.4, que estendem este mesmo hook. Toda a lógica é em worklets — nenhum `runOnJS` nesta task.

**Referências:**
- PRD: RF-003 — "rebate ao contato com bordas lateral e superior"; "colisão de canto → ambos os componentes invertidos"; ângulo inicial sorteado em [30°, 150°]; velocidade inicial `INITIAL_BALL_SPEED = 20 px/s`
- TechSpec: Seção 2.3 (Fluxo RF-003), Seção 3.2 (SharedValues: ballX, ballY, vx, vy, isGameActive), Seção 7.2 (useFrameCallback pattern com dt)
- Guidelines: `guidelines/coding-standards.md`

---

## O que deve ser feito

- [ ] Criar `src/features/game/hooks/useGameLoop.ts`
- [ ] Declarar SharedValues: `ballX`, `ballY`, `vx`, `vy`, `isGameActive`
- [ ] Implementar `useFrameCallback` com dt-based physics
- [ ] Implementar colisão com borda lateral esquerda e direita (inverter `vx`, corrigir posição)
- [ ] Implementar colisão com borda superior (inverter `vy`, corrigir posição)
- [ ] Implementar colisão de canto (lateral + superior no mesmo frame)
- [ ] Implementar `launchBall(gameAreaWidth)` — sorteia ângulo [30°,150°], define vx/vy, ativa loop

---

## Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/hooks/useGameLoop.ts  — game loop (criado aqui, expandido em 3.3 e 3.4)
```

**Padrão a seguir:**

```typescript
// src/features/game/hooks/useGameLoop.ts (versão desta task)
import { useSharedValue, useFrameCallback } from 'react-native-reanimated'
import {
  BALL_RADIUS, BALL_START_Y, INITIAL_BALL_SPEED,
  BALL_LAUNCH_ANGLE_MIN, BALL_LAUNCH_ANGLE_MAX,
} from '../constants'

interface UseGameLoopParams {
  gameAreaWidth: number
  gameAreaHeight: number
}

export function useGameLoop({ gameAreaWidth, gameAreaHeight }: UseGameLoopParams) {
  const ballX = useSharedValue(gameAreaWidth / 2)
  const ballY = useSharedValue(BALL_START_Y)
  const vx = useSharedValue(0)
  const vy = useSharedValue(0)
  const isGameActive = useSharedValue(false)

  useFrameCallback(({ timeSincePreviousFrame }) => {
    'worklet'
    if (!isGameActive.value) return

    const dt = (timeSincePreviousFrame ?? 16) / 1000

    let nextX = ballX.value + vx.value * dt
    let nextY = ballY.value + vy.value * dt

    // Borda lateral esquerda
    if (nextX - BALL_RADIUS <= 0) {
      vx.value = Math.abs(vx.value)
      nextX = BALL_RADIUS
    }
    // Borda lateral direita
    if (nextX + BALL_RADIUS >= gameAreaWidth) {
      vx.value = -Math.abs(vx.value)
      nextX = gameAreaWidth - BALL_RADIUS
    }
    // Borda superior
    if (nextY - BALL_RADIUS <= 0) {
      vy.value = Math.abs(vy.value)
      nextY = BALL_RADIUS
    }

    ballX.value = nextX
    ballY.value = nextY
  }, true)

  function launchBall(areaWidth: number) {
    const minRad = BALL_LAUNCH_ANGLE_MIN * (Math.PI / 180)
    const maxRad = BALL_LAUNCH_ANGLE_MAX * (Math.PI / 180)
    const angle = minRad + Math.random() * (maxRad - minRad)
    vx.value = INITIAL_BALL_SPEED * Math.cos(angle)
    vy.value = INITIAL_BALL_SPEED * Math.sin(angle)  // positivo = para baixo
    ballX.value = areaWidth / 2
    ballY.value = BALL_START_Y
    isGameActive.value = true
  }

  return { ballX, ballY, isGameActive, launchBall }
}
```

**Pontos de atenção:**
- `timeSincePreviousFrame` pode ser `null` no primeiro frame — use `?? 16` como fallback
- As correções de posição (`nextX = BALL_RADIUS` etc.) evitam que a bola fique presa na borda
- A colisão de canto (lateral + superior) é tratada pelos dois `if` independentes — ambos executam no mesmo frame
- `isGameActive.value = false` pausa o loop sem desmontar o callback — mais eficiente que recriar o `useFrameCallback`
- Ângulo [30°, 150°]: `sin(30°)=0.5 > 0` e `sin(150°)=0.5 > 0` — sempre descendente (vy > 0)

---

## Critérios de Aceite

- [ ] `launchBall` inicia a bola em `(gameAreaWidth/2, BALL_START_Y)` com velocidade `INITIAL_BALL_SPEED`
- [ ] Ângulo sorteado sempre produz `vy > 0` (direção descendente)
- [ ] Bola rebate borda esquerda: `vx` torna-se positivo
- [ ] Bola rebate borda direita: `vx` torna-se negativo
- [ ] Bola rebate borda superior: `vy` torna-se positivo
- [ ] Colisão de canto: ambos `vx` e `vy` invertidos no mesmo frame
- [ ] `isGameActive.value = false` pausa o movimento completamente
- [ ] Testes TDD: extrair e testar funções puras de reflexão (`reflectAtLeft`, `reflectAtRight`, `reflectAtTop`) com casos de borda (bola exatamente na borda, bola além da borda)
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
