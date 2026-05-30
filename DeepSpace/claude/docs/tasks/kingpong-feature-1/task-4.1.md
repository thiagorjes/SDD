# TASK-4.1 — Layout base: GameScreen, Header, GameBoard, Footer

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-4 — Interface Visual e Integração | **US:** US-6 — Estrutura visual da tela de jogo
**Labels:** `frontend`
**Estimativa:** M (4–8h)
**Depende de:** TASK-1.1, TASK-1.2
**Bloqueia:** TASK-4.2, TASK-4.3, TASK-4.4, TASK-4.5
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-2.1, TASK-3.1, TASK-3.2
**Status:** `Pendente`

---

## Contexto

Cria o esqueleto visual da tela de jogo. `GameScreen.tsx` organiza três regiões verticais (header 8%, game area 70%, footer 22%) via `useWindowDimensions` e `useSafeAreaInsets`. As dimensões da game area devem ser acessíveis para os hooks de física e controle (TASK-4.5 as passa como parâmetros). Header exibe "KingPong" em estilo CRT; footer é a zona de controle do paddle. `GameBoard` tem `overflow: 'hidden'` para clipar elementos além dos limites.

**Referências:**
- PRD: RF-001 — "header exibe 'KingPong' centralizado com fonte CRT em verde"; "fundo do header é visivelmente mais claro que o fundo da área de jogo"; "três regiões distintas sem sobreposição"; "adaptam-se proporcionalmente a diferentes tamanhos de tela"
- TechSpec: Seção 2.2 (estrutura de pastas), Seção 3.3 (HEADER_HEIGHT_RATIO=0.08, FOOTER_HEIGHT_RATIO=0.22, todas as cores)
- Guidelines: `guidelines/architecture.md` (estrutura de pastas feature-based), `guidelines/coding-standards.md` (PascalCase componentes)

---

## O que deve ser feito

- [ ] Criar `src/features/game/screens/GameScreen.tsx` (esqueleto sem hooks, apenas layout)
- [ ] Criar `src/features/game/components/GameBoard.tsx` (container da área de jogo com `overflow: 'hidden'` e suporte a `children`)
- [ ] Usar `useWindowDimensions` + `useSafeAreaInsets` para calcular alturas responsivas
- [ ] Aplicar cores: `COLOR_BG_HEADER`, `COLOR_BG_GAME`, `COLOR_BG_FOOTER`
- [ ] Header: texto "KingPong" centralizado em `COLOR_CRT_GREEN`
- [ ] Adicionar `testID="footer"` e `testID="game-area"`

---

## Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
src/features/game/screens/GameScreen.tsx    — orquestrador (esqueleto nesta task)
src/features/game/components/GameBoard.tsx  — container da área de jogo
```

**Padrão a seguir:**

```tsx
// src/features/game/screens/GameScreen.tsx (esqueleto desta task)
import { View, Text, StyleSheet, useWindowDimensions } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import { GameBoard } from '../components/GameBoard'
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

  return (
    <View style={[styles.container, { paddingTop: insets.top }]}>
      <View style={[styles.header, { height: headerHeight }]}>
        <Text style={styles.title}>KingPong</Text>
      </View>
      <GameBoard width={width} height={gameAreaHeight} />
      <View testID="footer" style={[styles.footer, { height: footerHeight }]} />
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

```tsx
// src/features/game/components/GameBoard.tsx
import { View, StyleSheet } from 'react-native'
import type { ReactNode } from 'react'
import { COLOR_BG_GAME } from '../constants'

interface GameBoardProps {
  width: number
  height: number
  children?: ReactNode
}

export function GameBoard({ width, height, children }: GameBoardProps) {
  return (
    <View testID="game-area" style={[styles.board, { width, height }]}>
      {children}
    </View>
  )
}

const styles = StyleSheet.create({
  board: { backgroundColor: COLOR_BG_GAME, overflow: 'hidden' },
})
```

**Pontos de atenção:**
- `overflow: 'hidden'` no `GameBoard` é essencial — clipa a bola ao sair da área visualmente
- `Math.round()` nos cálculos de altura evita gaps visuais de 1px entre regiões
- `react-native-safe-area-context` deve ter sido instalado em TASK-1.1 — usar `useSafeAreaInsets` para dispositivos com notch/home indicator
- Fonte CRT: usar `letterSpacing: 4` e `fontFamily: 'monospace'` como fallback (questão aberta #2 do TechSpec)

---

## Critérios de Aceite

- [ ] Três regiões visíveis e distintas sem sobreposição
- [ ] Header exibe "KingPong" centralizado em `COLOR_CRT_GREEN`
- [ ] `COLOR_BG_HEADER` visivelmente diferente de `COLOR_BG_GAME`
- [ ] Layout adapta-se a diferentes tamanhos de tela (360px e 430px de largura)
- [ ] `testID="footer"` e `testID="game-area"` presentes
- [ ] `GameBoard` aceita `children` (necessário para TASK-4.5)
- [ ] Sem gap visual entre regiões
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
