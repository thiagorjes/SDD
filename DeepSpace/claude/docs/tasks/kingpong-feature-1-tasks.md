# Tasks: KingPong — Feature 1: Tela de Jogo

**Versão:** 1.0
**Data:** 2026-05-30
**Autor:** Thiago Cavalcante
**PRD:** docs/prd/kingpong-feature-1-prd.md
**TechSpec:** docs/techspec/kingpong-feature-1-techspec.md
**Sprint/Milestone:** Sem restrição — Feature 1 completa

---

## Resumo de Escopo

| Métrica | Quantidade |
|---------|-----------|
| Epics | 5 |
| User Stories | 10 |
| Tasks | 14 |
| Estimativa total | ~10–14 dias solo |

---

## Cobertura RF × Tasks

| RF | US | Tasks |
|----|----|----|
| RF-001 Estrutura visual | US-6 | TASK-4.1, TASK-4.2 |
| RF-002 Paddle | US-3 | TASK-3.1 |
| RF-003 Física da bolinha | US-4 | TASK-3.2, TASK-3.3 |
| RF-004 Goal zone | US-5, US-7 | TASK-3.4, TASK-4.3 |
| RF-005 Vidas | US-2, US-5 | TASK-2.1, TASK-3.4 |
| RF-006 Game over | US-2, US-8 | TASK-2.1, TASK-4.4 |
| RF-007 HUD | US-7 | TASK-4.3 |
| RF-008 Overlay pre-launch | US-2, US-8 | TASK-2.1, TASK-4.4 |

---

## Épicos

| ID | Nome | Descrição | US relacionadas |
|----|------|-----------|-----------------|
| EPIC-1 | Infraestrutura e Fundação | Configuração de dependências, types e constants | US-1 |
| EPIC-2 | Lógica de Estado de Jogo | Máquina de estados com useReducer | US-2 |
| EPIC-3 | Física e Controles | Game loop, colisões, controle do paddle | US-3, US-4, US-5 |
| EPIC-4 | Interface Visual e Integração | Componentes, overlays e orquestração | US-6, US-7, US-8, US-9 |
| EPIC-5 | Qualidade e Testes E2E | Cobertura Detox de 90% dos fluxos críticos | US-10 |

---

## [EPIC-1] — Infraestrutura e Fundação

---

### US-1: Ambiente de desenvolvimento configurado

**Como** desenvolvedor,
**quero** o projeto configurado com Reanimated 3 e react-native-gesture-handler, portrait-only e estrutura de arquivos inicial,
**para** implementar a física do jogo com desempenho adequado (60 FPS, latência ≤ 16ms).

**RF relacionado:** Pré-requisito para todos os RFs
**Critério de aceite de alto nível:** App roda em Android e iOS com Reanimated e RNGH funcionais; orientação fixada em portrait.

---

#### TASK-1.1 ✅ Concluída (2026-05-30) — Instalar e configurar Reanimated 3, RNGH e portrait-only

**Epic:** EPIC-1 | **US:** US-1
**Labels:** `infra`
**Estimativa:** P (até 4h)
**Depende de:** nenhuma
**Bloqueia:** TASK-2.1, TASK-3.1, TASK-3.2, TASK-4.1, TASK-4.2
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-1.2

##### Contexto

Esta task instala e configura as duas dependências centrais de toda a feature: `react-native-reanimated` (game loop no UI thread via `useFrameCallback`) e `react-native-gesture-handler` (controle do paddle com latência ≤ 16ms). Sem estas bibliotecas instaladas e configuradas corretamente, nenhuma outra task de física ou controle pode avançar. A orientação portrait-only também é configurada aqui via manifesto nativo.

**Referências:**
- PRD: Restrições — "Stack tecnológica fixada: React Native CLI com TypeScript, sem Expo"; "Orientação fixada em portrait-only"
- TechSpec: Seção 1.3 (Stack), ADR-001 (Reanimated 3), ADR-002 (RNGH), ADR-004 (portrait)
- Guidelines: `guidelines/stack.md` — React Native CLI 0.73+

##### O que deve ser feito

- [ ] Instalar `react-native-reanimated@3.x` e `react-native-gesture-handler@2.x` via npm
- [ ] Adicionar `react-native-reanimated/plugin` ao `babel.config.js` (obrigatório para worklets)
- [ ] Envolver o app em `GestureHandlerRootView` no `App.tsx`
- [ ] Configurar portrait-only no `AndroidManifest.xml`
- [ ] Configurar portrait-only no `Info.plist` (iOS)
- [ ] Instalar pods do iOS: `cd ios && pod install`
- [ ] Verificar que o app builda sem erros em Android e iOS

##### Guia técnico de implementação

**Estrutura de arquivos alterados/criados:**
```
babel.config.js          — adicionar plugin do Reanimated
App.tsx                  — envolver com GestureHandlerRootView
android/app/src/main/AndroidManifest.xml  — screenOrientation="portrait"
ios/[NomeProjeto]/Info.plist              — UISupportedInterfaceOrientations
```

**Padrão a seguir:**

```bash
npm install react-native-reanimated react-native-gesture-handler
cd ios && pod install && cd ..
```

```javascript
// babel.config.js
module.exports = {
  presets: ['module:@react-native/babel-preset'],
  plugins: ['react-native-reanimated/plugin'],  // DEVE ser o último plugin
}
```

```tsx
// App.tsx
import { GestureHandlerRootView } from 'react-native-gesture-handler'
import { GameScreen } from './src/features/game/screens/GameScreen'

export default function App() {
  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <GameScreen />
    </GestureHandlerRootView>
  )
}
```

```xml
<!-- AndroidManifest.xml — no elemento <activity> -->
android:screenOrientation="portrait"
```

```xml
<!-- Info.plist -->
<key>UISupportedInterfaceOrientations</key>
<array>
  <string>UIInterfaceOrientationPortrait</string>
</array>
```

**Pontos de atenção:**
- O plugin do Reanimated no `babel.config.js` DEVE ser o último da lista de plugins; caso contrário, worklets não compilam
- `GestureHandlerRootView` deve envolver TODO o app, não apenas a tela do jogo
- Após alterar `babel.config.js`, limpar cache: `npx react-native start --reset-cache`

##### Critérios de Aceite

- [ ] `npx react-native run-android` e `run-ios` completam sem erros de build
- [ ] App não trava ao girar o dispositivo (permanece em portrait)
- [ ] Import de `useSharedValue` de `react-native-reanimated` funciona sem erro
- [ ] Import de `GestureDetector` de `react-native-gesture-handler` funciona sem erro
- [ ] Sem regressões nos testes existentes
- [ ] Code review aprovado seguindo `guidelines/coding-standards.md`

---

#### TASK-1.2 — Criar types.ts e constants.ts

**Epic:** EPIC-1 | **US:** US-1
**Labels:** `frontend`
**Estimativa:** P (até 4h)
**Depende de:** nenhuma
**Bloqueia:** TASK-2.1, TASK-3.1, TASK-3.2, TASK-4.1, TASK-4.2, TASK-4.3, TASK-4.4
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-1.1

##### Contexto

Todas as tasks de implementação dependem dos tipos TypeScript (`GameState`, `LaunchLabel`, `GameAction`) e das constantes de jogo (`BALL_RADIUS`, `INITIAL_BALL_SPEED`, etc.). Centralizar tudo em dois arquivos — `types.ts` para os tipos e `constants.ts` para as constantes — garante que qualquer alteração de calibração ou tipagem seja feita em um único lugar. As constantes marcadas com `⚠️ calibrar` terão seus valores ajustados durante testes de gameplay; os valores iniciais definidos aqui são o ponto de partida.

**Referências:**
- TechSpec: Seção 3.1 (tipos React), Seção 3.2 (SharedValues documentados), Seção 3.3 (constantes completas)
- Guidelines: `guidelines/coding-standards.md` — constantes em UPPER_SNAKE_CASE, tipos em PascalCase, `strict: true`

##### O que deve ser feito

- [ ] Criar `src/features/game/types.ts` com `GameState`, `LaunchLabel`, `GameStatus`, `GameAction`
- [ ] Criar `src/features/game/constants.ts` com todas as constantes do TechSpec seção 3.3
- [ ] Garantir que todos os tipos estão corretos com `tsc --noEmit`

##### Guia técnico de implementação

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
export const BALL_SPEED_MAX = 500                 // px/s — cap
export const BALL_LAUNCH_ANGLE_MIN = 30           // graus
export const BALL_LAUNCH_ANGLE_MAX = 150          // graus
export const BALL_FREEZE_OFFSET = 10              // px abaixo da borda ao congelar

// Paddle
export const PADDLE_WIDTH = 60
export const PADDLE_HEIGHT = 15
export const PADDLE_Y_OFFSET = 20                 // px acima da borda inferior da game area
export const PADDLE_SENSITIVITY = 1.0             // ⚠️ calibrar

// Ângulos de rebate (graus)
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
- Todos os ângulos em `constants.ts` estão em graus; a conversão para radianos (`angle * Math.PI / 180`) é feita nos worklets onde necessário
- `BALL_SPEED_MAX = 500 px/s` é calculado para garantir que a bola nunca mova mais que seu raio por frame a 60fps (anti-tunneling — ADR-004)

##### Critérios de Aceite

- [ ] `npx tsc --noEmit` sem erros após criar os arquivos
- [ ] Todos os tipos exportados e importáveis por outros módulos
- [ ] Todas as constantes do TechSpec seção 3.3 presentes
- [ ] Sem uso de `any` ou `as` nos arquivos criados
- [ ] Code review aprovado seguindo `guidelines/coding-standards.md`

---

## [EPIC-2] — Lógica de Estado de Jogo

---

### US-2: Máquina de estados de jogo

**Como** jogador,
**quero** que o jogo gerencie corretamente meus estados (lançamento, jogo, perda de vida, game over),
**para** ter uma sessão coerente — saber quando posso jogar, quando perdi uma vida e quando o jogo terminou.

**RF relacionado:** RF-005 (vidas), RF-006 (game over), RF-008 (overlay pre-launch)
**Critério de aceite de alto nível:** Todas as transições de estado ocorrem corretamente; `launchLabel` exibe o texto certo em cada contexto.

