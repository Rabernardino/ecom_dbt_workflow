

<div align="center">
  <h1>E-Commerce Data Pipeline</h1>
</div>

<br />

## Objetivo

Este projeto tem como objetivo emular o ciclo de vida completo de engenharia e modelagem analítica de um e-commerce em ambiente produtivo. Partindo da construção da infraestrutura, reproduzindo a dinâmica real de atualizações diárias, correções de regras de negócio, testes de qualidade automatizados e a esteiras de CI/CD.

A solução adota a arquitetura medalhão, rastreamento histórico de mudanças via SCD Type 2 (Utilizando Snapshots), modelagem dimensional e práticas de DataOps com foco em eficiência de custos e tempo de build via Slim CI.

---

## Arquitetura e Fluxo de Dados

```text
[ Dados Públicos ] 
        │
        ▼ (Script Python - Ingestion)
[ Supabase PostgreSQL: Raw Layer ]
        │
        ▼ (dbt: Sources & Staging)
[ Bronze Layer: Padronização Inicial ]
        │
        ├──► [ dbt Snapshots: SCD Type 2 em Orders ]
        ▼
[ Silver Layer: Limpeza, Tipagem, Regras de Negócio & Modelos Incrementais ]
        │
        ▼
[ Gold Layer: Dimensões, Fatos & Visões Analíticas de Negócio ]
        │
        ▼
[ Consumo / BI / Analytics ]
```

---

## Tecnologias e Ferramentas

<table width="100%">
  <thead>
    <tr>
      <th align="left">Ferramenta</th>
      <th align="left">Função na Arquitetura</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Python</strong></td>
      <td>Scripting para ingestão idempotente dos dados brutos na camada <code>raw</code>.</td>
    </tr>
    <tr>
      <td><strong>Supabase (PostgreSQL)</strong></td>
      <td>Data warehouse relacional gerenciado, segregado nos respectivos schemas.</td>
    </tr>
    <tr>
      <td><strong>dbt Core</strong></td>
      <td>Orquestração das transformações SQL, snapshots, documentação e testes automatizados.</td>
    </tr>
    <tr>
      <td><strong>GitHub Actions</strong></td>
      <td>Automação do fluxo de <strong>CI/CD</strong> com execução de <em>Slim CI</em> orientado a estado (<code>manifest.json</code>).</td>
    </tr>
  </tbody>
</table>

---

## Etapas de Implementação

### 1. Ingestão de Dados (Camada Raw)
* Desenvolvimento de scripts em Python responsáveis por realizar a leitura dos arquivos de e-commerce e execução do `INSERT`/`COPY` no banco de dados Supabase.
* Criação e segregação do schema `raw` como ponto de entrada imutável dos dados.

### 2. Setup e Governança no dbt
* Configuração do `profiles.yml` separando os ambientes:
  * `dev`: Ambiente isolado para desenvolvimento local.
  * `ci`: Ambiente temporário/dedicado acionado em Pull Requests.
  * `prod`: Ambiente de produção onde os dados finais são disponibilizados.
* Declaração de `sources` com validações estruturais nos arquivos `.yml`.
* Implementação de **Data Tests** nativos (checagens de `unique`, `not_null`, integridade referencial com `relationships` e regras de domínio com `accepted_values`).

### 3. Camadas Bronze e Silver (Modelagem e Snapshots)
* **Bronze:** Criação de visões/tabelas de staging para expor os dados da `raw` com nomenclaturas padronizadas.
* **Silver:**
  * Correção e uniformização de tipos de dados (timestamps, valores monetários, chaves substitutas).
  * **SCD Type 2 com dbt Snapshots:** Implementação de snapshot na tabela de `orders` para capturar alterações históricas em status e prazos de entrega, permitindo análises precisas de SLA logístico e variações de frete.
  * Estratégia de materialização ajustada: tabelas incrementais configuradas com `unique_key` e filtros baseados no cursor temporal de atualização para otimizar processamento e custo de computação.

### 4. Camada Gold (Data Marts)
* Consolidação dos dados limpos em modelos dimensionais (Fatos e Dimensões).
* Junção das entidades para responder aos principais casos de uso de negócio:
  * Volume transacional e métricas financeiras (LTV, AOV, ticket médio).
  * Eficiência de logística e entregas baseada nos dados versionados pelo snapshot.
  * Comportamento e retenção de clientes.

---

## Pipeline CI/CD (DataOps com Slim CI)

Para garantir qualidade sem desperdiçar recursos computacionais, a esteira foi desenhada utilizando **State Comparison** com o arquivo `manifest.json`:

```text
[ Pull Request Aberto ]
        │
        ├──► Download do manifest.json (Produção atual)
        ├──► dbt compile / dbt test --select state:modified+
        └──► Validação de integridade aprovada ✅
        
[ Merge na Branch Principal ]
        │
        ├──► dbt run & dbt test no ambiente de Produção
        └──► Geração e upload do novo manifest.json para o storage/artefatos
```

<details>
<summary><strong> Detalhes dos Workflows do GitHub Actions</strong></summary>
<br>

* **Continuous Integration (`ci.yml`):**
  1. Conecta ao ambiente `ci` no Supabase.
  2. Recupera o `manifest.json` mais recente de produção via artefatos/storage.
  3. Executa `dbt run --select state:modified+` e `dbt test --select state:modified+`, processando estritamente os modelos alterados ou seus dependentes diretos (Slim CI).
* **Continuous Deployment (`cd.yml`):**
  1. Disparado no merge para a branch `main`.
  2. Executa as transformações no ambiente `prod`.
  3. Gera a versão atualizada do `manifest.json` e realiza o upload do novo estado para servir de linha de base para os próximos ciclos de CI.

</details>


