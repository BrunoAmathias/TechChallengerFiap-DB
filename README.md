# TechChallengerFiap-DB

Repositório responsável pela infraestrutura de banco de dados do projeto TechChallengerFiap, com provisionamento de projeto PostgreSQL em Neon mediante Terraform. O projeto modela a base de dados de forma declarativa e mantém o estado de infraestrutura em backend remoto S3.

## Apresentação do projeto

Este repositório oferece o provisionamento da base de dados do sistema de oficina mecânica. A infraestrutura é descrita em Terraform e utiliza o provider `neon` configurado para criar e gerenciar um projeto `neon_project` denominado `Techchallenger - Base`.

O repositório possui dois pontos de observação principais:

1. `TFs/provider.tf`: define o provider Neon e o backend S3 `techchallenge-dev-tfstate`.
2. `TFs/resources.tf`: cria o projeto Neon chamado `Techchallenger - Base` com retenção de histórico de 21600 segundos.

## Funcionalidades

- Provisionamento de projeto Neon para a aplicação.
- Criação de projeto de banco de dados com nome `Techchallenger - Base`.
- Persistência do estado Terraform em backend S3.
- Configuração do provider `neon` por chave de API via variável de ambiente `NEON_API_KEY`.
- Base para permitir uso de um banco PostgreSQL com infraestrutura gerenciada.

## Tecnologias

| Tecnologia | Versão / Uso |
|---|---|
| Terraform | `>= [PREENCHER]` |
| Provider Neon | `kislerdm/neon` |
| PostgreSQL | Banco gerenciado por Neon |
| AWS S3 | Backend remoto do Terraform |
| Neon | Plataforma de banco de dados serverless |

## Arquitetura

A arquitetura de infraestrutura é pequena e objetiva:

```text
Terraform -> Provider Neon -> neon_project "Techchallenger - Base" -> PostgreSQL em Neon
```

A infra é organizada em:

- `provider.tf`: provider e configuração do backend S3.
- `resources.tf`: criação do projeto Neon.
- `imports.tf`: arquivo preparado para importações futuras, atualmente vazio.

## Estrutura de pastas

```text
TechChallengerFiap-DB/
+-- TFs/
¦   +-- imports.tf
¦   +-- provider.tf
¦   +-- resources.tf
¦   +-- terraform.tfstate
¦   +-- terraform.tfstate.backup
+-- README.md
```

## Instalação

Pré-requisitos:

- Terraform instalado
- Conta Neon com acesso válido
- Credenciais da AWS para o backend S3
- Variável de ambiente `NEON_API_KEY` configurada

Clone o repositório:

```bash
git clone [PREENCHER]
cd TechChallengerFiap-DB/TFs
```

Inicialize o Terraform:

```bash
terraform init
```

## Configuração das variáveis de ambiente

O provider do Neon depende da variável de ambiente:

```bash
export NEON_API_KEY="[PREENCHER]"
```

O código do provider informa que a API key vem da variável de ambiente `NEON_API_KEY`, e não deve ser escrita diretamente no arquivo.

## Execução local

Para aplicar o provisionamento localmente:

```bash
cd TFs
terraform init
terraform plan
terraform apply
```

O backend do Terraform aponta para o bucket:

```hcl
backend "s3" {
  bucket = "techchallenge-dev-tfstate"
  key    = "neon/terraform.tfstate"
  region = "us-east-1"
}
```

## Banco de dados

O banco de dados é provisionado no Neon como um projeto denominado `Techchallenger - Base`. O repositório não descreve o schema completo em Terraform; o schema de aplicação e os scripts SQL de inicialização estão no repositório `TechChallengerFiap-Application` na pasta `backEnd/db/init`.

Os scripts de inicialização são:

```text
01_clientes.sql
02_veiculos.sql
03_servicos.sql
04_pecas.sql
05_ordens_servico.sql
06_os_servicos.sql
07_os_pecas.sql
```

Estes arquivos criam as tabelas `clientes`, `veiculos`, `servicos`, `pecas`, `ordens_servico`, `os_servicos` e `os_pecas`.

## Testes

Este repositório não apresenta suíte automatizada de teste para infraestrutura. O fluxo mais adequado é a validação do Terraform:

```bash
terraform validate
terraform plan
```

## Exemplos de uso

### Exemplo de criação do projeto Neon

```hcl
resource "neon_project" "main" {
  name                      = "Techchallenger - Base"
  history_retention_seconds = 21600
}
```

### Exemplo de execução

```bash
export NEON_API_KEY="[PREENCHER]"
cd TFs
terraform init
terraform apply
```

## Deploy

O deploy é realizado pelo Terraform por meio do provider Neon e do backend S3. O corpo principal do deploy é a criação do projeto `Techchallenger - Base`.

```bash
cd TFs
terraform apply
```

## Contribuição

Contribuições são bem-vindas por meio de branchs, commits e pull requests. Recomendamos:

- manter o provider Neon e o backend S3 compatíveis;
- usar a variável de ambiente `NEON_API_KEY` em vez de gravar a chave no código;
- validar o plano com `terraform plan` antes do provisionamento.

## Licença

[PREENCHER]
