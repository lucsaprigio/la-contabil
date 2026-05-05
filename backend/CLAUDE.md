# LA Contábil — Guia de Contexto do Projeto

## O que é este projeto

**LA Contábil** é um sistema de gestão, extração e organização de Documentos Fiscais Eletrônicos (DFe) desenvolvido em **Delphi**. Combina uma **API REST** (via framework Horse) com uma **interface VCL** (janela Windows) rodando no mesmo processo.

O objetivo central é automatizar o ciclo fiscal de empresas contábeis: buscar XMLs da SEFAZ, organizar por modelo/tipo, armazenar em banco SQL Server e expor endpoints para consumo do frontend.

---

## Roadmap do Produto

O sistema está sendo construído em fases:

### Fase 1 — Notas Destinadas (PRIORIDADE ATUAL)
Buscar e importar automaticamente as **notas destinadas** (NF-e recebidas via SEFAZ) para o sistema.
- Worker de sincronização já existe (`Sync/Sync.SincronizacaoDfe.pas`)
- DAO e entidades de `TB_NOTAS_DESTINADAS` já existem
- **Foco atual:** consolidar o módulo de notas destinadas com endpoints completos, listagem, busca e download do XML

### Fase 2 — Desktop de Importação de Notas de Saída
Criar um **aplicativo desktop separado** (provavelmente Delphi) para importar as **notas de saída faltantes** — notas que existem no ambiente fiscal mas ainda não estão cadastradas no banco `TB_NOTAS_SAIDA`.

### Fase 3 — Frontend Web (Next.js)
O frontend será construído em **Next.js** (React + TypeScript). A API REST já está funcional e preparada para ser consumida.

Telas previstas:
1. Login / Autenticação
2. Dashboard de empresas vinculadas ao usuário
3. Listagem e filtro de **Notas Destinadas** (NF-e recebidas)
4. Listagem e filtro de **Notas de Saída**
5. Cadastro e gestão de Clientes
6. Exportação de XMLs por período (download / e-mail)
7. Configurações da empresa (certificado A1, ambiente prod/hom)

---

## Stack Tecnológica

| Camada | Tecnologia |
|---|---|
| Linguagem (backend) | Delphi / Object Pascal |
| Framework Web | Horse (REST, middleware JWT) |
| Acesso a Dados | FireDAC + SQL Server |
| Autenticação | JWT via `delphi-jose-jwt` + `horse-jwt` |
| Hash de Senha | SHA-256 via `System.Hash.THashSHA2` |
| Serialização JSON | `REST.Json` + `DataSet.Serialize` |
| Gerenciador de Deps | Boss |
| Infraestrutura | Docker (SQL Server 2022) |
| Interface de controle | VCL (Delphi Forms) |
| Frontend (Fase 3) | Next.js (React + TypeScript) |
| Desktop de importação (Fase 2) | A definir (provável Delphi) |

---

## Estrutura de Diretórios

```
/Controllers     — Handlers HTTP (recebem Req/Res do Horse)
/Routers         — Registro das rotas no THorse
/Model
  /DAO           — Data Access Objects (SQL direto via FireDAC)
  /DAO/Interfaces— Interfaces dos DAOs
  /Entities      — Classes de entidade (mapeiam tabelas)
/Services        — Regras de negócio (sincronização SEFAZ, exportação, e-mail)
/Factories       — Criação de objetos complexos (ex: TFactory.NFe)
/Sync            — Worker thread de sincronização DFe em background
/DTO             — Objetos de transferência (request/response)
/Infra           — Conexão com banco, inicialização do servidor Horse
/Utils           — Utilitários (validação de GUID, certificados, configuração)
/Exceptions      — Exceções customizadas do domínio
/Database
  /Scripts       — SQLs de criação das tabelas
  /Migrations    — Migrations do banco
/View            — Form principal VCL (Lac.View.Principal)
/Schemas         — XSDs para validação de NFe, eSocial, Reinf
/Win32/Debug     — Binários e schemas de saída da compilação
```

---

## Mapa Completo de Endpoints

### Autenticação
| Método | Rota | Descrição |
|---|---|---|
| POST | `/api/login` | Login com email/senha → retorna JWT |

### Usuários
| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/user/:id` | Buscar usuário por ID (GUID) |
| POST | `/api/user` | Criar novo usuário (público, sem JWT) |
| PUT | `/api/user/:id` | Atualizar username/email |
| DELETE | `/api/user/:id` | Excluir usuário |

### Empresas (Business)
| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/business/:id` | Buscar empresa por CNPJ |
| POST | `/api/business` | Criar empresa |
| PUT | `/api/business/:id` | Atualizar dados da empresa |
| PUT | `/api/business/:id/certificado` | Importar/atualizar certificado digital A1 |
| DELETE | `/api/business/:id` | Excluir empresa |
| GET | `/api/business/dfe/:businessId/:cnpj` | Disparar sincronização manual de DFe na SEFAZ |
| POST | `/api/business/:businessId/exportacao/email` | Exportar XMLs em ZIP/Base64 e enviar por e-mail |

