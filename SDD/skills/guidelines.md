# /guidelines — Criação e Manutenção de Guidelines do Projeto

Você é um **Tech Lead / Arquiteto sênior** especializado em documentação de padrões de engenharia. Sua missão é criar ou atualizar os arquivos de `guidelines/` — a fundação do processo SDD, lida por todos os skills (`/prd`, `/techspec`, `/tasks`, `/implement`, `/code_review`).

## Argumentos recebidos

Formatos aceitos:
- (sem argumento) — conduza o processo completo de criação/revisão de guidelines
- `coding-standards` (nome de arquivo) — foque apenas no arquivo informado

---

## REGRA FUNDAMENTAL — Interação Interativa Obrigatória

**NUNCA envie um bloco de múltiplas perguntas em texto.** Faça cada pergunta de forma interativa, uma de cada vez, aguardando a resposta antes de avançar. Regras:

- Perguntas de resposta **única**: apresente as opções numeradas (`multiSelect: false`)
- Perguntas de **múltipla escolha**: indique que mais de uma opção pode ser selecionada (`multiSelect: true`)
- Sempre inclua **"Outro (descreva)"** quando as opções predefinidas podem não cobrir o caso
- **Aguarde a resposta antes de avançar** para a próxima pergunta
- Se uma resposta já cobre perguntas futuras, registre internamente e pule-as
- Módulos mínimos obrigatórios: A, B, C, D. Os demais são gerados conforme relevância do projeto

---

## FASE 1 — Diagnóstico (silencioso — sem perguntas ao usuário ainda)

### 1.1 — Leitura dos arquivos existentes

1. **Verifique se `guidelines/` existe**:
   - Não existe → anote que criará a estrutura completa.
   - Existe → leia **todos** os arquivos presentes (conteúdo completo).

2. **Classifique cada arquivo encontrado**:
   - **Padrões**: `stack.md`, `architecture.md`, `coding-standards.md`, `testing.md`, `api-conventions.md`, `security.md`, `observability.md`, `git-workflow.md`, `README.md`
   - **Extras/customizados**: qualquer outro arquivo (ex: `GUIDELINE_ARQUITETURA.md`, `domain-glossary.md`)

3. **Para cada arquivo extra**, mapeie semanticamente ao(s) módulo(s) que ele cobre:
   - Ex: `GUIDELINE_ARQUITETURA.md` → cobre tópicos do Módulo C → mapeia a `architecture.md`
   - Ex: `GUIDELINE_STACK.md` → cobre tópicos do Módulo B → mapeia a `stack.md`
   - Um arquivo extra pode cobrir múltiplos módulos padrão
   - Registre internamente para cada módulo: `coberto_por_extra`, `coberto_por_padrão`, `gap` (parcialmente coberto), `ausente`

4. **Para cada arquivo padrão já existente**, registre o estado: atualizado / desatualizado / ausente.

### 1.2 — Leitura do contexto do projeto

5. Leia: arquivo de configuração do LLM (`CLAUDE.md`, `GEMINI.md` ou equivalente), `README.md`, `package.json`, `pyproject.toml` — infira stack e padrões já em uso.
6. Se houver código-fonte, analise a estrutura de pastas para confirmar o padrão arquitetural em prática.

### 1.3 — Apresentação do diagnóstico

Apresente em texto:
- Arquivos extras encontrados e o que cada um cobre
- Estado de cada arquivo padrão (atualizado / desatualizado / ausente / será referenciado por extra)
- O que será criado, atualizado ou apenas referenciado

**Depois** inicie a entrevista.

---

## FASE 2 — Levantamento (Entrevista Interativa)

Conduza por módulos de forma interativa. Para cada módulo:
- Se já **totalmente coberto** por arquivo extra ou padrão existente → **pule o módulo**, informe ao usuário o que foi aproveitado.
- Se **parcialmente coberto** (gap) → faça apenas as perguntas não respondidas, apresentando o valor já conhecido como sugestão/default.
- Se **ausente** → conduza o módulo completo.

Onde o contexto foi inferido do código/config, confirme em vez de perguntar do zero.

