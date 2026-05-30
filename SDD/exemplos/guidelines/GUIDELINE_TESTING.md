# Guideline: Testes Unitários e de Integração

## 1. Estratégia de Testes
Os testes devem ser simples, diretos e focados na validação de contrato e comportamento.
* **Camada de Controller:** Validação de requests e responses usando `MockMvc`.
* **Camada de Service:** Lógica de negócio isolada com `Mockito`.
* **Camada de Repository:** Integração com banco de dados usando **H2**.
* **Camada de Integrations:** Simulação de APIs externas usando **WireMock** com arquivos estáticos.

---

## 2. Integrações Externas com WireMock (JSON Mapping)
Para manter os testes limpos, as respostas das APIs externas não devem estar "hardcoded" no Java. Devem ser usados arquivos JSON organizados por API.

### Organização de Arquivos:
Os arquivos devem ser colocados em `src/test/resources/mappings/[nome-da-api]/`.
* Exemplo: `src/test/resources/mappings/correios/get-address-200.json`

### Exemplo de Configuração:
A IA deve configurar o WireMock para carregar esses arquivos automaticamente:
```java
@SpringBootTest
@AutoConfigureWireMock(port = 0, stubs = "classpath:/mappings/nome-da-api")
class ExternalIntegrationTest {
    // O WireMock carregará os stubs dos arquivos JSON automaticamente
}
```

---

## 3. Testes de API com MockMvc
Os testes de Controller (e integração de fluxo) devem seguir o padrão fluente do `MockMvc`. **É obrigatório validar cada campo do JSON de resposta.**

### Padrão Sugerido:
```java
@Test
void deveRetornarSucessoAoBuscarCliente() throws Exception {
    mockMvc.perform(get("/v1/clientes/{id}", 1L)
            .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isOk())
            // Validação exaustiva campo a campo
            .andExpect(jsonPath("$.id").value(1))
            .andExpect(jsonPath("$.nome").value("João Silva"))
            .andExpect(jsonPath("$.email").value("joao@email.com"))
            .andExpect(jsonPath("$.status").value("ATIVO"));
}
```

---

## 4. Persistência de Dados (H2)
Para testar a pasta `repository`, utilize o banco H2 para garantir que as queries e mapeamentos de entidade estão corretos.

```java
@DataJpaTest
@ActiveProfiles("test")
class ClienteRepositoryTest {
    @Autowired
    private ClienteRepository repository;

    @Test
    void devePersistirEntidade() {
        var entity = new ClienteEntity("Teste", "teste@email.com");
        var salvo = repository.save(entity);
        
        assertNotNull(salvo.getId());
        assertEquals("Teste", salvo.getNome());
    }
}
```

---

## 5. Protocolo para a IA (Instruções de Escrita)

1.  **Asserts Exaustivos:** Ao criar testes de `controller` ou `integrations`, nunca valide apenas o Status Code. Você deve usar `jsonPath` para checar todos os campos retornados no payload.
2.  **Simplicidade:** Os testes devem ser diretos. Evite lógicas complexas dentro do código de teste. O foco é: *Envia Request -> Checa Response*.
3.  **Separação de Mocks:** Se a integração for com a "API de Pagamentos", crie uma pasta específica em `resources/mappings/pagamentos` e coloque lá os arquivos `.json` de sucesso e erro.
4.  **Uso de MockMvc:** Sempre que o objetivo for testar um endpoint dentro de `internal/[dominio]/controller`, utilize a estrutura:
    `mockMvc.perform(...).andExpect(status().is...).andExpect(jsonPath(...));`

---

## Como usar no Antigravity

Ao solicitar um teste, utilize o seguinte comando:

> *"IA, gere os testes para o domínio de 'Pedido' seguindo a `GUIDELINE_TESTING.md`. Utilize o padrão MockMvc para o controller, validando todos os campos do response com jsonPath. Para a integração externa com a 'API de Frete', utilize um arquivo JSON em `mappings/frete/` para simular o mock do WireMock."*

---

**Dica para a IA:** Se o JSON de resposta for muito grande, não ignore campos. Liste todos os `jsonPath` necessários para garantir que o contrato da API não seja quebrado futuramente.