---

#### TASK-2.1 — Implementar useGameState (useReducer com todas as transições)

**Epic:** EPIC-2 | **US:** US-2
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-1.2
**Bloqueia:** TASK-3.1, TASK-4.3, TASK-4.4, TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-3.1, TASK-3.2, TASK-4.1 (após TASK-1.2)

##### Contexto

O `useGameState` é o coração da lógica de negócio do jogo. Ele implementa a máquina de estados descrita no PRD (§2.3): `LAUNCHING → PLAYING → LIFE_LOST → LAUNCHING | GAME_OVER`. O estado `launchLabel` (iniciar/continuar/reiniciar) é derivado do contexto de cada transição para `LAUNCHING`. Este hook é chamado pelo `GameScreen` e os valores derivados são passados como props para os overlays e HUD. Todos os eventos de gameplay (gol, vida perdida) que ocorrem no UI thread chegam até este hook via `runOnJS` — por isso a API deve ser estável e os callbacks memoizados com `useCallback`.

**Referências:**
- PRD: §2.3 (tabela de estados); RF-005 (critério "vidas ≥ 1 → LAUNCHING, vidas = 0 → GAME_OVER"); RF-006 ("play again → score=0, lives=3, velocidade=base, paddle=centro"); RF-008 (rótulos: "iniciar", "continuar", "reiniciar")
- TechSpec: Seção 3.1 (GameStatus, GameAction, tabela de transições)
- Guidelines: `guidelines/coding-standards.md` — hooks em camelCase com prefixo `use`

##### O que deve ser feito

- [ ] Criar `src/features/game/hooks/useGameState.ts`
- [ ] Implementar o reducer com todas as transições: `START_PLAY`, `SCORE`, `LIFE_LOST`, `PLAY_AGAIN`
- [ ] Derivar `launchLabel` automaticamente em cada ação que leva a `LAUNCHING`
- [ ] Retornar `gameStatus` e `dispatch` como interface pública do hook
- [ ] Envolver `dispatch` em callbacks memoizados com `useCallback` para uso como `runOnJS` targets

##### Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/hooks/useGameState.ts  — hook completo com reducer
```

**Padrão a seguir:**

```typescript
// src/features/game/hooks/useGameState.ts
import { useCallback, useReducer } from 'react'
import type { GameAction, GameStatus, LaunchLabel } from '../types'

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
      return {
        ...state,
        lives: newLives,
        gameState: 'LAUNCHING',
        launchLabel: 'continuar',
      }
    }

    case 'PLAY_AGAIN':
      return {
        ...initialState,
        gameState: 'LAUNCHING',
        launchLabel: 'reiniciar',
      }

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
- `LIFE_LOST` com `lives = 1` deve produzir `gameState = 'GAME_OVER'` e `lives = 0` — não `LAUNCHING`
- O estado `'LIFE_LOST'` é transitório: o reducer nunca retorna `gameState: 'LIFE_LOST'` diretamente (vai para LAUNCHING ou GAME_OVER na mesma dispatch)
- `onGoalScored` e `onLifeLost` são passados para o game loop como `runOnJS` targets — DEVEM ser `useCallback` para evitar recriação e memoização incorreta pelo Reanimated
- `PLAY_AGAIN` reseta score → 0 e lives → 3 (RN-008), e define `launchLabel: 'reiniciar'` (RN-009)
- O `launchLabel: 'iniciar'` é definido apenas no `initialState` — é o estado da primeira abertura do app

##### Critérios de Aceite

- [ ] Dado START_PLAY em LAUNCHING → gameState = 'PLAYING'
- [ ] Dado SCORE em PLAYING → score incrementado em 1, gameState permanece PLAYING
- [ ] Dado LIFE_LOST com lives = 3 → lives = 2, gameState = 'LAUNCHING', launchLabel = 'continuar'
- [ ] Dado LIFE_LOST com lives = 1 → lives = 0, gameState = 'GAME_OVER'
- [ ] Dado PLAY_AGAIN em GAME_OVER → score = 0, lives = 3, gameState = 'LAUNCHING', launchLabel = 'reiniciar'
- [ ] Inicialização: gameState = 'LAUNCHING', lives = 3, score = 0, launchLabel = 'iniciar'
- [ ] Testes TDD antes da implementação: testar o reducer puro (função `gameReducer`) com todas as transições e edge cases
- [ ] `npx tsc --noEmit` sem erros
- [ ] Code review aprovado

---

## [EPIC-3] — Física e Controles

---

### US-3: Controle analógico do paddle

**Como** jogador,
**quero** arrastar meu dedo horizontalmente no footer para mover o paddle proporcionalmente,
**para** interceptar a bolinha com precisão e sem delay perceptível.

**RF relacionado:** RF-002 — Controle Analógico do Paddle
**Critério de aceite de alto nível:** Paddle responde em ≤ 16ms, permanece dentro dos limites, bloqueado em overlays.

---

#### TASK-3.1 — Implementar usePaddleControl (Gesture.Pan no UI thread)

**Epic:** EPIC-3 | **US:** US-3
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-1.1, TASK-1.2
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-2.1, TASK-3.2, TASK-4.1

##### Contexto

O paddle é controlado por um gesto de arrasto horizontal no footer. O requisito RNF-002 exige latência ≤ 16ms (1 frame a 60fps), o que torna o `PanResponder` nativo inviável (passa pelo JS bridge). A solução é `Gesture.Pan()` do `react-native-gesture-handler`, que executa no UI thread junto com Reanimated. A posição do paddle é armazenada em um `useSharedValue<number>` (`paddleX`) que é lido diretamente pelo `useAnimatedStyle` do componente `Paddle.tsx` — sem passagem pelo JS thread. O gesto deve ser desabilitado quando o `gameState` não for `'PLAYING'` (durante overlays, o paddle está bloqueado per RF-002).

**Referências:**
- PRD: RF-002 — "O movimento do paddle é proporcional ao deslocamento do dedo (analógico)"; "O paddle não ultrapassa as bordas laterais"; "PLAYING" — paddle responsivo; overlays — paddle bloqueado; latência ≤ 16ms (RNF-002)
- TechSpec: Seção 2.3 (Fluxo RF-002), ADR-002 (RNGH), Seção 3.2 (paddleX SharedValue), Seção 3.3 (PADDLE_WIDTH, PADDLE_SENSITIVITY)
- Guidelines: `guidelines/coding-standards.md` — hooks camelCase com prefixo `use`

##### O que deve ser feito

- [ ] Criar `src/features/game/hooks/usePaddleControl.ts`
- [ ] Criar um `SharedValue<number>` para `paddleX` (posição central do paddle)
- [ ] Implementar `Gesture.Pan()` com `.onUpdate` no UI thread (`'worklet'`)
- [ ] Aplicar clamp para manter o paddle dentro da game area (`PADDLE_WIDTH/2` a `gameAreaWidth - PADDLE_WIDTH/2`)
- [ ] Aplicar `PADDLE_SENSITIVITY` ao translationX
- [ ] Desabilitar o gesto quando `gameState !== 'PLAYING'` via prop `enabled`
- [ ] Retornar `paddleX` (SharedValue), `panGesture` (para o `GestureDetector`) e uma função `resetPaddle`

##### Guia técnico de implementação

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
import {
  PADDLE_SENSITIVITY,
  PADDLE_WIDTH,
} from '../constants'

interface UsePaddleControlParams {
  gameAreaWidth: number
  gameState: GameState
}

