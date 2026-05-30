# Tasks: KingPong Core Gameplay

**Versão:** 1.1
**Data:** 29/05/2026
**Autor:** thiago cavalcante
**PRD:** [docs/prd/kingpong-core-gameplay-prd.md]
**TechSpec:** [docs/techspec/kingpong-core-gameplay-techspec.md]

---

## Resumo de Escopo

| Métrica | Quantidade |
|---------|-----------|
| Epics | 5 |
| User Stories | 6 |
| Tasks | 9 |
| Estimativa total | 12-14 dias |

---

## Épicos

| ID | Nome | Descrição | US relacionadas |
|----|------|-----------|-----------------|
| EPIC-1 | Setup & Infra | Configuração inicial da stack mobile | US-0 |
| EPIC-2 | Core Physics | Engine matemática de colisão e vetores | US-2, US-3, US-4 |
| EPIC-3 | UI Gameplay | Componentes visuais (Paddle, Ball, Goal) | US-1, US-2 |
| EPIC-4 | Game State | Máquina de estados e lógica de vidas | US-5 |
| EPIC-5 | Persistence | Recordes locais com SQLite | US-6 |

---

## [EPIC-1] — Setup & Infra

### US-0: Bootstrap do Projeto

#### ✅ Concluída TASK-1.1 — Configuração Inicial React Native
**Epic:** EPIC-1 | **US:** US-0
**Labels:** `[infra]` `[frontend]`
**Estimativa:** M
**Depende de:** nenhuma
**Bloqueia:** TASK-1.2, TASK-3.1
**Paralelo `[P]`:** Não

##### Contexto
Esta tarefa consiste em inicializar o projeto React Native com TypeScript e configurar as bibliotecas base (Reanimated, Gesture Handler) para suportar os requisitos de alta performance (RNF-001).

**Referências:**
- TechSpec: Seção 1.3 (Stack Tecnológica) e Seção 2.2 (Estrutura de Pastas).
- Guidelines: `stack.md` e `architecture.md`.

##### O que deve ser feito
- [ ] Inicializar projeto RN com TypeScript.
- [ ] Instalar e configurar `react-native-reanimated` v3 e `react-native-gesture-handler`.
- [ ] Configurar `babel.config.js` com o plugin do Reanimated.
- [ ] Criar estrutura de pastas base (`src/core`, `src/features`, `src/shared`).

##### Critérios de Aceite
- [ ] Projeto compila e roda em simulador/device.
- [ ] `react-native-reanimated` funcionando (teste de animação simples).
- [ ] Estrutura de diretórios segue o TechSpec.

---

## [EPIC-2] — Core Physics

### US-2: Controle do Paddle (Física)
### US-3: Movimento da Bolinha (Física)

#### TASK-2.1 — Motor de Vetores e Ângulo Mínimo
**Epic:** EPIC-2 | **US:** US-3
**Labels:** `[core]` `[logic]`
**Estimativa:** G
**Depende de:** TASK-1.1
**Bloqueia:** TASK-2.2
**Paralelo `[P]`:** Sim — com TASK-3.1

##### Contexto
Implementar a lógica matemática que move a bola e garante que ela nunca fique presa em loops horizontais (trava de 15 graus).

**Referências:**
- PRD: RF-003 (Ângulo mínimo 15 graus).
- TechSpec: Seção 2.3 (Fluxo de Dados: Movimentação).

##### O que deve ser feito
- [ ] Criar hook ou utilitário de física para cálculo de reflexão elástica.
- [ ] Implementar trava matemática para ângulos < 15° com a horizontal.
- [ ] Implementar lógica de inversão dupla em colisões de quina (P12).

---

#### TASK-2.2 — Colisão Dinâmica Paddle/Bola
**Epic:** EPIC-2 | **US:** US-2
**Labels:** `[core]` `[logic]`
**Estimativa:** G
**Depende de:** TASK-2.1
**Bloqueia:** TASK-4.1
**Paralelo `[P]`:** Não

##### Contexto
A física de rebatimento no paddle não é fixa; ela depende do ponto de impacto para permitir "efeito" na bola.

**Referências:**
- PRD: RF-002 e P4 (Física de desvio baseada na zona de contato).

##### O que deve ser feito
- [ ] Implementar detecção de intersecção estrita (sem sobreposição).
- [ ] Calcular vetor resultante baseado na distância entre o centro da bola e o centro do paddle no momento do impacto.

---

#### TASK-2.3 — Detecção de Goal (Pontuação)
**Epic:** EPIC-2 | **US:** US-4
**Labels:** `[core]` `[logic]`
**Estimativa:** M
**Depende de:** TASK-2.1
**Bloqueia:** TASK-4.1
**Paralelo `[P]`:** Sim

##### Contexto
Implementar a lógica que detecta quando a bola atravessa o "buraco" de 60px no topo sem rebater, incrementando a pontuação.

**Referências:**
- PRD: RF-004 e P10 (Goal de 60px).

---

## [EPIC-3] — UI Gameplay

### US-1: Estética CRT e Layout

