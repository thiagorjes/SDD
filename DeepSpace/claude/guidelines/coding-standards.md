# Padrões de Código — KingPong

## Nomenclatura

| Artefato | Convenção | Exemplo |
|----------|-----------|---------|
| Arquivos de componente | PascalCase | `GameBoard.tsx` |
| Arquivos de hook | camelCase com prefixo `use` | `useGameState.ts` |
| Arquivos utilitários | camelCase | `scoreCalculator.ts` |
| Arquivos de tipo | PascalCase | `GameTypes.ts` |
| Arquivos de screen | PascalCase com sufixo `Screen` | `GameScreen.tsx` |
| Pastas | kebab-case | `game-board/` |
| Componentes React | PascalCase | `GameBoard` |
| Funções/hooks | camelCase | `useGameState`, `calculateScore` |
| Variáveis e props | camelCase | `playerScore`, `isRunning` |
| Constantes | UPPER_SNAKE_CASE | `MAX_LIVES`, `BOARD_SIZE` |
| Tipos e interfaces | PascalCase | `PlayerState`, `GameConfig` |

## Tratamento de Erros

Usar `try/catch` nativo com `Error` padrão do JavaScript/TypeScript. Sempre incluir contexto suficiente para diagnóstico.

✅ Correto:
```ts
try {
  await db.executeSql(query, params)
} catch (error) {
  throw new Error(`Failed to save score: ${error instanceof Error ? error.message : String(error)}`)
}
```

❌ Incorreto:
```ts
try {
  await db.executeSql(query, params)
} catch {
  // silenciado
}
```

## Comentários

Zero comentários. Código deve ser autoexplicativo via nomes descritivos.

✅ Correto: função `calculateBonusMultiplier(streak: number): number`
❌ Incorreto: `// multiplica a pontuação pelo bônus` antes de `score * bonus`

## Componentes React Native

- Preferir componentes funcionais com hooks
- Props tipadas com `interface` ou `type` — nunca `any`
- Evitar lógica de negócio dentro de componentes — extrair para hooks

```ts
interface GameBoardProps {
  playerScore: number
  onScoreChange: (newScore: number) => void
}
```

## TypeScript

- `strict: true` no `tsconfig.json`
- Sem `any` — usar `unknown` quando o tipo não puder ser inferido
- Sem `as` para contornar tipagem — corrigir o tipo na origem
