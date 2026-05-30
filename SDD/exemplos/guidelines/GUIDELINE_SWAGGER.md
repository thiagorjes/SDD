# Guideline: OpenAPI / Swagger

Para a especificação de **OpenAPI / Swagger**, o objetivo é garantir que a documentação seja o contrato vivo da aplicação. Com Spring Boot 3 e Java 21, a integração é quase automática, mas a qualidade da doc depende de metadados bem aplicados.

---

## 📜 Política de Atualização
* **Mandatório:** Todo novo endpoint deve nascer com sua respectiva documentação OpenAPI.
* **Sincronismo:** Qualquer alteração em contratos existentes (mudança de campo em Record, novo Status Code ou alteração de URL) deve ser refletida imediatamente nas anotações do Swagger.

---

## 🏷️ Organização e Tags
Use a anotação `@Tag` no nível da Controller para agrupar os endpoints por domínio. Isso evita que a UI do Swagger vire uma lista infinita e desorganizada.

```java
@Tag(name = "Clientes", description = "Operações para gerenciamento de clientes e integrações")
@RestController
@RequestMapping("/v1/clientes")
public class ClienteController { ... }
```

---

## 🛠️ Documentando Endpoints (@Operation)
Não confie apenas no nome do método Java. Use `@Operation` para descrever o que o endpoint faz de forma clara para quem consome (ex: Frontend ou outros times).

* **Summary:** Resumo curto (o que aparece na lista fechada).
* **Description:** Explicação detalhada (se necessário).

```java
@Operation(summary = "Busca um cliente pelo ID", description = "Retorna os dados cadastrais do cliente consultando a base local e a API de integração.")
@GetMapping("/{id}")
public ClienteResponse buscar(@PathVariable String id) { ... }
```

---

## 📦 Documentando Models (Records)
Como estamos usando **Records**, a documentação fica limpa. Use `@Schema` para adicionar exemplos e descrições aos campos, facilitando o entendimento dos tipos de dados.

```java
public record ClienteResponse(
    @Schema(description = "ID único do cliente", example = "UUID-123")
    String id,
    
    @Schema(description = "Nome completo do cliente", example = "João Silva")
    String nome
) {}
```

> **Dica:** O Swagger lerá automaticamente as anotações do `Bean Validation` (como `@NotBlank`, `@Min`, `@Email`). Certifique-se de usá-las para que as restrições apareçam na documentação.

---

## 🔄 Padronização de Respostas (@ApiResponse)
Evite poluir cada método com 10 anotações de resposta. Documente apenas o **sucesso** e os **erros específicos** do negócio. Erros genéricos (como 500) costumam ser configurados globalmente.

Com o uso do `ProblemDetail` (RFC 7807), o Swagger deve refletir essa estrutura em caso de erro:

```java
@ApiResponses(value = {
    @ApiResponse(responseCode = "200", description = "Cliente encontrado com sucesso"),
    @ApiResponse(responseCode = "404", description = "Cliente não localizado na base", 
                 content = @Content(schema = @Schema(implementation = ProblemDetail.class))),
    @ApiResponse(responseCode = "422", description = "Dados de entrada inválidos")
})
```

---

## 💡 Boas Práticas Rápidas

1.  **Operation Id:** O SpringDoc gera um ID automático, mas se precisar de nomes específicos para geradores de client (ex: Angular), use o atributo `operationId`.
2.  **Esconda o desnecessário:** Se tiver um endpoint de controle interno que não deve ser exposto no Swagger, use `@Hidden`.
3.  **Ambientes:** A documentação deve estar habilitada em `dev` e `hml`, mas avalie se deve estar exposta em `prd` por questões de segurança (usualmente protegida por VPN ou desabilitada).