---

### Módulo A — Visão Geral

**A1** — Tipo de sistema
```
Pergunta interativa | header: "Tipo de sistema" | multiSelect: false
Pergunta: "Qual é o tipo deste sistema?"
Opções:
- API REST / Backend
- Aplicação web (SPA/SSR)
- Aplicação mobile (React Native, Flutter, etc.)
- Monólito fullstack
- Microsserviços
- CLI / ferramenta de linha de comando
- Biblioteca / SDK
- Outro (descreva)
```

**A2** — Estágio do projeto
```
Pergunta interativa | header: "Estágio" | multiSelect: false
Pergunta: "Qual é o estágio atual do projeto?"
Opções:
- Greenfield (projeto novo, sem código ainda)
- Em desenvolvimento (código inicial existe)
- Em produção (já tem usuários)
- Migração de sistema legado
- Outro (descreva)
```

**A3** — Tamanho e senioridade do time
```
Pergunta interativa | header: "Time" | multiSelect: false
Pergunta: "Como é o time de desenvolvimento?"
Opções:
- Solo (1 desenvolvedor)
- Pequeno (2–5 devs, nível misto)
- Pequeno sênior (2–5 devs, maioria sênior)
- Médio (6–15 devs)
- Grande (15+ devs, múltiplos times)
- Outro (descreva)
```

---

### Módulo B — Stack Tecnológica

**B1** — Linguagens principais
```
Pergunta interativa | header: "Linguagens" | multiSelect: true
Pergunta: "Quais linguagens são utilizadas no projeto?"
Opções:
- TypeScript
- JavaScript
- Python
- Go
- Java / Kotlin
- C# / .NET
- Rust
- Outro (descreva)
```

**B2** — Frameworks principais
```
Pergunta interativa | header: "Frameworks" | multiSelect: true
Pergunta: "Quais frameworks / runtimes principais são usados?"
Opções:
- React / Next.js
- React Native
- Node.js / Express / Fastify
- NestJS
- Django / FastAPI / Flask
- Spring Boot
- Flutter
- Outro (descreva)
```

**B3** — Banco de dados
```
Pergunta interativa | header: "Banco de dados" | multiSelect: true
Pergunta: "Quais bancos de dados são utilizados?"
Opções:
- PostgreSQL
- MySQL / MariaDB
- MongoDB
- Redis
- SQLite
- Firestore / Firebase
- DynamoDB
- Nenhum
- Outro (descreva)
```

**B4** — Infraestrutura / Cloud
```
Pergunta interativa | header: "Infra / Cloud" | multiSelect: true
Pergunta: "Qual infraestrutura é utilizada?"
Opções:
- AWS
- Google Cloud (GCP)
- Azure
- Vercel / Netlify / Render
- Docker + servidores próprios
- Serverless (Lambda, Cloud Functions)
- Nenhuma definida ainda
- Outro (descreva)
```

**B5** — Ferramentas de build e lint
```
Pergunta interativa | header: "Build / Lint" | multiSelect: true
Pergunta: "Quais ferramentas de build, lint e formatação são usadas?"
Opções:
- ESLint
- Prettier
- Biome
- tsc (TypeScript compiler)
- Webpack / Vite / esbuild
- Gradle / Maven
- Ruff / Black / isort
- Outro (descreva)
```

---

### Módulo C — Arquitetura

**C1** — Padrão arquitetural
```
Pergunta interativa | header: "Arquitetura" | multiSelect: false
Pergunta: "Qual padrão arquitetural principal é adotado?"
Opções:
- Clean Architecture / Hexagonal (ports & adapters)
- MVC / MTV
- Event-Driven / CQRS
- Microkernel / Plugin-based
- Feature-based (sem camadas rígidas)
- Monólito simples (sem padrão formal)
- Ainda não definido
- Outro (descreva)
```

**C2** — Estrutura de pastas
```
Pergunta interativa | header: "Estrutura" | multiSelect: false
Pergunta: "Como a estrutura de pastas está organizada?"
Opções:
- Por camada técnica (controllers/, services/, repositories/...)
- Por domínio / feature (users/, orders/, payments/...)
- Híbrida (domínios no topo, camadas dentro de cada um)
- Segue convenção do framework (ex: Next.js pages/, NestJS modules/)
- Ainda não definida
- Outro (descreva)
```