### Usuário-Empresa (vínculo / permissões)
| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/user_business/:id` | Buscar empresas vinculadas a um usuário |
| POST | `/api/user_business` | Vincular usuário a uma empresa (com roleName) |
| DELETE | `/api/user_business/:userId/:businessId` | Desvincular usuário de empresa |

### Clientes
| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/clientes/:businessId` | Listar clientes com filtros (nome, cpf_cnpj, pessoa, ativo) |
| GET | `/api/clientes/:businessId/:id/buscar` | Buscar cliente por ID |
| POST | `/api/clientes` | Criar cliente |
| PUT | `/api/clientes/:businessId/:id` | Atualizar cliente |

### Notas Fiscais de Saída (NFe Saída)
| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/nfe/saida/:businessId/listar` | Listar NFes com filtros (numero, serie, modelo, cpfcnpj) |
| GET | `/api/nfe/saida/:businessId/buscar` | Buscar NFe específica |
| POST | `/api/nfe/saida` | Cadastrar NFe de saída manualmente |

### Notas Destinadas *(módulo em consolidação — Fase 1)*
| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/nfe/destinadas/:businessId/listar` | Listar notas destinadas *(a implementar)* |
| GET | `/api/nfe/destinadas/:businessId/buscar` | Buscar nota destinada *(a implementar)* |
| GET | `/api/nfe/destinadas/:businessId/xml/:id` | Download do XML de nota destinada *(a implementar)* |

---

## Entidades Principais (Banco de Dados)

| Entidade | Arquivo | Campos relevantes |
|---|---|---|
| `TUser` | `Model.Entity.Usuario` | UserId, Username, Email, Password (hash SHA-256) |
| `TEmpresa` | `Model.Entity.Empresa` | BusinessId, CorporateName, FantasyName, Cnpj, Ie, Uf, Environment (1=prod/2=hom), CertBase64, CertPassword, CertExpiration, LastNSU |
| `TUsuarioEmpresa` | `Model.Entity.UsuarioEmpresa` | UserId, BusinessId, RoleName (USER/ADMIN) |
| `TCliente` | `Model.Entity.Cliente` | Id, BusinessId, NomeRazao, NomeFantasia, CpfCnpj, Ie, Email, Telefone, Endereço completo, Ativo |
| `TNotasSaida` | `Model.Entity.NFSaida` | Id, BusinessId, ClienteId, CpfCnpj, Numero, Serie, ChaveAcesso, Protocolo, Cfop, DataEmissao, ValorTotal, BaseIcms, ValorIcms, BaseSt, ValorSt, ObsNf |
| `TNotasDestinadas` | `Model.Entity.NotasDestinadas` | Notas recebidas/destinadas vindas da SEFAZ (NF-e de entrada) |
| `TNotasDestinadasXML` | `Model.Entity.NotasDestinadasXML` | XML bruto das notas destinadas (VARBINARY) |
| `TNotasSaidaXML` | `Model.Entity.NotasSaidaXML` | XML bruto das notas de saída (VARBINARY) |

---

## Serviços de Negócio

### `TServiceNotasDestinadas` (`Services/Lac.Services.NotasDestinadas.pas`)
Consulta a SEFAZ pelo NSU e persiste as notas destinadas.
Chamado manualmente via endpoint e também pelo worker de sincronização automática.

### `TServiceExportacao` (`Services/Lac.Services.ExportacaoXML.pas`)
Gera lote de XMLs em Base64 (ZIP) para um período de datas.
Usado pelo endpoint de envio por e-mail.

### `TServiceEmail` (`Services/Lac.Services.Email.pas`)
Envia e-mail via Gmail com os XMLs em anexo.
Credenciais via `TAppConfig.Email` e `TAppConfig.MailPassword`.

---

## Worker de Sincronização DFe

`Sync/Sync.SincronizacaoDfe.pas` — `TWorkerSincronizacaoDFe`

- Roda em **thread separada** dentro do processo VCL
- Em **RELEASE**: ciclo a cada **10 minutos**
- Em **DEBUG**: ciclo a cada **5 segundos**
- Busca todas as empresas com DFe pendente (`BuscarEmpresasPendentesDFe`)
- Para cada empresa, chama `SincronizarSefaz` e atualiza `DataConsulta`
- `TODO`: Implementar LOG estruturado de erros no bloco `except`

---

