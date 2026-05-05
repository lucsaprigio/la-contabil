## LA Contábil - Organizador de Documentos Fiscais
#### O LA Contábil é uma solução robusta desenvolvida em Delphi para a gestão, extração e organização de Documentos Fiscais Eletrónicos (DFe). O sistema combina uma API REST de alta performance com uma interface VCL para facilitar o fluxo de trabalho contabilístico.

## 🚀Funcionalidades Principais
- Gestão de XML: Extração automática de ficheiros XML diretamente da base de dados.

- Organização Inteligente: Descompressão e categorização automática de ficheiros por modelo (NFe, CTe, MDFe, etc.) e tipo.

- Sincronização DFe: Módulos dedicados para manter os documentos fiscais sempre atualizados.

- Integração API: Backend desenvolvido com o framework Horse, permitindo integrações externas e automação.

- Segurança: Sistema de autenticação de utilizadores e controlo de acessos por empresa.

## 📁 Estrutura do Repositório

**/Controllers:** Lógica de rotas e processamento de pedidos (Auth, Clientes, Notas Saída).

**/Database:** Scripts SQL Server para criação de tabelas (TB_USERS, TB_CLIENTES) e lógica de persistência.

**/Model:** Implementação de DAOs (Data Access Objects) e Entidades.

**/Sync:** Motor de sincronização para documentos fiscais eletrónicos.

**/View:** Interface de utilizador desenvolvida em VCL.

**/Win32/Debug/Schemas:** Repositório completo de esquemas XSD para validação de NFe, eSocial e Reinf.

## 🛠️ Tecnologias Utilizadas
- Delphi (Pascal)

- Horse (Framework Web)

- FireDAC (Acesso a Dados)

- SQL Server (Base de Dados)

- Boss (Gestor de Dependências)

- Docker (Contentorização da infraestrutura)

## ⚙️ Como Começar
Dependências:
1. Instala as dependências do Delphi utilizando o Boss:
```bash
boss install
```
2. Base de Dados:
Executa os scripts localizados em Database/Scripts no teu servidor SQL Server para preparar o ambiente.

3. Configuração:
Ajusta as configurações de ligação à base de dados e caminhos de schemas no ficheiro de configuração da aplicação.

Execução:
4. Abre o projeto OrganizadorSpeedContabil.dproj no RAD Studio e compila em modo Debug ou Release.

## 📦 Docker
O projeto inclui suporte para Docker, facilitando o levantamento de serviços auxiliares:

```bash
docker-compose up -d 
```
*Desenvolvido para otimizar processos de contabilidade e gestão fiscal.*
