import { apiFetch } from '@/lib/api'
import type { TEmpresa, TCreateEmpresaRequest, TUserBusinessResponse } from '@/types'

export async function getBusinessByUser(userId: string): Promise<TEmpresa[]> {
  const data = await apiFetch<TUserBusinessResponse>(`/api/user_business/${userId}`)
  return data?.empresas ?? []
}

export async function getBusinessByCnpj(cnpj: string): Promise<TEmpresa> {
  return apiFetch<TEmpresa>(`/api/business/${cnpj}`)
}

export async function createBusiness(data: TCreateEmpresaRequest): Promise<TEmpresa> {
  return apiFetch<TEmpresa>('/api/business', {
    method: 'POST',
    body: JSON.stringify(data),
  })
}

export async function updateBusiness(id: string, data: Partial<TCreateEmpresaRequest>): Promise<TEmpresa> {
  return apiFetch<TEmpresa>(`/api/business/${id}`, {
    method: 'PUT',
    body: JSON.stringify(data),
  })
}

export async function triggerDfeSync(businessId: string, cnpj: string): Promise<void> {
  return apiFetch(`/api/business/dfe/${businessId}/${cnpj}`)
}
