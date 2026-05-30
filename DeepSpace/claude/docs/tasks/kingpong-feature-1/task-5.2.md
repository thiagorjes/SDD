# TASK-5.2 — Testes E2E: gameplay core (RF-002, RF-003, RF-004, RF-005, RF-006)

**Feature:** KingPong — Feature 1: Tela de Jogo
**Documento principal:** docs/tasks/kingpong-feature-1-tasks.md
**Epic:** EPIC-5 — Qualidade e Testes E2E | **US:** US-10 — Cobertura E2E de 90% dos fluxos críticos
**Labels:** `test`
**Estimativa:** G (1–2 dias)
**Depende de:** TASK-5.1
**Bloqueia:** nenhuma
**Paralelo `[P]`:** Não
**Status:** `Pendente`

---

## Contexto

Adiciona ao `gameplay.e2e.ts` os cenários de gameplay real. São os testes mais complexos pois dependem de timing e interação com a física do jogo. Alguns cenários requerem `waitFor` com timeout para aguardar eventos assíncronos da UI (ex: bola cair). O objetivo é cobrir happy paths e edge cases críticos de RF-002 a RF-006, privilegiando testes de estado (overlay visível, label correto, score) sobre posição visual exata.

**Referências:**
- PRD: RF-002 (paddle bloqueado em overlays); RF-005 (3 vidas → decremento → GAME_OVER na 3ª perda); RF-006 (play again → reset: score=0, lives=3, label="reiniciar"); RF-004 (goal-zone visível)
- TechSpec: Seção 9.2 (testIDs: `ball`, `paddle`, `goal-zone`, `hud-score`, `hud-lives`, `play-again-button`, `final-score`, `launch-label`)
- Guidelines: `guidelines/testing.md` — mínimo de mocks; preferência por testes reais; timer mocks apenas para flakiness

---

## O que deve ser feito

- [ ] RF-002: verificar que paddle não muda durante overlay (estado indireto — label "iniciar" visível = LAUNCHING = paddle bloqueado)
- [ ] RF-004: verificar que `goal-zone` está visível na game area
- [ ] RF-005: simular 3 perdas de vida com `waitFor`; verificar decrementação de lives e label "continuar"; verificar `GAME_OVER` na 3ª
- [ ] RF-006: verificar reset completo após "play again" — score=0, lives=3, label="reiniciar"
- [ ] Verificar label "continuar" após 1ª perda de vida

---

## Guia técnico de implementação

**Adições ao `tests/e2e/gameplay.e2e.ts`:**

```typescript
  describe('RF-002: Controle do Paddle', () => {
    it('paddle bloqueado durante overlay de pre-launch', async () => {
      // Validação indireta: em LAUNCHING o overlay está visível = paddle bloqueado (RF-002)
      await expect(element(by.id('launch-overlay'))).toBeVisible()
      // Não há API Detox para verificar posição de SharedValue diretamente
      // A implementação do .enabled(gameState === 'PLAYING') garante o bloqueio
    })
  })

  describe('RF-004: Goal Zone', () => {
    it('goal zone está visível na game area', async () => {
      await expect(element(by.id('goal-zone'))).toBeVisible()
    })
  })

  describe('RF-005 / RF-006: Vidas e Game Over', () => {
    it('exibe continuar após perda da primeira vida', async () => {
      await element(by.id('launch-button')).tap()
      // Aguarda a bola cair (INITIAL_BALL_SPEED = 20px/s — pode levar vários segundos)
      await waitFor(element(by.id('launch-overlay')))
        .toBeVisible()
        .withTimeout(60000)
      await expect(element(by.id('launch-label'))).toHaveText('continuar')
      await expect(element(by.id('hud-lives'))).toHaveText('♥ 2')
    })

    it('exibe game over após 3 perdas de vida', async () => {
      // Perda 1
      await element(by.id('launch-button')).tap()
      await waitFor(element(by.id('launch-overlay')))
        .toBeVisible().withTimeout(60000)
      // Perda 2
      await element(by.id('launch-button')).tap()
      await waitFor(element(by.id('launch-overlay')))
        .toBeVisible().withTimeout(60000)
      // Perda 3 → GAME_OVER (sem overlay de pre-launch)
      await element(by.id('launch-button')).tap()
      await waitFor(element(by.id('game-over-overlay')))
        .toBeVisible().withTimeout(60000)
      await expect(element(by.id('launch-overlay'))).not.toBeVisible()
    })

    it('reseta o jogo corretamente após play again', async () => {
      // Chegar ao GAME_OVER (reusar helper ou repetir as 3 perdas)
      await element(by.id('launch-button')).tap()
      await waitFor(element(by.id('game-over-overlay')))
        .toBeVisible().withTimeout(180000)  // timeout maior para as 3 quedas

      await element(by.id('play-again-button')).tap()

      await expect(element(by.id('launch-overlay'))).toBeVisible()
      await expect(element(by.id('launch-label'))).toHaveText('reiniciar')
      await expect(element(by.id('hud-score'))).toHaveText('0')
      await expect(element(by.id('hud-lives'))).toHaveText('♥ 3')
    })
  })
```

**Pontos de atenção:**
- `waitFor` com timeout de 60s é necessário para aguardar a bola cair naturalmente (`INITIAL_BALL_SPEED = 20 px/s`) — o tempo real depende do layout do dispositivo; ajuste o timeout se necessário
- O teste de "3 perdas de vida" pode ser flakey se o timeout for muito curto em dispositivos lentos — `withTimeout(60000)` por perda é o mínimo seguro
- Para o teste de "reset após play again", usar timeout de 180s (3 quedas × 60s each)
- Testes de física exata (score incrementado ao atravessar a goal zone) são difíceis de automatizar via Detox sem controle de velocidade da bola — deixar como "best effort" ou testar manualmente
- Se um teste for cronicamente flakey após 3 execuções, adicionar `.skip` temporariamente e registrar na seção `## Histórico de Issues` deste arquivo

---

## Critérios de Aceite

- [ ] RF-004: `goal-zone` visível em `game-area`
- [ ] RF-005: label "continuar" e `hud-lives` = "♥ 2" após 1ª perda
- [ ] RF-005: `game-over-overlay` visível após 3ª perda; `launch-overlay` não visível
- [ ] RF-006: após "play again" → label "reiniciar", `hud-score` = "0", `hud-lives` = "♥ 3"
- [ ] Todos os testes passam 3× consecutivas sem flakiness
- [ ] `npx detox test --configuration android.emu.debug` verde
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
