# Padrões de Código

## Nomenclatura
| Artefato | Convenção | Exemplo |
|----------|-----------|---------|
| Arquivos | PascalCase | `GameBoard.tsx`, `ScoreService.ts` |
| Componentes | PascalCase | `PaddleComponent` |
| Funções/Métodos | camelCase | `calculateBallTrajectory` |
| Variáveis | camelCase | `scoreCount` |
| Constantes | UPPER_SNAKE_CASE | `MAX_BALL_SPEED` |

## Tratamento de Erros
- Utilizar exceções nativas (`try/catch`).
- Erros em lógica de jogo crítica devem ser logados e, se possível, retornar o jogo para um estado estável (ex: reset da bola).

## Comentários
- **Zero comentários**: O código deve ser escrito de forma autoexplicativa.
- Se uma lógica for complexa demais para ser lida sem comentários, ela deve ser refatorada em funções menores com nomes descritivos.
