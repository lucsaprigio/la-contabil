import type { TLoginRequest, TLoginResponse } from '@/types'

const API_URL = process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost:9000'

export async function loginService(data: TLoginRequest): Promise<TLoginResponse> {
  const res = await fetch(`${API_URL}/api/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
    cache: 'no-store',
  })

  if (!res.ok) {
    const err = await res.json().catch(() => ({ erro: 'Credenciais inválidas' }))
    throw new Error(err?.erro ?? 'Erro ao fazer login')
  }

  return res.json()
}
