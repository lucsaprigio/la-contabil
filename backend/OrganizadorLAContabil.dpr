program OrganizadorLAContabil;

uses
  Vcl.Forms,
  Lac.View.Principal in 'View\Lac.View.Principal.pas' {frm_view_principal},
  Lac.Controller.Usuario in 'Controllers\Lac.Controller.Usuario.pas',
  Lac.Router.Usuario in 'Routers\Lac.Router.Usuario.pas',
  Lac.Utils.Configuracao in 'Utils\Lac.Utils.Configuracao.pas',
  Lac.Controller.Auth in 'Controllers\Lac.Controller.Auth.pas',
  Lac.Router.Auth in 'Routers\Lac.Router.Auth.pas' {$R *.res},
  Lac.Infra.Connection in 'Infra\Lac.Infra.Connection.pas',
  Infra.HorseServer in 'Infra\Infra.HorseServer.pas',
  Lac.UserAuth.Response in 'DTO\Lac.UserAuth.Response.pas',
  Lac.Schema.ScriptExecute in 'Schemas\Lac.Schema.ScriptExecute.pas' {$R *.res},
  Lac.Model.DAO.Usuario in 'Model\DAO\Lac.Model.DAO.Usuario.pas',
  Model.Entity.Usuario in 'Model\Entities\Model.Entity.Usuario.pas',
  Lac.Utils in 'Utils\Lac.Utils.pas',
  Lac.Database.Migrations in 'Database\Migrations\Lac.Database.Migrations.pas',
  Lac.Model.DAO.Empresa in 'Model\DAO\Lac.Model.DAO.Empresa.pas',
  Model.Entity.Empresa in 'Model\Entities\Model.Entity.Empresa.pas',
  Lac.Controller.Empresa in 'Controllers\Lac.Controller.Empresa.pas',
  Lac.Router.Empresa in 'Routers\Lac.Router.Empresa.pas',
  Lac.Utils.Certificados in 'Utils\Lac.Utils.Certificados.pas',
  Model.Entity.UsuarioEmpresa in 'Model\Entities\Model.Entity.UsuarioEmpresa.pas',
  Lac.Model.DAO.UsuarioEmpresa in 'Model\DAO\Lac.Model.DAO.UsuarioEmpresa.pas',
  DTO.UsuarioEmpresa.Response in 'DTO\DTO.UsuarioEmpresa.Response.pas',
  Lac.Controller.UsuarioEmpresa in 'Controllers\Lac.Controller.UsuarioEmpresa.pas',
  Lac.Router.UsuarioEmpresa in 'Routers\Lac.Router.UsuarioEmpresa.pas',
  Lac.Exceptions in 'Exceptions\Lac.Exceptions.pas',
  Lac.Services.NotasDestinadas in 'Services\Lac.Services.NotasDestinadas.pas',
  Lac.Factory.NFe in 'Factories\Lac.Factory.NFe.pas',
  Lac.Model.DAO.NotasDestinadas in 'Model\DAO\Lac.Model.DAO.NotasDestinadas.pas',
  Model.Entity.NotasDestinadas in 'Model\Entities\Model.Entity.NotasDestinadas.pas' {$R *.res},
  Model.DAO.Interfaces in 'Model\DAO\Interfaces\Model.DAO.Interfaces.pas',
  Model.Entity.NotasDestinadasXML in 'Model\Entities\Model.Entity.NotasDestinadasXML.pas',
  Lac.Model.DAO.NotasDestinadasXML in 'Model\DAO\Lac.Model.DAO.NotasDestinadasXML.pas',
  Sync.SincronizacaoDfe in 'Sync\Sync.SincronizacaoDfe.pas',
  Sync.Interfaces in 'Sync\Interfaces\Sync.Interfaces.pas',
  Sync.Sincronismo in 'Sync\Sync.Sincronismo.pas',
  Model.Entity.NFSaida in 'Model\Entities\Model.Entity.NFSaida.pas',
  Lac.Model.DAO.NotasSaida in 'Model\DAO\Lac.Model.DAO.NotasSaida.pas',
  Lac.Controller.NFSaida in 'Controllers\Lac.Controller.NFSaida.pas',
  Lac.Router.NotasSaidas in 'Routers\Lac.Router.NotasSaidas.pas',
  Model.Entity.Cliente in 'Model\Entities\Model.Entity.Cliente.pas',
  Lac.Model.DAO.Clientes in 'Model\DAO\Lac.Model.DAO.Clientes.pas',
  Lac.Controller.Clientes in 'Controllers\Lac.Controller.Clientes.pas',
  Lac.Router.Clientes in 'Routers\Lac.Router.Clientes.pas',
  Lac.Services.ExportacaoXML in 'Services\Lac.Services.ExportacaoXML.pas',
  Lac.Services.Email in 'Services\Lac.Services.Email.pas',
  Model.Entity.NotasSaidaXML in 'Model\Entities\Model.Entity.NotasSaidaXML.pas',
  DTO.NFExportacaoXML in 'DTO\DTO.NFExportacaoXML.pas',
  Lac.Model.DAO.NFSaidaXML in 'Model\DAO\Lac.Model.DAO.NFSaidaXML.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_view_principal, frm_view_principal);
  Application.Run;

end.
