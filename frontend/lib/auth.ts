import { cookies } from 'next/headers'

const COOKIE_NAME = process.env.JWT_COOKIE_NAME ?? 'lac-token'

interface JwtPayload {
  sub: string
  email?: string
  username?: string
  iss?: string
  exp?: number
  iat?: number
}

export function decodeJwt(token: string): JwtPayload | null {
  try {
    const [, payload] = token.split('.')
    const decoded = Buffer.from(payload, 'base64url').toString('utf-8')
    return JSON.parse(decoded) as JwtPayload
  } catch {
    return null
  }
}

export async function getServerUser(): Promise<JwtPayload | null> {
  const cookieStore = await cookies()
  const token = cookieStore.get(COOKIE_NAME)?.value
  if (!token) return null
  return decodeJwt(token)
}

export async function getServerToken(): Promise<string | null> {
  const cookieStore = await cookies()
  return cookieStore.get(COOKIE_NAME)?.value ?? null
}