export function usePaddleControl({ gameAreaWidth, gameState }: UsePaddleControlParams) {
  const paddleX = useSharedValue(gameAreaWidth / 2)

  const minX = PADDLE_WIDTH / 2
  const maxX = gameAreaWidth - PADDLE_WIDTH / 2

  const panGesture = Gesture.Pan()
    .onUpdate(({ translationX }) => {
      'worklet'
      const next = paddleX.value + translationX * PADDLE_SENSITIVITY
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
- `.onUpdate` recebe `translationX` ACUMULADO desde o início do gesto — CORRETO. `.onChange` recebe o delta desde o frame anterior — usar `.onUpdate` aqui pode causar duplicação se não houver reset do estado interno. Verifique o comportamento com um gesto longo.
  - **Alternativa mais robusta**: usar `.onChange` com `changeX` (delta por frame):
    ```typescript
    .onChange(({ changeX }) => {
      'worklet'
      paddleX.value = Math.max(minX, Math.min(maxX, paddleX.value + changeX * PADDLE_SENSITIVITY))
    })
    ```
  - Teste ambas e use a que não causa "salto" na retomada de gesto.
- O parâmetro `.enabled(gameState === 'PLAYING')` é avaliado no JS thread; mudanças de `gameState` desabilitem o gesto corretamente, mas pode haver 1 frame de delay. Aceitável.
- `gameAreaWidth` deve ser o valor da area de jogo (sem header e footer), passado pelo `GameScreen`
- O gesto deve começar no footer (não na área de jogo) — isso é garantido pelo `GestureDetector` aplicado sobre o componente Footer

##### Critérios de Aceite

- [ ] Arrasto para a direita → `paddleX.value` aumenta proporcionalmente
- [ ] Arrasto para a esquerda → `paddleX.value` diminui proporcionalmente
- [ ] `paddleX.value` nunca sai dos limites `[PADDLE_WIDTH/2, gameAreaWidth - PADDLE_WIDTH/2]`
- [ ] Com `gameState !== 'PLAYING'` → gesto ignorado, `paddleX.value` não muda
- [ ] `resetPaddle()` centraliza o paddle (`paddleX.value = gameAreaWidth / 2`)
- [ ] Testes TDD: mock do GestureDetector não é necessário para testar a lógica de clamp — testar o cálculo de clamp diretamente com valores de entrada e saída esperados
- [ ] Code review aprovado

---

### US-4: Física da bolinha

**Como** jogador,
**quero** que a bolinha se mova e rebata de forma física e previsível,
**para** desenvolver estratégia e sentir o jogo responsivo.

**RF relacionado:** RF-003 — Mecânica da Bolinha
**Critério de aceite de alto nível:** Bolinha se move com dt-based physics, rebate corretamente em todas as superfícies, acelera progressivamente.

---

#### TASK-3.2 — useGameLoop: movimento e colisões com bordas

**Epic:** EPIC-3 | **US:** US-4
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-1.1, TASK-1.2
**Bloqueia:** TASK-3.3
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-2.1, TASK-3.1, TASK-4.1

##### Contexto

Esta task implementa o núcleo do game loop: `useFrameCallback` do Reanimated 3, que executa a cada frame no UI thread (~60fps) sem bloquear o JS thread. A física usa delta time (`timeSincePreviousFrame`) para ser independente do frame rate. Nesta task, a bola se move e rebate nas bordas laterais e superior da game area. A colisão com paddle, goal zone e borda inferior são implementadas nas tasks seguintes (3.3 e 3.4) que estendem este mesmo hook.

A lógica TODA usa `useSharedValue` e deve estar dentro de worklets (marcados com `'worklet'`). Nenhuma chamada ao JS thread é feita nesta task — apenas na 3.4.

**Referências:**
- PRD: RF-003 — "rebate ao contato com as bordas lateral esquerda, lateral direita e superior"; "colisão de canto → ambos os componentes invertidos"; "velocidade inicial é exatamente INITIAL_BALL_SPEED (20 px/s)"; ângulo sorteado em [30°, 150°]
- TechSpec: Seção 2.3 (Fluxo RF-003), Seção 3.2 (SharedValues ballX/ballY/vx/vy/isGameActive), Seção 3.3 (constantes de velocidade e ângulo), Seção 7.2 (useFrameCallback pattern)
- Guidelines: `guidelines/coding-standards.md`

##### O que deve ser feito

- [ ] Criar `src/features/game/hooks/useGameLoop.ts`
- [ ] Criar SharedValues: `ballX`, `ballY`, `vx`, `vy`, `isGameActive`
- [ ] Implementar `useFrameCallback` com dt-based physics
- [ ] Implementar colisão com borda lateral esquerda e direita (inverter `vx`)
- [ ] Implementar colisão com borda superior (inverter `vy`)
- [ ] Implementar colisão de canto (lateral + superior simultânea — inverter ambos)
- [ ] Implementar função `launchBall(gameAreaWidth)` que sorteia ângulo aleatório [30°,150°] e define `vx`/`vy` iniciais com `INITIAL_BALL_SPEED`
- [ ] Retornar `{ ballX, ballY, isGameActive, launchBall }` (partial — será expandido em 3.3 e 3.4)

##### Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/hooks/useGameLoop.ts  — game loop (criado aqui, expandido em 3.3 e 3.4)
```

**Padrão a seguir:**

```typescript
// src/features/game/hooks/useGameLoop.ts (versão desta task)
import { useSharedValue, useFrameCallback } from 'react-native-reanimated'
import {
  BALL_RADIUS,
  BALL_START_Y,
  INITIAL_BALL_SPEED,
  BALL_LAUNCH_ANGLE_MIN,
  BALL_LAUNCH_ANGLE_MAX,
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

    const dt = (timeSincePreviousFrame ?? 16) / 1000 // ms → s

    let nextX = ballX.value + vx.value * dt
    let nextY = ballY.value + vy.value * dt

    // Colisão borda lateral esquerda
    if (nextX - BALL_RADIUS <= 0) {
      vx.value = Math.abs(vx.value)
      nextX = BALL_RADIUS
    }
    // Colisão borda lateral direita
    if (nextX + BALL_RADIUS >= gameAreaWidth) {
      vx.value = -Math.abs(vx.value)
      nextX = gameAreaWidth - BALL_RADIUS
    }
    // Colisão borda superior
    if (nextY - BALL_RADIUS <= 0) {
      vy.value = Math.abs(vy.value)
      nextY = BALL_RADIUS
    }

    ballX.value = nextX
    ballY.value = nextY
  }, true)

  function launchBall(areaWidth: number) {
    const minAngle = BALL_LAUNCH_ANGLE_MIN * (Math.PI / 180)
    const maxAngle = BALL_LAUNCH_ANGLE_MAX * (Math.PI / 180)
    const angle = minAngle + Math.random() * (maxAngle - minAngle)
    // ângulo medido a partir do eixo horizontal; vy positivo = para baixo
    vx.value = INITIAL_BALL_SPEED * Math.cos(angle)
    vy.value = INITIAL_BALL_SPEED * Math.sin(angle)
    ballX.value = areaWidth / 2
    ballY.value = BALL_START_Y
    isGameActive.value = true
  }

  return { ballX, ballY, isGameActive, launchBall }
}
```

**Pontos de atenção:**
- `timeSincePreviousFrame` pode ser `null` no primeiro frame — use `?? 16` como fallback
- As colisões laterais e superior devem corrigir a posição além da inversão de velocidade (o `nextX = BALL_RADIUS` etc.) para evitar que a bola fique "presa" na borda
- A colisão de canto (lateral + superior no mesmo frame) é tratada automaticamente pelos dois blocos if independentes — ambos são executados
- `isGameActive.value = false` pausa o loop sem desmontar o callback — isso é mais eficiente que recriar o `useFrameCallback`
- O ângulo [30°, 150°] garante componente `vy` positivo (descendente) — `sin(30°) > 0` e `sin(150°) > 0`

##### Critérios de Aceite

- [ ] Bola iniciada em `(gameAreaWidth/2, BALL_START_Y)` com velocidade `INITIAL_BALL_SPEED` ao chamar `launchBall`
- [ ] Ângulo sorteado sempre produz `vy > 0` (direção descendente)
- [ ] Bola rebate na borda esquerda: `vx` inverte para positivo
- [ ] Bola rebate na borda direita: `vx` inverte para negativo
- [ ] Bola rebate na borda superior: `vy` inverte para positivo
- [ ] Colisão de canto: ambos `vx` e `vy` invertidos
- [ ] `isGameActive.value = false` pausa o movimento
- [ ] Testes TDD: testar a lógica de colisão e reflexão com valores puros (extrair funções puras `reflectX`, `reflectY` e testá-las)
- [ ] Code review aprovado

---

#### TASK-3.3 — useGameLoop: colisão com paddle e física de rebate

**Epic:** EPIC-3 | **US:** US-4
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-3.2
**Bloqueia:** TASK-3.4
**Paralelo `[P]`:** Não — estende o mesmo hook de TASK-3.2

##### Contexto

Esta task adiciona ao `useGameLoop` a detecção de colisão entre a bola e o paddle, bem como o cálculo de ângulo de rebate baseado no ponto de impacto. O ângulo varia linearmente entre `BALL_BOUNCE_ANGLE_CENTER` (rebate central, quase reto para cima) e `BALL_BOUNCE_ANGLE_EDGE` (rebate rasante nas extremidades). Cada colisão com o paddle também incrementa a velocidade da bola. O paddle passa a ser um SharedValue recebido como parâmetro do hook.

**Referências:**
- PRD: RF-003 — "ao contato com o paddle, rebate para cima com variação angular conforme o ponto de impacto: centro do paddle → BALL_BOUNCE_ANGLE_CENTER, extremidades → BALL_BOUNCE_ANGLE_EDGE"; "velocidade é incrementada em um valor fixo após cada rebate no paddle"
- TechSpec: Seção 2.3 (Fluxo RF-003 — passo f), Seção 3.3 (BALL_BOUNCE_ANGLE_CENTER=80°, BALL_BOUNCE_ANGLE_EDGE=20°, BALL_SPEED_INCREMENT_PADDLE=5)
- Guidelines: `guidelines/coding-standards.md`

##### O que deve ser feito

- [ ] Adicionar `paddleX: SharedValue<number>` como parâmetro do hook `useGameLoop`
- [ ] Dentro do `useFrameCallback` worklet, detectar colisão bola × paddle (hitbox circulo × retângulo)
- [ ] Calcular `impactRatio` = distância do centro / (metade da largura do paddle), no intervalo [-1, +1]
- [ ] Interpolar o ângulo de saída entre `BALL_BOUNCE_ANGLE_CENTER` e `BALL_BOUNCE_ANGLE_EDGE` usando `Math.abs(impactRatio)`
- [ ] Calcular novo `vx` e `vy` com base no ângulo interpolado e na velocidade atual
- [ ] Incrementar a velocidade em `BALL_SPEED_INCREMENT_PADDLE` a cada colisão (com cap em `BALL_SPEED_MAX`)

##### Guia técnico de implementação

**Padrão a seguir (adições ao useFrameCallback existente):**

```typescript
// Adicionar ao useFrameCallback, após as colisões de borda, antes de atualizar ballX/ballY

// Posição e dimensões do paddle
const paddleTop = gameAreaHeight - PADDLE_Y_OFFSET - PADDLE_HEIGHT
const paddleLeft = paddleX.value - PADDLE_WIDTH / 2
const paddleRight = paddleX.value + PADDLE_WIDTH / 2
const paddleBottom = gameAreaHeight - PADDLE_Y_OFFSET

// Detecção de colisão (bola descendo em direção ao paddle)
const ballBottom = nextY + BALL_RADIUS
const ballLeft = nextX - BALL_RADIUS
const ballRight = nextX + BALL_RADIUS

if (
  vy.value > 0 &&                          // bola descendo
  ballBottom >= paddleTop &&               // bola atingiu ou ultrapassou o topo do paddle
  ballBottom <= paddleBottom &&            // bola ainda está dentro do paddle
  ballRight >= paddleLeft &&               // sobreposição horizontal
  ballLeft <= paddleRight
) {
  const halfWidth = PADDLE_WIDTH / 2
  const impactRatio = (nextX - paddleX.value) / halfWidth  // [-1, +1]
  const clampedRatio = Math.max(-1, Math.min(1, impactRatio))

  // Interpolar ângulo entre CENTER (centro) e EDGE (extremidades)
  const centerRad = BALL_BOUNCE_ANGLE_CENTER * (Math.PI / 180)
  const edgeRad = BALL_BOUNCE_ANGLE_EDGE * (Math.PI / 180)
  const angle = centerRad + (edgeRad - centerRad) * Math.abs(clampedRatio)

  // Nova velocidade (incrementada, com cap)
  const currentSpeed = Math.sqrt(vx.value ** 2 + vy.value ** 2)
  const newSpeed = Math.min(currentSpeed + BALL_SPEED_INCREMENT_PADDLE, BALL_SPEED_MAX)

  // Novo vetor de velocidade (sempre para cima após rebate no paddle)
  vx.value = Math.sign(clampedRatio !== 0 ? clampedRatio : 1) * newSpeed * Math.sin(angle)
  vy.value = -newSpeed * Math.cos(angle)  // negativo = para cima

  // Ajustar posição para evitar re-colisão no próximo frame
  nextY = paddleTop - BALL_RADIUS
}
```

**Pontos de atenção:**
- A condição `vy.value > 0` evita colisões duplas (bola subindo através do paddle após rebate)
- O cálculo do `impactRatio` usa a posição do CENTRO da bola (`nextX`) relativa ao centro do paddle
- `Math.sign(clampedRatio !== 0 ? clampedRatio : 1)` trata o caso raro de impacto perfeitamente central — direciona para a direita por convenção
- O ajuste `nextY = paddleTop - BALL_RADIUS` após a colisão evita que a bola fique "dentro" do paddle no próximo frame
- Importar as constantes adicionais: `BALL_SPEED_INCREMENT_PADDLE`, `BALL_SPEED_MAX`, `BALL_BOUNCE_ANGLE_CENTER`, `BALL_BOUNCE_ANGLE_EDGE`, `PADDLE_Y_OFFSET`, `PADDLE_HEIGHT`, `PADDLE_WIDTH`

##### Critérios de Aceite

- [ ] Bola colide com centro do paddle → `vy` inverte com ângulo próximo a 80° (quase reto)
- [ ] Bola colide com extremidade do paddle → `vy` inverte com ângulo próximo a 20° (rasante)
- [ ] Velocidade incrementa em `BALL_SPEED_INCREMENT_PADDLE` a cada colisão com paddle
- [ ] Velocidade não ultrapassa `BALL_SPEED_MAX`
- [ ] Bola não atravessa o paddle (posição corrigida após colisão)
- [ ] Bola subindo não dispara colisão com paddle
- [ ] Testes TDD: testar o cálculo de impactRatio e ângulo resultante com valores de entrada controlados
- [ ] Code review aprovado

---

### US-5: Goal zone e vida perdida

**Como** jogador,
**quero** marcar pontos ao passar a bolinha pela goal zone e perder uma vida quando ela cai,
**para** ter objetivos claros e um ciclo de risco/recompensa.

**RF relacionado:** RF-004 (goal zone detection), RF-005 (vida perdida event)
**Critério de aceite de alto nível:** Ponto marcado exatamente 1× por travessia; vida decrementada exatamente 1× por queda.

---

#### TASK-3.4 — useGameLoop: detecção goal zone, borda inferior e callbacks runOnJS

**Epic:** EPIC-3 | **US:** US-5
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-3.3
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Não — estende o mesmo hook de TASK-3.3

##### Contexto

Esta é a última adição ao `useGameLoop`. Implementa dois mecanismos de detecção no worklet e usa `runOnJS` para notificar o React state: (1) interseção da bola com a goal zone (ponto marcado, exatamente 1× por travessia via flag `inGoalZone`); (2) bola ultrapassando a borda inferior (vida perdida, debounce via `lifeLostLock`). São os dois únicos pontos de comunicação entre o UI thread e o JS thread no game loop. Os callbacks `onGoalScored` e `onLifeLost` são os retornados por `useGameState` (TASK-2.1).

**Referências:**
- PRD: RF-004 — "ponto marcado quando qualquer parte do hitbox intersecciona a goal zone"; "apenas uma vez por travessia (entrada → saída)"; "trajetória não alterada"; RF-003 — "bola cruza borda inferior → congela 10 px abaixo da borda, 1 vida decrementada"; RF-005 — "múltiplos eventos no mesmo frame → apenas 1 vida decrementada"
- TechSpec: Seção 2.3 (Fluxos RF-003 passos g e h, RF-004, RF-005/RF-006), Seção 3.2 (inGoalZone, lifeLostLock SharedValues), Seção 3.3 (GOAL_ZONE_WIDTH, GOAL_ZONE_HEIGHT, BALL_FREEZE_OFFSET, BALL_SPEED_INCREMENT_GOAL)
- Guidelines: `guidelines/coding-standards.md`

##### O que deve ser feito

- [ ] Adicionar SharedValues: `inGoalZone`, `lifeLostLock` ao hook
- [ ] Adicionar parâmetros `onGoalScored: () => void` e `onLifeLost: () => void` ao hook (callbacks para `runOnJS`)
- [ ] Calcular posição Y da goal zone: `goalZoneY = gameAreaHeight / 2 - GOAL_ZONE_HEIGHT / 2`
- [ ] Calcular posição X da goal zone: `goalZoneX = gameAreaWidth / 2 - GOAL_ZONE_WIDTH / 2`
- [ ] Detectar interseção bola × goal zone e gerenciar flag `inGoalZone`
- [ ] Detectar bola ultrapassando borda inferior, congelar posição e chamar `runOnJS(onLifeLost)()`
- [ ] Exportar `inGoalZone`, `lifeLostLock` do hook (para reset em `GameScreen`)
- [ ] Exportar função `resetBallState()` para uso em reset de jogo

##### Guia técnico de implementação

**Padrão a seguir (adições ao useFrameCallback):**

```typescript
import { runOnJS } from 'react-native-reanimated'
import { GOAL_ZONE_WIDTH, GOAL_ZONE_HEIGHT, BALL_FREEZE_OFFSET, BALL_SPEED_INCREMENT_GOAL, BALL_SPEED_MAX } from '../constants'

// Shared values adicionais (declarar junto com os existentes)
const inGoalZone = useSharedValue(false)
const lifeLostLock = useSharedValue(false)
const ballSpeed = useSharedValue(INITIAL_BALL_SPEED)  // rastrear velocidade escalar

// --- Dentro do useFrameCallback, após colisão com paddle ---

// Goal zone
const goalLeft = gameAreaWidth / 2 - GOAL_ZONE_WIDTH / 2
const goalRight = gameAreaWidth / 2 + GOAL_ZONE_WIDTH / 2
const goalTop = gameAreaHeight / 2 - GOAL_ZONE_HEIGHT / 2
const goalBottom = gameAreaHeight / 2 + GOAL_ZONE_HEIGHT / 2

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
  return  // interrompe o processamento deste frame
}