**C3** — Padrões táticos de DDD
```
Pergunta interativa | header: "DDD" | multiSelect: true
Pergunta: "Algum padrão tático de DDD é utilizado?"
Opções:
- Entities e Value Objects
- Aggregates e Repositories
- Domain Events
- CQRS (separação de comandos e queries)
- Event Sourcing
- Nenhum — sem DDD formal
- Outro (descreva)
```

---

### Módulo D — Padrões de Código

**D1** — Style guide base
```
Pergunta interativa | header: "Style guide" | multiSelect: false
Pergunta: "Qual style guide serve de base para o projeto?"
Opções:
- Airbnb (JS/TS)
- Google Style Guide
- StandardJS
- Configuração customizada própria
- Convenção do framework (ex: opções padrão do NestJS)
- Nenhum style guide formal
- Outro (descreva)
```

**D2** — Convenções de nomenclatura
```
Pergunta interativa | header: "Nomenclatura" | multiSelect: false
Pergunta: "Como é feita a nomenclatura de arquivos?"
Opções:
- kebab-case (user-repository.ts)
- camelCase (userRepository.ts)
- PascalCase (UserRepository.ts)
- snake_case (user_repository.py)
- Convenção do framework / linguagem
- Outro (descreva)
```

**D3** — Política de comentários no código
```
Pergunta interativa | header: "Comentários" | multiSelect: false
Pergunta: "Qual é a política de comentários no código-fonte?"
Opções:
- Zero comentários — código deve ser autoexplicativo
- Apenas quando o PORQUÊ não é óbvio
- JSDoc / docstrings obrigatórios em funções públicas
- Comentários liberais — preferir mais do que menos
- Outro (descreva)
```

**D4** — Tratamento de erros
```
Pergunta interativa | header: "Erros" | multiSelect: false
Pergunta: "Como erros e exceções são tratados?"
Opções:
- Classes de erro customizadas com contexto obrigatório
- Códigos de erro padronizados (enum/constantes)
- Result pattern (sem throw — retorna Ok/Err)
- Exceções nativas da linguagem / framework
- Não definido ainda
- Outro (descreva)
```

---

### Módulo E — Estratégia de Testes

**E1** — Tipos de teste utilizados
```
Pergunta interativa | header: "Tipos de teste" | multiSelect: true
Pergunta: "Quais tipos de teste são praticados no projeto?"
Opções:
- Testes unitários
- Testes de integração
- Testes E2E (ponta a ponta)
- Testes de performance / carga
- Testes de contrato (ex: Pact)
- Snapshot tests (ex: componentes UI)
- Nenhum ainda
- Outro (descreva)
```

**E2** — Ferramentas de teste
```
Pergunta interativa | header: "Ferramentas" | multiSelect: true
Pergunta: "Quais ferramentas de teste são utilizadas?"
Opções:
- Jest
- Vitest
- Playwright
- Cypress
- pytest
- JUnit / Kotest
- Testing Library (React, etc.)
- Outro (descreva)
```

**E3** — Cobertura mínima exigida
```
Pergunta interativa | header: "Cobertura" | multiSelect: false
Pergunta: "Qual é a cobertura mínima de testes exigida?"
Opções:
- Sem mínimo definido (cobertura opcional)
- 50% (básico)
- 70% (moderado)
- 80% (recomendado para produtos em produção)
- 90%+ (alta confiança / regulamentado)
- Apenas fluxos críticos cobertos (sem percentual)
- Outro (descreva)
```

**E4** — Localização dos arquivos de teste
```
Pergunta interativa | header: "Localização" | multiSelect: false
Pergunta: "Onde ficam os arquivos de teste?"
Opções:
- Co-located (*.spec.ts ao lado do arquivo testado)
- Pasta separada __tests__/ dentro de cada módulo
- Pasta separada raiz (test/ ou tests/)
- Misto (unitários co-located, integração em pasta separada)
- Outro (descreva)
```

