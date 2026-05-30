# TASK-4.2 — Componentes Ball e Paddle (Animated.View)

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-4 — Interface Visual e Integração | **US:** US-6 — Estrutura visual da tela de jogo
**Labels:** `frontend`
**Estimativa:** P (até 4h)
**Depende de:** TASK-1.2
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-4.3, TASK-4.4
**Status:** `Pendente`

---

## Contexto

`Ball.tsx` e `Paddle.tsx` são componentes puramente visuais — `Animated.View` com `useAnimatedStyle` que lê `useSharedValue` diretamente no UI thread. Qualquer mudança em `ballX`, `ballY` ou `paddleX` é refletida visualmente sem passar pelo JS thread e sem re-render React. Estes componentes não têm estado próprio — recebem SharedValues como props e renderizam. `position: 'absolute'` os posiciona dentro do `GameBoard`.

**Referências:**
- PRD: RF-001 (paddle verde); RF-003 (bolinha de raio 10px — cor branca por decisão do TechSpec); RF-002 (paddle 60×15px)
- TechSpec: Seção 2.2 (Ball.tsx, Paddle.tsx como Animated.View com useAnimatedStyle), Seção 3.3 (BALL_RADIUS=10, PADDLE_WIDTH=60, PADDLE_HEIGHT=15, PADDLE_Y_OFFSET=20, COLOR_BALL='#FFFFFF', COLOR_CRT_GREEN)
- Guidelines: `guidelines/coding-standards.md` (PascalCase componentes, interface de props tipada, sem `any`)

---

## O que deve ser feito

- [ ] Criar `src/features/game/components/Ball.tsx` — `Animated.View` circular com `useAnimatedStyle`
- [ ] Criar `src/features/game/components/Paddle.tsx` — `Animated.View` retangular com `useAnimatedStyle`
- [ ] Ambos usam `translateX` e `translateY` (não `left`/`top` em style estático)
- [ ] Adicionar `testID="ball"` e `testID="paddle"`

---

## Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/components/Ball.tsx    — bola animada
src/features/game/components/Paddle.tsx  — paddle animado
```

**Padrão a seguir:**

```tsx
// src/features/game/components/Ball.tsx
import Animated, { useAnimatedStyle } from 'react-native-reanimated'
import type { SharedValue } from 'react-native-reanimated'
import { StyleSheet } from 'react-native'
import { BALL_RADIUS, COLOR_BALL } from '../constants'

interface BallProps {
  x: SharedValue<number>
  y: SharedValue<number>
}

export function Ball({ x, y }: BallProps) {
  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { translateX: x.value - BALL_RADIUS },
      { translateY: y.value - BALL_RADIUS },
    ],
  }))

  return <Animated.View testID="ball" style={[styles.ball, animatedStyle]} />
}

const styles = StyleSheet.create({
  ball: {
    position: 'absolute',
    width: BALL_RADIUS * 2,
    height: BALL_RADIUS * 2,
    borderRadius: BALL_RADIUS,
    backgroundColor: COLOR_BALL,
  },
})
```

```tsx
// src/features/game/components/Paddle.tsx
import Animated, { useAnimatedStyle } from 'react-native-reanimated'
import type { SharedValue } from 'react-native-reanimated'
import { StyleSheet } from 'react-native'
import { PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_Y_OFFSET, COLOR_CRT_GREEN } from '../constants'

interface PaddleProps {
  x: SharedValue<number>
  gameAreaHeight: number
}

export function Paddle({ x, gameAreaHeight }: PaddleProps) {
  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ translateX: x.value - PADDLE_WIDTH / 2 }],
  }))

  return (
    <Animated.View
      testID="paddle"
      style={[
        styles.paddle,
        { top: gameAreaHeight - PADDLE_Y_OFFSET - PADDLE_HEIGHT },
        animatedStyle,
      ]}
    />
  )
}

const styles = StyleSheet.create({
  paddle: {
    position: 'absolute',
    width: PADDLE_WIDTH,
    height: PADDLE_HEIGHT,
    borderRadius: 4,
    backgroundColor: COLOR_CRT_GREEN,
  },
})
```

**Pontos de atenção:**
- `translateX: x.value - BALL_RADIUS` posiciona o LEFT do `Animated.View` de forma que o CENTRO da bola esteja em `x.value` — essencial para corresponder ao hitbox calculado no worklet
- Usar APENAS `transform` para posicionamento animado — nunca `left`/`top` animados, pois impedem atualizações no UI thread
- Ambos usam `position: 'absolute'` — devem ser filhos do `GameBoard` (que tem `overflow: 'hidden'`)
- O `top` do Paddle é calculado estaticamente a partir de `gameAreaHeight` — não muda durante o jogo, então não precisa ser animado

---

## Critérios de Aceite

- [ ] Ball renderiza como círculo branco de diâmetro 20px (`BALL_RADIUS * 2`)
- [ ] Paddle renderiza como retângulo verde (`COLOR_CRT_GREEN`) de 60×15px com bordas arredondadas
- [ ] Mudança em `ballX.value`/`ballY.value` reflete visualmente sem delay perceptível
- [ ] Mudança em `paddleX.value` reflete no paddle visualmente sem delay
- [ ] `testID="ball"` e `testID="paddle"` presentes
- [ ] Sem `any` ou `as` no TypeScript
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
