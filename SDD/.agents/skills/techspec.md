# /techspec — Especificações Técnicas

Você é um **Arquiteto de Software / Tech Lead sênior** com experiência em desenvolvimento de produtos digitais escaláveis. Sua missão é, a partir do PRD e dos guidelines do projeto, produzir um documento de especificações técnicas (TechSpec) completo que guie a implementação de forma precisa e alinhada com os padrões do projeto.

## Argumentos recebidos

Interprete os argumentos assim:
- **Sem argumentos** → use o PRD mais recente em `docs/prd/`
- **Nome do PRD** (ex: `"auth-prd"`) → localiza o arquivo correspondente em `docs/prd/`
- **Caminho de arquivo** (ex: `docs/techspec/auth-techspec.md`) → modo revisão: leia o TechSpec existente e pergunte o que o usuário quer atualizar

**Modo revisão**: se um TechSpec existente foi fornecido, preserve as decisões arquiteturais que não mudaram, atualize apenas as seções afetadas, incremente a versão e registre as alterações no histórico.

---

## FASE 0 — Pesquisa de Incertezas Técnicas (condicional)

> Esta fase só é executada quando existem incertezas técnicas reais. Se tudo for conhecido, informe: "Nenhuma incerteza técnica identificada — prosseguindo para FASE 1." e avance diretamente.

Execute **antes de qualquer decisão de design**, logo após identificar os requisitos do PRD:

1. **Identifique incertezas técnicas** — itens que, se não resolvidos agora, resultarão em decisões erradas no TechSpec:
   - Integração com serviço externo sem documentação clara
   - Escolha de biblioteca/framework com trade-offs não óbvios
   - Padrão de modelagem de dados para um tipo de dado não coberto pelos guidelines
   - Estratégia de autenticação/autorização para um caso específico do PRD
   - Comportamento de sincronização, concorrência ou consistência eventual

2. **Para cada incerteza**: documente o que é desconhecido, pesquise (web ou guidelines), e registre a decisão tomada com justificativa.

3. **Gere `docs/techspec/[nome]-research.md`** se houver 2 ou mais incertezas:

````markdown
# Research: [Nome da Feature]

**TechSpec de destino:** docs/techspec/[nome]-techspec.md
**Data:** [data atual]

---

## Incertezas resolvidas

### [Incerteza 1 — ex: Estratégia de cache para sessões]
**Contexto:** [Por que esta incerteza existe — qual requisito do PRD a origina]
**Opções avaliadas:**
- [Opção A] — [pros/contras]
- [Opção B] — [pros/contras]
**Decisão:** [Opção escolhida]
**Justificativa:** [Por que — alinhamento com guidelines, performance, manutenção]
**Impacto no TechSpec:** [Qual seção e como será documentado]

---

[Repetir para cada incerteza]

## Incertezas não resolvidas (requerem input do usuário)

| Incerteza | Impacto se não resolvida | Bloqueante? |
|-----------|--------------------------|------------|
| [Questão] | [Impacto no design] | Sim / Não |
````

4. **Se houver incertezas não resolvidas bloqueantes**: apresente-as ao usuário e aguarde resposta antes de prosseguir. Incertezas não bloqueantes vão para a seção 12 do TechSpec ("Questões Técnicas em Aberto").

---

## FASE 1 — Leitura de Contexto

Execute **antes** de qualquer geração:

1. **Leia todos os arquivos em `guidelines/`** — estes definem os padrões que TODA decisão técnica deve respeitar. Priorize a leitura de:
   - `guidelines/stack.md` → informa a seção 1.3 (Stack Tecnológica) e os ADRs
   - `guidelines/architecture.md` → informa a seção 2.1 (Padrão Arquitetural) e a estrutura de pastas
   - `guidelines/api-conventions.md` → informa toda a seção 4 (Especificação de APIs)
   - `guidelines/security.md` → informa a seção 5 (Segurança)
   - `guidelines/testing.md` → informa a seção 9 (Estratégia de Testes)

   Se a pasta não existir:
   > "A pasta `guidelines/` não foi encontrada. Execute `/guidelines` para definir os padrões do projeto — sem eles, as decisões técnicas desta TechSpec não terão base de referência e precisarão ser revalidadas depois."
   
   Pergunte se o usuário quer prosseguir mesmo assim. Se sim, continue e marque cada seção afetada com `⚠️ validar contra guidelines quando criados`.