#### TASK-3.1 — Layout Base e Header/Footer
**Epic:** EPIC-3 | **US:** US-1
**Labels:** `[frontend]` `[UI]`
**Estimativa:** M
**Depende de:** TASK-1.1
**Bloqueia:** TASK-3.2
**Paralelo `[P]`:** Sim — com TASK-2.1

##### Contexto
Renderizar a estrutura visual do KingPong com as dimensões absolutas solicitadas.

**Referências:**
- PRD: RF-001 e P9 (Header 50px, Footer 200px).

##### O que deve ser feito
- [ ] Criar componente de Layout com as cores `rgb(0,0,0)` e `rgb(25,25,25)`.
- [ ] Garantir que a Game Area ocupe o espaço dinâmico central.

---

#### TASK-3.2 — Efeitos CRT (Scanlines e Flicker)
**Epic:** EPIC-3 | **US:** US-1
**Labels:** `[frontend]` `[UI]`
**Estimativa:** M
**Depende de:** TASK-3.1
**Bloqueia:** nenhuma
**Paralelo `[P]`:** Sim

##### Contexto
Implementar a estética retrô utilizando overlays visuais.

**Referências:**
- PRD: RF-001 e P7 (Linhas de 1px com 2px de espaço, Scanline 10px animada).

---

## [EPIC-4] — Game State

### US-5: Ciclo de Jogo e Vidas

#### TASK-4.1 — Máquina de Estados (Round Control)
**Epic:** EPIC-4 | **US:** US-5
**Labels:** `[logic]` `[frontend]`
**Estimativa:** G
**Depende de:** TASK-2.2
**Bloqueia:** TASK-4.2
**Paralelo `[P]`:** Não

##### Contexto
Gerenciar os estados PAUSED, PLAYING, LIFE_LOST e GAME_OVER.

**Referências:**
- PRD: RF-005 e P5.

---

#### TASK-4.2 — UI de Modais (Iniciar/GameOver)
**Epic:** EPIC-4 | **US:** US-5
**Labels:** `[frontend]` `[UI]`
**Estimativa:** M
**Depende de:** TASK-4.1
**Bloqueia:** nenhuma
**Paralelo `[P]`:** Sim

##### Contexto
Desenvolver os componentes visuais de Modal seguindo a estética CRT e os requisitos de layout do PRD.

**Referências:**
- PRD: RF-005 e P11 (UI dos modais).

---

## [EPIC-5] — Persistence

### US-6: Sistema de Recordes

#### TASK-5.1 — Integração SQLite e Persistência
**Epic:** EPIC-5 | **US:** US-6
**Labels:** `[backend]` `[database]`
**Estimativa:** M
**Depende de:** TASK-1.1
**Bloqueia:** nenhuma
**Paralelo `[P]`:** Sim

##### Contexto
Implementar a persistência local da tabela `Score` para salvar os recordes das partidas.

**Referências:**
- TechSpec: Seção 3 (Modelagem de Dados).

---

## Dependências entre Tasks (Visão Geral)

```
TASK-1.1 (Setup)
  ├── TASK-3.1 (Layout UI) ⚡ [P]
  │     └── TASK-3.2 (CRT Effects)
  ├── TASK-2.1 (Vector Physics) ⚡ [P]
  │     ├── TASK-2.2 (Paddle Collision)
  │     │     └── TASK-4.1 (Game States)
  │     │           └── TASK-4.2 (Modal UI)
  │     └── TASK-2.3 (Goal Detection) ⚡ [P]
  └── TASK-5.1 (SQLite Score) ⚡ [P]
```

---

## Backlog Priorizado (Ordem de Execução)

| Prioridade | Task | Estimativa | Label | Depende de | `[P]` |
|-----------|------|-----------|-------|------------|-------|
| 1 | TASK-1.1 — Configuração Inicial | M | infra | — | — | ✅ Concluída (29/05/2026) |
| 2 | TASK-2.1 — Motor de Vetores | G | core | TASK-1.1 | ⚡ |
| 3 | TASK-3.1 — Layout Base | M | UI | TASK-1.1 | ⚡ |
| 4 | TASK-5.1 — SQLite Score | M | db | TASK-1.1 | ⚡ |
| 5 | TASK-2.2 — Colisão Dinâmica | G | core | TASK-2.1 | — |
| 6 | TASK-2.3 — Detecção de Goal | M | core | TASK-2.1 | ⚡ |
| 7 | TASK-3.2 — Efeitos CRT Overlay | M | UI | TASK-3.1 | ⚡ |
| 8 | TASK-4.1 — Máquina de Estados | G | logic | TASK-2.2 | — |
| 9 | TASK-4.2 — UI de Modais | M | UI | TASK-4.1 | ⚡ |

---

## Histórico de Revisões

| Versão | Data | Autor | Alterações |
|--------|------|-------|------------|
| 1.0 | 29/05/2026 | thiago cavalcante | Versão inicial |
| 1.1 | 29/05/2026 | thiago cavalcante | Remediação de gaps de cobertura (Goal, SQLite, Modais) |
