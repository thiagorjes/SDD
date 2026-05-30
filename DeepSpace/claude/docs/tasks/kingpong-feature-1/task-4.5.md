# TASK-4.5 — GameScreen: orquestração completa de hooks e componentes

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-4 — Interface Visual e Integração | **US:** US-9 — Integração completa da tela de jogo
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-3.4, TASK-3.1, TASK-4.1, TASK-4.2, TASK-4.3, TASK-4.4
**Bloqueia:** TASK-5.1
**Paralelo `[P]`:** Não — aguarda todos os predecessores
**Status:** `Pendente`

---

## Contexto

Transforma o `GameScreen.tsx` (esqueleto de TASK-4.1) na tela funcional completa. Orquestra `useGameState`, `useGameLoop` e `usePaddleControl`, renderiza todos os componentes e overlays, e implementa os efeitos colaterais: `useEffect` observando `gameState` para ativar/pausar o game loop e resetar posições; passagem dos callbacks `onGoalScored`/`onLifeLost` (via `runOnJS` internamente no hook) para o game loop; `GestureDetector` no footer com o `panGesture`.

**Referências:**
- PRD: RF-003 — "bolinha parte da região superior ao toque do botão"; RF-005 — "bolinha reinicia do topo após perda"; RF-006 — "play again → reset completo → LAUNCHING"
- TechSpec: Seção 2.3 (todos os fluxos), Seção 1.1 (separação UI thread/JS thread), Seção 7.3 (otimizações de renderização)
- Guidelines: `guidelines/architecture.md` (lógica em hooks, não em componentes)

---

## O que deve ser feito

- [ ] Substituir o esqueleto do `GameScreen.tsx` pela versão completa
- [ ] Instanciar `useGameState()`, `useGameLoop()`, `usePaddleControl()` e passar os parâmetros corretos
- [ ] Implementar `useEffect` observando `gameStatus.gameState`:
  - `'PLAYING'`: resetar `lifeLostLock`, chamar `resetPaddle()` se `launchLabel === 'reiniciar'`, chamar `launchBall(width)`
  - Outros estados: `isGameActive.value = false`
- [ ] Aplicar `GestureDetector` envolvendo o Footer com `panGesture`
- [ ] Renderizar `Ball`, `Paddle`, `GoalZone`, `HUD` dentro do `GameBoard`
- [ ] Renderizar `LaunchOverlay` condicionalmente (`gameState === 'LAUNCHING'`)
- [ ] Renderizar `GameOverOverlay` condicionalmente (`gameState === 'GAME_OVER'`)

---

## Guia técnico de implementação

**Estrutura de arquivos alterada:**
```
src/features/game/screens/GameScreen.tsx  — versão completa (substitui esqueleto de TASK-4.1)
```

**Padrão a seguir:**