2. **Leia o PRD** em `docs/prd/` (o mais recente ou o especificado nos argumentos). Se não existir PRD:
   > "Nenhum PRD encontrado em `docs/prd/`. Execute `/prd` primeiro para documentar os requisitos de negócio."

3. **Faça um mapa dos requisitos**: Liste os RFs, RNFs, integrações e restrições do PRD que guiarão as decisões técnicas.

---

## FASE 2 — Análise e Decisões Técnicas

Com base no PRD, guidelines e no `research.md` gerado na FASE 0 (se existir):

1. **Gaps restantes**: Há requisitos no PRD que ainda precisam de esclarecimento técnico? (Incertezas não resolvidas na FASE 0 que não eram bloqueantes mas precisam de posição antes de especificar.) Liste e pergunte ao usuário.

2. **Decisões com trade-offs confirmados**: Identifique pontos de decisão arquitetural onde múltiplas abordagens válidas existem — sync vs async, estratégia de cache, tipo de banco, padrão de eventos. Apresente opções com pros/contras e recomende a que melhor se alinha com os guidelines.

3. **Riscos técnicos**: Identifique complexidades, pontos de atenção e dependências críticas que impactam o cronograma ou a arquitetura.

**Limite**: faça no máximo **5 perguntas bloqueantes** nesta fase. Se houver mais lacunas, documente-as como questões em aberto na seção 12 e prossiga. Não atrase a geração do documento por perguntas que podem ser respondidas depois.

Resolva os gaps antes de gerar o documento.

---

## FASE 3 — Geração e Salvamento Inicial do TechSpec

> Prossiga para esta fase somente após todas as incertezas bloqueantes da FASE 0 e os gaps da FASE 2 estarem resolvidos.
> **Importante:** Grave o TechSpec gerado diretamente no disco (`docs/techspec/[nome-kebab-case]-techspec.md`) sem exibi-lo completo no chat, poupando tokens.

Gere o documento completo usando exatamente este template:

````markdown
# TechSpec: [Nome do Projeto/Feature]

**Versão:** 1.0
**Data:** [data atual]
**Autor:** [solicite ao iniciar a Fase 1, antes de qualquer leitura]
**PRD de referência:** [docs/prd/nome-do-arquivo-prd.md]
**Status:** Draft

---

## 1. Visão Técnica

### 1.1 Resumo da Solução
[Descrição de alto nível da solução em no máximo 5 linhas. O "o quê" e "como" em linguagem técnica acessível. Contextualize em relação ao PRD.]

### 1.2 Diagrama de Contexto (C4 Nível 1)

Prefira **Mermaid** (renderiza no GitHub, GitLab, Obsidian e na maioria das ferramentas):
```mermaid
graph LR
    U[Usuário] --> S[Nome do Sistema]
    S --> DB[(Database)]
    S --> AUTH[Serv. Auth]
    S --> EXT[API Terceiro]
```

Se Mermaid não for suportado no ambiente, use ASCII art:
```
┌─────────────┐     ┌──────────────────┐     ┌──────────────┐
│   Usuário   │────▶│  [Nome Sistema]  │────▶│   Database   │
└─────────────┘     └──────────────────┘     └──────────────┘
```

### 1.3 Stack Tecnológica
[Baseado nos guidelines do projeto — confirme ou especifique:]

| Camada | Tecnologia | Versão | Justificativa |
|--------|-----------|--------|---------------|
| Frontend | [tech] | [versão] | [alinhado com guidelines — motivo] |
| Backend | [tech] | [versão] | [motivo] |
| Banco de dados | [tech] | [versão] | [motivo] |
| Cache | [tech] | [versão] | [motivo] |
| Infraestrutura | [tech] | [versão] | [motivo] |
| Mensageria | [tech se aplicável] | [versão] | [motivo] |

---

## 2. Arquitetura

### 2.1 Padrão Arquitetural
[Descreva o padrão adotado (ex: Clean Architecture, Hexagonal, MVC, Event-Driven, CQRS) e justifique com base nos guidelines e nos requisitos do PRD.]

### 2.2 Estrutura de Pastas e Módulos
```
[Represente a estrutura de diretórios esperada do projeto/feature, alinhada com os coding standards dos guidelines]

src/
├── [módulo]/
│   ├── [submodulo]/
│   └── ...
└── ...
```

### 2.3 Fluxo de Dados por Caso de Uso

[Para cada RF principal do PRD, descreva o fluxo técnico]

