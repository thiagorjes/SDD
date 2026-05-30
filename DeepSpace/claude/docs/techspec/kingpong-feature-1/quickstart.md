# Quickstart: KingPong — Feature 1: Tela de Jogo

**TechSpec completo:** [docs/techspec/kingpong-feature-1-techspec.md](../kingpong-feature-1-techspec.md)
**Gerado em:** 2026-05-30

> Leia este arquivo antes de começar qualquer task da Feature 1.

---

## Stack

| Camada | Tecnologia | Versão |
|--------|-----------|--------|
| Linguagem | TypeScript | 5.x (strict) |
| Framework | React Native CLI | 0.73+ |
| Animação / Física | react-native-reanimated | 3.x |
| Gestos | react-native-gesture-handler | 2.x |
| Testes E2E | Detox | latest |

---

## Estrutura de Pastas

```
src/
└── features/
    └── game/
        ├── components/
        │   ├── Ball.tsx
        │   ├── GameBoard.tsx
        │   ├── GameOverOverlay.tsx
        │   ├── GoalZone.tsx
        │   ├── HUD.tsx
        │   ├── LaunchOverlay.tsx
        │   └── Paddle.tsx
        ├── hooks/
        │   ├── useGameLoop.ts       ← game loop principal (useFrameCallback)
        │   ├── useGameState.ts      ← useReducer (score, lives, gameState)
        │   └── usePaddleControl.ts  ← Gesture.Pan
        ├── screens/
        │   └── GameScreen.tsx
        ├── constants.ts             ← TODAS as constantes aqui
        └── types.ts
tests/
└── e2e/
    └── gameplay.e2e.ts
```

---

## Setup Mínimo

```bash
# 1. Instalar dependências (além das existentes no projeto)
npm install react-native-reanimated react-native-gesture-handler

# 2. iOS — instalar pods
cd ios && pod install && cd ..

# 3. Adicionar ao babel.config.js (Reanimated 3 obrigatório):
#    plugins: ['react-native-reanimated/plugin']

# 4. Wrapping obrigatório em App.tsx:
#    import { GestureHandlerRootView } from 'react-native-gesture-handler'
#    <GestureHandlerRootView style={{ flex: 1 }}>
#      <GameScreen />
#    </GestureHandlerRootView>

# 5. Portrait-only (fazer antes de qualquer build):
#    Android: android/app/src/main/AndroidManifest.xml
#      screenOrientation="portrait"
#    iOS: Info.plist → UISupportedInterfaceOrientations → apenas UIInterfaceOrientationPortrait

# 6. Rodar em Android
npx react-native run-android

# 7. Rodar em iOS
npx react-native run-ios

# 8. Testes E2E
npx detox test --configuration android.emu.debug
```

---

## Arquitetura em 3 linhas

- **UI thread** (Reanimated worklets): posição da bola, velocidade, colisões, posição do paddle
- **JS thread** (React): score, lives, enum de estado, overlays, HUD
- **Ponte**: `runOnJS` (worklet → React) + `useSharedValue` lido pelo worklet (React → worklet)

---

## Cenários Principais

### RF-001 — Estrutura da Tela

**Dado** que o app é iniciado
**Quando** a GameScreen renderiza
**Então** header ("KingPong" em verde), game area (fundo escuro) e footer (zona de controle) são visíveis e distintos

```typescript
// GameScreen.tsx — proporções via useWindowDimensions
const { height } = useWindowDimensions()
const headerHeight = height * HEADER_HEIGHT_RATIO   // 8%
const footerHeight = height * FOOTER_HEIGHT_RATIO   // 22%
const gameAreaHeight = height - headerHeight - footerHeight  // 70%
```

---

### RF-002 — Controle do Paddle

**Dado** que o jogo está em PLAYING
**Quando** o usuário arrasta horizontalmente no footer
**Então** `paddleX.value` é atualizado no UI thread com clamp nos limites