```tsx
// src/features/game/screens/GameScreen.tsx (versão completa)
import { useEffect } from 'react'
import { View, Text, StyleSheet, useWindowDimensions } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import { GestureDetector } from 'react-native-gesture-handler'

import { useGameState } from '../hooks/useGameState'
import { useGameLoop } from '../hooks/useGameLoop'
import { usePaddleControl } from '../hooks/usePaddleControl'

import { Ball } from '../components/Ball'
import { GameBoard } from '../components/GameBoard'
import { GameOverOverlay } from '../components/GameOverOverlay'
import { GoalZone } from '../components/GoalZone'
import { HUD } from '../components/HUD'
import { LaunchOverlay } from '../components/LaunchOverlay'
import { Paddle } from '../components/Paddle'

import {
  HEADER_HEIGHT_RATIO, FOOTER_HEIGHT_RATIO,
  COLOR_BG_HEADER, COLOR_BG_FOOTER, COLOR_CRT_GREEN,
} from '../constants'

export function GameScreen() {
  const { height, width } = useWindowDimensions()
  const insets = useSafeAreaInsets()
  const safeHeight = height - insets.top - insets.bottom

  const headerHeight = Math.round(safeHeight * HEADER_HEIGHT_RATIO)
  const footerHeight = Math.round(safeHeight * FOOTER_HEIGHT_RATIO)
  const gameAreaHeight = safeHeight - headerHeight - footerHeight

  const { gameStatus, onGoalScored, onLifeLost, onPlayAgain, onStartPlay } = useGameState()

  const { ballX, ballY, isGameActive, lifeLostLock, launchBall } = useGameLoop({
    gameAreaWidth: width,
    gameAreaHeight,
    onGoalScored,
    onLifeLost,
  })

  const { paddleX, panGesture, resetPaddle } = usePaddleControl({
    gameAreaWidth: width,
    gameState: gameStatus.gameState,
  })

  useEffect(() => {
    if (gameStatus.gameState === 'PLAYING') {
      lifeLostLock.value = false
      if (gameStatus.launchLabel === 'reiniciar') {
        resetPaddle()
      }
      launchBall(width)
    } else {
      isGameActive.value = false
    }
  }, [gameStatus.gameState]) // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <View style={[styles.container, { paddingTop: insets.top }]}>
      <View style={[styles.header, { height: headerHeight }]}>
        <Text style={styles.title}>KingPong</Text>
      </View>
      <GameBoard width={width} height={gameAreaHeight}>
        <GoalZone gameAreaWidth={width} gameAreaHeight={gameAreaHeight} />
        <HUD score={gameStatus.score} lives={gameStatus.lives} />
        <Ball x={ballX} y={ballY} />
        <Paddle x={paddleX} gameAreaHeight={gameAreaHeight} />
        {gameStatus.gameState === 'LAUNCHING' && (
          <LaunchOverlay
            lives={gameStatus.lives}
            label={gameStatus.launchLabel}
            onLaunch={onStartPlay}
          />
        )}
        {gameStatus.gameState === 'GAME_OVER' && (
          <GameOverOverlay score={gameStatus.score} onPlayAgain={onPlayAgain} />
        )}
      </GameBoard>
      <GestureDetector gesture={panGesture}>
        <View testID="footer" style={[styles.footer, { height: footerHeight }]} />
      </GestureDetector>
    </View>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: { backgroundColor: COLOR_BG_HEADER, justifyContent: 'center', alignItems: 'center' },
  title: { color: COLOR_CRT_GREEN, fontSize: 24, fontWeight: 'bold', letterSpacing: 4 },
  footer: { backgroundColor: COLOR_BG_FOOTER },
})
```

**Pontos de atenção:**
- `GameBoard` deve aceitar `children?: ReactNode` — confirmar que TASK-4.1 implementou isso
- O `useEffect` tem apenas `gameStatus.gameState` como dep — o `eslint-disable` é intencional (funções estáveis via `useCallback`)
- `launchBall(width)` já reseta `ballX`, `ballY`, `vx`, `vy` e ativa `isGameActive` — não duplicar isso no `useEffect`
- `GestureDetector` envolve APENAS o footer — gestos na game area não movem o paddle (RF-002)
- `runOnJS` é chamado DENTRO de `useGameLoop` (nos worklets do `useFrameCallback`) — não há `runOnJS` no `GameScreen`
- Verificar que `useGameLoop` aceita `onGoalScored` e `onLifeLost` como parâmetros (adicionados em TASK-3.4)

---

## Critérios de Aceite

- [ ] App inicia em `LAUNCHING` com `launchLabel = 'iniciar'` e overlay visível
- [ ] Toque em "iniciar" → overlay some, bola lança, paddle responsivo
- [ ] Bola cai → vida decrementada, overlay "continuar" aparece
- [ ] Bola atravessa goal zone → score + 1 no HUD imediatamente
- [ ] Após 3 perdas → `GAME_OVER` com score final exibido
- [ ] Toque em "play again" → score=0, lives=3, overlay "reiniciar", paddle centralizado
- [ ] Paddle bloqueado durante overlays (TASK-3.1 garante via `.enabled(gameState === 'PLAYING')`)
- [ ] HUD visível atrás dos overlays
- [ ] `npx tsc --noEmit` sem erros
- [ ] `npx eslint src/features/game/` sem warnings
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
