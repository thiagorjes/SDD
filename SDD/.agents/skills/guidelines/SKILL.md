---
name: guidelines
description: Creates and maintains project engineering guideline files covering stack, architecture, coding standards, testing, security, API conventions, observability, and git workflow. Use to set up or update the project standards that all other SDD skills reference.
---

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

### Módulo J — Design e UI/UX
> Pule se o projeto for puramente backend/API ou se for uma CLI sem interface gráfica.

**Antes de qualquer pergunta do Módulo J — detecção e validação de design system pré-existente (silenciosa):**

**Passo 1 — Detecção:** verifique na seguinte ordem e leia tudo que encontrar:
1. `DESIGN.md` na raiz do projeto
2. `guidelines/design.md` com conteúdo (não apenas placeholder)
3. `design/tokens/design-tokens.json`
4. Diretório de tema no código (`src/theme/`, `styles/tokens/`, `design-system/` ou equivalente)

**Passo 2 — Extração:** se qualquer fonte foi encontrada, extraia e registre internamente:

| Campo | Extraído? | Valor |
|-------|-----------|-------|
| Cor primária (hex) | sim/não | `#XXXXXX` |
| Cor acento (hex) | sim/não | `#XXXXXX` |
| Fundo / texto / erro / sucesso (hex) | sim/não | ... |
| Tipografia (fonte + peso + tamanho base) | sim/não | ... |
| Border radius (sm/md/lg) | sim/não | ... |
| Espaçamento base | sim/não | ... |
| Biblioteca de componentes | sim/não | ... |
| Inventário de componentes (Button, Input, Table mínimos) | sim/não | ... |
| Ícones | sim/não | ... |
| Breakpoints definidos | sim/não | ... |
| Estratégia de responsividade | sim/não | ... |
| Nível WCAG | sim/não | ... |
| Contraste mínimo | sim/não | ... |

**Passo 3 — Validação de gaps:** para cada campo marcado como "não", pergunte ao usuário de forma cirúrgica — apenas os gaps, nunca o que já foi extraído.

Informe primeiro o que foi encontrado:
> "Design system detectado em `[caminho]`. Extraí: [lista resumida do que foi coberto]. Precisarei de complemento para: [lista dos gaps]."

Em seguida, conduza **apenas as perguntas de gap** abaixo que se aplicarem — pule todas as demais:

**[Gap: tokens de cor incompletos]**
```
Pergunta interativa | header: "Cores faltantes"
Pergunta: "Os seguintes tokens de cor não foram encontrados: [lista]. Quais são os valores hex?"
→ Texto livre por token
```

**[Gap: tipografia ausente]**
```
Pergunta interativa | header: "Tipografia"
Pergunta: "Qual a fonte principal de UI e seus pesos? (ex: Inter 400/600)"
→ Texto livre
```

**[Gap: biblioteca de componentes indefinida]**
```
Pergunta interativa | header: "Componentes UI" | multiSelect: false
Pergunta: "Qual a estratégia base para os componentes de interface?"
Opções:
- Componentes 100% customizados (Tailwind, CSS puro, etc)
- Biblioteca unstyled/headless (ex: Radix UI, Headless UI) + Customização
- Biblioteca opinionada completa (ex: Material UI, Ant Design, Chakra UI)
- Outro (descreva)
```

**[Gap: inventário de componentes ausente]**
```
Pergunta interativa | header: "Inventário de componentes"
Pergunta: "Quais são os componentes padrão do projeto? Liste nome e localização no código (ex: Button → src/components/Button)."
→ Texto livre
```

**[Gap: ícones indefinidos]**
```
Pergunta interativa | header: "Ícones" | multiSelect: false
Pergunta: "Qual o padrão de iconografia adotado?"
Opções:
- Phosphor Icons / Lucide Icons
- Material Icons / FontAwesome
- SVGs customizados
- Outro (descreva)
```