#### Fluxo: [RF-001 — Nome]
```
1. [Ator/Origem] → [Componente]: [ação/chamada]
2. [Componente] → [Repositório/Serviço]: [operação]
3. [Repositório] → [Banco]: [query/comando]
4. [Banco] → [Repositório]: [resultado]
5. [Componente] → [Ator/Destino]: [resposta]
```
**Tratamento de falha:** [O que acontece em cada ponto de falha]

### 2.4 Decisões de Arquitetura (ADRs)

#### ADR-001: [Título da Decisão]
- **Contexto:** [Por que esta decisão precisou ser tomada]
- **Decisão:** [O que foi decidido]
- **Alternativas consideradas:** [Outras opções avaliadas e por que foram descartadas]
- **Consequências:** [Trade-offs e impactos desta decisão]

[Repetir ADR-XXX para cada decisão arquitetural relevante]

---

## 3. Modelagem de Dados

### 3.1 Entidades e Relacionamentos

Prefira **Mermaid erDiagram** (renderiza no GitHub/GitLab/Obsidian):
```mermaid
erDiagram
    Entidade1 }o--|| Entidade2 : "pertence a"
    Entidade1 {
        uuid id PK
        string campo1
        timestamp created_at
        uuid entidade2_id FK
    }
    Entidade2 {
        uuid id PK
        string campo1
        timestamp created_at
    }
```

Se Mermaid não for suportado, use pseudoERD textual:
```
Entidade1(id PK, campo1, entidade2_id FK, created_at, updated_at)
Entidade2(id PK, campo1, created_at, updated_at)
Entidade1 }o--|| Entidade2 : "pertence a"
```

### 3.2 Definição das Entidades

#### [Nome da Entidade]
| Campo | Tipo | Restrições | Descrição |
|-------|------|-----------|-----------|
| id | UUID | PK, NOT NULL | Identificador único |
| [campo] | [tipo SQL] | [NOT NULL/UNIQUE/DEFAULT] | [Descrição e regra de negócio] |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Data de criação |
| updated_at | TIMESTAMP | NOT NULL | Data da última atualização |

**Índices:**
- `idx_[tabela]_[campo]` em ([campos]) — [justificativa de performance]

**Regras de integridade:**
- [Constraint de negócio — ex: status deve ser um dos valores: PENDING, ACTIVE, INACTIVE]

[Repetir para cada entidade]

### 3.3 Estratégia de Migrations
[Como mudanças de schema serão versionadas, geradas e aplicadas. Ferramenta usada, convenção de nomenclatura, política de rollback.]

---

## 4. Especificação de APIs

### 4.1 Padrões e Convenções
[Referenciando guidelines: versionamento de API, autenticação, formato de resposta, paginação, ordenação, filtros, rate limiting]

**Envelope de resposta — Sucesso:**
```json
{
  "data": { },
  "meta": {
    "requestId": "uuid-v4",
    "timestamp": "2024-01-01T00:00:00Z"
  }
}
```

**Envelope de resposta — Erro:**
```json
{
  "error": {
    "code": "CODIGO_ERRO_SNAKE_UPPER",
    "message": "Mensagem legível para o desenvolvedor",
    "details": [
      { "field": "campo", "message": "Mensagem de validação" }
    ]
  },
  "meta": {
    "requestId": "uuid-v4",
    "timestamp": "2024-01-01T00:00:00Z"
  }
}
```

**Códigos de status utilizados:**
| Status | Quando usar |
|--------|-------------|
| 200 | Sucesso em GET, PUT, PATCH |
| 201 | Recurso criado com sucesso (POST) |
| 204 | Sucesso sem corpo de resposta (DELETE) |
| 400 | Erro de validação / requisição inválida |
| 401 | Não autenticado |
| 403 | Autenticado mas sem permissão |
| 404 | Recurso não encontrado |
| 409 | Conflito (ex: recurso já existe) |
| 422 | Entidade não processável (regra de negócio) |
| 500 | Erro interno do servidor |

### 4.2 Endpoints por Módulo

---
#### `POST /api/v1/[recurso]`
**Descrição:** [O que faz]
**Autenticação:** [Bearer JWT / API Key / Pública]
**Permissão necessária:** [ex: `recurso:create`]

Request Body:
```json
{
  "campo1": "string — descrição e validações",
  "campo2": "number — mínimo X, máximo Y"
}
```

Response `201 Created`:
```json
{
  "data": {
    "id": "uuid",
    "campo1": "valor",
    "created_at": "ISO8601"
  }
}
```

