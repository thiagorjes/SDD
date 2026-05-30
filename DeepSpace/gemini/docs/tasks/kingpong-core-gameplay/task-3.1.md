# TASK-3.1 — Layout Base e Header/Footer

**Feature:** KingPong Core Gameplay
**Documento principal:** [docs/tasks/kingpong-core-gameplay-tasks.md]
**Epic:** EPIC-3 — UI Gameplay | **US:** US-1 — Estética CRT e Layout
**Labels:** `[frontend]` `[UI]`
**Estimativa:** M
**Depende de:** TASK-1.1
**Bloqueia:** TASK-3.2
**Paralelo `[P]`:** Sim — com TASK-2.1
**Status:** `Pendente`

---

## Contexto

Renderizar a estrutura visual do KingPong com as dimensões absolutas solicitadas.

**Referências:**
- PRD: [RF-001 — Fundo rgb(0,0,0). Header 50px, Footer 200px (rgb(25,25,25))] e [P9 — Game Area ocupa todo o espaço restante] e [P6 — Cor verde-radioativo #83e509]
- TechSpec: [ADR-002 — Layout Absoluto para Área de Jogo] e [Seção 2.2 — Estrutura: shared/components Header/Footer]

---

## O que deve ser feito

- [ ] Criar componente de Layout com as cores `rgb(0,0,0)` e `rgb(25,25,25)`.
- [ ] Garantir que a Game Area ocupe o espaço dinâmico central.
- [ ] Definir cores globais no tema.

---

## Guia técnico de implementação

Utilizar Flexbox para a estrutura principal e garantir que as medidas fixas (50px e 200px) sejam respeitadas em diferentes tamanhos de tela.

**Estrutura de arquivos esperada:**
```
src/shared/theme/colors.ts       — Definição de constantes de cores
src/shared/components/Header.tsx — Altura 50px, bg rgb(25,25,25)
src/shared/components/Footer.tsx — Altura 200px, bg rgb(25,25,25)
src/features/Game/GameView.tsx   — Container principal
```

**Pontos de atenção:**
- A Game Area deve ter `flex: 1` para ocupar o espaço entre o Header e o Footer.

---

## Critérios de Aceite

- [ ] Header com exatamente 50px de altura.
- [ ] Footer com exatamente 200px de altura.
- [ ] Backgrounds e cores seguem o código RGB especificado.
- [ ] Testes TDD escritos antes da implementação
- [ ] Sem regressões nos testes existentes
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
