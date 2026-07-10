# PRD: [Nome do Projeto/Feature]

**Versão:** 1.0
**Data:** [data atual]
**Autor:** [nome coletado na Fase 1]
**Status:** Aprovado para Especificação
**Próxima revisão:** [sugerir data em 1 semana]

---

## 1. Visão Geral

### 1.1 Contexto e Motivação
[Contexto do projeto, problema de negócio identificado e por que esta iniciativa é importante agora. Inclua impacto esperado e urgência.]

### 1.2 Objetivo
[Objetivo claro e mensurável. Formato sugerido: "Este projeto tem como objetivo [verbo de ação] [resultado esperado] para [persona principal] de forma que [benefício mensurável]."]

### 1.3 Escopo da Entrega

**Em escopo (IN):**
- [Item 1]
- [Item 2]

**Fora do escopo (OUT):**
- [Item 1 — com breve justificativa]

### 1.4 Sistemas Afetados

> Baseado na pergunta A5. Em workspace de sistema único, uma linha basta.

| Sistema | Papel nesta entrega | Cenário | Impacto |
|---------|--------------------|---------|---------|
| [nome (systems/nome/)] | [ex: emite o novo token JWT] | [greenfield/brownfield/migração] | [Alto/Médio/Baixo] |

[Se 2+ sistemas: descreva em 2–3 linhas como eles interagem nesta feature — isso orienta o contrato de integração no /techspec.]

---

## 2. Usuários e Stakeholders

### 2.1 Personas

| Persona | Perfil | Necessidades Principais | Critério de Sucesso |
|---------|--------|------------------------|---------------------|
| [Nome]  | [Perfil profissional e contexto de uso] | [O que precisa fazer/resolver] | [Como saberá que o produto atende suas necessidades] |

### 2.2 Jornada do Usuário (alto nível)
[Descreva a jornada da persona principal: "antes" (problema atual) e "depois" (experiência com a solução).]

### 2.3 Stakeholders

| Stakeholder | Papel | Interesse no Projeto |
|-------------|-------|---------------------|
| [Nome/Área] | [Papel] | [O que espera ou precisa] |

---

## 3. Requisitos Funcionais

> Cada RF deve ter identificador único, descrição clara e critérios de aceite verificáveis no formato Dado/Quando/Então. **Os critérios de aceite devem ter sido validados com o usuário no Módulo D da entrevista — não invente critérios não confirmados.**

### RF-001: [Nome do Requisito]
**Prioridade:** [Must Have / Should Have / Could Have / Won't Have]
**Persona:** [Persona relacionada]

**Descrição:** [Comportamento esperado do sistema de forma completa e sem ambiguidade]

**Critérios de Aceite:**
- [ ] Dado [contexto inicial], quando [ação do usuário ou sistema], então [resultado esperado]
- [ ] Dado [contexto], quando [ação], então [resultado]

**Fluxo de Erro:**
- [ ] Dado [contexto de erro], quando [ação], então [comportamento esperado do sistema]

**Observações:** [Notas relevantes, referências a wireframes, regras específicas]

---
[Repetir RF-XXX para cada requisito funcional, incrementando o número]

---

## 4. Requisitos Não-Funcionais

> Preencha apenas os RNFs aplicáveis à entrega. Para os não aplicáveis, registre `N/A — [motivo]` em uma linha.

### RNF-001: Performance
- **Requisito:** [Descrição específica e mensurável]
- **Métrica:** [Como será medido]
- **Meta:** [Valor alvo — ex: p95 < 500ms]

### RNF-002: Escalabilidade
- **Volume esperado:** [Usuários, req/s, volume de dados]
- **Crescimento projetado:** [Crescimento esperado em 12 meses]

### RNF-003: Segurança
- **Autenticação:** [Mecanismo]
- **Autorização:** [Modelo de permissões]
- **Proteção de dados:** [Dados sensíveis e como serão tratados]
- **Conformidade:** [Regulamentações aplicáveis]

### RNF-004: Disponibilidade
- **SLA:** [Percentual de uptime — ex: 99.9%]
- **RTO:** [Recovery Time Objective]
- **RPO:** [Recovery Point Objective]

### RNF-005: Observabilidade
- **Logs:** [O que deve ser registrado]
- **Métricas:** [O que deve ser monitorado]
- **Alertas:** [Quando e quem notificar]

---

## 5. Regras de Negócio

| ID     | Regra | Impacto em caso de violação | Origem |
|--------|-------|----------------------------|--------|
| RN-001 | [Descrição clara e sem ambiguidade] | [Consequência] | [Regulação/Política interna/Contrato] |

---

## 6. Integrações e Dependências Externas

| Sistema/Serviço | Tipo | Descrição da Integração | Responsável | Risco |
|-----------------|------|------------------------|-------------|-------|
| [Nome] | [REST/GraphQL/Evento/Batch] | [Como será utilizado] | [Time/Pessoa] | [Alto/Médio/Baixo] |

---

## 7. Premissas e Restrições

### Premissas (assumimos como verdadeiro)
- [Premissa 1 — algo assumido sem confirmação explícita]

### Restrições (limites que devem ser respeitados)
- [Restrição técnica, regulatória ou de negócio]

---

## 8. Métricas de Sucesso

| KPI | Definição | Baseline Atual | Meta | Prazo | Como Medir |
|-----|-----------|----------------|------|-------|------------|
| [KPI] | [Definição precisa] | [Valor atual] | [Meta] | [Prazo] | [Ferramenta/método] |

---

## 9. Riscos e Mitigações

| # | Risco | Probabilidade | Impacto | Mitigação | Responsável |
|---|-------|---------------|---------|-----------|-------------|
| 1 | [Descrição do risco] | Alta/Média/Baixa | Alto/Médio/Baixo | [Estratégia] | [Quem monitora] |

---

## 10. Questões em Aberto

| # | Questão | Impacto se não resolvida | Responsável | Prazo |
|---|---------|--------------------------|-------------|-------|
| 1 | [Questão] | [Impacto] | [Quem deve responder] | [Data] |

---

## 11. Histórico de Revisões

| Versão | Data | Autor | Alterações |
|--------|------|-------|------------|
| 1.0 | [data] | [autor] | Versão inicial |
