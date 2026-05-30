# Arquitetura — KingPong

## Padrão Adotado

Feature-based — organização por feature/tela do jogo, sem camadas rígidas formais.

**Justificativa:** projeto solo greenfield de jogo mobile. Feature-based é simples, direto ao ponto e adequado para a escala prevista.

## Estrutura de Pastas

```
src/
├── features/
│   ├── menu/           # Tela inicial, navegação principal
│   ├── game/           # Lógica e telas do jogo em si
│   ├── ranking/        # Placar, histórico de partidas
│   └── settings/       # Configurações do jogador
├── shared/
│   ├── components/     # Componentes reutilizáveis entre features
│   ├── hooks/          # Hooks compartilhados
│   ├── utils/          # Utilitários puros (sem side effects)
│   └── storage/        # Abstração do SQLite (acesso a dados)
└── App.tsx             # Entry point e configuração de navegação
```

Cada feature contém:

```
features/game/
├── components/         # Componentes visuais da feature
├── hooks/              # Hooks específicos da feature
├── screens/            # Screens (telas) da feature
└── types.ts            # Tipos TypeScript da feature
```

## Regras de Dependência

| De | Pode importar | Não pode importar |
|----|--------------|-------------------|
| `features/*` | `shared/*` | Outra `features/*` diretamente |
| `shared/components` | `shared/hooks`, `shared/utils` | `features/*`, `shared/storage` |
| `shared/storage` | `shared/utils` | `features/*`, `shared/components` |

**Comunicação entre features:** via navegação (parâmetros de rota) ou estado global — nunca importação direta entre features.

## Gerenciamento de Estado

<!-- TODO: definir biblioteca de estado global (ex: Zustand, Redux Toolkit, Context API) -->

- **Estado local de UI:** `useState` / `useReducer`
- **Estado global do jogo:** <!-- TODO: definir -->
- **Estado persistido:** SQLite via `shared/storage`