// Atualizar posições (só chegamos aqui se não perdemos vida)
ballX.value = nextX
ballY.value = nextY
```

**Pontos de atenção:**
- `runOnJS` só pode ser chamado de dentro de um worklet; a função passada (`onGoalScored`, `onLifeLost`) deve ser um callback normal do JS thread (não um worklet)
- As constantes `goalLeft`, `goalRight`, `goalTop`, `goalBottom` devem ser calculadas UMA VEZ fora do useFrameCallback (são fixas para o jogo); passá-las como parâmetros closured é a abordagem correta em worklets
- `lifeLostLock.value = true` garante que mesmo se múltiplos frames detectarem a borda inferior, `onLifeLost` é chamado apenas uma vez
- `lifeLostLock.value` deve ser resetado para `false` na função `launchBall` ou `resetBallState`
- `ballSpeed` como SharedValue separado rastreia a velocidade escalar — garante que o incremento por goal zone seja aplicado corretamente ao vetor atual

##### Critérios de Aceite

- [ ] Bola entra na goal zone → `onGoalScored` chamado exatamente 1× (transição false→true de `inGoalZone`)
- [ ] Bola permanece na goal zone por N frames → `onGoalScored` chamado 1× no total
- [ ] Bola sai e re-entra na goal zone → `onGoalScored` chamado novamente
- [ ] Bola ultrapassa borda inferior → `onLifeLost` chamado 1×; bola congela em `gameAreaHeight + BALL_FREEZE_OFFSET`
- [ ] Trajetória da bola não alterada ao passar pela goal zone
- [ ] `lifeLostLock` previne múltiplas chamadas a `onLifeLost` no mesmo evento
- [ ] Testes TDD: testar lógica de interseção AABB (bola vs goal zone rect) com valores numéricos puros
- [ ] Code review aprovado

---

## [EPIC-4] — Interface Visual e Integração

---

### US-6: Estrutura visual da tela de jogo

**Como** jogador,
**quero** ver a tela de jogo estruturada em header, área de jogo e footer distintos com elementos visuais CRT,
**para** entender o layout imediatamente e focar no gameplay.

**RF relacionado:** RF-001 — Estrutura Visual da Tela de Jogo
**Critério de aceite de alto nível:** Três regiões distintas, responsivas, header com "KingPong" em verde, orientação portrait.

---

#### TASK-4.1 — Layout base: GameScreen, Header, GameBoard, Footer

**Epic:** EPIC-4 | **US:** US-6
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-1.1, TASK-1.2
**Bloqueia:** TASK-4.2, TASK-4.3, TASK-4.4, TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-2.1, TASK-3.1, TASK-3.2

##### Contexto

Esta task cria o esqueleto visual da tela de jogo. `GameScreen.tsx` organiza três regiões verticais (header 8%, game area 70%, footer 22%) usando `useWindowDimensions` para responsividade. É fundamental que as dimensões da game area sejam acessíveis via props para os hooks de física e controle (`useGameLoop`, `usePaddleControl`). O header exibe "KingPong" em estilo CRT; o footer é a zona de controle do paddle (onde o `GestureDetector` será aplicado na TASK-4.5). A `GameBoard` (área de jogo) deve ter `overflow: 'hidden'` para clipar elementos além dos limites.

**Referências:**
- PRD: RF-001 — "header exibe 'KingPong' centralizado com fonte CRT em verde"; "fundo do header é visivelmente mais claro que o fundo da área de jogo"; "header, área de jogo e footer são visualmente distintos"; "se adaptam proporcionalmente sem sobreposição"
- TechSpec: Seção 1.1 (separação de responsabilidades), Seção 2.2 (estrutura de pastas), Seção 3.3 (HEADER_HEIGHT_RATIO=0.08, FOOTER_HEIGHT_RATIO=0.22, cores)
- Guidelines: `guidelines/architecture.md` (estrutura de pastas), `guidelines/coding-standards.md` (PascalCase para componentes)

##### O que deve ser feito

- [ ] Criar `src/features/game/screens/GameScreen.tsx` (tela principal, sem lógica nesta task)
- [ ] Criar `src/features/game/components/GameBoard.tsx` (container da área de jogo)
- [ ] Implementar layout responsivo com `useWindowDimensions` + `useSafeAreaInsets`
- [ ] Calcular `headerHeight`, `gameAreaHeight`, `footerHeight` a partir das ratios e da safe area
- [ ] Aplicar cores: `COLOR_BG_HEADER`, `COLOR_BG_GAME`, `COLOR_BG_FOOTER`
- [ ] Header: texto "KingPong" centralizado em `COLOR_CRT_GREEN`
- [ ] GameBoard: `overflow: 'hidden'` para clipar bola nas bordas

##### Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/screens/GameScreen.tsx    — orquestrador principal (esqueleto nesta task)
src/features/game/components/GameBoard.tsx  — container da área de jogo
```

