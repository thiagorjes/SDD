# Guideline: Spring Boot Best Practices (Java 21)

Para fechar o guia de **Spring Boot Best Practices** com Java 21 e a versão mais recente do Spring Boot (3.x), vamos focar no que realmente move o ponteiro no dia a dia: legibilidade, performance com recursos modernos e manutenção simplificada.

Como estamos usando Java 21, o código deve ser mais conciso e expressivo.

---

## 1. Java 21: O Fim da Verbocidade

Com Java 21, o uso de **Records** e **Pattern Matching** não é apenas "legal", é o padrão.

* **Records para DTOs:** Use records para todas as representações de dados que não mudam (Imutabilidade por padrão).
* **Switch Expressions:** Utilize para lógicas de decisão mais limpas e exaustivas.

```java
// Exemplo de DTO moderno
public record ClienteRequest(
    @NotBlank String nome,
    @Email String email
) {}
```

---

## 2. Arquitetura e Organização de Camadas

Mantenha a separação clara de responsabilidades. Para uma API simples com integrações, a estrutura recomendada é:

1.  **Web/Controller:** Apenas orquestração de entrada e saída. Nunca coloque lógica de negócio aqui.
2.  **Service:** Onde a "mágica" acontece. Validações de negócio e orquestração entre banco e integrações.
3.  **Repository:** Apenas persistência (Spring Data JPA).
4.  **Integrations:** Como definido anteriormente, isolando o mundo externo.



---

## 3. Injeção de Dependências

Esqueça o `@Autowired` em campos. Use **Injeção por Construtor**. 
* **Vantagem:** Garante imutabilidade (`final`) e facilita a detecção de dependências circulares.
* **Dica:** Com Java 21 e Spring 3, se a classe tem apenas um construtor, o `@Autowired` é opcional.

```java
@Service
public class ClienteService {
    private final ClienteRepository repository;
    private final ClientesApiClient apiClient;

    public ClienteService(ClienteRepository repository, ClientesApiClient apiClient) {
        this.repository = repository;
        this.apiClient = apiClient;
    }
}
```

---

## 4. Tratamento de Erros Moderno (RFC 7807)

O Spring Boot 3 introduziu o suporte nativo ao **Problem Details for HTTP APIs**. Em vez de retornar mapas genéricos, use o `ProblemDetail`.

* Crie um `@ControllerAdvice` global.
* Retorne status codes semânticos (404 para Not Found, 422 para erros de negócio).

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ClienteNotFoundException.class)
    public ProblemDetail handleNotFound(ClienteNotFoundException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
        problem.setTitle("Cliente não encontrado");
        return problem;
    }
}
```

---

## 5. Configurações Tipo-Safe

Evite usar `@Value("${chave}")` espalhado pelo código. Use `@ConfigurationProperties`. Isso agrupa configurações relacionadas e permite validação na inicialização.

```java
@ConfigurationProperties(prefix = "external.api")
public record ApiSettings(String baseUrl, Duration timeout, int retryAttempts) {}

// No arquivo principal ou config: @EnableConfigurationProperties(ApiSettings.class)
```

---

## 6. Banco de Dados e Performance

* **N+1 Selects:** Sempre monitore suas queries. Use `@EntityGraph` ou `JOIN FETCH` quando precisar de dados relacionados.
* **DTO Projections:** Se você só precisa de 2 campos de uma tabela com 50, não traga a entidade inteira. Use interfaces ou records no Repository para fazer o "select" apenas do que é necessário.

---

## 7. Checklist de "O que NÃO fazer"

| Prática Ruim | O que fazer no lugar |
| :--- | :--- |
| Retornar Entidades JPA na Controller | Usar Records (DTOs) |
| Lógica de negócio no Repository | Criar métodos específicos no Service |
| Usar `System.out.println` | Usar SLF4J com `@Slf4j` (Lombok) |
| Hardcoding de URLs | Usar `application.yml` + `ConfigurationProperties` |

Esta abordagem mantém o projeto alinhado com o que há de mais moderno no ecossistema Java, garantindo que a aplicação seja simples de entender, mas robusta o suficiente para crescer.