unit Lac.Router.Empresa;

interface

uses
  Horse, Lac.Controller.Empresa;

procedure Registry;

implementation

procedure Registry;
begin
   THorse.Get('/api/business/:id', TControllerEmpresa.GetBusinessByCnpj);
   THorse.Post('/api/business', TControllerEmpresa.PostNewBusiness);
   THorse.Put('/api/business/:id/certificado', TControllerEmpresa.PutAtualizaCertificado);
   THorse.Put('/api/business/:id', TControllerEmpresa.PutAtualizarEmpresa);
   THorse.Delete('/api/business/:id', TControllerEmpresa.DeleteExcluirEmpresa);
   THorse.Get('/api/business/dfe/:businessId/:cnpj', TControllerEmpresa.GetNotasDestinadas);
   THorse.Post('/api/business/:businessId/exportacao/email', TControllerEmpresa.PostEnviarEmailXML);
end;

end.
