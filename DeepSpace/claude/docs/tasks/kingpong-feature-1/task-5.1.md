# TASK-5.1 — Testes E2E: estrutura, overlays e HUD (RF-001, RF-007, RF-008)

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-5 — Qualidade e Testes E2E | **US:** US-10 — Cobertura E2E de 90% dos fluxos críticos
**Labels:** `test`
**Estimativa:** M (4–8h)
**Depende de:** TASK-4.5
**Bloqueia:** TASK-5.2
**Paralelo `[P]`:** Não
**Status:** `Pendente`

---

## Contexto

Configura o Detox (se necessário) e implementa os primeiros cenários E2E: verificação da estrutura visual, comportamento dos overlays e atualização do HUD. São os testes mais fáceis de implementar pois não dependem de timing da física da bola. Seguem a estrutura padrão de `guidelines/testing.md` com os `testID` definidos no TechSpec seção 9.2.

**Referências:**
- PRD: RF-001 critérios de aceite; RF-007 critérios; RF-008 critérios (incluindo "toque fora do botão = sem ação")
- TechSpec: Seção 9.2 (testIDs completos: `game-area`, `footer`, `launch-overlay`, `launch-button`, `launch-label`, `hud-score`, `hud-lives`)
- Guidelines: `guidelines/testing.md` — estrutura `describe/beforeAll/beforeEach`, Arrange/Act/Assert

---

## O que deve ser feito

- [ ] Verificar/configurar Detox (`.detoxrc.js` — configuração de emulador Android e simulador iOS)
- [ ] Criar `tests/e2e/gameplay.e2e.ts` com o `describe('KingPong — Feature 1')` principal
- [ ] RF-001: "KingPong" visível; `game-area` e `footer` visíveis
- [ ] RF-008: label "iniciar" na primeira abertura; toque no botão dispara lançamento; toque fora do botão não dispara
- [ ] RF-007: `hud-score` e `hud-lives` visíveis durante jogo e atrás do overlay

---

## Guia técnico de implementação

**Estrutura de arquivos esperada:**
```
tests/e2e/gameplay.e2e.ts  — arquivo principal de testes E2E
.detoxrc.js                — configuração Detox
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
    it('exibe KingPong no header ao iniciar', async () => {
      await expect(element(by.text('KingPong'))).toBeVisible()
    })

    it('exibe game-area e footer', async () => {
      await expect(element(by.id('game-area'))).toBeVisible()
      await expect(element(by.id('footer'))).toBeVisible()
    })
  })

  describe('RF-008: Overlay de Pre-Launch', () => {
    it('exibe label iniciar na primeira abertura', async () => {
      await expect(element(by.id('launch-overlay'))).toBeVisible()
      await expect(element(by.id('launch-label'))).toHaveText('iniciar')
    })

    it('fecha overlay ao tocar no botão de lançamento', async () => {
      await element(by.id('launch-button')).tap()
      await expect(element(by.id('launch-overlay'))).not.toBeVisible()
    })

    it('mantém overlay ao tocar fora do botão', async () => {
      // Toca no container do overlay (não no botão)
      await element(by.id('launch-overlay')).tap()
      await expect(element(by.id('launch-overlay'))).toBeVisible()
    })
  })

  describe('RF-007: HUD', () => {
    it('exibe score e lives durante o jogo', async () => {
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
- `beforeEach: device.reloadReactNative()` reseta o app a cada teste — garante estado `LAUNCHING` inicial
- `device.launchApp({ newInstance: true })` em `beforeAll` — inicia o app limpo
- O teste "mantém overlay ao tocar fora do botão" usa `element(by.id('launch-overlay')).tap()` — o toque vai para o container; por ser `View` sem `onPress`, não dispara nada
- Comando E2E: `npx detox test --configuration android.emu.debug` (ver `guidelines/testing.md`)

---

## Critérios de Aceite

- [ ] `npx detox test --configuration android.emu.debug` passa em todos os testes desta task
- [ ] RF-001: "KingPong" visível; `game-area` e `footer` existem
- [ ] RF-008: label "iniciar" correto; botão dispara lançamento; fora do botão = sem ação
- [ ] RF-007: HUD visível durante jogo; HUD visível atrás do overlay
- [ ] Testes passam 3× consecutivas sem flakiness
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
