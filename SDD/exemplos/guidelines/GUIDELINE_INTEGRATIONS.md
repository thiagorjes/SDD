# Guideline: Integrações Externas (WebClient)

Para o padrão de **Integrações Externas**, o foco será a utilização do `WebClient` dentro de um ecossistema **imperativo (bloqueante)**. Embora o `WebClient` seja nativamente reativo, ele é a escolha recomendada pela Spring para substituir tecnologias legadas, oferecendo uma API mais fluida e recursos modernos de resiliência.

---

## 🏗️ Estrutura de Pastas

Todas as novas integrações devem ser centralizadas no pacote `integrations`, organizadas pelo nome da API de destino. Isso isola o domínio externo da lógica de negócio interna.

**Exemplo de hierarquia:**
* `src/main/java/com/exemplo/integrations/`
    * `clientes-api/`
        * `ClientesApiClient.java` (Interface ou Classe de chamada)
        * `ClientesApiConfig.java` (Configuração específica: timeouts, base URL)
        * `models/` (DTOs de Request e Response exclusivos desta API)
    * `estoque-api/`
        * `EstoqueApiClient.java`
        * `models/`

---

## 🛠️ Configuração do WebClient

Para aplicações bloqueantes, o segredo está em configurar corretamente os **Timeouts** e utilizar o método `.block()` para obter o resultado da requisição.

### Exemplo de Configuração (Bean)

```java
@Configuration
public class ClientesApiConfig {

    @Bean
    public WebClient webClientClientes(WebClient.Builder builder) {
        return builder
            .baseUrl("https://api.clientes.com/v1")
            .clientConnector(new ReactorClientHttpConnector(HttpClient.create()
                .responseTimeout(Duration.ofSeconds(2)))) // Timeout de resposta
            .build();
    }
}
```

---

## 🚀 Implementação do Client com Retry

Abaixo, um exemplo de implementação utilizando o padrão de diretórios sugerido e a estratégia de **Retry**. O uso de tentativas automáticas é essencial para lidar com instabilidades momentâneas da rede.

```java
@Component
public class ClientesApiClient {

    private final WebClient webClient;

    public ClientesApiClient(WebClient webClientClientes) {
        this.webClient = webClientClientes;
    }

    public ClienteResponse buscarCliente(String id) {
        return webClient.get()
            .uri("/clientes/{id}", id)
            .retrieve()
            .bodyToMono(ClienteResponse.class)
            // Estratégia de Retry: 3 tentativas com intervalo de 2 segundos
            .retryWhen(Retry.fixedDelay(3, Duration.ofSeconds(2))) 
            .block(); // Transforma a chamada em bloqueante
    }
}
```

---

## 📝 Boas Práticas

* **Isolamento de Models:** Nunca utilize suas classes de entidade JPA ou DTOs de entrada da sua API nas integrações. Crie modelos específicos dentro da pasta `models` de cada integração para evitar acoplamento.
* **Timeouts Obrigatórios:** Nunca deixe o timeout default. Em aplicações bloqueantes, uma API externa lenta pode "pendurar" todas as threads do seu Spring Boot rapidamente.
* **Tratamento de Erros:** Utilize o `.onStatus()` antes do `.bodyToMono()` se precisar capturar erros específicos (4xx ou 5xx) e lançar exceções de negócio personalizadas.
* **Log de Requisições:** Considere configurar um filtro de log no `WebClient` para facilitar o debug em ambiente de desenvolvimento, mas cuidado com dados sensíveis em produção.

O uso do `.block()` garante que sua aplicação continue seguindo o fluxo imperativo do Spring MVC tradicional, enquanto aproveita a sintaxe moderna do `WebClient`.