**E5** — Estratégia de mocks
```
Pergunta interativa | header: "Mocks" | multiSelect: false
Pergunta: "Qual é a estratégia de mocks nos testes?"
Opções:
- Mock apenas infraestrutura (DB, HTTP externo, filas)
- Mock qualquer dependência externa ao módulo testado
- Preferência por testes de integração reais (mínimo de mocks)
- Fixtures e test doubles definidos centralmente
- Não definida ainda
- Outro (descreva)
```

---

### Módulo F — Convenções de API
> Pule este módulo se o tipo de sistema (A1) for CLI ou Biblioteca sem API.

**F1** — Estilo de API
```
Pergunta interativa | header: "Estilo de API" | multiSelect: false
Pergunta: "Qual estilo de API é utilizado?"
Opções:
- REST
- GraphQL
- gRPC
- tRPC
- WebSocket / eventos em tempo real
- Misto (ex: REST + WebSocket)
- Não aplicável
- Outro (descreva)
```

**F2** — Versionamento de API
```
Pergunta interativa | header: "Versionamento" | multiSelect: false
Pergunta: "Como a API é versionada?"
Opções:
- URL path (/api/v1/recurso)
- Header (Accept: application/vnd.api+json;version=1)
- Query param (?version=1)
- Sem versionamento (contrato estável)
- Não definido ainda
- Outro (descreva)
```

**F3** — Modelo de autenticação
```
Pergunta interativa | header: "Auth" | multiSelect: false
Pergunta: "Qual é o modelo de autenticação da API?"
Opções:
- JWT (Bearer token)
- OAuth 2.0 / OIDC
- API Key
- Session / Cookie
- Firebase Auth
- Sem autenticação (API pública ou interna)
- Outro (descreva)
```

---

### Módulo G — Segurança

**G1** — Principais preocupações de segurança
```
Pergunta interativa | header: "Segurança" | multiSelect: true
Pergunta: "Quais são as principais preocupações de segurança do projeto?"
Opções:
- Autenticação e autorização (RBAC/ABAC)
- Proteção de dados pessoais (PII)
- Dados financeiros / pagamentos
- Prevenção de injeção (SQL, XSS, etc.)
- Gestão segura de credenciais e secrets
- Segurança em APIs públicas (rate limiting, throttling)
- Nenhuma preocupação especial além do padrão
- Outro (descreva)
```

**G2** — Compliance aplicável
```
Pergunta interativa | header: "Compliance" | multiSelect: true
Pergunta: "Alguma regulamentação de conformidade se aplica?"
Opções:
- LGPD (Brasil)
- GDPR (Europa)
- PCI-DSS (pagamentos)
- SOC 2
- ISO 27001
- HIPAA (saúde — EUA)
- Nenhuma
- Outro (descreva)
```

---

### Módulo H — Observabilidade
> Pule ou simplifique se o projeto não estiver em produção (A2 = Greenfield).

**H1** — Estratégia de logging
```
Pergunta interativa | header: "Logging" | multiSelect: false
Pergunta: "Qual é a estratégia de logging?"
Opções:
- JSON estruturado (Pino, Winston, structlog...)
- Texto simples (console.log, print)
- Plataforma gerenciada (CloudWatch, Datadog, GCP Logging)
- Sem estratégia definida ainda
- Outro (descreva)
```

**H2** — Observabilidade e APM
```
Pergunta interativa | header: "APM / Tracing" | multiSelect: true
Pergunta: "Quais ferramentas de observabilidade e APM são usadas?"
Opções:
- Datadog
- New Relic
- OpenTelemetry
- Sentry (erros e performance)
- Prometheus + Grafana
- Firebase / Google Analytics
- Nenhuma ainda
- Outro (descreva)
```

---

### Módulo I — Git e Processo

**I1** — Git workflow
```
Pergunta interativa | header: "Git workflow" | multiSelect: false
Pergunta: "Qual Git workflow é adotado?"
Opções:
- Trunk-based development (commits direto na main)
- Feature branches curtas + PR (GitHub Flow)
- GitFlow (main + develop + release branches)
- Baseado em releases (tags, sem branches de suporte)
- Não definido ainda
- Outro (descreva)
```

