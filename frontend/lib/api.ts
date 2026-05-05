import { cookies } from 'next/headers'

const API_URL = process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost:9000'
const COOKIE_NAME = process.env.JWT_COOKIE_NAME ?? 'lac-token'

interface FetchOptions extends Omit<RequestInit, 'headers'> {
  headers?: Record<string, string>
}

export async function apiFetch<T>(
  path: string,
  options: FetchOptions = {}
): Promise<T> {
  const cookieStore = await cookies()
  const token = cookieStore.get(COOKIE_NAME)?.value

  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(options.headers ?? {}),
  }

  if (token) {
    headers['Authorization'] = `Bearer ${token}`
  }

  const res = await fetch(`${API_URL}${path}`, {
    ...options,
    headers,
    cache: 'no-store',
  })

  if (!res.ok) {
    const errorBody = await res.json().catch(() => ({ erro: res.statusText }))
    throw new Error(errorBody?.erro ?? `Request failed: ${res.status}`)
  }

  const text = await res.text()
  if (!text) return undefined as T
  return JSON.parse(text) as T
}