Responses de erro:
- `400` — Campos obrigatórios ausentes ou formato inválido
- `401` — Token ausente ou expirado
- `403` — Sem permissão para criar este recurso
- `409` — [Condição de conflito específica]

---
[Repetir para cada endpoint — GET, PUT, PATCH, DELETE conforme necessário]

---

## 5. Segurança

### 5.1 Autenticação
[Mecanismo (JWT, OAuth2, Session), fluxo de autenticação, expiração e renovação de tokens, estratégia de revogação]

### 5.2 Autorização
[Modelo de permissões (RBAC, ABAC), definição dos papéis, regras de acesso por recurso e operação]

### 5.3 Proteção de Dados
[Dados sensíveis identificados no PRD: estratégia de criptografia em trânsito (TLS 1.3), em repouso (campos específicos), mascaramento em logs, política de retenção]

### 5.4 Validação e Sanitização de Entrada
[Estratégia de validação (schema validation), prevenção de SQL injection, XSS, CSRF — alinhado com guidelines]

### 5.5 Auditoria
[O que será auditado (quem fez o quê e quando), formato do log de auditoria, retenção, acesso]

---

## 6. Integrações Externas

### 6.1 [Nome da Integração]
- **Tipo:** [REST / GraphQL / Webhook / Mensageria / Batch]
- **Autenticação:** [Como se autentica com o serviço externo]
- **Operações utilizadas:** [Lista de endpoints/ações consumidos]
- **Contrato de exemplo:**
  ```json
  // Request
  { }
  // Response
  { }
  ```
- **Tratamento de falha:** [Timeout, retry com backoff exponencial, circuit breaker, fallback]
- **SLA esperado:** [Tempo máximo aceitável de resposta]

[Repetir para cada integração]

---

## 7. Performance e Escalabilidade

### 7.1 Estratégia de Cache
| O que cachear | TTL | Estratégia de invalidação | Tecnologia |
|---------------|-----|--------------------------|-----------|
| [Dado/resposta] | [tempo] | [evento que invalida] | [Redis/etc] |

### 7.2 Processamento Assíncrono
[Filas utilizadas, cenários que disparam processamento async, garantias de entrega, idempotência]

### 7.3 Otimizações de Banco
[Índices críticos identificados, estratégia de paginação, connection pooling, read replicas se aplicável]

---

## 8. Observabilidade

### 8.1 Logs
- **Formato:** JSON estruturado
- **Campos obrigatórios em toda entrada:** `timestamp`, `level`, `service`, `requestId`, `userId` (quando autenticado), `action`
- **Quando usar cada nível:** ERROR (falha com impacto), WARN (situação anômala recuperável), INFO (fluxo normal relevante), DEBUG (diagnóstico)
- **O que NÃO registrar:** Senhas, tokens, dados de cartão, CPF/dados pessoais sem mascaramento

### 8.2 Métricas
| Métrica | Tipo | Descrição | Alerta quando |
|---------|------|-----------|--------------|
| `[nome_metrica]` | Counter/Gauge/Histogram | [O que mede] | [Threshold para alerta] |

### 8.3 Rastreabilidade
[Correlation ID gerado na entrada e propagado em todos os serviços/logs, distributed tracing se aplicável]

---

## 9. Estratégia de Testes

### 9.1 Pirâmide de Testes
[Referenciando guidelines: ferramentas, cobertura mínima por tipo]

| Tipo | Ferramenta | Cobertura Mínima | O que cobre |
|------|-----------|-----------------|-------------|
| Unitário | [tool] | [%] | Regras de negócio, use cases, transformações |
| Integração | [tool] | [%] | Repositórios, serviços externos (com mock/stub) |
| E2E / API | [tool] | Fluxos críticos | Contratos de API, fluxos de ponta a ponta |
| Performance | [tool] | SLOs do PRD | Tempo de resposta, throughput sob carga |

### 9.2 Cenários de Teste Críticos por Requisito

#### RF-001: [Nome]
- Happy path: [Cenário principal]
- Borda: [Casos limítrofes]
- Falha: [Comportamentos de erro esperados]

---

## 10. Deploy e Infraestrutura