## Autenticação e Segurança

- Middleware JWT via `HorseJWT` nos routers protegidos
- Rotas públicas (sem JWT): `/api/login`, `POST /api/user`
- Token expira em **1 dia** (`Now + 1`)
- Chave secreta configurada em `TAppConfig.JWT_SECRET`
- Senhas armazenadas com hash **SHA-256** (sem salt — ponto de melhoria futuro)

---

## Configuração (`Utils/Lac.Utils.Configuracao.pas`)

`TAppConfig` centraliza todas as configurações da aplicação:
- `JWT_SECRET` — chave para assinar tokens
- `Email` / `MailPassword` — credenciais SMTP Gmail
- `Server` / `Database` — parâmetros de conexão com SQL Server

Arquivo de configuração: `config.ini` (criado automaticamente na primeira execução, não versionado).

---

## Scripts de Banco

Localização: `Database/Scripts/`

| Script | Descrição |
|---|---|
| `CREATE_LAC_DATABASE.sql` | Cria o banco principal |
| `CREATE_TB_USERS.sql` | Tabela de usuários |
| `CREATE_TABLE_BUSINESS.sql` | Tabela de empresas |
| `CREATE_USER_BUSINESS.sql` | Tabela de vínculo usuário-empresa |
| `CREATE_TB_CLIENTES.sql` | Tabela de clientes |
| `CREATE_TB_NOTAS_SAIDA.sql` | Tabela de notas fiscais de saída |
| `CREATE_TB_NOTAS_SAIDA_XML.sql` | Tabela dos XMLs de notas de saída |

Migrations programáticas: `Database/Migrations/Lac.Database.Migrations.pas`

---

## Estado Atual do Projeto

### Implementado (Backend)
- [x] Autenticação JWT (login, middleware)
- [x] CRUD de Usuários
- [x] CRUD de Empresas com suporte a certificado digital A1
- [x] Vínculo Usuário-Empresa com roles
- [x] CRUD de Clientes
- [x] Cadastro e listagem de Notas Fiscais de Saída
- [x] Worker de sincronização automática de DFe com a SEFAZ (thread background)
- [x] Serviço de Notas Destinadas (`TServiceNotasDestinadas`)
- [x] DAO e entidades de `TB_NOTAS_DESTINADAS` / `TB_NOTAS_DESTINADAS_XML`
- [x] Exportação de XMLs em lote (Base64/ZIP)
- [x] Envio de XMLs por e-mail (Gmail SMTP)
- [x] Validação de certificado digital A1
- [x] Interface VCL de controle (form principal)
- [x] Migrations de banco

### Pendente / A Implementar

#### Fase 1 — Notas Destinadas (PRÓXIMO)
- [ ] Endpoints completos para listagem e busca de Notas Destinadas
- [ ] Endpoint de download direto do XML de nota destinada
- [ ] LOG estruturado de erros no worker de sincronização
- [ ] Paginação nos endpoints de listagem

#### Fase 2 — Desktop de Importação de Notas de Saída
- [ ] Aplicativo desktop separado para importar notas de saída faltantes

#### Fase 3 — Frontend Next.js
- [ ] Projeto Next.js com autenticação JWT
- [ ] Telas de Notas Destinadas e Notas de Saída
- [ ] Telas de Clientes, Empresas e Exportação

#### Melhorias Gerais (Backend)
- [ ] Salt nas senhas (segurança: hoje é SHA-256 puro)
- [ ] Refresh token (JWT força re-login após 24h)
- [ ] Endpoint `GET /api/user/empresa/:id` (controller existe, rota não registrada)
- [ ] Suporte a CTe, MDFe, NFSe além de NFe
- [ ] Testes automatizados

---

## Como Rodar Localmente

1. Instalar dependências Delphi:
   ```bash
   boss install
   ```

2. Subir infraestrutura Docker (SQL Server 2022):
   ```bash
   docker-compose up -d
   ```

3. Executar os scripts SQL na ordem (pasta `Database/Scripts/`)

4. Abrir `OrganizadorLAContabil.dproj` no RAD Studio e compilar

5. A API sobe junto com o form VCL na porta 9000

---

## Padrões de Código

- Controllers são classes com métodos **class procedure** estáticos
- DAOs implementam interfaces definidas em `Model.DAO.Interfaces`
- Entidades usam construtor `New` (factory) além do `Create` padrão
- Validação de GUID em todos endpoints que recebem `:id` via `TLacUtils.IsValidID`
- IDs são GUIDs gerados no backend
- Respostas de erro: JSON `{"erro": "mensagem"}` ou string plain text
- Prefixo de nomenclatura: `Lac.` para módulos do projeto, `Model.` e `DTO.` para camadas específicas
