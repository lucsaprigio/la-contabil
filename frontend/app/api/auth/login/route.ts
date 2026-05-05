import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'
import { loginService } from '@/services/auth.service'
import { decodeJwt } from '@/lib/auth'

const COOKIE_NAME = process.env.JWT_COOKIE_NAME ?? 'lac-token'

export async function POST(request: NextRequest) {
  const body = await request.json()

  const { email, password } = body
  if (!email || !password) {
    return NextResponse.json({ erro: 'Email e senha são obrigatórios' }, { status: 400 })
  }

  const data = await loginService({ email, password })

  const payload = decodeJwt(data.token)
  const maxAge = payload?.exp
    ? payload.exp - Math.floor(Date.now() / 1000)
    : 60 * 60 * 24

  const response = NextResponse.json({
    userId: data.userId ?? payload?.sub,
    email: data.email ?? email,
    username: data.username ?? email.split('@')[0],
  })

  response.cookies.set(COOKIE_NAME, data.token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    path: '/',
    maxAge,
  })

  return response
}
