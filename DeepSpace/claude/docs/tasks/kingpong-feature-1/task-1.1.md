# TASK-1.1 — Instalar e configurar Reanimated 3, RNGH e portrait-only

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-1 — Infraestrutura e Fundação | **US:** US-1 — Ambiente de desenvolvimento configurado
**Labels:** `infra`
**Estimativa:** P (até 4h)
**Depende de:** nenhuma
**Bloqueia:** TASK-2.1, TASK-3.1, TASK-3.2, TASK-4.1, TASK-4.2
**Paralelo `[P]`:** Sim — pode executar simultaneamente com TASK-1.2
**Status:** `Concluída — 2026-05-30`

---

## Contexto

Esta task instala e configura as duas dependências centrais de toda a feature: `react-native-reanimated` (game loop no UI thread via `useFrameCallback`) e `react-native-gesture-handler` (controle do paddle com latência ≤ 16ms). Sem estas bibliotecas instaladas e configuradas corretamente, nenhuma outra task de física ou controle pode avançar. A orientação portrait-only também é configurada aqui via manifesto nativo.

**Referências:**
- PRD: Restrições — "Stack tecnológica fixada: React Native CLI com TypeScript, sem Expo"; "Orientação fixada em portrait-only"
- TechSpec: Seção 1.3 (Stack), ADR-001 (Reanimated 3), ADR-002 (RNGH)
- Guidelines: `guidelines/stack.md` — React Native CLI 0.73+

---

## O que deve ser feito

- [ ] Instalar `react-native-reanimated@3.x` e `react-native-gesture-handler@2.x` via npm
- [ ] Adicionar `react-native-reanimated/plugin` ao `babel.config.js` (obrigatório para worklets)
- [ ] Envolver o app em `GestureHandlerRootView` no `App.tsx`
- [ ] Configurar portrait-only no `AndroidManifest.xml`
- [ ] Configurar portrait-only no `Info.plist` (iOS)
- [ ] Instalar pods do iOS: `cd ios && pod install`
- [ ] Verificar que o app builda sem erros em Android e iOS

---

## Guia técnico de implementação

**Estrutura de arquivos alterados:**
```
babel.config.js                                    — adicionar plugin Reanimated
App.tsx                                            — GestureHandlerRootView + SafeAreaProvider
android/app/src/main/AndroidManifest.xml           — screenOrientation="portrait"
ios/[NomeProjeto]/Info.plist                       — UISupportedInterfaceOrientations
```

**Padrão a seguir:**

```bash
npm install react-native-reanimated react-native-gesture-handler react-native-safe-area-context
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
import { SafeAreaProvider } from 'react-native-safe-area-context'
import { GameScreen } from './src/features/game/screens/GameScreen'

export default function App() {
  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <GameScreen />
      </SafeAreaProvider>
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
- O plugin do Reanimated no `babel.config.js` DEVE ser o último da lista; caso contrário, worklets não compilam
- `GestureHandlerRootView` deve envolver TODO o app, não apenas a tela do jogo
- `SafeAreaProvider` também deve envolver o app (necessário para `useSafeAreaInsets` em TASK-4.1)
- Após alterar `babel.config.js`, limpar cache: `npx react-native start --reset-cache`

---

## Critérios de Aceite

- [ ] `npx react-native run-android` e `run-ios` completam sem erros de build
- [ ] App não trava ao girar o dispositivo (permanece em portrait)
- [ ] Import de `useSharedValue` de `react-native-reanimated` funciona sem erro
- [ ] Import de `GestureDetector` de `react-native-gesture-handler` funciona sem erro
- [ ] Sem regressões nos testes existentes
- [ ] Code review aprovado seguindo `guidelines/coding-standards.md`

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