### 10.1 Ambientes
| Ambiente | Propósito | Branch | URL |
|----------|-----------|--------|-----|
| Development | Desenvolvimento local | feature/* | localhost |
| Staging | Homologação | main | [URL] |
| Production | Produção | tags/v* | [URL] |

### 10.2 Pipeline CI/CD
```
[Descreva os stages: ex:]
1. Lint + Type Check
2. Unit Tests
3. Integration Tests
4. Security Scan (SAST)
5. Build / Docker image
6. Deploy Staging (auto)
7. E2E Tests em Staging
8. Deploy Production (manual gate)
```

### 10.3 Estratégia de Rollback
[Como reverter em caso de problema: feature flags, blue-green, canary, ou rollback de deploy]

---

## 11. Áreas de Trabalho Identificadas

> Esta seção alimenta o skill `/tasks`. Liste as grandes frentes de trabalho.

| Área | Descrição | Complexidade | Dependências |
|------|-----------|-------------|-------------|
| Setup / Infra | [Configurações iniciais necessárias] | P/M/G | — |
| Modelagem de dados | [Migrations e modelos] | P/M/G | Setup |
| Camada de domínio | [Entidades, regras de negócio] | P/M/G | Modelagem |
| Repositórios / DAL | [Acesso a dados] | P/M/G | Domínio |
| API / Controllers | [Endpoints especificados] | P/M/G | Repositórios |
| Integrações | [Serviços externos] | P/M/G | API |
| Frontend / UI | [Componentes e telas] | P/M/G | API |
| Testes | [Cobertura planejada] | P/M/G | Implementação |

---

## 12. Questões Técnicas em Aberto

| # | Questão | Impacto | Responsável | Prazo |
|---|---------|---------|-------------|-------|
| 1 | [Questão técnica não resolvida] | [Impacto se não resolvida] | [Quem] | [Data] |

---

## 13. Histórico de Revisões

| Versão | Data | Autor | Alterações |
|--------|------|-------|------------|
| 1.0 | [data] | [autor] | Versão inicial |
````

---

## FASE 4 — Geração e Salvamento dos Artefatos Granulares

> Com base no conteúdo do TechSpec gerado na FASE 3, gere e **salve no disco imediatamente** os artefatos de design em arquivos separados. Cada arquivo deve ser legível **sem precisar abrir o TechSpec**.

Estrutura de destino:
```
docs/techspec/
  [nome]-techspec.md          ← TechSpec completo (FASE 3)
  [nome]-research.md          ← Pesquisa técnica (FASE 0, se gerado)
  [nome]/
    data-model.md             ← Modelo de dados standalone
    quickstart.md             ← Guia rápido de implementação
    contracts/
      [recurso].md            ← Um arquivo por recurso/módulo de API
```

---

### 4.1 — `data-model.md` (do TechSpec seção 3)

Extraia e reformate a seção 3 do TechSpec como documento standalone:

````markdown
# Data Model: [Nome da Feature]

**TechSpec:** [docs/techspec/[nome]-techspec.md — Seção 3](../[nome]-techspec.md#3-modelagem-de-dados)
**Gerado em:** [data]

---

## Diagrama ER

```mermaid
erDiagram
    [conteúdo da seção 3.1]
```

---

## Entidades

### [NomeEntidade]

| Campo | Tipo | Restrições | Descrição |
|-------|------|-----------|-----------|
| [campos da seção 3.2] | | | |

**Índices:** [da seção 3.2]
**Regras de integridade:** [da seção 3.2]

[Repetir por entidade]

---

## Ciclo de Vida de Estados

> Inclua apenas entidades que possuem transições de estado relevantes.

### [Entidade com estados]

```
[estado inicial] → [estado A] → [estado final]
                 → [estado B]
```

| Estado | Transições permitidas | Condição / evento |
|--------|----------------------|-------------------|
| [estado] | [→ próximo estado] | [condição] |

*Omitir esta seção se nenhuma entidade possuir máquina de estados.*

---

## Estratégia de Migrations

[Da seção 3.3: ferramenta, convenção de nomenclatura, política de rollback]
````

---

### 4.2 — `contracts/[recurso].md` (do TechSpec seção 4)

Gere **um arquivo por recurso ou módulo de API** (ex: `contracts/pedidos.md`, `contracts/usuarios.md`). Determine os grupos por recurso REST (`/api/v1/[recurso]`) ou por área funcional se não for REST.

Para cada arquivo:

````markdown
# Contratos: [Recurso] — [Nome da Feature]

**TechSpec:** [docs/techspec/[nome]-techspec.md — Seção 4](../[nome]-techspec.md#4-especificação-de-apis)
**Gerado em:** [data]
**Base URL:** `/api/v1/[recurso]`
**Autenticação padrão:** Bearer JWT (salvo indicação contrária por endpoint)

---

## `POST /api/v1/[recurso]`

**Descrição:** [O que faz]
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
````

Se a feature não tiver API (ex: só processamento interno), omita os contratos e registre no relatório da FASE 5: "Nenhuma interface de API identificada — contratos não gerados."

---

### 4.3 — `quickstart.md` (síntese das seções 1.3, 2.2, 4, 9)

Guia rápido para um desenvolvedor começar a implementar a feature sem ler o TechSpec completo:

````markdown
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
````

---

### 4.4 — Atualizar referências no TechSpec

Após gerar os artefatos, adicione referências no TechSpec:

- **Início da seção 3** (Modelagem de Dados): adicione
  > **Artefato standalone:** [`docs/techspec/[nome]/data-model.md`]([nome]/data-model.md)

- **Início da seção 4** (Especificação de APIs): adicione
  > **Contratos standalone:** [`docs/techspec/[nome]/contracts/`]([nome]/contracts/)

- **Salve o TechSpec** novamente com as referências adicionadas.

---

## FASE 5 — Comitê de Análise Assíncrono

Assim como no `/guidelines`, o TechSpec e os artefatos granulares devem passar por escrutínio técnico antes de congelarmos a versão.

1. **Apresente ao Usuário e Peça Permissão:**
   > "A Especificação Técnica (TechSpec) e os artefatos foram gerados e salvos no disco. Deseja que eu submeta este planejamento ao **Comitê de Especialistas** (Arquitetura, Segurança, Dados, DevOps e Qualidade) no background para revisão crítica? [Sim / Não]"

2. **Se o usuário disser "Sim":**
   - Utilize `invoke_subagent` (ou equivalentes no orquestrador) para invocar os agentes, instruindo-os a **ler os arquivos recém-salvos**. Eles devem avaliar gargalos de performance, falhas de modelagem, segurança, riscos operacionais e testabilidade dos contratos.
   - *Se não houver suporte a subagentes:* Simule as personas de Arquitetura, Segurança, Database, DevOps e Qualidade em uma auto-reflexão profunda no próprio chat.
   - Apresente o feedback consolidado ao usuário.
   > "O comitê analisou os arquivos:
   > - **Arquitetura:** [Ponto levantado]
   > - **Segurança:** [Ponto levantado]
   > - **Dados:** [Ponto levantado]
   > - **DevOps:** [Ponto levantado]
   > - **Qualidade:** [Ponto levantado]
   > Aceita que eu atualize os arquivos salvos para corrigir esses pontos?"
   - Se o usuário aceitar, atualize diretamente os arquivos em disco.

3. **Se o usuário disser "Não":** Avance direto para a Fase 6.

---

## FASE 6 — Resumo e Próximos Passos

1. Informe ao usuário:
   - Artefatos gerados (lista com caminhos)
   - Entidades modeladas e endpoints especificados
   - ADRs tomados e seus trade-offs
   - Incertezas resolvidas na FASE 0 (se aplicável)
   - Questões técnicas em aberto (seção 12 do TechSpec)
   - **Próximo passo:** Execute `/analyze` para validar consistência PRD × TechSpec antes de `/tasks`.

3. Atualize `memory/state.md` — seção **Especificações Técnicas**:
   - Nome da feature, caminho do TechSpec
   - ADRs chave resumidos (1 linha cada)
   - Artefatos granulares gerados: data-model, contracts (N recursos), quickstart
   - Atualize status da feature: `Em especificação` → `Em desenvolvimento`

---

## Critérios de Qualidade — Checklist Final

Antes de finalizar, verifique:
- [ ] Todas as decisões técnicas estão alinhadas com os guidelines do projeto
- [ ] Cada RF do PRD tem especificação técnica correspondente
- [ ] Cada RNF do PRD tem abordagem técnica documentada e mensurável
- [ ] Todos os endpoints têm contratos completos (request, response, erros)
- [ ] A modelagem de dados é consistente com os fluxos descritos
- [ ] Os ADRs documentam o raciocínio por trás das decisões
- [ ] A estratégia de testes está clara e cobre os cenários críticos
- [ ] O documento é suficientemente detalhado para que um desenvolvedor implemente sem tomar decisões de arquitetura sozinho
- [ ] `data-model.md` gerado e legível independentemente do TechSpec
- [ ] `contracts/[recurso].md` gerado para cada recurso de API (ou justificativa de ausência)
- [ ] `quickstart.md` gerado com setup, cenários principais e pontos de atenção
- [ ] Referências cruzadas adicionadas no TechSpec (seções 3 e 4)
