# Segurança — KingPong

## Contexto

Jogo mobile offline, sem backend próprio e sem dados sensíveis críticos. Preocupações de segurança são mínimas — foco em boas práticas básicas.

## Checklist por entrega

- [ ] Sem secrets ou chaves hardcoded no código-fonte
- [ ] Dependências sem vulnerabilidades conhecidas (`npm audit`)
- [ ] Dados no SQLite não contêm informações pessoais sensíveis além de apelido/nickname do jogador

## Dados do Jogador

O único dado pessoal armazenado é o **nome/apelido do jogador** (definido por ele, armazenado localmente no SQLite do dispositivo). Não há envio de dados para servidores.

## Compliance

Nenhuma regulamentação formal aplicável (LGPD, GDPR etc.) dado o escopo offline e local do jogo.
