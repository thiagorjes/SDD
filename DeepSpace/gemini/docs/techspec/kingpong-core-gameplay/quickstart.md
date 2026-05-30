# Quickstart: KingPong Core Gameplay

**TechSpec completo:** [docs/techspec/kingpong-core-gameplay-techspec.md](../kingpong-core-gameplay-techspec.md)
**Gerado em:** 29/05/2026

> Guia rápido para implementação. Leia este arquivo antes de começar qualquer task.

---

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Mobile | React Native (Expo ou CLI) |
| Logic | TypeScript |
| Animation | React Native Reanimated v3 |
| Gestures | React Native Gesture Handler |

---

## Estrutura de Pastas

```
src/
├── core/
│   └── physics/         # Lógica matemática (Vetores)
├── features/
│   └── Game/            # UI e Animações
└── shared/
    └── theme/           # Cores e Dimensões fixas
```

---

## Setup Mínimo (ambiente local)

```bash
# 1. Dependências
npm install react-native-reanimated react-native-gesture-handler lucide-react-native

# 2. Reanimated Plugin
# Adicione ao babel.config.js: plugins: ['react-native-reanimated/plugin']

# 3. Executar localmente
npx react-native run-android # ou run-ios
```

---

## Cenários Principais

### RF-003 — Saque Inicial
- **Dado** o app aberto em PAUSED
- **Quando** clicar em Iniciar
- **Então** a bola deve spawnar em Y = (Height * 0.2) com velocidade 20px/s

### RF-004 — Marcar Ponto (Goal)
- **Dado** a bola subindo
- **Quando** (ball_y <= 50) e (ball_x entre 1/2_screen - 30 e 1/2_screen + 30)
- **Então** score++, e a bola continua subindo (sem bounce no goal)

---

## Pontos de Atenção

- **Ângulo Mínimo:** Ao calcular o rebatimento, se `abs(angle_degrees) < 15`, force o ângulo para 15 ou -15 para evitar loops horizontais infinitos.
- **Hitbox:** Lembre-se que o raio da bola é 10px. Os cálculos devem considerar o centro da bola (X, Y) +/- 10px para detecção de colisão exata.
- **CRT Overlay:** Use `pointerEvents="none"` na View das scanlines para não bloquear os toques do jogador.

---

## Cenários de Teste Críticos

- [ ] Validar inversão de X e Y ao atingir a quina superior.
- [ ] Garantir que a bola atravessa o Goal de 60px sem rebater.
- [ ] Confirmar que o paddle ocupa exatamente 30% da largura horizontal da tela.
