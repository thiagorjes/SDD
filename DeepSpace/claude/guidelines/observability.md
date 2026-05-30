# Observabilidade — KingPong

## Contexto

Projeto greenfield, solo developer. Logging mínimo apenas para desenvolvimento — sem ferramentas de APM ou logging estruturado em produção por ora.

## Logging

**Estratégia:** `console.log` / `console.error` apenas em ambiente de desenvolvimento.

**Regra:** remover ou guardar atrás de flag de dev todos os `console.log` antes de release para produção.

```ts
if (__DEV__) {
  console.log('Game state:', state)
}
```

## Diagnóstico de Crash

<!-- TODO: avaliar integração do Sentry quando o app for para produção -->

Sem ferramenta de crash reporting configurada por ora. Crashs em produção serão identificados via feedback manual ou relatórios da loja (Google Play Console / App Store Connect).

## Métricas

Não aplicável no estágio atual.
