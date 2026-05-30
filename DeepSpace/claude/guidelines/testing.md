# Estratégia de Testes — KingPong

## Pirâmide de Testes

| Tipo | Ferramenta | Cobertura mínima | Localização | Velocidade esperada |
|------|-----------|-----------------|-------------|---------------------|
| E2E (ponta a ponta) | Detox | 90% dos fluxos críticos | `tests/e2e/` | < 60s/fluxo |

> **Nota:** cobertura de 90% aqui refere-se a fluxos críticos do jogo cobertos por testes E2E — não a cobertura de linhas de código (Detox não mede isso nativamente). Fluxo crítico = qualquer caminho que impacte a experiência principal do jogador.

## Fluxos Críticos (exemplos)

- Iniciar uma partida do zero
- Completar uma rodada e salvar pontuação
- Visualizar ranking
- Alterar configurações e persistir entre sessões

## Estrutura de Pasta

```
tests/
└── e2e/                  # Testes E2E com Detox
    ├── firstLaunch.e2e.ts
    ├── gameplay.e2e.ts
    └── ranking.e2e.ts
```

## Estrutura Padrão de Teste E2E (Detox)

```ts
describe('Gameplay', () => {
  beforeAll(async () => {
    await device.launchApp()
  })

  it('deve salvar pontuação ao terminar uma partida', async () => {
    // Arrange
    await element(by.id('btn-play')).tap()

    // Act
    await element(by.id('btn-end-game')).tap()

    // Assert
    await expect(element(by.id('score-saved-indicator'))).toBeVisible()
  })
})
```

## Estratégia de Mocks

Preferência por testes reais — mínimo de mocks. Mocks apenas para:
- Módulos nativos sem suporte em simulador (ex: sensores específicos de hardware)
- Timers em testes de animação que causariam flakiness

## IDs de Teste

Todo elemento interativo e indicador de estado relevante deve ter `testID` definido:

```tsx
<TouchableOpacity testID="btn-play" onPress={startGame}>
```

## Rodando os Testes

```bash
# E2E Android
npx detox test --configuration android.emu.debug

# E2E iOS
npx detox test --configuration ios.sim.debug
```
