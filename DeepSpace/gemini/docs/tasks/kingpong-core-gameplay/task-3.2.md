# TASK-3.2 — Efeitos CRT (Scanlines e Flicker)

**Feature:** KingPong Core Gameplay
**Documento principal:** [docs/tasks/kingpong-core-gameplay-tasks.md]
**Epic:** EPIC-3 — UI Gameplay | **US:** US-1 — Estética CRT e Layout
**Labels:** `[frontend]` `[UI]`
**Estimativa:** M
**Depende de:** TASK-3.1
**Bloqueia:** nenhuma
**Paralelo `[P]`:** Sim
**Status:** `Pendente`

---

## Contexto

Implementar a estética retrô utilizando overlays visuais.

**Referências:**
- PRD: [RF-001 — Camadas sobrepostas: Linhas fixas e Scanline animada] e [P7 — Linhas 1px espaçadas 2px, 80% transparência. Scanline 10px com gradiente]
- TechSpec: [Seção 6.1 — Scanline animada usando Native Driver para consumo zero de CPU]

---

## O que deve ser feito

- [ ] Criar overlay de linhas fixas (1px espessura, 2px espaço).
- [ ] Implementar animação de Scanline (barra de 10px) que percorre a tela verticalmente.

---

## Guia técnico de implementação

Para as linhas fixas, utilizar uma View absoluta com background repetido ou gerada programaticamente. Para a scanline, usar `Animated` ou `Reanimated` com `useNativeDriver: true`.

**Estrutura de arquivos esperada:**
```
src/features/Game/components/CRTOverlay.tsx — Componente de efeito
```

**Pontos de atenção:**
- O efeito deve estar *sobre* todos os elementos de jogo (bola, paddle, goal), mas pode estar abaixo de modais de sistema se preferível. No PRD P6 diz que elementos principais usam verde-radioativo, o overlay deve unificar o visual.

---

## Critérios de Aceite

- [ ] Linhas horizontais visíveis com 80% de transparência.
- [ ] Scanline de 10px percorrendo a tela de cima a baixo em loop.
- [ ] Performance de 60 FPS mantida (RNF-001).
- [ ] Testes TDD escritos antes da implementação
- [ ] Sem regressões nos testes existentes
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