**Padrão a seguir:**

```tsx
// src/features/game/screens/GameScreen.tsx (esqueleto)
import { useWindowDimensions, View, Text, StyleSheet } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import { HEADER_HEIGHT_RATIO, FOOTER_HEIGHT_RATIO, COLOR_BG_HEADER, COLOR_BG_GAME, COLOR_BG_FOOTER, COLOR_CRT_GREEN } from '../constants'
import { GameBoard } from '../components/GameBoard'

export function GameScreen() {
  const { height, width } = useWindowDimensions()
  const insets = useSafeAreaInsets()
  const safeHeight = height - insets.top - insets.bottom

  const headerHeight = Math.round(safeHeight * HEADER_HEIGHT_RATIO)
  const footerHeight = Math.round(safeHeight * FOOTER_HEIGHT_RATIO)
  const gameAreaHeight = safeHeight - headerHeight - footerHeight

  return (
    <View style={[styles.container, { paddingTop: insets.top }]}>
      <View style={[styles.header, { height: headerHeight }]}>
        <Text style={styles.title}>KingPong</Text>
      </View>
      <GameBoard width={width} height={gameAreaHeight} />
      <View
        testID="footer"
        style={[styles.footer, { height: footerHeight }]}
      />
    </View>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLOR_BG_GAME },
  header: { backgroundColor: COLOR_BG_HEADER, justifyContent: 'center', alignItems: 'center' },
  title: { color: COLOR_CRT_GREEN, fontSize: 24, fontWeight: 'bold', letterSpacing: 4 },
  footer: { backgroundColor: COLOR_BG_FOOTER },
})
```

```tsx
// src/features/game/components/GameBoard.tsx
import { View, StyleSheet } from 'react-native'
import { COLOR_BG_GAME } from '../constants'

interface GameBoardProps {
  width: number
  height: number
}

export function GameBoard({ width, height }: GameBoardProps) {
  return (
    <View
      testID="game-area"
      style={[styles.board, { width, height }]}
    />
  )
}

const styles = StyleSheet.create({
  board: { backgroundColor: COLOR_BG_GAME, overflow: 'hidden' },
})
```

**Pontos de atenção:**
- `react-native-safe-area-context` deve ser instalado (`npm install react-native-safe-area-context`) e o `SafeAreaProvider` deve envolver o app em `App.tsx` (junto com `GestureHandlerRootView`)
- `overflow: 'hidden'` no `GameBoard` é essencial para que a bola seja clippada ao sair da área de jogo (evita ver a bola "vazar" visualmente)
- A questão da fonte CRT está documentada na questão em aberto #2 do TechSpec — usar `fontFamily: 'monospace'` como fallback se uma fonte customizada não for configurada nesta task
- `Math.round()` nos cálculos de altura evita sub-pixels que causam gaps visuais de 1px entre regiões

##### Critérios de Aceite

- [ ] App renderiza três regiões visíveis e distintas sem sobreposição
- [ ] Header exibe "KingPong" centralizado em `COLOR_CRT_GREEN`
- [ ] `COLOR_BG_HEADER` é visivelmente diferente de `COLOR_BG_GAME`
- [ ] Layout se adapta a diferentes tamanhos de tela (testar em 360px e 430px de largura)
- [ ] `testID="footer"` e `testID="game-area"` presentes
- [ ] Sem gap visual entre as regiões
- [ ] Code review aprovado

---

#### TASK-4.2 — Componentes Ball e Paddle (Animated.View)

**Epic:** EPIC-4 | **US:** US-6
**Labels:** `frontend`
**Estimativa:** P (até 4h)
**Depende de:** TASK-1.2
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-4.3, TASK-4.4 (após TASK-1.2)

##### Contexto

`Ball.tsx` e `Paddle.tsx` são componentes puramente visuais — `Animated.View` com `useAnimatedStyle` que lê `useSharedValue` diretamente no UI thread. Qualquer mudança em `ballX`, `ballY` ou `paddleX` é refletida visualmente sem passar pelo JS thread e sem re-render React. Estes componentes não têm estado próprio — recebem SharedValues como props e renderizam.

**Referências:**
- PRD: RF-001 (paddle verde); RF-003 (bolinha branca de raio 10px); RF-002 (paddle 60×15px)
- TechSpec: Seção 2.2 (Ball.tsx, Paddle.tsx como Animated.View), Seção 3.3 (BALL_RADIUS, PADDLE_WIDTH, PADDLE_HEIGHT, COLOR_BALL, COLOR_CRT_GREEN), Seção 9.2 (testIDs: `ball`, `paddle`)
- Guidelines: `guidelines/coding-standards.md` (PascalCase componentes, interface de props tipada)

##### O que deve ser feito

- [ ] Criar `src/features/game/components/Ball.tsx` como `Animated.View` circular
- [ ] Criar `src/features/game/components/Paddle.tsx` como `Animated.View` retangular
- [ ] Ambos usam `useAnimatedStyle` para posição via `translateX` e `translateY`
- [ ] Adicionar `testID` em ambos

##### Guia técnico de implementação

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
- `translateX: x.value - BALL_RADIUS` posiciona o LEFT do `Animated.View` de modo que o CENTRO da bola esteja em `x.value` — essencial para que o hitbox calculado no worklet corresponda à posição visual
- Ambos usam `position: 'absolute'` — devem ser filhos de um container com `position: 'relative'` (o `GameBoard`)
- Não usar `left: x.value` no style estático — usar apenas `transform` para garantir que a atualização ocorra no UI thread

##### Critérios de Aceite

- [ ] Ball renderiza como círculo branco de diâmetro 20px
- [ ] Paddle renderiza como retângulo verde de 60×15px com bordas arredondadas
- [ ] Mudança em `ballX.value` / `ballY.value` / `paddleX.value` reflete visualmente sem delay
- [ ] `testID="ball"` e `testID="paddle"` presentes
- [ ] Sem `any` ou `as` no código TypeScript
- [ ] Code review aprovado

---

### US-7: GoalZone visual e HUD

**Como** jogador,
**quero** ver a goal zone destacada na tela e minha pontuação/vidas atualizadas em tempo real,
**para** saber onde apontar a bola e monitorar meu progresso na partida.

**RF relacionado:** RF-004 (goal zone visual), RF-007 (HUD)
**Critério de aceite de alto nível:** GoalZone centralizada e visível; HUD com score e lives atualizando no mesmo frame do evento.

---

#### TASK-4.3 — Componentes GoalZone e HUD

**Epic:** EPIC-4 | **US:** US-7
**Labels:** `frontend`
**Estimativa:** P (até 4h)
**Depende de:** TASK-1.2, TASK-2.1
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-4.2, TASK-4.4

##### Contexto

`GoalZone.tsx` é um componente estático que indica visualmente a posição da goal zone — a bola passa por ela sem rebater (pass-through), então o componente é puramente visual. `HUD.tsx` exibe a pontuação e vidas recebidas via props do React state (`GameStatus`); usa `React.memo` para evitar re-renders desnecessários. O HUD permanece visível mesmo durante os overlays (z-index abaixo dos overlays).

**Referências:**
- PRD: RF-004 — "goal zone está visível como área demarcada no centro da área de jogo com largura de 60px"; RF-007 — "pontuação e vidas visíveis em todo momento"; "valor atualizado imediatamente no mesmo frame"; "HUD permanece visível atrás do overlay"
- TechSpec: Seção 3.3 (GOAL_ZONE_WIDTH=60, GOAL_ZONE_HEIGHT=20, COLOR_GOAL_ZONE_FILL, COLOR_GOAL_ZONE_BORDER, COLOR_CRT_GREEN), Seção 9.2 (testIDs: `goal-zone`, `hud-score`, `hud-lives`)
- Guidelines: `guidelines/coding-standards.md` (React.memo, interface de props)

##### O que deve ser feito

- [ ] Criar `src/features/game/components/GoalZone.tsx` — retângulo centralizado com borda verde e fundo semi-transparente
- [ ] Criar `src/features/game/components/HUD.tsx` — score (top-left) e lives (top-right) com `React.memo`
- [ ] `GoalZone` recebe `gameAreaWidth` e `gameAreaHeight` para calcular posição centralizada
- [ ] `HUD` recebe `score: number` e `lives: number`

##### Guia técnico de implementação

**Padrão a seguir:**

```tsx
// src/features/game/components/GoalZone.tsx
import { View, StyleSheet } from 'react-native'
import { GOAL_ZONE_WIDTH, GOAL_ZONE_HEIGHT, COLOR_GOAL_ZONE_FILL, COLOR_GOAL_ZONE_BORDER } from '../constants'

interface GoalZoneProps {
  gameAreaWidth: number
  gameAreaHeight: number
}

export function GoalZone({ gameAreaWidth, gameAreaHeight }: GoalZoneProps) {
  const left = (gameAreaWidth - GOAL_ZONE_WIDTH) / 2
  const top = (gameAreaHeight - GOAL_ZONE_HEIGHT) / 2

  return (
    <View
      testID="goal-zone"
      style={[styles.zone, { left, top }]}
    />
  )
}

const styles = StyleSheet.create({
  zone: {
    position: 'absolute',
    width: GOAL_ZONE_WIDTH,
    height: GOAL_ZONE_HEIGHT,
    backgroundColor: COLOR_GOAL_ZONE_FILL,
    borderWidth: 1,
    borderColor: COLOR_GOAL_ZONE_BORDER,
  },
})
```

