import { apiFetch } from '@/lib/api'
import type { TCliente, TCreateClienteRequest } from '@/types'

interface ClientesFilters {
  nome?: string
  cpf_cnpj?: string
  pessoa?: 'F' | 'J'
  ativo?: 'S' | 'N'
}

export async function getClientes(businessId: string, filters: ClientesFilters = {}): Promise<TCliente[]> {
  const params = new URLSearchParams()
  if (filters.nome) params.set('nome', filters.nome)
  if (filters.cpf_cnpj) params.set('cpf_cnpj', filters.cpf_cnpj)
  if (filters.pessoa) params.set('pessoa', filters.pessoa)
  if (filters.ativo) params.set('ativo', filters.ativo)

  const qs = params.toString()
  return apiFetch<TCliente[]>(`/api/clientes/${businessId}${qs ? `?${qs}` : ''}`)
}

export async function getClienteById(businessId: string, id: string): Promise<TCliente> {
  return apiFetch<TCliente>(`/api/clientes/${businessId}/${id}/buscar`)
}

export async function createCliente(data: TCreateClienteRequest): Promise<TCliente> {
  return apiFetch<TCliente>('/api/clientes', {
    method: 'POST',
    body: JSON.stringify(data),
  })
}

export async function updateCliente(businessId: string, id: string, data: Partial<TCreateClienteRequest>): Promise<TCliente> {
  return apiFetch<TCliente>(`/api/clientes/${businessId}/${id}`, {
    method: 'PUT',
    body: JSON.stringify(data),
  })
}
