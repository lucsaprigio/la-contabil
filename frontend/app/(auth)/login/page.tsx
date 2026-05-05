import { Suspense } from 'react'
import { FileText } from 'lucide-react'
import { LoginForm } from './login-form'

export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-bg">
      {/* Background glow */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-40 -left-40 w-96 h-96 rounded-full bg-[#7c3aed]/10 blur-3xl" />
        <div className="absolute -bottom-40 -right-40 w-96 h-96 rounded-full bg-[#06b6d4]/10 blur-3xl" />
      </div>

      <div className="w-full max-w-md relative">
        {/* Logo */}
        <div className="flex flex-col items-center mb-8">
          <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-gradient-to-br from-[#7c3aed] to-[#06b6d4] shadow-lg shadow-[#7c3aed]/30 mb-4">
            <FileText className="h-7 w-7 text-white" />
          </div>
          <h1 className="text-2xl font-bold text-fg">LA Contábil</h1>
          <p className="text-sm text-muted mt-1">Sistema de Gestão Fiscal</p>
        </div>

        {/* Card */}
        <div className="glass-strong rounded-2xl p-8 border border-white/10">
          <h2 className="text-lg font-semibold text-fg mb-1">Entrar na conta</h2>
          <p className="text-sm text-muted mb-6">Use seu e-mail e senha cadastrados.</p>
          <Suspense>
            <LoginForm />
          </Suspense>
        </div>

        <p className="text-center text-xs text-subtle mt-6">
          LA Contábil · Sistema Fiscal Eletrônico
        </p>
      </div>
    </div>
  )
}
