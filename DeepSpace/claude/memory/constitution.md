# Resumo do Projeto — KingPong

_Guidelines geradas em: 2026-05-29_

Jogo mobile em React Native CLI (TypeScript) para Android e iOS. Projeto solo, greenfield, totalmente offline.

### Stack

| Componente | Tecnologia |
|---|---|
| Linguagem | TypeScript (strict: true) |
| Framework | React Native CLI (vanilla, sem Expo) |
| Engine de jogo | Componentes RN nativos (sem engine dedicada) |
| Persistência local | SQLite via react-native-sqlite-storage |
| Backend | Nenhum — offline |
| Linting | ESLint + Prettier + tsc |
| Plataformas alvo | Android e iOS |

### Arquitetura

Feature-based sem camadas rígidas. Pastas por feature do jogo (`menu/`, `game/`, `ranking/`, `settings/`) dentro de `src/features/`. Código compartilhado em `src/shared/`. Sem DDD formal.

### Convenções de Código

| Aspecto | Decisão |
|---|---|
| Arquivos de componente/screen | PascalCase (`GameScreen.tsx`) |
| Arquivos de hook | camelCase com prefixo `use` (`useGameState.ts`) |
| Arquivos utilitários | camelCase (`scoreCalculator.ts`) |
| Constantes | UPPER_SNAKE_CASE |
| Style guide | React Native defaults (sem Airbnb) |
| Comentários | Zero — código autoexplicativo |
| Tratamento de erros | try/catch nativo com mensagem contextualizada |
| TypeScript | strict, sem `any`, sem `as` para contornar tipagem |

### Testes

| Aspecto | Decisão |
|---|---|
| Tipo | E2E com Detox |
| Cobertura | 90% dos fluxos críticos |
| Localização | `tests/e2e/` na raiz |
| Mocks | Mínimos — preferência por testes reais |

### Processo

| Aspecto | Decisão |
|---|---|
| Git | Não utilizado por ora |
| Logging | `console.log` apenas em dev (`__DEV__` guard) |
| CI/CD | Não configurado |

### Guidelines geradas

| Arquivo | Status |
|---|---|
| `guidelines/stack.md` | Gerado |
| `guidelines/architecture.md` | Gerado |
| `guidelines/coding-standards.md` | Gerado |
| `guidelines/testing.md` | Gerado |
| `guidelines/security.md` | Gerado |
| `guidelines/observability.md` | Gerado |
| `guidelines/api-conventions.md` | Não aplicável (sem API) |
| `guidelines/git-workflow.md` | Não aplicável (sem git por ora) |