```typescript
// usePaddleControl.ts
const panGesture = Gesture.Pan()
  .onUpdate(({ translationX }) => {
    'worklet'
    const newX = paddleX.value + translationX * PADDLE_SENSITIVITY
    paddleX.value = clamp(newX, PADDLE_WIDTH / 2, gameAreaWidth - PADDLE_WIDTH / 2)
  })
  .enabled(isGameActive)  // desabilitado em LAUNCHING/GAME_OVER
```

---

### RF-003 — Game Loop

**Dado** que o estado é PLAYING
**Quando** `useFrameCallback` é executado a cada frame
**Então** a bola se move, colisões são detectadas e eventos são disparados via runOnJS

```typescript
// useGameLoop.ts — estrutura do worklet
useFrameCallback(({ timeSincePreviousFrame }) => {
  'worklet'
  if (!isGameActive.value) return
  const dt = (timeSincePreviousFrame ?? 16) / 1000

  // 1. Mover bola
  let nextX = ballX.value + vx.value * dt
  let nextY = ballY.value + vy.value * dt

  // 2. Colisões laterais e superior
  // 3. Colisão com paddle → ângulo baseado em impactRatio
  // 4. Goal zone → runOnJS(onGoalScored)()
  // 5. Borda inferior → runOnJS(onLifeLost)()

  ballX.value = nextX
  ballY.value = nextY
}, true)
```

---

### RF-008 — Overlay de Pre-Launch (cenário de erro)

**Dado** que o estado é LAUNCHING
**Quando** o usuário toca fora do botão de lançamento
**Então** nada acontece (o overlay permanece)

```typescript
// LaunchOverlay.tsx — apenas o botão tem onPress; o overlay container não
<View testID="launch-overlay" style={styles.overlay}>
  <Text>{livesCount} vidas</Text>
  <TouchableOpacity testID="launch-button" onPress={handleLaunch}>
    <Text testID="launch-label">{label}</Text>
  </TouchableOpacity>
</View>
```

---

## Pontos de Atenção

- **Reanimated 3 exige** `react-native-reanimated/plugin` no `babel.config.js` — sem isso, worklets não compilam
- **GestureHandlerRootView** deve envolver o app inteiro no `App.tsx`, não apenas a tela do jogo
- **runOnJS** só pode ser chamado de dentro de um worklet — não use fora de `useFrameCallback` ou `useAnimatedReaction`
- **lifeLostLock**: reset para `false` ao lançar a bola (via `resetBall()` no `useEffect` que observa `gameState === 'PLAYING'`)
- **inGoalZone**: reset para `false` quando a bola sai da goal zone — verificar a transição `inside → outside` no worklet
- **PADDLE_SENSITIVITY = 1.0**: se o paddle parecer lento, aumentar; se impreciso, diminuir. Calibrar na implementação
- **Goal zone Y**: calculada em runtime como `gameAreaHeight / 2 - GOAL_ZONE_HEIGHT / 2` — não hardcoded
- Constantes marcadas com `⚠️ calibrar` em `constants.ts` serão ajustadas durante testes de gameplay

---

## Checklist Antes de Abrir PR

- [ ] `npx tsc --noEmit` — sem erros de tipo
- [ ] `npx eslint src/features/game/` — sem warnings
- [ ] RF-001: três regiões visíveis, header com "KingPong" verde
- [ ] RF-002: paddle se move no footer; bloqueado em overlays; clamp nas bordas
- [ ] RF-003: bola lança, rebota, acelera; não ultrapassa `BALL_SPEED_MAX`
- [ ] RF-004: goal zone detecta passagem; +1 ponto; trajetória não alterada; 1 ponto por travessia
- [ ] RF-005/006: 3 vidas → perda → overlay → 2 vidas → ... → game over → reset completo
- [ ] RF-007: HUD visível em tempo real; visível atrás de overlays
- [ ] RF-008: labels corretos ("iniciar"/"continuar"/"reiniciar"); toque fora do botão = sem ação
- [ ] Detox E2E: `npx detox test --configuration android.emu.debug`
