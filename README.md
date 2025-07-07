# 🧾 Projeto

Este repositório contém o projeto desenvolvido para a criação de um sistema de lançamentos de vendas, utilizando **Delphi + DataSnap**, **Firebird** e arquitetura em **3 camadas**. O projeto segue princípios de Clean Code, separação de responsabilidades e modularidade.

---

## 🔍 Visão Geral

Este sistema foi desenvolvido como parte de um teste técnico, com foco em:

- Cadastro de clientes e produtos  
- Lançamento de vendas com múltiplos itens  
- Geração de relatórios com **FastReport**  
- Consulta de CEP via **ACBr**  
- Arquitetura limpa, orientada a objetos e com práticas modernas

---

## 📌 Informações Básicas

- **Nome do Projeto:** Sistema 3 Camadas  
- **Data de Início:** 30/06/2025  
- **Entrega Final:** 07/07/2025  
- **Tempo Estimado:** 30 horas  

---

## 🎯 Objetivos e Escopo

### ✅ Objetivos

- Criar base de dados Firebird com domínios e constraints
- Desenvolver interface VCL para lançamentos
- Gerar relatório com FastReport
- Implementar consulta de CEP via ACBr

### ❌ Fora do Escopo

- Foi solicitado DBExpress, mas foi utilizado **FireDAC**, por ser mais moderno, robusto e nativo nas versões atuais do Delphi.

---

## 🧱 Arquitetura

### 🔹 Frontend

- Delphi VCL  
- FastReport  

### 🔹 Backend

- Delphi (DataSnap)  
- FireDAC  
- ACBr  

### 🔹 Banco de Dados

- Firebird 3.0  
- Domínios personalizados  
- Triggers, Generators, Constraints  

---

## 🚀 Metodologia

- Desenvolvimento iterativo com feedback contínuo  
- Divisão clara entre camadas: UI / Aplicação / Dados  
- Planejamento baseado no documento de requisitos

---

## 🧼 Padrões e Boas Práticas

- PascalCase para variáveis e tipos  
- Tipagem explícita  
- Uso de interfaces e RTTI para desacoplamento  
- Código comentado nos pontos críticos  
- Organização em Units modulares  

---

## 📆 Cronograma de Marcos

| 🏁 Etapa                | 📋 Descrição                           | 📅 Data       |
|------------------------|----------------------------------------|---------------|
| Back-end               | Criação do servidor DataSnap           | 04/07/2025    |
| Front-end              | Desenvolvimento da interface VCL       | 05/07/2025    |
| Relatórios             | Relatório de vendas com FastReport     | 06/07/2025    |
| Entrega Final          | Sistema completo e funcional            | 07/07/2025    |

---

## ⚙️ Execução do Sistema

### 🔧 Passos

1. Inicie o servidor Delphi (arquivo `.exe`)
2. Configure porta `8080`
3. Informe o caminho para o banco `.fdb`  
   - **Usuário:** SYSDBA  
   - **Senha:** `masterkey`
4. Inicie o cliente Delphi
5. A aplicação consumirá os métodos via DataSnap

### 🧱 Pré-requisitos

- Delphi com suporte a **DataSnap** e **FireDAC**
- **Firebird** instalado e configurado
- **FastReport** instalado
- Componente **ACBrCEP** disponível

---

## 🗄️ Estrutura do Banco de Dados

### 📋 CLIENTE

| Campo       | Tipo         | Descrição                  |
|-------------|--------------|----------------------------|
| CLI_ID      | BIGINT (PK)  | ID do cliente              |
| CLI_NOME    | VARCHAR(100) | Nome                       |
| CLI_CPF     | VARCHAR(15)  | CPF (opcional)             |
| CLI_CEP     | VARCHAR(9)   | CEP                        |
| CLI_ENDERECO| VARCHAR(256) | Endereço                   |
| CLI_BAIRRO  | VARCHAR(100) | Bairro                     |
| CLI_CIDADE  | VARCHAR(150) | Cidade                     |
| CLI_ESTADO  | VARCHAR(2)   | UF                         |
| CLI_ATIVO   | BOOLEAN      | Ativo/Inativo (default: T) |

### 📋 PRODUTO

| Campo        | Tipo           | Descrição                |
|--------------|----------------|--------------------------|
| PRO_ID       | BIGINT (PK)    | ID do produto            |
| PRO_NOME     | VARCHAR(250)   | Nome                     |
| PRO_DESCRICAO| BLOB TEXT      | Descrição longa          |
| PRO_PRECO    | NUMERIC(15,2)  | Preço                    |
| PRO_ATIVO    | BOOLEAN        | Disponível para venda    |

### 📋 LANCAMENTO

| Campo         | Tipo           | Descrição                  |
|---------------|----------------|----------------------------|
| LAN_ID        | BIGINT (PK)    | ID do lançamento           |
| LAN_DATA      | DATE           | Data da venda              |
| LAN_CLI_ID    | BIGINT (FK)    | Cliente vinculado          |
| LAN_CLI_NOME  | VARCHAR(100)   | Nome na hora da venda      |
| LAN_VALOR_TOTAL | NUMERIC(15,2)| Valor total da venda       |

### 📋 LANCAMENTO_ITEM

| Campo           | Tipo           | Descrição              |
|------------------|----------------|------------------------|
| LAI_ID           | BIGINT (PK)    | ID do item             |
| LAI_LAN_ID       | BIGINT (FK)    | ID do lançamento       |
| LAI_PRO_ID       | BIGINT (FK)    | ID do produto          |
| LAI_QUANTIDADE   | INTEGER        | Quantidade             |
| LAI_VALOR_UNITARIO | NUMERIC(15,2)| Valor unitário         |
| LAI_VALOR_TOTAL  | NUMERIC(15,2)  | Subtotal               |

---

## 🧠 Domínios Personalizados

| Nome       | Tipo Base     | Not Null | Aplicação             |
|------------|---------------|----------|------------------------|
| DON_PK     | BIGINT        | ✅        | Chaves primárias       |
| DON_FK     | BIGINT        | ❌        | Chaves estrangeiras    |
| DON_VALOR  | NUMERIC(15,2) | ✅        | Valores financeiros    |
| DON_NOME   | VARCHAR(250)  | ✅        | Campos de nome         |

**Exemplo de definição:**
```sql
CREATE DOMAIN DON_PK AS BIGINT NOT NULL;
CREATE DOMAIN DON_VALOR AS NUMERIC(15,2) NOT NULL;
