# TASK-2.2 — Colisão Dinâmica Paddle/Bola

**Feature:** KingPong Core Gameplay
**Documento principal:** [docs/tasks/kingpong-core-gameplay-tasks.md]
**Epic:** EPIC-2 — Core Physics | **US:** US-2 — Controle do Paddle (Física)
**Labels:** `[core]` `[logic]`
**Estimativa:** G
**Depende de:** TASK-2.1
**Bloqueia:** TASK-4.1
**Paralelo `[P]`:** Não
**Status:** `Pendente`

---

## Contexto

A física de rebatimento no paddle não é fixa; ela depende do ponto de impacto para permitir "efeito" na bola.

**Referências:**
- PRD: [RF-002 — Bola e Paddle operam em lógica de colisão estrita; não pode haver sobreposição] e [P4 — Velocidade e direção variam de acordo com a posição e ângulo de impacto no paddle]
- TechSpec: [Seção 2.3 — Colisão Paddle (Calcula novo vetor baseado no ponto de impacto center vs edge)]

---

## O que deve ser feito

- [ ] Implementar detecção de intersecção estrita (sem sobreposição).
- [ ] Calcular vetor resultante baseado na distância entre o centro da bola e o centro do paddle no momento do impacto.

---

## Guia técnico de implementação

A variação do ângulo deve ser proporcional à distância do centro do paddle. Se atingir a extremidade, o ângulo de reflexão deve ser mais agudo.

**Estrutura de arquivos esperada:**
```
src/core/physics/collision.ts  — Lógica de detecção Paddle/Ball
```

**Pontos de atenção:**
- Evitar o bug de "tunnelling" (bola atravessar o paddle em alta velocidade) garantindo que a detecção considere a posição anterior e atual.

---

## Critérios de Aceite

- [ ] Bolinha rebate no paddle sem entrar dentro dele (sobreposição zero).
- [ ] O ângulo de saída muda dependendo de onde a bola bate no paddle.
- [ ] Testes TDD escritos antes da implementação
- [ ] Sem regressões nos testes existentes
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
