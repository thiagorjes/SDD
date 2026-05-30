# Idioma
Sempre se comunicar em português do Brasil.

# travas de segurança
- Durante as atividades, mantenha o controle dos arquivos lidos para evitar releitura.
- **Exceto sob a orientação explícita do usuário**, nunca altere ou exclua um documento/arquivo sem antes conferir o conteúdo para garantir que está realizando a ação no arquivo correto. Essa orientação pode ser ignorada se o arquivo já tiver sido "marcado" como lido. 

# pesquisa/leitura de arquivos, diretorios, banco de dados e afins
1. ações não destrutiva (que não criam, alteram ou removem dados/arquivos) não precisam de permissão do usuário se executadas na pasta do projeto.
2. criação de arquivos na pasta do projeto não precisam de permissão do usuário.
3. criação de arquivos/dados fora pasta do projeto devem aguardar autorização do usuário.
4. ações destrutivas (que criam, alteram ou removem dados/arquivos) precisam de permissão do usuário.
4. 1. se o usuário explicitamente autorizar que as ações destrutivas possam ser realizadas sem autorização, use isso apenas até o final da execução das tarefas do prompt. Em outros prompts deve ser solicitada autorização novamente.
5. os comandos de bash/shell usados para realizas as ações seguem as regras acima, considerando se são destrutivos ou não.

# interação com o usuário
- Seja menos verboso durante as implementações, comunicando ao usuário apenas o essencial.
- Quando for necessária tomada de decisão do usuário, explique considerando que é um profissional sênior que tem conhecimento técnico e conhecimento suficiente do projeto. 
- Deixe que ele pergunte caso não entenda alguma das explicações. 
- Caso ele solicite mais detalhes, forneça-os, mas apenas durante a execução da tarefa. Nas próximas interações volte a ser sucinto e objetivo.

# economia de tokens
- mantenha dois arquivos de memória separados:
  - `memory/constitution.md` — princípios estáveis, ADRs e decisões de design do toolset. Atualizado apenas quando os fundamentos do projeto mudarem.
  - `memory/state.md` — estado operacional (features ativas, tasks, qualidade, evolução). Atualizado a cada interação que altera o estado do projeto.
- **regra de ouro**: se a mudança é um princípio ou decisão de arquitetura → `constitution.md`. Se é progresso, status ou resultado → `state.md`.
- ao final de cada interação com o usuário, execute o script de custos especificado na configuração do LLM em uso.