# TASK-3.1 — Implementar usePaddleControl (Gesture.Pan no UI thread)

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-3 — Física e Controles | **US:** US-3 — Controle analógico do paddle
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-1.1, TASK-1.2
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-2.1, TASK-3.2, TASK-4.1
**Status:** `Pendente`

---

## Contexto

O paddle é controlado por arrasto horizontal no footer. RNF-002 exige latência ≤ 16ms, tornando o `PanResponder` inviável (passa pelo JS bridge). A solução é `Gesture.Pan()` do `react-native-gesture-handler`, que executa no UI thread junto com Reanimated. A posição do paddle é `useSharedValue<number>` (`paddleX`) lido diretamente pelo `useAnimatedStyle` do `Paddle.tsx` — sem passar pelo JS thread. O gesto deve ser desabilitado quando `gameState !== 'PLAYING'` (paddle bloqueado durante overlays — RF-002).

**Referências:**
- PRD: RF-002 — "movimento proporcional ao deslocamento do dedo (analógico)"; "paddle não ultrapassa bordas laterais"; overlay ativo → paddle bloqueado; RNF-002 (latência ≤ 16ms)
- TechSpec: Seção 2.3 (Fluxo RF-002), ADR-002 (RNGH Gesture.Pan), Seção 3.2 (paddleX SharedValue), Seção 3.3 (PADDLE_WIDTH, PADDLE_SENSITIVITY)
- Guidelines: `guidelines/coding-standards.md` — hooks camelCase com prefixo `use`

---

## O que deve ser feito

- [ ] Criar `src/features/game/hooks/usePaddleControl.ts`
- [ ] Criar `paddleX: SharedValue<number>` para a posição central do paddle
- [ ] Implementar `Gesture.Pan()` com `.onChange` no UI thread (`'worklet'`)
- [ ] Aplicar clamp para manter paddle dentro da game area
- [ ] Desabilitar gesto quando `gameState !== 'PLAYING'`
- [ ] Retornar `paddleX`, `panGesture` e `resetPaddle`

---

## Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/hooks/usePaddleControl.ts  — hook do controle do paddle
```

**Padrão a seguir:**

```typescript
// src/features/game/hooks/usePaddleControl.ts
import { Gesture } from 'react-native-gesture-handler'
import { useSharedValue } from 'react-native-reanimated'
import type { GameState } from '../types'
import { PADDLE_SENSITIVITY, PADDLE_WIDTH } from '../constants'

interface UsePaddleControlParams {
  gameAreaWidth: number
  gameState: GameState
}

export function usePaddleControl({ gameAreaWidth, gameState }: UsePaddleControlParams) {
  const paddleX = useSharedValue(gameAreaWidth / 2)

  const minX = PADDLE_WIDTH / 2
  const maxX = gameAreaWidth - PADDLE_WIDTH / 2

  const panGesture = Gesture.Pan()
    .onChange(({ changeX }) => {
      'worklet'
      const next = paddleX.value + changeX * PADDLE_SENSITIVITY
      paddleX.value = Math.max(minX, Math.min(maxX, next))
    })
    .enabled(gameState === 'PLAYING')

  function resetPaddle() {
    paddleX.value = gameAreaWidth / 2
  }

  return { paddleX, panGesture, resetPaddle }
}
```

**Pontos de atenção:**
- Usar `.onChange` com `changeX` (delta por frame) em vez de `.onUpdate` com `translationX` (acumulado) — evita "salto" ao retomar gesto após pausa
- `.enabled(gameState === 'PLAYING')` é avaliado no JS thread; mudanças de `gameState` desabilitam o gesto corretamente com possível delay de 1 frame (aceitável)
- `gameAreaWidth` deve ser o valor da área de jogo (sem header e footer), passado pelo `GameScreen` via `useWindowDimensions`
- O `GestureDetector` com este gesto deve ser aplicado APENAS no footer (não na game area) — isso é feito em TASK-4.5

---

## Critérios de Aceite

- [ ] Arrasto para a direita → `paddleX.value` aumenta proporcionalmente
- [ ] Arrasto para a esquerda → `paddleX.value` diminui proporcionalmente
- [ ] `paddleX.value` nunca sai de `[PADDLE_WIDTH/2, gameAreaWidth - PADDLE_WIDTH/2]`
- [ ] `gameState !== 'PLAYING'` → gesto ignorado, `paddleX.value` não muda
- [ ] `resetPaddle()` define `paddleX.value = gameAreaWidth / 2`
- [ ] Testes TDD: testar a lógica de clamp com valores de entrada e saída esperados (extrair função pura `clampPaddleX` e testá-la)
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
