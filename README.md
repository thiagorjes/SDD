# SDD — Specification-Driven Development Framework

Bem-vindo ao **SDD**, um framework metodológico estruturado para orientar o desenvolvimento de software guiado por especificações rigorosas. Foi desenhado desde o princípio para ser operado em conjunto com Inteligência Artificial (atualmente homologado para LLMs como **Claude** e **Antigravity**).

O SDD é altamente escalável: flexível e ágil o suficiente para o desenvolvimento de pequenos projetos e MVPs, mas com a governança e profundidade necessárias para projetos corporativos ambiciosos.

## 🎯 O Problema que Resolvemos

No ecossistema atual, onde as LLMs assumem grande parte da geração de código, **a qualidade da especificação tornou-se o código-fonte definitivo**. O desenvolvimento tradicional frequentemente sofre com ruídos de comunicação entre "o que o negócio pede" e "o que a TI constrói". 

O SDD ataca esse problema segregando as responsabilidades. Em vez de uma única e exaustiva especificação mista, o framework divide o levantamento de requisitos em temas, facilitando as entrevistas e garantindo que cada participante se foque apenas no seu domínio de especialidade.

## 🔄 O Fluxo do Framework (As Três Camadas)

### 1. Camada de Negócio (Business Spec)
* **Público:** Exclusivo para Stakeholders e Product Owner (PO).
* **Foco:** Visão puramente comercial e de utilizador. Mapeamento de dores, regras de negócio, jornadas e valor esperado, sem a presença de jargões técnicos ou decisões de arquitetura.

### 2. Camada de Design (Discovery e Prototipação) 🎨 *Em Evolução*
* **Público:** PO, Designers (UX/UI) e Especialistas.
* **Foco:** Etapa **opcional, mas recomendada**. Destinada ao *discovery*, ideação visual, testes de usabilidade e criação de protótipos baseados nas dores levantadas na camada de negócio.

### 3. Camada de TI (Tech Spec)
* **Público:** PO e Arquiteto de Software.
* **Foco:** A ponte para a máquina. Traduz as exigências de negócio e as interfaces do design em requisitos técnicos concretos: modelagem de dados, diagramas de arquitetura, contratos de API e restrições de segurança que alimentarão as LLMs para a construção final do software.

## 📁 Estrutura do Repositório

O projeto conta com ferramentas embutidas para auxiliar os agentes virtuais e o ciclo de vida do framework:

📂 raiz-do-projeto

├── 📂 SDD/

│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 .agents/  # Definições de papéis (Architect, Database, Designer, QA, etc.) e skills.

│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 .claude/  # Comandos e agentes específicos otimizados para o Claude[cite: 32].

│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 memory/   # Gestão de estado, custos e constituição das LLMs[cite: 33].

│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 scripts/  # Scripts de automação (ex: init.ps1, cálculo de custos)[cite: 34].
   
├── 📄 README.md             # Este documento[cite: 35].
   
└── 📄 roadmap_melhorias.txt # Acompanhamento do desenvolvimento e evolução do framework[cite: 35].


## 🚀 Como Começar
Para inicializar a estrutura do SDD em um novo projeto e preparar o ambiente para as IAs, utilize o script de inicialização localizado na pasta de utilitários:

```
# Executar no terminal (PowerShell)
./SDD/scripts/init.ps1
```

A partir daí, inicie a extração de requisitos pela Camada de Negócio, alimentando seu agente LLM com os templates correspondentes para dar a largada no seu desenvolvimento guiado por especificação.

Projeto idealizado e mantido por Thiago Gonçalves Cavalcante (Argovix Soluções Tecnologicas LTDA).