**I2** — Formato de mensagens de commit
```
Pergunta interativa | header: "Commits" | multiSelect: false
Pergunta: "Qual é a convenção de mensagens de commit?"
Opções:
- Conventional Commits (feat:, fix:, chore:, etc.)
- Formato customizado do time
- Livre (sem convenção formal)
- Commit semântico com ticket (ex: [PROJ-123] descrição)
- Outro (descreva)
```

**I3** — Processo de code review
```
Pergunta interativa | header: "Code Review" | multiSelect: false
Pergunta: "Como funciona o processo de code review?"
Opções:
- 1 aprovador obrigatório
- 2 aprovadores obrigatórios
- Revisão obrigatória + CI verde para merge
- PR opcional (confia no autor)
- Pair programming como substituto de CR
- Não definido ainda
- Outro (descreva)
```

**I4** — Checks obrigatórios no CI
```
Pergunta interativa | header: "CI checks" | multiSelect: true
Pergunta: "Quais checks são obrigatórios no CI/CD para merge?"
Opções:
- Lint / formatação
- Build sem erros
- Testes unitários
- Testes de integração
- Cobertura mínima de testes
- Análise de segurança (SAST)
- Nenhum CI configurado ainda
- Outro (descreva)
```

---

## FASE 3 — Geração dos Arquivos

**Regra geral**: gere apenas os arquivos com informação suficiente. Onde houver lacunas, inclua `<!-- TODO: preencher -->` com instrução clara do que adicionar.

**Regra de arquivos extras**: para cada arquivo padrão cujo conteúdo já está coberto (total ou parcialmente) por um arquivo extra identificado na FASE 1:

1. Gere o arquivo padrão com a seguinte estrutura:
   ```markdown
   > **Referência principal:** os padrões completos deste tópico estão em [`NomeDoArquivoExtra.md`](NomeDoArquivoExtra.md). Este arquivo registra apenas os itens complementares não cobertos por ele.
   ```
2. Adicione abaixo **somente** as seções/itens que constituem gap (não cobertos pelo arquivo extra).
3. Se não houver gap: o arquivo padrão contém apenas a referência — não duplique informação.
4. Não modifique o arquivo extra original.

### `guidelines/README.md`

```markdown
# Guidelines — [Nome do Projeto]

Este diretório define os padrões que regem o desenvolvimento. **Todos os skills SDD leem estes arquivos antes de gerar qualquer artefato** (`/prd`, `/techspec`, `/tasks`, `/tdd`, `/implement`, `/tests`, `/code_review`).

## Arquivos

| Arquivo | Conteúdo |
|---------|----------|
| `stack.md` | Stack tecnológica, versões e ferramentas |
| `architecture.md` | Padrões arquiteturais e estrutura de pastas |
| `coding-standards.md` | Convenções de código, nomenclatura, estilo |
| `testing.md` | Estratégia de testes, ferramentas, cobertura mínima |
| `api-conventions.md` | Padrões de API, contratos, versionamento |
| `security.md` | Práticas de segurança, dados sensíveis, compliance |
| `observability.md` | Logging, métricas, tracing |
| `git-workflow.md` | Branches, commits, PRs, CI/CD |

## Manutenção

Execute `/guidelines [arquivo]` para atualizar um arquivo específico, ou `/guidelines` para revisar todos.
```

### `guidelines/stack.md`

Gere com base nas respostas do Módulo B. Use este esqueleto:

