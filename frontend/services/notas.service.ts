import { apiFetch } from '@/lib/api'
import type { TNotaSaida, TNotaDestinada } from '@/types'

interface NotasSaidaFilters {
  numero?: string
  serie?: string
  modelo?: string
  cpfcnpj?: string
}

export async function getNotasSaida(businessId: string, filters: NotasSaidaFilters = {}): Promise<TNotaSaida[]> {
  const params = new URLSearchParams()
  if (filters.numero) params.set('numero', filters.numero)
  if (filters.serie) params.set('serie', filters.serie)
  if (filters.modelo) params.set('modelo', filters.modelo)
  if (filters.cpfcnpj) params.set('cpfcnpj', filters.cpfcnpj)

  const qs = params.toString()
  return apiFetch<TNotaSaida[]>(`/api/nfe/saida/${businessId}/listar${qs ? `?${qs}` : ''}`)
}

export async function getNotasDestinadas(businessId: string): Promise<TNotaDestinada[]> {
  return apiFetch<TNotaDestinada[]>(`/api/nfe/destinadas/${businessId}/listar`)
}
