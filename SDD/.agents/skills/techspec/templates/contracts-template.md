# Contratos: [Recurso] — [Nome da Feature]

**TechSpec:** [docs/techspec/[nome]-techspec.md — Seção 4](../../[nome]-techspec.md#4-especificação-de-apis-resumo)
**Gerado em:** [data]
**Base URL:** `/api/v1/[recurso]`
**Autenticação padrão:** Bearer JWT (salvo indicação contrária por endpoint)
**Convenções:** [referencie `guidelines/api-conventions.md`; se não existir, documente aqui o envelope de resposta e os códigos de status]

> **Este arquivo é a fonte de verdade dos contratos deste recurso** — o TechSpec contém apenas um índice de endpoints com link para cá.

---

## `POST /api/v1/[recurso]`

**Descrição:** [O que faz]
**RF relacionado:** [RF-XXX]
**Permissão:** `[recurso]:create`

### Request

```http
POST /api/v1/[recurso]
Authorization: Bearer <token>
Content-Type: application/json
```

```json
{
  "campo1": "string — [validações: obrigatório, max 255]",
  "campo2": "number — [mínimo 1, máximo 9999]"
}
```

### Response `201 Created`

```json
{
  "data": {
    "id": "uuid",
    "campo1": "valor",
    "created_at": "ISO8601"
  },
  "meta": { "requestId": "uuid", "timestamp": "ISO8601" }
}
```

### Erros

| Status | Código | Condição |
|--------|--------|---------|
| 400 | `VALIDATION_ERROR` | Campos obrigatórios ausentes ou formato inválido |
| 401 | `UNAUTHORIZED` | Token ausente ou expirado |
| 403 | `FORBIDDEN` | Sem permissão `[recurso]:create` |
| 409 | `CONFLICT` | [Condição de conflito específica] |

---

[Repetir para cada endpoint do recurso: GET lista, GET por ID, PUT, PATCH, DELETE]
