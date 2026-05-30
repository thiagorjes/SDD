# TASK-1.1 — Configuração Inicial React Native

**Feature:** KingPong Core Gameplay
**Documento principal:** [docs/tasks/kingpong-core-gameplay-tasks.md]
**Epic:** EPIC-1 — Setup & Infra | **US:** US-0 — Bootstrap do Projeto
**Labels:** `[infra]` `[frontend]`
**Estimativa:** M
**Depende de:** nenhuma
**Bloqueia:** TASK-1.2, TASK-3.1
**Paralelo `[P]`:** Não
**Status:** `Concluída`

---

## Contexto

Esta tarefa consiste em inicializar o projeto React Native com TypeScript e configurar as bibliotecas base (Reanimated, Gesture Handler) para suportar os requisitos de alta performance (RNF-001).

**Referências:**
- PRD: [RNF-001 — A movimentação do paddle não pode ter atraso (lag) perceptível... garantindo 60 FPS]
- TechSpec: [Seção 1.3 — Stack Tecnológica (React Native, TypeScript, Reanimated ^3.0, Gesture Handler)] e [Seção 2.2 — Estrutura de Pastas (src/core, src/features, src/shared)]
- Guidelines: [stack.md] e [architecture.md]

---

## O que deve ser feito

- [ ] Inicializar projeto RN com TypeScript.
- [ ] Instalar e configurar `react-native-reanimated` v3 e `react-native-gesture-handler`.
- [ ] Configurar `babel.config.js` com o plugin do Reanimated.
- [ ] Criar estrutura de pastas base (`src/core`, `src/features`, `src/shared`).

---

## Guia técnico de implementação

Seguir a estrutura de pastas definida na Seção 2.2 do TechSpec para organizar o código desde o início.

**Estrutura de arquivos esperada:**
```
src/core/          — Motores e hooks globais
src/features/      — Funcionalidades isoladas (Game, Modals)
src/shared/        — Componentes e temas comuns
```

**Padrão a seguir:**
Configuração padrão do Reanimated v3:
```javascript
// babel.config.js
module.exports = {
  presets: ['module:metro-react-native-babel-preset'],
  plugins: ['react-native-reanimated/plugin'],
};
```

**Pontos de atenção:**
- Certificar-se de limpar o cache do Metro (`npm start -- --reset-cache`) após instalar o Reanimated.

---

## Critérios de Aceite

- [ ] Projeto compila e roda em simulador/device.
- [ ] `react-native-reanimated` funcionando (teste de animação simples).
- [ ] Estrutura de diretórios segue o TechSpec.
- [ ] Testes TDD escritos antes da implementação
- [ ] Sem regressões nos testes existentes
- [ ] Code review aprovado

---

## Histórico de Issues

| # | Data | Descrição | Encontrado em | Status |
|---|------|-----------|---------------|--------|
| — | — | *Nenhuma issue registrada* | — | — |