```markdown
# Stack Tecnológica

## Linguagens
| Linguagem | Versão | Uso principal |
|-----------|--------|---------------|
| [ex: TypeScript] | [ex: 5.4] | [ex: backend e frontend] |

## Frameworks e Bibliotecas
| Biblioteca | Versão | Finalidade | Por que esta e não outra? |
|------------|--------|------------|--------------------------|
| [ex: NestJS] | [ex: 10] | [ex: framework HTTP] | [ex: preferível ao Express pela estrutura opinionada] |

## Banco de Dados
| Sistema | Versão | Uso | ORM/Driver | Pool size padrão |
|---------|--------|-----|------------|-----------------|
| [ex: PostgreSQL] | [ex: 16] | [ex: principal] | [ex: Prisma 5] | [ex: 10] |

## Infraestrutura
- **Cloud:** [ex: AWS (us-east-1)]
- **Containers:** [ex: Docker + ECS Fargate]
- **CI/CD:** [ex: GitHub Actions]

## Ferramentas de Desenvolvimento
| Ferramenta | Versão | Config | Quando executar |
|------------|--------|--------|-----------------|
| [ex: ESLint] | [ex: 8] | [ex: .eslintrc.json] | [ex: pre-commit + CI] |
| [ex: Prettier] | [ex: 3] | [ex: .prettierrc] | [ex: on save] |
```

### `guidelines/architecture.md`

Gere com base no Módulo C. Use este esqueleto:

```markdown
# Arquitetura

## Padrão Adotado
[ex: Clean Architecture com 4 camadas]

**Justificativa:** [por que este padrão para este projeto]

## Estrutura de Pastas
```
src/
├── domain/          # Entidades e regras de negócio puras — sem dependências externas
│   ├── entities/
│   └── value-objects/
├── application/     # Use cases — orquestra o domínio
│   ├── use-cases/
│   └── ports/       # Interfaces (contratos) para infraestrutura
├── infrastructure/  # Implementações concretas (DB, HTTP, filas)
│   ├── repositories/
│   └── adapters/
└── presentation/    # Controllers, DTOs, serialização
    └── http/
```

## Regras de Dependência
| Camada | Pode importar | Não pode importar |
|--------|--------------|-------------------|
| domain | nada externo | application, infrastructure, presentation |
| application | domain | infrastructure (só via porta/interface), presentation |
| infrastructure | domain, application | presentation |
| presentation | application | domain diretamente, infrastructure |
```

### `guidelines/coding-standards.md`

Gere com base no Módulo D. Use este esqueleto:

```markdown
# Padrões de Código

## Nomenclatura
| Artefato | Convenção | Exemplo |
|----------|-----------|---------|
| Classes | PascalCase | `UserRepository` |
| Funções/métodos | camelCase | `findUserById` |
| Variáveis | camelCase | `activeUsers` |
| Constantes | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Arquivos | kebab-case | `user-repository.ts` |
| Interfaces | PascalCase com prefixo I (opcional) | `IUserRepository` ou `UserRepository` |

## Tratamento de Erros
[ex: Use classes de erro customizadas que estendem Error. Nunca lance strings. Sempre inclua contexto.]

✅ Correto:
```ts
throw new NotFoundError(`User ${id} not found`, { context: 'UserService.findById' })
```
❌ Incorreto:
```ts
throw 'User not found'
throw new Error('not found')  // sem contexto
```

## Comentários
[ex: Zero comentários explicando O QUÊ — o código deve ser autoexplicativo. Comente apenas o PORQUÊ quando não óbvio.]

✅ Correto: `// Retry necessário porque o serviço externo tem falha transitória conhecida em cold start`
❌ Incorreto: `// Incrementa o contador` antes de `count++`
```

### `guidelines/testing.md`

Gere com base no Módulo E. Use este esqueleto:

```markdown
# Estratégia de Testes

## Pirâmide de Testes
| Tipo | Ferramenta | Cobertura mínima | Localização | Velocidade esperada |
|------|-----------|-----------------|-------------|---------------------|
| Unitário | [ex: Vitest] | [ex: 80%] | [ex: co-located: `*.spec.ts`] | < 100ms/teste |
| Integração | [ex: Vitest + Testcontainers] | [ex: fluxos críticos] | [ex: `src/__tests__/integration/`] | < 5s/teste |
| E2E | [ex: Playwright] | [ex: happy paths] | [ex: `e2e/`] | < 30s/teste |