```tsx
// src/features/game/components/HUD.tsx
import { memo } from 'react'
import { View, Text, StyleSheet } from 'react-native'
import { COLOR_CRT_GREEN } from '../constants'

interface HUDProps {
  score: number
  lives: number
}

export const HUD = memo(function HUD({ score, lives }: HUDProps) {
  return (
    <View style={styles.container} pointerEvents="none">
      <Text testID="hud-score" style={styles.text}>{score}</Text>
      <Text testID="hud-lives" style={styles.text}>♥ {lives}</Text>
    </View>
  )
})

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    top: 8,
    left: 0,
    right: 0,
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 12,
    zIndex: 1,
  },
  text: { color: COLOR_CRT_GREEN, fontSize: 18, fontWeight: 'bold' },
})
```

**Pontos de atenção:**
- `pointerEvents="none"` no HUD garante que o toque sobre o HUD não interfere com o gesto do paddle no footer
- `GoalZone` usa `position: 'absolute'` relativo ao `GameBoard` — deve ser filho direto do `GameBoard`
- `HUD` usa `position: 'absolute'` sobre o `GameBoard` — `zIndex: 1` garante que fica acima de outros elementos mas abaixo dos overlays (`zIndex: 10`)
- O HUD deve suportar pontuação até 999.999 sem quebrar layout (RNF-004) — testar com `score = 999999` visualmente

##### Critérios de Aceite

- [ ] GoalZone visível no centro da game area com borda verde
- [ ] HUD exibe score (top-left) e lives (top-right)
- [ ] HUD não bloqueia toques no footer
- [ ] HUD permanece visível durante overlays (z-index correto)
- [ ] Score 999999 não quebra layout
- [ ] `testID` presentes em `goal-zone`, `hud-score`, `hud-lives`
- [ ] Code review aprovado

---

### US-8: Overlays de lançamento e game over

**Como** jogador,
**quero** ver um overlay antes de cada lançamento (com vidas restantes e botão contextual) e uma tela de game over ao perder,
**para** ter confirmação de cada lançamento e saber quando a partida terminou.

**RF relacionado:** RF-006 (game over overlay), RF-008 (launch overlay)
**Critério de aceite de alto nível:** Labels corretos em cada contexto; toque fora do botão não dispara ação; debounce previne duplo disparo.

---

#### TASK-4.4 — Overlays: LaunchOverlay e GameOverOverlay

**Epic:** EPIC-4 | **US:** US-8
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-2.1
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-4.2, TASK-4.3

##### Contexto

`LaunchOverlay.tsx` é exibido quando `gameState === 'LAUNCHING'`. Mostra as vidas restantes e um botão cujo label varia: "iniciar" (primeira abertura), "continuar" (após perda de vida), "reiniciar" (após game over). O toque no botão chama `onStartPlay`. `GameOverOverlay.tsx` é exibido quando `gameState === 'GAME_OVER'`. Mostra a pontuação final e o botão "play again" que chama `onPlayAgain`. Ambos têm debounce de `LAUNCH_BUTTON_DEBOUNCE_MS` (300ms) para evitar duplo disparo. O `GameScreen` decide qual overlay renderizar com base no `gameState`.

**Referências:**
- PRD: RF-008 — "overlay renderizado com vidas restantes"; "botão: 'iniciar' (1ª abertura), 'continuar' (respawn), 'reiniciar' (após play again)"; "toque fora do botão → overlay permanece"; RF-006 — "pontuação final visível em destaque"; "'play again' → debounce"
- TechSpec: Seção 2.3 (Fluxo RF-008), Seção 3.3 (LAUNCH_BUTTON_DEBOUNCE_MS=300), Seção 9.2 (testIDs: `launch-overlay`, `launch-button`, `launch-label`, `game-over-overlay`, `play-again-button`, `final-score`)
- Guidelines: `guidelines/coding-standards.md`

##### O que deve ser feito

- [ ] Criar `src/features/game/components/LaunchOverlay.tsx`
- [ ] Criar `src/features/game/components/GameOverOverlay.tsx`
- [ ] Implementar debounce de `LAUNCH_BUTTON_DEBOUNCE_MS` em ambos os botões
- [ ] Overlay ocupa toda a game area com fundo semi-transparente escuro
- [ ] Apenas o botão tem `onPress` — o container do overlay não

##### Guia técnico de implementação

**Padrão a seguir:**

```tsx
// src/features/game/components/LaunchOverlay.tsx
import { useCallback, useRef } from 'react'
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native'
import type { LaunchLabel } from '../types'
import { COLOR_CRT_GREEN, LAUNCH_BUTTON_DEBOUNCE_MS } from '../constants'

interface LaunchOverlayProps {
  lives: number
  label: LaunchLabel
  onLaunch: () => void
}

export function LaunchOverlay({ lives, label, onLaunch }: LaunchOverlayProps) {
  const lastTap = useRef(0)

  const handleLaunch = useCallback(() => {
    const now = Date.now()
    if (now - lastTap.current < LAUNCH_BUTTON_DEBOUNCE_MS) return
    lastTap.current = now
    onLaunch()
  }, [onLaunch])

  return (
    <View testID="launch-overlay" style={styles.overlay}>
      <Text style={styles.lives}>♥ {lives}</Text>
      <TouchableOpacity testID="launch-button" onPress={handleLaunch} style={styles.button}>
        <Text testID="launch-label" style={styles.buttonText}>{label}</Text>
      </TouchableOpacity>
    </View>
  )
}

const styles = StyleSheet.create({
  overlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0, 0, 0, 0.7)',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 10,
  },
  lives: { color: COLOR_CRT_GREEN, fontSize: 32, marginBottom: 24 },
  button: { borderWidth: 1, borderColor: COLOR_CRT_GREEN, paddingHorizontal: 32, paddingVertical: 12 },
  buttonText: { color: COLOR_CRT_GREEN, fontSize: 20, letterSpacing: 2 },
})
```

```tsx
// src/features/game/components/GameOverOverlay.tsx
import { useCallback, useRef } from 'react'
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native'
import { COLOR_CRT_GREEN, LAUNCH_BUTTON_DEBOUNCE_MS } from '../constants'

interface GameOverOverlayProps {
  score: number
  onPlayAgain: () => void
}

export function GameOverOverlay({ score, onPlayAgain }: GameOverOverlayProps) {
  const lastTap = useRef(0)

  const handlePlayAgain = useCallback(() => {
    const now = Date.now()
    if (now - lastTap.current < LAUNCH_BUTTON_DEBOUNCE_MS) return
    lastTap.current = now
    onPlayAgain()
  }, [onPlayAgain])

  return (
    <View testID="game-over-overlay" style={styles.overlay}>
      <Text testID="final-score" style={styles.score}>{score}</Text>
      <TouchableOpacity testID="play-again-button" onPress={handlePlayAgain} style={styles.button}>
        <Text style={styles.buttonText}>play again</Text>
      </TouchableOpacity>
    </View>
  )
}

const styles = StyleSheet.create({
  overlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0, 0, 0, 0.85)',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 10,
  },
  score: { color: COLOR_CRT_GREEN, fontSize: 64, fontWeight: 'bold', marginBottom: 32 },
  button: { borderWidth: 1, borderColor: COLOR_CRT_GREEN, paddingHorizontal: 32, paddingVertical: 12 },
  buttonText: { color: COLOR_CRT_GREEN, fontSize: 20, letterSpacing: 2 },
})
```

**Pontos de atenção:**
- O container do overlay (`View testID="launch-overlay"`) NÃO tem `onPress` — apenas o `TouchableOpacity` interno tem, garantindo que toque fora do botão não dispara ação (RF-008)
- `StyleSheet.absoluteFillObject` posiciona o overlay sobre toda a game area — requer que o GameBoard seja o container pai
- `zIndex: 10` garante que o overlay fica acima do HUD (`zIndex: 1`) e da GoalZone
- O debounce com `useRef` é simples e eficaz — não usa `useState` para evitar re-render

##### Critérios de Aceite

- [ ] `LaunchOverlay` exibe vidas restantes e botão com label correto
- [ ] Label "iniciar" quando `launchLabel === 'iniciar'`, "continuar" quando `'continuar'`, "reiniciar" quando `'reiniciar'`
- [ ] Toque fora do botão → nenhuma ação
- [ ] Toque duplo rápido → `onLaunch` chamado apenas 1×
- [ ] `GameOverOverlay` exibe score final em destaque e botão "play again"
- [ ] Todos os `testID` presentes: `launch-overlay`, `launch-button`, `launch-label`, `game-over-overlay`, `play-again-button`, `final-score`
- [ ] Code review aprovado

---

### US-9: Integração completa da tela de jogo

**Como** jogador,
**quero** jogar uma partida completa com todos os sistemas interligados,
**para** ter a experiência integral de KingPong — do lançamento ao game over.

**RF relacionado:** RF-001 a RF-008 (realizados conjuntamente)
**Critério de aceite de alto nível:** Partida completa funcional — lançamento, gameplay, goal, vidas, game over, reinício.

---

#### TASK-4.5 — GameScreen: orquestração completa de hooks e componentes

**Epic:** EPIC-4 | **US:** US-9
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-3.4, TASK-3.1, TASK-4.2, TASK-4.3, TASK-4.4, TASK-4.1
**Bloqueia:** TASK-5.1
**Paralelo `[P]`:** Não — aguarda todos os predecessores

##### Contexto