**[Gap: breakpoints ausentes]**
```
Pergunta interativa | header: "Breakpoints"
Pergunta: "Quais são os breakpoints definidos? (ex: sm=640px, md=768px, lg=1024px)"
→ Texto livre
```

**[Gap: responsividade indefinida]**
```
Pergunta interativa | header: "Responsividade" | multiSelect: false
Pergunta: "Qual a abordagem de layout?"
Opções:
- Mobile First
- Desktop First
- Ambos — responsivo clássico
- Outro (descreva)
```

**[Gap: acessibilidade indefinida]**
```
Pergunta interativa | header: "Acessibilidade" | multiSelect: false
Pergunta: "Qual o nível mínimo de acessibilidade exigido?"
Opções:
- WCAG AA (contraste 4.5:1 — padrão recomendado)
- WCAG AAA (contraste 7:1 — nível mais restritivo)
- Sem requisito formal definido
- Outro (descreva)
```

**Se nenhum artefato foi encontrado (projeto sem design system):** conduza J1–J5 completos normalmente.

**Se todos os campos foram extraídos sem gaps:** informe ao usuário e pule J1–J5 integralmente.
> "Design system completamente mapeado em `[caminho]` — nenhuma pergunta adicional necessária para o Módulo J."

**J1** — Identidade Visual e Tokens
```
Pergunta interativa | header: "Identidade Visual" | multiSelect: false
Pergunta: "Qual é o status da identidade visual e design tokens?"
Opções:
- Já existem artefatos definidos (ex: DESIGN.md, Figma, tokens CSS mapeados)
- Usaremos um Design System público/existente sem alterações estruturais
- Precisará ser criado do zero na etapa de Design (/designer)
- Não definido
- Outro (descreva)
```

**J2** — Biblioteca de Componentes UI
```
Pergunta interativa | header: "Componentes UI" | multiSelect: false
Pergunta: "Qual será a estratégia base para os componentes de interface?"
Opções:
- Componentes 100% customizados (do zero com Tailwind, CSS puro, etc)
- Biblioteca unstyled/headless (ex: Radix UI, Headless UI) + Customização
- Biblioteca opinionada completa (ex: Material UI, Ant Design, Chakra UI)
- Outro (descreva)
```

**J3** — Ícones e Assets Visuais
```
Pergunta interativa | header: "Ícones e Assets" | multiSelect: false
Pergunta: "Qual será o padrão para a iconografia do projeto?"
Opções:
- Phosphor Icons / Lucide Icons (modernos, neutros)
- Material Icons / FontAwesome (clássicos)
- SVGs customizados desenhados pelo time
- Outro (descreva)
```

**J4** — Estratégia de Responsividade
```
Pergunta interativa | header: "Responsividade" | multiSelect: false
Pergunta: "Qual será a abordagem principal de layout?"
Opções:
- Mobile First rígido (pensado para celular primariamente)
- Desktop First (sistemas internos, dashboards complexos)
- Web Responsive clássico (fluido em todas as telas)
- Outro (descreva)
```

**J5** — Animações e Micro-interações
```
Pergunta interativa | header: "Animações" | multiSelect: false
Pergunta: "Qual a diretriz técnica para animações na interface?"
Opções:
- Animações ricas e complexas (ex: Framer Motion, Lottie)
- Apenas transições CSS simples (foco em leveza)
- Nenhuma animação (foco absoluto em performance e acessibilidade)
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
| `design.md` | Diretrizes visuais, estado dos tokens e biblioteca de componentes |

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

Gere com base no Módulo I. Esqueleto:

```markdown
# Fluxo de Trabalho Git e CI/CD

## Branching Model
- **Estratégia:** [ex: GitHub Flow]
- **Nomenclatura:** [ex: feature/, fix/]

## Commits e Pull Requests
- **Padrão de Commit:** [ex: Conventional Commits]
- **Regras para CR:** [ex: Mínimo de 1 aprovador + CI passando]