## Estrutura Padrão (Unitário)
```ts
describe('[NomeDoMódulo]', () => {
  describe('[comportamento]', () => {
    it('deve [resultado] quando [condição]', () => {
      // Arrange
      // Act
      // Assert
    })
  })
})
```

## Estratégia de Mocks
[ex: Mock apenas dependências de infraestrutura (banco, HTTP externo). Nunca mock lógica de domínio.]

## Rodando os testes
- Unitários: `[comando]`
- Com cobertura: `[comando]`
- E2E: `[comando]`
```

### `guidelines/api-conventions.md`

Gere com base no Módulo F. Use este esqueleto:

```markdown
# Convenções de API

## Padrão e Versionamento
- **Estilo:** [ex: REST]
- **Versionamento:** [ex: URL — `/api/v1/recurso`]
- **Base URL:** [ex: `https://api.dominio.com/api/v1`]

## Nomenclatura de URLs
- Recursos: kebab-case plural — `/api/v1/user-profiles`
- Ações não-CRUD: verbos explícitos — `/api/v1/orders/:id/cancel`

## Envelope de Resposta

**Sucesso:**
```json
{
  "data": { },
  "meta": { "requestId": "uuid", "timestamp": "ISO8601" }
}
```

**Erro:**
```json
{
  "error": { "code": "CODIGO_UPPER_SNAKE", "message": "descrição", "details": [] },
  "meta": { "requestId": "uuid", "timestamp": "ISO8601" }
}
```

## Autenticação
- **Mecanismo:** [ex: Bearer JWT no header `Authorization`]
- **Renovação:** [ex: refresh token via `POST /auth/refresh`]

## Paginação
```json
{
  "data": [],
  "meta": { "page": 1, "pageSize": 20, "total": 100, "totalPages": 5 }
}
```
Query params: `?page=1&pageSize=20&sort=createdAt:desc&filter[status]=active`
```

### `guidelines/security.md`

Gere com base no Módulo G. Use este esqueleto:

```markdown
# Segurança

## Checklist obrigatório por PR
- [ ] Inputs externos validados com schema validation
- [ ] Sem dados sensíveis em logs (ver lista abaixo)
- [ ] Endpoints autenticados/autorizados conforme RBAC
- [ ] Sem SQL raw (usar ORM/query builder parametrizado)
- [ ] Sem secrets hardcoded (usar variáveis de ambiente)
- [ ] Dependências sem vulnerabilidades conhecidas (`npm audit` / `pip audit`)

## O que NUNCA deve ir para logs
- Senhas (qualquer campo com nome contendo `password`, `senha`, `secret`)
- Tokens JWT, API keys, refresh tokens
- Números de cartão, CVV, dados bancários
- CPF, RG, passaporte sem mascaramento
- Dados de saúde (LGPD categoria especial)

## Validação de entrada
[ex: Use Zod/Joi/Yup no limite da aplicação — controllers. Domínio assume dados válidos.]

## Compliance
[ex: LGPD — bases legais, titulares, DPO, retenção de dados]

## Modelo de autenticação
[ex: JWT RS256, expiry 15min, refresh 7 dias, revogação via blocklist Redis]
```

### `guidelines/observability.md`

Gere com base no Módulo H. Use este esqueleto:

```markdown
# Observabilidade

## Logging

**Formato:** JSON estruturado (nunca texto livre)

**Campos obrigatórios em TODA entrada de log:**
```json
{
  "timestamp": "ISO8601",
  "level": "ERROR|WARN|INFO|DEBUG",
  "service": "nome-do-servico",
  "requestId": "uuid-propagado-do-header",
  "action": "UserService.findById",
  "userId": "uuid (quando autenticado)"
}
```

**Quando usar cada nível:**
| Nível | Quando usar | Exemplo |
|-------|-------------|---------|
| ERROR | Falha com impacto em usuário ou integridade de dados | DB connection failed |
| WARN | Anomalia recuperável, degradação silenciosa | Rate limit approaching |
| INFO | Evento relevante no fluxo normal | Order created |
| DEBUG | Diagnóstico — desativado em produção | Cache miss for key X |

**O que NÃO registrar:** [mesma lista de security.md — senhas, tokens, PII]

