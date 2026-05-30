# Segurança

## Foco em POC
Como este projeto é uma Prova de Conceito de um jogo offline/local, as medidas de segurança são simplificadas.

## Diretrizes
- **Secrets**: Nunca incluir chaves de API, certificados ou credenciais de lojas (App Store/Play Store) no código-fonte.
- **Validação**: Inputs de usuário (como nome para o placar) devem ser sanitizados para evitar quebras no banco de dados SQLite.
- **Dados Sensíveis**: Não registrar PII (Informações Pessoais Identificáveis) ou dados de telemetria sensíveis no console.

## Checklist de Segurança (POC)
- [ ] Nenhum token ou chave hardcoded.
- [ ] Validação básica de campos de texto.
- [ ] Sem permissões excessivas no AndroidManifest.xml ou Info.plist (ex: pedir câmera se o jogo não usa).
