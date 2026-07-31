# Quickstart: [Nome da Feature]

**TechSpec completo:** [docs/techspec/[nome]-techspec.md](../[nome]-techspec.md)
**Gerado em:** [data]

> Guia rápido para implementação. Leia este arquivo antes de começar qualquer task.

---

## Stack

| Camada | Tecnologia | Versão |
|--------|-----------|--------|
| [da seção 1.3 do TechSpec] | | |

---

## Estrutura de Pastas

```
[da seção 2.2 do TechSpec — apenas a estrutura relevante a esta feature]
```

---

## Setup Mínimo (ambiente local)

```bash
# 1. Dependências
[comando de instalação — ex: npm install / pip install -r requirements.txt]

# 2. Variáveis de ambiente necessárias
[lista das env vars obrigatórias com exemplo de valor]

# 3. Migrations / Schema
[comando para aplicar migrations — ex: npx prisma migrate dev]

# 4. Executar localmente
[comando para rodar — ex: npm run dev]
```

---

## Cenários Principais

> Um por RF crítico. Use como referência ao escrever testes e ao validar a implementação.

### RF-001 — [Nome]

**Dado/Quando/Então:**
- **Dado** [estado inicial]
- **Quando** [ação do usuário ou sistema]
- **Então** [resultado esperado]

**Exemplo:**
```bash
curl -X POST http://localhost:3000/api/v1/[recurso] \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ "campo1": "valor" }'
```

**Resposta esperada:**
```json
{ "data": { "id": "...", "campo1": "valor" } }
```

---

[Repetir por RF principal. Incluir pelo menos 1 cenário de erro para o RF mais crítico.]

---

## Pontos de Atenção

> Gotchas e restrições não óbvias que causam erros comuns.

- [Ponto 1 — ex: "O campo X deve ser único por usuário, não globalmente"]
- [Ponto 2 — ex: "A migration Y precisa ser executada antes da Z"]
- [Ponto 3 — ex: "O serviço externo Z tem rate limit de 100 req/min"]

---

## Cenários de Teste Críticos

> Baseado na seção 9.2 do TechSpec. Execute estes antes de abrir PR.

- [ ] [Happy path do RF-001]
- [ ] [Erro de autenticação]
- [ ] [Input inválido retorna 400 com detalhes]
- [ ] [RF-00X — caso de borda crítico]