Esta task transforma o `GameScreen.tsx` (criado como esqueleto em TASK-4.1) na tela funcional completa. Ela orquestra `useGameState`, `useGameLoop` e `usePaddleControl`, renderiza todos os componentes e overlays, e implementa os efeitos colaterais necessários:
- `useEffect` observando `gameState` para ativar/pausar o game loop e resetar posições
- Função `resetBall()` chamada ao iniciar uma nova jogada
- Passagem dos callbacks `onGoalScored` e `onLifeLost` (via `runOnJS`) para o game loop
- `GestureDetector` no footer com o `panGesture` do `usePaddleControl`

**Referências:**
- PRD: RF-003 — "bolinha parte da região superior com ângulo sorteado ao toque do botão"; RF-005 — "bolinha reinicia do topo após perda"; RF-006 — "ao acionar play again → reset completo → LAUNCHING"
- TechSpec: Seção 2.3 (todos os fluxos), Seção 1.1 (separação UI thread / JS thread), Seção 7.3 (GestureHandlerRootView, useEffect, React.memo)
- Guidelines: `guidelines/architecture.md` (lógica de negócio em hooks, não em componentes)

##### O que deve ser feito

- [ ] Instanciar `useGameState()`, `useGameLoop()`, `usePaddleControl()` no `GameScreen`
- [ ] Passar `onGoalScored` e `onLifeLost` para `useGameLoop` (serão usados via `runOnJS`)
- [ ] Implementar `useEffect` observando `gameStatus.gameState`:
  - `'PLAYING'`: chamar `launchBall(gameAreaWidth)`, resetar `lifeLostLock`
  - `'LAUNCHING'` / `'GAME_OVER'`: `isGameActive.value = false`
- [ ] Implementar `useEffect` observando `'PLAYING'` para também resetar `paddleX` ao centro quando `gameStatus.launchLabel === 'reiniciar'` (play again reset)
- [ ] Aplicar `GestureDetector` envolvendo o `Footer` com o `panGesture`
- [ ] Renderizar `Ball`, `Paddle`, `GoalZone`, `HUD` dentro do `GameBoard`
- [ ] Renderizar `LaunchOverlay` condicionalmente quando `gameState === 'LAUNCHING'`
- [ ] Renderizar `GameOverOverlay` condicionalmente quando `gameState === 'GAME_OVER'`

##### Guia técnico de implementação

```tsx
// src/features/game/screens/GameScreen.tsx (completo)
import { useEffect } from 'react'
import { View, Text, StyleSheet } from 'react-native'
import { useWindowDimensions } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import { GestureDetector } from 'react-native-gesture-handler'
import { runOnJS } from 'react-native-reanimated'

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

import { HEADER_HEIGHT_RATIO, FOOTER_HEIGHT_RATIO, COLOR_BG_HEADER, COLOR_BG_FOOTER, COLOR_CRT_GREEN } from '../constants'

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
  }, [gameStatus.gameState])  // eslint-disable-line react-hooks/exhaustive-deps

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
- `GameBoard` deve aceitar `children` — atualizar a interface `GameBoardProps` para incluir `children?: React.ReactNode`
- O `useEffect` que observa `gameState` tem dependências completas que incluem várias funções — usar `eslint-disable` na linha é aceitável aqui pois a lógica DEVE rodar apenas quando `gameState` muda
- `launchBall(width)` reseta automaticamente `ballX`, `ballY` e define `isGameActive.value = true` — não é necessário fazer isso manualmente no `useEffect`
- O `GestureDetector` envolve apenas o `Footer` — não a game area — garantindo que gestos na área de jogo não movem o paddle (RF-002)
- `runOnJS` é aplicado dentro do `useGameLoop`, não no `GameScreen` — os callbacks `onGoalScored` e `onLifeLost` são passados como parâmetros e wrappados com `runOnJS` dentro do worklet

##### Critérios de Aceite

- [ ] App inicia em `LAUNCHING` com `launchLabel = 'iniciar'` e overlay visível
- [ ] Toque em "iniciar" → overlay some, bola lança, paddle responsivo
- [ ] Bola atinge borda inferior → vida decrementada, overlay "continuar" aparece
- [ ] Bola atravessa goal zone → score + 1 no HUD
- [ ] Após 3 perdas → `GAME_OVER` com score final exibido
- [ ] Toque em "play again" → score = 0, lives = 3, overlay "reiniciar"
- [ ] Paddle bloqueado durante overlays
- [ ] HUD visível atrás dos overlays
- [ ] Sem regressões visuais
- [ ] `npx tsc --noEmit` sem erros
- [ ] `npx eslint src/features/game/` sem warnings

---

## [EPIC-5] — Qualidade e Testes E2E

---

### US-10: Cobertura E2E de 90% dos fluxos críticos

**Como** desenvolvedor,
**quero** cobertura E2E com Detox de 90% dos fluxos críticos,
**para** garantir que a feature funciona corretamente em dispositivo real antes de qualquer release.

**RF relacionado:** RF-001 a RF-008
**Critério de aceite de alto nível:** 90% dos fluxos críticos cobertos; testes passam em Android emulador.

---

#### TASK-5.1 — Testes E2E: estrutura, overlays e HUD (RF-001, RF-007, RF-008)

**Epic:** EPIC-5 | **US:** US-10
**Labels:** `test`
**Estimativa:** M (4–8h)
**Depende de:** TASK-4.5
**Bloqueia:** TASK-5.2
**Paralelo `[P]`:** Não

##### Contexto

Esta task configura o Detox (se necessário) e implementa os primeiros cenários E2E: verificação da estrutura visual da tela, comportamento dos overlays de lançamento e game over, e atualização do HUD. São os testes mais fáceis de implementar porque não dependem de timing da física da bola. Seguem a estrutura padrão definida em `guidelines/testing.md` com `testID` definidos no TechSpec (seção 9.2).

**Referências:**
- PRD: RF-001 critérios de aceite; RF-007 critérios; RF-008 critérios
- TechSpec: Seção 9.2 (todos os testIDs), `quickstart.md` (comando E2E)
- Guidelines: `guidelines/testing.md` (estrutura padrão Detox, beforeAll, Arrange/Act/Assert)

##### O que deve ser feito

- [ ] Verificar/configurar Detox no projeto (`.detoxrc.js`, configuração de emulador)
- [ ] Criar `tests/e2e/gameplay.e2e.ts` com o `describe('Gameplay')` principal
- [ ] Implementar testes RF-001: três regiões visíveis, "KingPong" em tela
- [ ] Implementar testes RF-008: label "iniciar" no primeiro launch; botão dispara lançamento; toque fora do botão não dispara
- [ ] Implementar testes RF-007: HUD visível durante jogo; HUD visível atrás de overlay

##### Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
tests/e2e/gameplay.e2e.ts  — arquivo principal de testes E2E desta feature
.detoxrc.js                — configuração do Detox (verificar se existe)
```

**Padrão a seguir:**

```typescript
// tests/e2e/gameplay.e2e.ts
describe('KingPong — Feature 1: Tela de Jogo', () => {
  beforeAll(async () => {
    await device.launchApp({ newInstance: true })
  })

  beforeEach(async () => {
    await device.reloadReactNative()
  })

  describe('RF-001: Estrutura Visual', () => {
    it('exibe "KingPong" no header ao iniciar', async () => {
      await expect(element(by.text('KingPong'))).toBeVisible()
    })

    it('exibe a game area e o footer', async () => {
      await expect(element(by.id('game-area'))).toBeVisible()
      await expect(element(by.id('footer'))).toBeVisible()
    })
  })

  describe('RF-008: Overlay de Pre-Launch', () => {
    it('exibe label "iniciar" na primeira abertura', async () => {
      await expect(element(by.id('launch-overlay'))).toBeVisible()
      await expect(element(by.id('launch-label'))).toHaveText('iniciar')
    })

    it('dispara lançamento ao tocar no botão', async () => {
      await element(by.id('launch-button')).tap()
      await expect(element(by.id('launch-overlay'))).not.toBeVisible()
    })

    it('não dispara ao tocar fora do botão', async () => {
      await element(by.id('launch-overlay')).tap()  // toca o overlay (fora do botão)
      await expect(element(by.id('launch-overlay'))).toBeVisible()
    })
  })

  describe('RF-007: HUD', () => {
    it('exibe score e vidas durante o jogo', async () => {
      await element(by.id('launch-button')).tap()
      await expect(element(by.id('hud-score'))).toBeVisible()
      await expect(element(by.id('hud-lives'))).toBeVisible()
    })

    it('HUD visível atrás do overlay de pre-launch', async () => {
      await expect(element(by.id('hud-score'))).toBeVisible()
      await expect(element(by.id('launch-overlay'))).toBeVisible()
    })
  })
})
```

**Pontos de atenção:**
- `beforeEach: device.reloadReactNative()` reseta o estado do app a cada teste — necessário para garantir o estado `LAUNCHING` inicial
- O teste "não dispara ao tocar fora do botão" toca o container do overlay — verifique que o `testID="launch-overlay"` é o container e não o botão
- Configuração do Detox em `guidelines/testing.md` inclui os comandos `npx detox test --configuration android.emu.debug`

##### Critérios de Aceite

- [ ] `npx detox test --configuration android.emu.debug` passa em todos os testes desta task
- [ ] RF-001: "KingPong", game-area e footer visíveis
- [ ] RF-008: label "iniciar"; launch dispara; fora do botão não dispara
- [ ] RF-007: HUD visível durante jogo e durante overlay
- [ ] Sem testes flakey (re-executar 3× consecutivas — todos passam)
- [ ] Code review aprovado

---

#### TASK-5.2 — Testes E2E: gameplay core (RF-002, RF-003, RF-004, RF-005, RF-006)

**Epic:** EPIC-5 | **US:** US-10
**Labels:** `test`
**Estimativa:** G (1–2 dias)
**Depende de:** TASK-5.1
**Bloqueia:** nenhuma
**Paralelo `[P]`:** Não

##### Contexto

Esta task adiciona ao `gameplay.e2e.ts` os cenários de gameplay real — movimento do paddle, física da bola, marcação de ponto, sistema de vidas e game over. São os testes mais complexos porque dependem de timing e interação com a física do jogo. Alguns cenários (especialmente os de física da bola) podem requerer estratégias de espera (`waitFor` com timeout) para aguardar eventos assíncronos da UI. O objetivo é cobrir os happy paths e edge cases mais críticos de cada RF.

