# Segurança e Observabilidade

## Segurança
- **Foco em POC**: Não há necessidade de RBAC ou criptografia complexa nesta fase.
- **Secrets**: Nunca incluir chaves sensíveis diretamente no código.
- **PII**: Não coletar dados pessoais do jogador.

## Observabilidade (Logging)
- **Estratégia**: Uso de `console.log` simples para depuração em tempo de desenvolvimento.
- **Níveis**:
    - `INFO`: Início de partida, fim de partida, recorde quebrado.
    - `ERROR`: Falha na persistência de dados ou erro inesperado na engine.

## O que NÃO registrar
- Eventos de alta frequência (ex: cada frame de animação) para não poluir o log e prejudicar a performance.
