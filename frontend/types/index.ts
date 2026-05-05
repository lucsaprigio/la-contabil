export interface TUser {
  userId: string
  username: string
  email: string
  createdAt?: string
  updatedAt?: string
}

export interface TEmpresa {
  businessId: string
  corporateName: string
  fantasyName: string
  cnpj: string
  ie?: string
  uf?: string
  environment?: 1 | 2
  roleName?: string
  certExpiration?: string
  lastNSU?: string
  dataConsulta?: string
}

export interface TUserBusinessResponse {
  userId: string
  empresas: TEmpresa[]
}

export interface TCliente {
  id: string
  businessId: string
  nomeRazao: string
  nomeFantasia?: string
  cpfCnpj: string
  ie?: string
  email?: string
  telefone?: string
  logradouro?: string
  numero?: string
  complemento?: string
  bairro?: string
  municipio?: string
  uf?: string
  cep?: string
  ativo: 'S' | 'N'
  dataCadastro?: string
}

export interface TNotaSaida {
  id: string
  businessId: string
  clienteId?: string
  cpfCnpj?: string
  numero: string
  serie: string
  chaveAcesso?: string
  protocolo?: string
  cfop?: string
  dataEmissao: string
  valorTotal: number
  baseIcms?: number
  valorIcms?: number
  baseSt?: number
  valorSt?: number
  obsNf?: string
}

export interface TNotaDestinada {
  id: string
  businessId: string
  cpfCnpjEmitente?: string
  nomeEmitente?: string
  numero: string
  serie: string
  chaveAcesso?: string
  protocolo?: string
  cfop?: string
  dataEmissao: string
  valorTotal: number
  nsu?: string
  tipoEvento?: string
  situacao?: string
}

export interface TLoginResponse {
  token: string
  userId: string
  email: string
  username: string
}

export interface TLoginRequest {
  email: string
  password: string
}

export interface TApiError {
  erro: string
}

export interface TPaginatedResponse<T> {
  data: T[]
  total: number
  page: number
  pageSize: number
}

export interface TCreateEmpresaRequest {
  corporateName: string
  fantasyName: string
  cnpj: string
  ie: string
  uf: string
  environment: 1 | 2
}

export interface TCreateClienteRequest {
  businessId: string
  nomeRazao: string
  nomeFantasia?: string
  cpfCnpj: string
  ie?: string
  email?: string
  telefone?: string
  logradouro?: string
  numero?: string
  complemento?: string
  bairro?: string
  municipio?: string
  uf?: string
  cep?: string
}
