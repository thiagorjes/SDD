# TASK-4.3 — Componentes GoalZone e HUD

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-4 — Interface Visual e Integração | **US:** US-7 — GoalZone visual e HUD
**Labels:** `frontend`
**Estimativa:** P (até 4h)
**Depende de:** TASK-1.2, TASK-2.1
**Bloqueia:** TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-4.2, TASK-4.4
**Status:** `Pendente`

---

## Contexto

`GoalZone.tsx` é um componente estático que indica visualmente a goal zone — a bola passa por ela sem rebater (pass-through), então é puramente visual. `HUD.tsx` exibe pontuação e vidas recebidas via props do React state; usa `React.memo` para evitar re-renders desnecessários. O HUD permanece visível atrás dos overlays (`zIndex: 1` < overlays `zIndex: 10`).

**Referências:**
- PRD: RF-004 — "goal zone visível como área demarcada no centro com 60px de largura"; RF-007 — "pontuação e vidas visíveis em todo momento"; "HUD permanece visível atrás do overlay"; RNF-004 (suportar pontuações até 999.999)
- TechSpec: Seção 3.3 (GOAL_ZONE_WIDTH=60, GOAL_ZONE_HEIGHT=20, COLOR_GOAL_ZONE_FILL, COLOR_GOAL_ZONE_BORDER, COLOR_CRT_GREEN), Seção 9.2 (testIDs: `goal-zone`, `hud-score`, `hud-lives`)
- Guidelines: `guidelines/coding-standards.md` (React.memo, interface de props tipada)

---

## O que deve ser feito

- [ ] Criar `src/features/game/components/GoalZone.tsx` — retângulo centralizado com borda `COLOR_GOAL_ZONE_BORDER` e fundo `COLOR_GOAL_ZONE_FILL`
- [ ] Criar `src/features/game/components/HUD.tsx` — score (top-left) e lives (top-right) com `React.memo`
- [ ] `GoalZone` recebe `gameAreaWidth` e `gameAreaHeight` para calcular posição centralizada
- [ ] `HUD` recebe `score: number` e `lives: number`; `pointerEvents="none"` para não bloquear toques

---

## Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/components/GoalZone.tsx  — goal zone estática
src/features/game/components/HUD.tsx       — score e lives
```

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
    <View testID="goal-zone" style={[styles.zone, { left, top }]} />
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
- `pointerEvents="none"` no HUD garante que toques sobre o HUD não interferem com gestos no footer
- `GoalZone` usa `position: 'absolute'` relativo ao `GameBoard` (que tem `overflow: 'hidden'`)
- `zIndex: 1` no HUD — abaixo dos overlays (que usarão `zIndex: 10`)
- Testar visualmente `score = 999999` para garantir que o layout não quebra (RNF-004)
- A posição da GoalZone calculada aqui deve corresponder à detecção no worklet (TASK-3.4): `goalTop = gameAreaHeight/2 - GOAL_ZONE_HEIGHT/2` — idêntica ao cálculo no hook

---

## Critérios de Aceite

- [ ] GoalZone visível no centro da game area com borda `COLOR_GOAL_ZONE_BORDER` e fundo semi-transparente
- [ ] HUD exibe score (top-left) e lives (top-right) em `COLOR_CRT_GREEN`
- [ ] HUD não bloqueia toques (pointerEvents="none")
- [ ] HUD com `zIndex: 1` — visível atrás de overlays com `zIndex: 10`
- [ ] Score `999999` não quebra layout
- [ ] `testID` presentes: `goal-zone`, `hud-score`, `hud-lives`
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
