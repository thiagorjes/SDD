# Arquitetura

## Padrão Adotado
**Feature-based Architecture**

Justificativa: Adequado para jogos simples onde a lógica e a UI estão fortemente ligadas por cena ou funcionalidade.

## Estrutura de Pastas
```
src/
├── features/         # Funcionalidades completas (Game, Menu, Score)
│   ├── [FeatureName]/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── assets/
│   │   └── index.ts
├── shared/           # Código compartilhado entre features
│   ├── components/
│   ├── hooks/
│   └── utils/
├── core/             # Lógica central do jogo (Engine, Physics)
└── database/         # Configurações e acesso ao SQLite
e2e/                  # Testes de ponta a ponta (Detox)
```

## Regras de Dependência
- Features podem importar de `shared`, `core` e `database`.
- Uma feature não deve importar diretamente de outra feature para evitar acoplamento circular; use o `shared` se necessário.
