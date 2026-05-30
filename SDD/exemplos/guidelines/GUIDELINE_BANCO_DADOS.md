# Guideline: Performance & Database Rules

Para garantir que a aplicação seja escalável e o banco de dados não se torne o gargalo, estas são as diretrizes de **Performance & Database Rules**. Com Java 21 e Spring Boot 3, temos ferramentas poderosas para manter a persistência eficiente.

---

## 1. Migrations: O Único Caminho
Nunca utilize `spring.jpa.hibernate.ddl-auto=update` em produção. O controle de esquema deve ser versionado.

* **Ferramenta:** Use **Flyway** ou **Liquibase**.
* **Padrão de Nomeclatura:** `V[ANO][MES][DIA][HORA]__descricao_clara.sql` (ex: `V202411221030__create_table_clientes.sql`). Isso evita conflitos de ordem em times grandes.
* **Imutabilidade:** Nunca altere um arquivo de migration que já foi aplicado. Se precisar corrigir, crie uma nova migration.

---

## 2. Combate ao Problema do N+1
O problema do N+1 ocorre quando o Hibernate faz uma consulta para buscar uma lista de entidades e, em seguida, dispara uma nova consulta para cada registro para carregar seus relacionamentos `LAZY`.

* **Solução 1 (Join Fetch):** Use `JOIN FETCH` em suas consultas JPQL quando souber que precisará dos dados relacionados.
* **Solução 2 (EntityGraph):** Utilize a anotação `@EntityGraph` no Repository para definir quais atributos devem ser carregados de forma earger em uma consulta específica.

```java
@Repository
public interface PedidoRepository extends JpaRepository<Pedido, Long> {
    
    @Query("SELECT p FROM Pedido p JOIN FETCH p.itens WHERE p.cliente.id = :clienteId")
    List<Pedido> findAllByClienteWithItens(Long clienteId);
}
```

---

## 3. DTO Projections (Records)
Buscar uma entidade JPA completa (`Select *`) quando você só precisa de dois campos é um desperdício de memória e processamento.

* **Projeções com Records:** Use Java 21 Records para buscar apenas os campos necessários diretamente do banco. O Spring Data JPA mapeia isso automaticamente.
* **Vantagem:** Reduz o payload do banco e evita que o Hibernate coloque as entidades no "Persistence Context", economizando memória.

```java
// Record para a projeção
public record ClienteMinDTO(String nome, String email) {}

// No Repository
@Query("SELECT new com.exemplo.models.ClienteMinDTO(c.nome, c.email) FROM Cliente c WHERE c.ativo = true")
List<ClienteMinDTO> findAllAtivosProjected();
```

---

## 4. Estratégia de Índices
Uma migration de criação de tabela deve quase sempre ser acompanhada de uma análise de índices.

* **Foreign Keys:** Sempre crie índices em colunas que são chaves estrangeiras.
* **Campos de Busca:** Colunas usadas frequentemente em cláusulas `WHERE`, `ORDER BY` ou `JOIN` devem ser indexadas.
* **Índices Compostos:** Se você sempre busca por `status` e `data_criacao` juntos, crie um índice composto em vez de dois separados.

---

## 5. Transacionalidade Consciente
O uso incorreto do `@Transactional` pode travar o banco de dados.

* **ReadOnly:** Use `@Transactional(readOnly = true)` em métodos de consulta. Isso permite que o Hibernate otimize o flush e o dirty checking, além de direcionar a carga para réplicas de leitura se configurado.
* **Escopo Curto:** Mantenha as transações o mais curtas possível. Evite chamadas a APIs externas (WebClient) dentro de um método `@Transactional`, para não segurar uma conexão com o banco enquanto aguarda o IO da rede.

---

## 6. Batch Inserts/Updates
Para operações que envolvem muitos registros (ex: salvar 1000 logs), habilite o processamento em lote no `application.yml`:

```yaml
spring:
  jpa:
    properties:
      hibernate:
        jdbc:
          batch_size: 25
        order_inserts: true
        order_updates: true
```

---

### Resumo de Decisões
* **Entidade JPA:** Use apenas para escrita (Save/Update/Delete).
* **Records/Projections:** Use para 100% das leituras (Selects) que serão expostas pela API.
* **Lazy Loading:** Deve ser o padrão absoluto. O carregamento Eager (`FetchType.EAGER`) é proibido.