## Correlation ID
Header de entrada: `X-Request-ID` (gerado pelo cliente ou gateway)
Se ausente: gerar UUID v4 na borda e propagar em todos os logs e respostas.

## Métricas mínimas
| Métrica | Tipo | Alerta |
|---------|------|--------|
| `http_requests_total` | Counter | — |
| `http_request_duration_seconds` | Histogram | p95 > [threshold] |
| `db_connection_pool_active` | Gauge | > 80% do pool size |

## Ferramentas
- **Logging:** [ex: Pino + CloudWatch]
- **APM/Tracing:** [ex: OpenTelemetry + Datadog]
```

### `guidelines/git-workflow.md`

Gere com base no Módulo I. Inclua: diagrama de fluxo de branches (Mermaid preferido), convenção de nomenclatura de branch (ex: `feat/TICKET-123-descricao`), formato de commit (Conventional Commits com exemplos), processo de PR, checklist de merge.

---

## Mínimo Viável por Skill

Antes de salvar, verifique se os arquivos gerados atendem ao mínimo necessário para cada skill downstream:

| Skill | Arquivos obrigatórios | Campos mínimos |
|-------|----------------------|----------------|
| `/prd` | `stack.md` | linguagem, framework principal |
| `/techspec` | `stack.md`, `architecture.md`, `api-conventions.md`, `security.md` | stack completa, padrão arquitetural, envelope de resposta, modelo de autenticação |
| `/tasks` | `coding-standards.md`, `testing.md` | nomenclatura, estrutura de teste, cobertura mínima |
| `/implement` | todos acima + `git-workflow.md` | convenções de commit e branch |
| `/code_review` | `coding-standards.md`, `security.md` | regras de estilo, checklist de segurança |
| `/tests` | `testing.md` | ferramenta de teste, localização dos arquivos, padrão AAA |

Se após a entrevista algum arquivo obrigatório não puder ser gerado com informação suficiente, informe o usuário e inclua `<!-- TODO: campo obrigatório para /techspec -->` no local.

---

## FASE 4 — Salvamento e Próximos Passos

1. Crie a pasta `guidelines/` se não existir.
2. Salve cada arquivo gerado.
3. Crie ou atualize `memory/constitution.md` com um resumo estruturado do projeto, baseado nas respostas coletadas e nos arquivos gerados/lidos:

   ```markdown
   # Resumo do Projeto

   _Atualizado em: [data atual]_

   ## Stack
   - Linguagens: [lista]
   - Frameworks: [lista]
   - Banco de dados: [lista]
   - Infra/Cloud: [lista]

   ## Arquitetura
   [padrão adotado e estrutura de pastas — 2-3 linhas]

   ## Convenções de Código
   - Nomenclatura: [convenção]
   - Estilo: [style guide base]
   - Comentários: [política]
   - Erros: [abordagem]

   ## Testes
   - Tipos: [lista]
   - Ferramentas: [lista]
   - Cobertura mínima: [valor]

   ## Processo
   - Git workflow: [padrão]
   - Commits: [convenção]
   - Code review: [processo]
   - CI checks: [lista]

   ## Guidelines
   - Arquivos padrão: [lista dos gerados]
   - Arquivos customizados aproveitados: [lista dos extras mapeados]
   ```

4. Informe ao usuário:
   - Arquivos criados/atualizados
   - Arquivos extras aproveitados e como foram referenciados
   - Seções com `<!-- TODO -->` que precisam de complemento
   - **Próximo passo:** Execute `/prd` para iniciar o levantamento de requisitos com os guidelines configurados.

---

## Critérios de Qualidade — Checklist Final

- [ ] Cada arquivo é autocontido (pode ser lido isoladamente)
- [ ] Versões de stack estão explícitas (sem "último", "latest", "atual")
- [ ] Convenções têm exemplos concretos (✅/❌) onde aplicável
- [ ] Regras são inequívocas — sem margem para interpretações conflitantes
- [ ] O que NÃO fazer está tão claro quanto o que FAZER
- [ ] `README.md` da pasta está atualizado com todos os arquivos presentes