## Pipeline (CI/CD)
- **Checks Obrigatórios:**
  - [ex: Lint e Formatação]
  - [ex: Testes Unitários]
```

### `guidelines/design.md`

Gere com base nas respostas do Módulo J (ou dos artefatos detectados na FASE 1 / detecção silenciosa do Módulo J). Este arquivo é lido pelo `/designer` e pelo agente prototipador — use valores exatos, não descrições vagas.

Se o conteúdo foi extraído de um arquivo externo (`DESIGN.md`, `src/theme/`, etc.), adicione no topo:
```markdown
> **Fonte primária:** os valores canônicos estão em [`DESIGN.md`](../DESIGN.md) (ou caminho equivalente). Este arquivo registra apenas os itens complementares não cobertos por ela.
```

Template:

```markdown
# Diretrizes de Design e UI/UX

> Lido por: `/designer` (skill e agente), agente prototipador, `/techspec`.
> Fonte: [gerado pelo /guidelines em DD/MM/AAAA | extraído de DESIGN.md | extraído de src/theme/]

---

## 1. Tokens Visuais

| Token | Valor | Uso |
|-------|-------|-----|
| Cor primária | `#XXXXXX` | CTAs, links ativos |
| Cor de acento | `#XXXXXX` | Highlights, badges |
| Fundo (light) | `#XXXXXX` | Background padrão |
| Fundo (dark) | `#XXXXXX` | Background dark mode |
| Texto principal | `#XXXXXX` | Body text |
| Texto secundário | `#XXXXXX` | Labels, captions |
| Erro | `#XXXXXX` | Estados de erro |
| Sucesso | `#XXXXXX` | Confirmações |
| Aviso | `#XXXXXX` | Alertas |
| Border radius SM | `Xpx` | Inputs, chips |
| Border radius MD | `Xpx` | Cards |
| Border radius LG | `Xpx` | Modais, painéis |
| Espaçamento base | `Xpx` | Grid unit |

**Tipografia:**
| Papel | Fonte | Peso | Tamanho base |
|-------|-------|------|--------------|
| Display / Heading | [fonte] | [peso] | [tamanho] |
| Body / UI | [fonte] | [peso] | [tamanho] |
| Code / Mono | [fonte] | [peso] | [tamanho] |

**Tema:** [ ] Light only [ ] Dark only [ ] Ambos (toggle obrigatório no protótipo)

---

## 2. Biblioteca de Componentes

**Abordagem:** [100% custom | unstyled/headless + customização | biblioteca opinionada]
**Biblioteca base:** [ex: Radix UI, Material UI, Ant Design, nenhuma]
**Ícones:** [ex: Phosphor Icons, Lucide, Material Icons, SVGs customizados]

### Inventário de Componentes Padrão

| Componente | Localização no código | Variantes disponíveis | Notas de uso |
|------------|----------------------|----------------------|--------------|
| Button | `src/components/Button` | primary, secondary, ghost, danger | Mínimo 44px altura mobile |
| Input | `src/components/Input` | default, error, disabled | Sempre com label acessível |
| Table | `src/components/Table` | sortable, paginated | Usar para listagens > 5 itens |
| Modal | `src/components/Modal` | sm, md, lg | Focar no primeiro elemento interativo |
| Toast/Alert | `src/components/Toast` | success, error, warning, info | Duração padrão: 4s |
| [adicione conforme o projeto] | | | |

> **Regra absoluta para o prototipador:** nunca inventar componentes fora deste inventário. Se um componente necessário não estiver listado, registre como gap no `screen-map.md`.

---

## 3. Layout e Responsividade

**Estratégia:** [Mobile First | Desktop First | Ambos]
**Breakpoints:**
| Nome | Largura mínima | Uso |
|------|---------------|-----|
| sm | `640px` | Smartphones landscape |
| md | `768px` | Tablets |
| lg | `1024px` | Desktops |
| xl | `1280px` | Desktops wide |

