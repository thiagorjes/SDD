# Guideline: Arquitetura e Estrutura de Código (Java/Spring)

## 1. Visão Geral da Estrutura
O projeto utiliza uma variação de **Screaming Architecture**, onde a intenção do negócio está centralizada no diretório `internal`. A estrutura deve ser rigorosamente seguida para garantir manutenibilidade e isolamento.

### Hierarquia de Pastas e Responsabilidades:

| Pasta | Responsabilidade |
| :--- | :--- |
| **`config`** | Configurações globais do Spring (Security, Bean Beans, Jackson, etc.). |
| **`integrations`** | Clientes para APIs externas (Feign, WebClient), mappers de integração e DTOs de terceiros. |
| **`internal/core`** | Componentes compartilhados entre domínios (Exceptions base, Enums genéricos, classes utilitárias internas). |
| **`internal/[dominio]`** | O "coração" da aplicação. Cada domínio (ex: `cliente`, `pedido`) é isolado. |
| **`util`** | Classes puras de Java (Helper classes) sem dependência do Spring, reutilizáveis em qualquer projeto. |
| **`resources/db`** | Scripts SQL, Flyway/Liquibase migrations e configurações de banco. |

---

## 2. Camadas do Domínio (`internal/[dominio]`)

Cada subpasta dentro de um domínio tem um papel restrito:

### A. Controller
* **Papel:** Ponto de entrada (REST).
* **Regra:** Não deve conter lógica de negócio. Deve apenas receber a request, validar o input básico e chamar o `service`.
* **Dados:** Recebe e retorna objetos contidos na pasta `model`.

### B. Service
* **Papel:** Onde reside 100% da regra de negócio.
* **Regra:** Orquestra as chamadas ao `repository` e as transformações de dados. 
* **Restrição:** É a única camada que pode injetar componentes de `integrations` ou outros services de `internal`.

### C. Model
* **Papel:** Objetos de transporte de dados (DTOs, Request, Response).
* **Regra:** Devem ser usados para trafegar dados entre `controller` e `service`. 
* **Padrão:** Usar `Java Records` para garantir imutabilidade.

### D. Repository & Entity
* **Repository:** Interfaces que estendem Spring Data JPA.
* **Entity:** Mapeamento direto com o banco de dados.
* **Regra Crítica:** Uma **Entity** nunca deve ser retornada diretamente pelo Controller. Ela deve ser mapeada para um objeto da pasta `model` dentro do `service`.

---

## 3. Regras de Ouro para a IA (Protocolo de Escrita)

Ao gerar código, a IA deve respeitar as seguintes diretrizes técnicas:

1.  **Injeção de Dependência:** Usar exclusivamente **Constructor Injection** com campos `final`. Evitar `@Autowired`.
2.  **Imutabilidade:** Priorizar `Records` em `model` e em `internal/core`.
3.  **Clean Code:** Métodos de `service` devem ser pequenos e ter nomes que descrevam a ação de negócio (ex: `finalizarCompra` em vez de `updateStatus`).
4.  **Tratamento de Erros:** Exceções de negócio devem ser criadas em `internal/core` ou no domínio específico e capturadas por um Global Exception Handler em `config`.
5.  **Separação de Preocupações:** Se uma classe utilitária for específica para o domínio, fica em `internal/[dominio]`. Se for genérica (ex: manipulador de datas), fica em `util`.

---

## 4. Como usar no Antigravity

Sempre que iniciar uma tarefa, você pode referenciar este documento. 

**Exemplo de instrução para a IA:**
> "Crie um novo domínio de 'Produto' seguindo a estrutura definida em `GUIDELINE_ARQUITETURA.md`. Lembre-se de colocar as entidades em `internal/produto/repository/entity` e usar records para os objetos em `internal/produto/model`."

**Para revisões de código:**
> "Analise o PR atual. Verifique se alguma Entity do domínio 'Cliente' está vazando para o Controller ou se há lógica de negócio fora da pasta `service`."