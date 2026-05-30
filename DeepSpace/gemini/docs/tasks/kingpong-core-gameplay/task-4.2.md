# TASK-4.2 — Interface de Modais (Pausa e Fim de Jogo)

**Feature:** KingPong Core Gameplay
**Documento principal:** [docs/tasks/kingpong-core-gameplay-tasks.md]
**Epic:** EPIC-4 — Game State | **US:** US-5 — Ciclo de Jogo e Vidas
**Labels:** `[frontend]` `[UI]`
**Estimativa:** M
**Depende de:** TASK-4.1
**Bloqueia:** nenhuma
**Paralelo `[P]`:** Sim
**Status:** `Pendente`

---

## Contexto

Criar a interface visual dos modais que gerenciam o fluxo do jogo (Iniciar, Pausar e Game Over), seguindo a estética visual retrô e as especificações de cores e bordas.

**Referências:**
- PRD: [RF-005 — Sistema de Vidas, Modais e Fim de Jogo] e [P11 — Estilização do Modal (verde-radioativo #83e509)]
- TechSpec: [Seção 2.2 — Estrutura de Pastas (src/features/Modals)]

---

## O que deve ser feito

- [ ] Criar componente base de Modal com fundo escurecido (`rgba(0,0,0,0.7)`).
- [ ] Estilizar o container do popup com a cor `rgb(25,25,25)`.
- [ ] Implementar botões com estética retrô: fundo transparente, borda verde-radioativo (`#83e509`) e texto na mesma cor.
- [ ] Criar variações de conteúdo para os estados: "Iniciar Jogo", "Pausado" e "Game Over".

---

## Guia técnico de implementação

Utilizar o componente `Modal` nativo do React Native ou uma View absoluta com `z-index`.

**Estilo do Botão (P11):**
```typescript
const styles = StyleSheet.create({
  button: {
    backgroundColor: 'transparent',
    borderWidth: 2,
    borderColor: '#83e509',
    padding: 15,
    borderRadius: 4, // Levemente arredondado para estilo terminal
  },
  buttonText: {
    color: '#83e509',
    fontFamily: 'Courier', // Se disponível, ou similar mono-espaçada
    textAlign: 'center',
    fontWeight: 'bold',
  }
});
```

**Pontos de atenção:**
- O modal de Game Over deve exibir a pontuação final da rodada.

---

## Critérios de Aceite

- [ ] Modal de "Iniciar" visível ao abrir o app.
- [ ] Modal de "Game Over" exibe botão "Reiniciar" após perda de 3 vidas.
- [ ] Estética segue rigorosamente as cores e transparências do PRD.
- [ ] Botão responde ao toque com feedback visual (ex: leve alteração na opacidade).
- [ ] Code review aprovado.

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