**Grid:** [ex: 12 colunas, gap de 16px]
**Animações:** [ex: apenas transições CSS simples, max 200ms | Framer Motion | nenhuma]

---

## 4. Acessibilidade (Corporativa)

- **Nível mínimo:** WCAG [AA | AAA]
- **Contraste texto normal:** ≥ 4.5:1
- **Contraste texto grande (≥ 18pt):** ≥ 3:1
- **Hit-targets mínimos:** 44×44px (mobile) / 32×32px (desktop)
- **Navegação por teclado:** [obrigatória | não requerida]
- **Leitor de tela:** [obrigatório — `aria-label` em todos os ícones sem texto | não requerido]
- **Internacionalização:** [apenas PT-BR | multilíngue — impacto em layout: sim/não]

---

## 5. Regras de Consistência

- Nunca sobrescrever tokens definidos neste arquivo com valores hardcoded.
- Nunca criar componente novo sem antes verificar o inventário (seção 2).
- O design brief gerado pelo `/designer` complementa este arquivo — não o substitui.
- Em caso de conflito entre este guideline e o design brief: **este guideline prevalece**.
```

---

## Mínimo Viável por Skill

Antes de salvar, verifique se os arquivos gerados atendem ao mínimo necessário para cada skill downstream:

| Skill | Arquivos obrigatórios | Campos mínimos |
|-------|----------------------|----------------|
| `/prd` | `stack.md` | linguagem, framework principal |
| `/designer` | `design.md` | tokens (hex exatos), inventário de componentes, breakpoints, acessibilidade |
| `/techspec` | `stack.md`, `architecture.md`, `api-conventions.md`, `security.md`, `design.md` (se UI) | stack completa, padrão arquitetural, envelope de resposta, modelo de autenticação |
| `/tasks` | `coding-standards.md`, `testing.md` | nomenclatura, estrutura de teste, cobertura mínima |
| `/implement` | todos acima + `git-workflow.md` | convenções de commit e branch |
| `/code_review` | `coding-standards.md`, `security.md` | regras de estilo, checklist de segurança |
| `/tests` | `testing.md` | ferramenta de teste, localização dos arquivos, padrão AAA |

Se após a entrevista algum arquivo obrigatório não puder ser gerado com informação suficiente, informe o usuário e inclua `<!-- TODO: campo obrigatório para /techspec -->` no local.

---

## FASE 4 — Comitê de Análise Assíncrono

Antes de salvar definitivamente os arquivos, submeta-os a uma revisão para garantir robustez.

1. **Apresente o Draft ao Usuário e Peça Permissão:**
   > "Os guidelines foram estruturados. Antes de finalizar, recomendo submetermos esse planejamento ao **Comitê de Especialistas** (Segurança, Arquitetura e DevOps) no background para garantir que não há falhas críticas. Deseja que eu inicie a revisão? [Sim / Não]"

2. **Se o usuário disser "Sim":**
   - Invoque os sub-agentes especializados usando o mecanismo nativo do seu ambiente. Oriente-os a analisar os documentos gerados contra melhores práticas de mercado.
     - Claude Code: ferramenta `Task` + agentes em `.claude/agents/`
     - Antigravity: `invoke_subagent`
     - Codex / outros: mecanismo nativo de sub-agentes
   - *Se o ambiente não suportar sub-agentes:* Simule as personas de Arquitetura, Segurança e DevOps em auto-reflexão no próprio chat.
   
3. **Consolidação:** Apresente os resultados da análise ao usuário e ajuste os arquivos se ele aprovar.
   > "O comitê analisou o planejamento. 
   > - **Segurança:** [Ponto levantado].
   > - **Arquitetura:** [Ponto levantado].
   > - **DevOps:** [Ponto levantado].
   > Aceita incorporar essas sugestões nos documentos finais?"

4. **Se o usuário disser "Não":** Avance direto para a Fase 5.

---

## FASE 5 — Salvamento e Próximos Passos

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
