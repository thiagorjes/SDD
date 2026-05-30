# Estratégia de Testes

## Foco Principal
**Testes de Ponta a Ponta (E2E)**

Justificativa: Para uma POC de jogo, garantir que o fluxo principal (jogar e marcar pontos) funciona é mais valioso que testes unitários granulares inicialmente.

| Tipo | Ferramenta | Cobertura Meta | Localização |
|------|-----------|-----------------|-------------|
| E2E | Detox | 90% (fluxos críticos) | `/e2e` |

## Estrutura de Teste (Detox)
```javascript
describe('Game Flow', () => {
  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should start game from menu', async () => {
    await element(by.id('start-button')).tap();
    await expect(element(by.id('game-board'))).toBeVisible();
  });
});
```

## Estratégia de Mocks
- **Preferência por testes reais**: Evitar mocks para validar o comportamento real do jogo.
- Mockar apenas módulos nativos complexos que não podem ser executados no simulador (ex: Sensores de movimento específicos se houver).
