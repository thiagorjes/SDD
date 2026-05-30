# Guideline de Qualidade de Código - SonarQube Banestes

Este documento define as diretrizes de implementação para garantir que o código seja aderente às regras do SonarQube (Perfil: `Banestes_way`). IAs e desenvolvedores devem seguir estas regras rigorosamente.

## 1. Java (Backend)

### Segurança e Criptografia
* **Algoritmos Fortes:** Proibido o uso de algoritmos criptográficos fracos (ex: MD5, SHA1, DES). Utilize AES-256 ou SHA-256/512. (Regra: `S4426`)
* **Criptografia Dinâmica:** Sempre utilize Salt e Vetor de Inicialização (IV) dinâmicos em operações de cifragem. (Regra: `S5542`)
* **Gestão de Dependências:** Proibido o uso de bibliotecas com vulnerabilidades conhecidas (ex: Log4J v1.x ou v2.x vulneráveis). Utilize as versões recomendadas pelo Nexus do Banestes.

### Manutenibilidade e Complexidade
* **Complexidade Cognitiva:** O limite máximo permitido por método é **15**. Evite aninhamentos excessivos de `if`, `for` e `switch`. (Regra: `S3776`)
* **Tamanho de Métodos:** Mantenha métodos curtos e com responsabilidade única.
* **Código Duplicado:** Evite blocos de código idênticos. Extraia lógica comum para métodos utilitários ou serviços compartilhados.

### Higiene de Código e Logging
* **Logging Profissional:** Proibido o uso de `System.out.println` ou `System.err.println`. Utilize o Logger (`SLF4J` com `Lombok @Slf4j` é preferencial). (Regra: `S106`)
* **Tratamento de Exceções:** Nunca ignore exceções. Registre o erro no log e tome uma ação corretiva ou lance uma exceção de negócio.
* **Padrão de Nomenclatura:** Siga o padrão CamelCase para variáveis e métodos, e PascalCase para classes.

## 2. Frontend (Javascript / React / Web)

### Padrões Web
* **Tabnapping:** Links externos (`target="_blank"`) devem obrigatoriamente incluir `rel="noopener noreferrer"`. (Regra: `S5148`)
* **Tags HTML:** Evite o uso de URIs absolutas em tags HTML dentro da aplicação; prefira caminhos relativos ou injetados por configuração. (Regra: `S1829`)
* **Tamanho de Arquivo:** Arquivos Web (HTML/JS) não devem exceder 1000 linhas.

### Javascript/Typescript
* **Comparações:** Sempre utilize comparadores estritos (`===` e `!==`). (Regra: `S888`)
* **Parâmetros:** Funções não devem ter mais de 7 parâmetros. (Regra: `S107`)

## 3. Estilização (CSS)
* **Seletores:** Evite seletores excessivamente genéricos ou inválidos.
* **Propriedades:** Não duplique propriedades dentro do mesmo bloco CSS.
* **Importância:** O uso de `!important` é proibido, exceto em casos de override de bibliotecas externas devidamente justificados. (Regra: `S4653`)

## 4. Configuração (YAML / XML)
* **Sintaxe:** Arquivos YAML devem ser validados quanto à indentação e duplicação de chaves.
* **Configurações Internas:** Endereços de serviços internos (ex: Introscope) devem seguir o padrão `demopolis.banestes.sfb`.

---

## 5. Regras de Ouro para a IA (Protocolo de Escrita)

Ao gerar ou refatorar código, a IA **deve** obedecer às seguintes diretrizes preventivas contra falhas no SonarQube:

1.  **Bloqueio de Supressão:** A IA **nunca** deve utilizar anotações como `@SuppressWarnings("squid:...")` ou comentários do tipo `// NOSONAR` para contornar um problema. O código deve ser resolvido estruturalmente.
2.  **Fragmentação Ativa:** Se ao gerar um método a IA prever que a complexidade cognitiva ultrapassará 15 (múltiplos `if/else`, loops aninhados ou `switch` longos), ela deve **obrigatoriamente** quebrar a lógica em métodos auxiliares privados.
3.  **Logs ao invés de Prints:** A IA deve assumir o uso da anotação `@Slf4j` e usar `log.info()`, `log.warn()`, ou `log.error()` no lugar de qualquer saída de console (`System.out`).
4.  **Tratamento Estrito de Erros:** Blocos `catch` vazios ou que apenas printam o stack trace são estritamente proibidos. A IA deve registrar o erro no log e relançá-lo como uma exceção customizada ou tratá-lo adequadamente de acordo com o domínio.

---

## 6. Como usar no Antigravity

Sempre que solicitar a criação de uma nova feature ou refatoração, referencie este documento para garantir a aprovação nos pipelines.

**Exemplo de instrução para a IA:**
> "Refatore a classe `ProcessadorDeArquivos`. Utilize o `GUIDELINE_SONAR.md` como base, garantindo que a complexidade cognitiva dos métodos fique abaixo de 15, extraindo lógicas para métodos privados. Certifique-se de substituir qualquer `System.out` pelo padrão de logs do Lombok."

---
*Nota: Este guideline deve ser atualizado sempre que novas regras forem adicionadas ao Quality Profile do SonarQube.*
