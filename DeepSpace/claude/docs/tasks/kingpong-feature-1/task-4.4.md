# TASK-4.4 — Overlays: LaunchOverlay e GameOverOverlay

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-4 — Interface Visual e Integração | **US:** US-8 — Overlays de lançamento e game over
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-2.1
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-4.2, TASK-4.3
**Status:** `Pendente`

---

## Contexto

`LaunchOverlay.tsx` exibido quando `gameState === 'LAUNCHING'`: vidas restantes e botão com label variável — "iniciar" (1ª abertura), "continuar" (após perda de vida), "reiniciar" (após play again). `GameOverOverlay.tsx` exibido quando `gameState === 'GAME_OVER'`: pontuação final e botão "play again". Ambos têm debounce de `LAUNCH_BUTTON_DEBOUNCE_MS` (300ms). O container do overlay NÃO tem `onPress` — apenas o botão interno (RF-008: "toque fora do botão → overlay permanece").

**Referências:**
- PRD: RF-008 — "exibe vidas restantes"; "botão: 'iniciar'/'continuar'/'reiniciar'"; "toque fora do botão → overlay permanece"; "apenas um overlay por vez"; RF-006 — "pontuação final em destaque"; "'play again' → debounce (processado apenas 1×)"; RN-009 (3 rótulos do botão)
- TechSpec: Seção 3.3 (LAUNCH_BUTTON_DEBOUNCE_MS=300), Seção 9.2 (testIDs: `launch-overlay`, `launch-button`, `launch-label`, `game-over-overlay`, `play-again-button`, `final-score`)
- Guidelines: `guidelines/coding-standards.md` (PascalCase componentes, useCallback)

---

## O que deve ser feito

- [ ] Criar `src/features/game/components/LaunchOverlay.tsx` com debounce e label dinâmico
- [ ] Criar `src/features/game/components/GameOverOverlay.tsx` com debounce e score final
- [ ] Overlay cobre toda a game area via `StyleSheet.absoluteFillObject`
- [ ] `zIndex: 10` (acima do HUD com `zIndex: 1`)
- [ ] Apenas o botão interno tem `onPress` — container do overlay não

---

## Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/components/LaunchOverlay.tsx    — overlay de pre-launch
src/features/game/components/GameOverOverlay.tsx  — overlay de game over
```

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
- Container do overlay NÃO tem `onPress` — só o `TouchableOpacity` interno → "toque fora do botão = sem ação" (RF-008)
- `StyleSheet.absoluteFillObject` = `{ position: 'absolute', left: 0, right: 0, top: 0, bottom: 0 }` — cobre toda a game area quando filho do GameBoard
- Debounce com `useRef<number>` não causa re-render (ao contrário de `useState`)
- `zIndex: 10` > HUD `zIndex: 1` — overlays ficam acima do HUD

---

## Critérios de Aceite

- [ ] `LaunchOverlay` exibe `♥ {lives}` e botão com label dinâmico (`LaunchLabel`)
- [ ] Labels corretos: "iniciar", "continuar", "reiniciar" conforme prop
- [ ] Toque fora do botão → overlay permanece (container sem `onPress`)
- [ ] Duplo toque rápido no botão → `onLaunch` chamado apenas 1×
- [ ] `GameOverOverlay` exibe score final e botão "play again"
- [ ] Todos os `testID` presentes: `launch-overlay`, `launch-button`, `launch-label`, `game-over-overlay`, `play-again-button`, `final-score`
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
