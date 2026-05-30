# Stack Tecnológica — KingPong

## Linguagens

| Linguagem | Versão | Uso principal |
|-----------|--------|---------------|
| TypeScript | <!-- TODO: definir versão (recomendado: 5.x) --> | Toda a base de código |

## Frameworks e Bibliotecas

| Biblioteca | Versão | Finalidade | Por que esta e não outra? |
|------------|--------|------------|--------------------------|
| React Native (CLI) | <!-- TODO: definir versão (recomendado: 0.73+) --> | Framework mobile nativo | CLI vanilla sem Expo — controle total do código nativo |
| react-native-sqlite-storage | <!-- TODO: versão --> | Persistência local de dados do jogo | Banco relacional local, adequado para rankings e saves |

## Banco de Dados

| Sistema | Versão | Uso | Driver |
|---------|--------|-----|--------|
| SQLite | embutido no SO | Rankings, progresso, configurações do jogador | react-native-sqlite-storage |

## Infraestrutura

- **Backend:** Nenhum — jogo totalmente offline
- **Cloud:** Não aplicável
- **Plataformas alvo:** Android e iOS

## Ferramentas de Desenvolvimento

| Ferramenta | Versão | Config | Quando executar |
|------------|--------|--------|-----------------|
| ESLint | <!-- TODO: versão --> | `.eslintrc.js` | Antes de todo commit manual + CI |
| Prettier | <!-- TODO: versão --> | `.prettierrc` | On save no editor |
| tsc | mesmo do TypeScript | `tsconfig.json` | Verificação de tipos — antes de subir código |

## Plataformas de Build

- **Android:** Gradle via React Native CLI (`npx react-native run-android`)
- **iOS:** Xcode via React Native CLI (`npx react-native run-ios`)
