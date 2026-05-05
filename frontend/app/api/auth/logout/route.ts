import { NextResponse } from 'next/server'

const COOKIE_NAME = process.env.JWT_COOKIE_NAME ?? 'lac-token'

export async function POST() {
  const response = NextResponse.json({ ok: true })
  response.cookies.delete(COOKIE_NAME)
  return response
}