**Referências:**
- PRD: RF-002 critérios (paddle nas bordas, bloqueio em overlays); RF-003 (velocidade, rebote, congelamento); RF-004 (ponto na goal zone, sem rebate); RF-005 (3 vidas → decremento → game over); RF-006 (play again → reset completo)
- TechSpec: Seção 9.2 (testIDs: `ball`, `paddle`, `goal-zone`, `hud-score`, `hud-lives`, `play-again-button`, `final-score`)
- Guidelines: `guidelines/testing.md` (preferência por testes reais, mínimo de mocks; timer mocks apenas para flakiness)

##### O que deve ser feito

- [ ] RF-002: teste de bloqueio do paddle durante overlay (verificar que paddle não muda após arrasto)
- [ ] RF-003: lançar bola e verificar que ela está em movimento (posição muda ao longo do tempo)
- [ ] RF-004: verificar que goal zone está visível e que score incrementa ao passar a bola (pode requerer simulação de posição se a physics for muito imprevisível)
- [ ] RF-005: simular 3 perdas de vida (via wait do evento de queda); verificar decrementação e transição para GAME_OVER na 3ª
- [ ] RF-006: verificar reset completo após "play again" (score=0, lives=3, label="reiniciar")
- [ ] Verificar label "continuar" após 1ª perda de vida

##### Guia técnico de implementação

**Padrão a seguir (adições ao gameplay.e2e.ts):**

```typescript
  describe('RF-002: Controle do Paddle', () => {
    it('paddle bloqueado durante overlay de pre-launch', async () => {
      // paddle está em LAUNCHING — arrastar no footer não deve mover o paddle
      await expect(element(by.id('launch-overlay'))).toBeVisible()
      // verificar via testID que paddle está centrado — não há API direta para posição
      // validar indiretamente: após lançar, o paddle responde; antes, não
    })
  })

  describe('RF-005 / RF-006: Vidas e Game Over', () => {
    it('exibe "continuar" após perda de vida', async () => {
      await element(by.id('launch-button')).tap()
      // aguardar a bola cair (perder vida)
      await waitFor(element(by.id('launch-overlay')))
        .toBeVisible()
        .withTimeout(30000)
      await expect(element(by.id('launch-label'))).toHaveText('continuar')
      await expect(element(by.id('hud-lives'))).toHaveText('♥ 2')
    })

    it('exibe game over após 3 perdas de vida', async () => {
      for (let i = 0; i < 3; i++) {
        await element(by.id('launch-button')).tap()
        await waitFor(element(by.id('launch-overlay')).atIndex(0))
          .toBeVisible()
          .withTimeout(30000)
      }
      await expect(element(by.id('game-over-overlay'))).toBeVisible()
    })

    it('reseta o jogo corretamente após "play again"', async () => {
      // ... após game over (reusar lógica do teste anterior)
      await element(by.id('play-again-button')).tap()
      await expect(element(by.id('launch-overlay'))).toBeVisible()
      await expect(element(by.id('launch-label'))).toHaveText('reiniciar')
      await expect(element(by.id('hud-score'))).toHaveText('0')
      await expect(element(by.id('hud-lives'))).toHaveText('♥ 3')
    })
  })

  describe('RF-001 / RF-004: Goal Zone', () => {
    it('goal zone está visível na game area', async () => {
      await expect(element(by.id('goal-zone'))).toBeVisible()
    })
  })
```

**Pontos de atenção:**
- O `waitFor` com timeout de 30s é necessário para aguardar a bola cair naturalmente — evite tornar o timeout muito curto, pois depende da velocidade inicial (`INITIAL_BALL_SPEED = 20 px/s`)
- Para testar o incremento de score (RF-004), pode ser necessário manipular a velocidade da bola via configuração de test ou aceitar que o teste seja de longa duração — considerar como "best effort"
- Testes de física que dependem de posição exata da bola tendem a ser flakey — preferir testes de estado (overlay visível, label correto, score) em vez de posição visual
- Se um teste for muito flakey, documentar na `## Histórico de Issues` do arquivo `task-5.2.md` e marcar com `.skip` temporariamente enquanto investiga

##### Critérios de Aceite

- [ ] RF-005: overlay "continuar" após 1ª perda com lives = 2
- [ ] RF-006: `GAME_OVER` após 3ª perda com overlay visível
- [ ] RF-006: "play again" reseta score=0, lives=3, label="reiniciar"
- [ ] RF-004: `goal-zone` visível em `game-area`
- [ ] Todos os testes passam 3× consecutivas sem flakiness
- [ ] `npx detox test --configuration android.emu.debug` verde
- [ ] Code review aprovado

---

## Dependências entre Tasks (Visão Geral)

```
TASK-1.1 [P] ⚡ TASK-1.2
    │             │
    └──────┬──────┘
           ▼
    ┌──────┴────────────────────────────┐
    │  (após ambas 1.1 e 1.2)          │
    ▼              ▼         ▼         ▼
TASK-2.1 [P]  TASK-3.1 [P] TASK-3.2 [P] TASK-4.1 [P]
(useGameState)  (paddle)    (loop core)  (layout)
    │                           │
    │               TASK-3.3 ◄──┘
    │               (paddle collision)
    │                   │
    │               TASK-3.4
    │               (goal + life lost)
    │                   │
    ├────────────────────┤
    ▼              ▼     ▼         ▼
TASK-4.3 [P]  TASK-4.2 [P]  TASK-4.4 [P]
(GoalZone+HUD) (Ball+Paddle)  (Overlays)
    │               │              │
    └───────┬────────┘──────────────┘
            ▼
        TASK-4.5
        (Integration GameScreen)
            │
        TASK-5.1
        (E2E estrutura)
            │
        TASK-5.2
        (E2E gameplay)
```

---

## Oportunidades de Paralelismo

| Grupo | Tasks Paralelas | Dependência Comum | Condição |
|-------|----------------|-------------------|----------|
| Grupo 1 | TASK-1.1 ⚡ TASK-1.2 | — | Sem dependências; módulos diferentes |
| Grupo 2 | TASK-2.1 ⚡ TASK-3.1 ⚡ TASK-3.2 ⚡ TASK-4.1 | TASK-1.1 + TASK-1.2 concluídas | Hooks e layout distintos; sem dependência entre si |
| Grupo 3 | TASK-4.2 ⚡ TASK-4.3 ⚡ TASK-4.4 | TASK-2.1 + TASK-3.4 + TASK-4.1 | Componentes distintos (Ball/Paddle, GoalZone/HUD, Overlays) |

---

## Backlog Priorizado (Ordem de Execução)

| Prioridade | Task | Estimativa | Label | Depende de | `[P]` |
|-----------|------|-----------|-------|------------|-------|
| 1 | TASK-1.1 — Setup Reanimated 3 + RNGH + portrait | P | infra | — | ⚡ TASK-1.2 |
| 2 | TASK-1.2 — types.ts e constants.ts | P | frontend | — | ⚡ TASK-1.1 |
| 3 | TASK-2.1 — useGameState (useReducer) | M | frontend | TASK-1.2 | ⚡ TASK-3.1/3.2/4.1 |
| 4 | TASK-3.2 — useGameLoop núcleo | M | frontend | TASK-1.1, 1.2 | ⚡ TASK-2.1/3.1/4.1 |
| 5 | TASK-3.1 — usePaddleControl | M | frontend | TASK-1.1, 1.2 | ⚡ TASK-2.1/3.2/4.1 |
| 6 | TASK-4.1 — Layout base (GameScreen, GameBoard) | M | frontend | TASK-1.1, 1.2 | ⚡ TASK-2.1/3.1/3.2 |
| 7 | TASK-3.3 — useGameLoop: colisão paddle | M | frontend | TASK-3.2 | Não |
| 8 | TASK-3.4 — useGameLoop: goal zone + borda inferior | M | frontend | TASK-3.3 | Não |
| 9 | TASK-4.2 — Ball.tsx + Paddle.tsx | P | frontend | TASK-1.2 | ⚡ TASK-4.3/4.4 |
| 10 | TASK-4.3 — GoalZone.tsx + HUD.tsx | P | frontend | TASK-1.2, 2.1 | ⚡ TASK-4.2/4.4 |
| 11 | TASK-4.4 — LaunchOverlay + GameOverOverlay | M | frontend | TASK-2.1 | ⚡ TASK-4.2/4.3 |
| 12 | TASK-4.5 — GameScreen: integração completa | M | frontend | TASK-3.4, 3.1, 4.1, 4.2, 4.3, 4.4 | Não |
| 13 | TASK-5.1 — E2E: estrutura, overlays, HUD | M | test | TASK-4.5 | Não |
| 14 | TASK-5.2 — E2E: gameplay core | G | test | TASK-5.1 | Não |

**Caminho crítico:** TASK-1.2 → TASK-3.2 → TASK-3.3 → TASK-3.4 → TASK-4.5 → TASK-5.1 → TASK-5.2

**Tasks que podem iniciar imediatamente (sem dependências):** TASK-1.1, TASK-1.2

---

## Tasks Fora de Escopo / Backlog Futuro

| Item | Motivo do adiamento | US relacionada |
|------|--------------------|--------------------|
| Persistência de high score em SQLite | Out of scope do PRD Feature 1 — feature separada de ranking | US-10 (mencionado nos critérios) |
| Efeitos sonoros e feedback háptico | Out of scope explícito do PRD | US-4, US-5 |
| Fonte customizada CRT (questão aberta #2 do TechSpec) | Configuração de assets nativos; usar monospace como fallback | US-6 |
| Tela de menu / splash | Feature separada | — |
| Testes de performance automatizados (RNF-001, RNF-002) | Requerem dispositivo físico e instrumentação dedicada; validar manualmente | US-10 |
| Comportamento ao retornar de background (questão aberta #4 do TechSpec) | AppState listener — baixo impacto para MVP | US-9 |

---

## Histórico de Revisões

| Versão | Data | Autor | Alterações |
|--------|------|-------|------------|
| 1.0 | 2026-05-30 | Thiago Cavalcante | Versão inicial |
