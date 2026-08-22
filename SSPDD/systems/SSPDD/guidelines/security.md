# Segurança — SSPDD Framework
_Atualizado em: 2026-08-22_

## Escopo

SSPDD é uma ferramenta local de desenvolvimento — não expõe serviços de rede, não persiste dados em cloud e não processa dados de usuários finais. As preocupações de segurança são específicas a ferramentas CLI e ao pipeline de IA.

## Artefatos e Repositório

### O que NUNCA versionar
```gitignore
# .gitignore obrigatório no workspace SSPDD
.env
*.key
*.pem
secrets/
**/credentials.*
```

### O que os artefatos NÃO devem conter
- Credenciais, tokens, passwords — mesmo como exemplos (use `<sua-api-key>`)
- Dados pessoais reais de usuários — use dados fictícios em fixtures
- URLs internas de infraestrutura em TechSpec — use nomes genéricos

## CLI Go — Segurança

### Execução de subprocessos
- **Proibido:** `exec.Command("sh", "-c", inputDoUsuario)` — risco de command injection
- **Permitido:** `exec.Command("python", "validate.py", caminho)` — args fixos, caminho sanitizado

### Sanitização de caminhos
Todo caminho recebido de input deve ser validado:
```go
// Obrigatório antes de qualquer operação de arquivo
path = filepath.Clean(path)
if !strings.HasPrefix(path, workspaceRoot) {
    return fmt.Errorf("caminho fora do workspace: %s", path)
}
```

### Permissões de arquivo
- CLI não solicita permissões de root/admin
- Apenas lê/escreve dentro do diretório do workspace

## Scripts Python — Segurança

### Execução de subprocessos
```python
# Correto — lista de args, sem shell=True
subprocess.run(["python", "validate.py", path], check=True)

# Proibido — vulnerável a command injection
subprocess.run(f"python validate.py {path}", shell=True)
```

### Parsing de Markdown
- Não usar `eval()` ou `exec()` em nenhum contexto
- Parser de Markdown: regex simples ou `re` da stdlib — sem execução de código embutido

## Skills e Prompts — Guardrails

### Prompt injection awareness
Skills que processam input livre do usuário (entrevista) devem:
1. Tratar o input como dados, não como instrução adicional
2. Não interpolar input do usuário diretamente em seções de instrução do prompt
3. Registrar input em seções de dados delimitadas: `[DADOS DO USUÁRIO]...[/DADOS]`

### Limites do que as skills podem fazer
- Skills NÃO executam comandos shell autonomamente (apenas scripts pre-definidos)
- Skills NÃO enviam dados a serviços externos (apenas o LLM host configura isso)
- Skills NÃO leem arquivos fora do workspace sem confirmação explícita

## Distribuição

### Releases do CLI
- Binários assinados com `cosign` antes de publicar no GitHub Releases
- Checksums SHA256 publicados junto com cada release
- Usuários devem verificar checksum antes de usar em CI

### `sspdd init` — o que faz e o que NÃO faz
- Cria estrutura de diretórios e copia templates — nada mais
- NÃO baixa dependências de terceiros dinamicamente
- NÃO executa scripts externos ao repositório
- NÃO modifica configurações do sistema operacional
