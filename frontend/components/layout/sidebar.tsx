'use client'

import Link from 'next/link'
import { usePathname, useRouter } from 'next/navigation'
import {
  LayoutDashboard,
  Building2,
  Users,
  FileText,
  FileInput,
  LogOut,
  ChevronRight,
} from 'lucide-react'
import { cn } from '@/lib/utils'
import { useAuthStore } from '@/store/auth.store'
import { useAppStore } from '@/store/app.store'
import { toast } from 'sonner'

const NAV_ITEMS = [
  { label: 'Dashboard',        href: '/',                  icon: LayoutDashboard },
  { label: 'Empresas',         href: '/empresas',           icon: Building2 },
  { label: 'Clientes',         href: '/clientes',           icon: Users },
  { label: 'Notas de Saída',   href: '/notas-saida',        icon: FileText },
  { label: 'Notas Destinadas', href: '/notas-destinadas',   icon: FileInput },
]

export function Sidebar() {
  const pathname = usePathname()
  const { username, clear: clearAuth } = useAuthStore()
  const { clearBusiness } = useAppStore()
  const router = useRouter()

  async function handleLogout() {
    await fetch('/api/auth/logout', { method: 'POST' })
    clearAuth()
    clearBusiness()
    toast.success('Sessão encerrada')
    router.push('/login')
  }

  return (
    <aside
      className="fixed inset-y-0 left-0 z-50 flex w-64 flex-col border-r border-[var(--c-border)]"
      style={{ background: 'var(--c-glass-strong)', backdropFilter: 'blur(20px)' }}
    >
      {/* Logo */}
      <div className="flex items-center gap-3 px-6 py-5 border-b border-[var(--c-border)]">
        <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-primary to-secondary shadow-lg shadow-primary/20">
          <FileText className="h-5 w-5 text-white" />
        </div>
        <div>
          <p className="text-sm font-bold text-fg leading-none">LA Contábil</p>
          <p className="text-[10px] text-muted mt-0.5">Sistema Fiscal</p>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto px-3 py-4 space-y-0.5">
        {NAV_ITEMS.map(({ label, href, icon: Icon }) => {
          const isActive = href === '/' ? pathname === '/' : pathname.startsWith(href)
          return (
            <Link
              key={href}
              href={href}
              className={cn(
                'group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all',
                isActive
                  ? 'bg-gradient-to-r from-primary/15 to-secondary/10 text-fg border border-primary/25'
                  : 'text-muted hover:text-fg hover:bg-[var(--c-overlay-md)]'
              )}
            >
              <Icon
                className={cn(
                  'h-4 w-4 shrink-0 transition-colors',
                  isActive ? 'text-primary' : 'group-hover:text-secondary'
                )}
              />
              <span className="flex-1">{label}</span>
              {isActive && <ChevronRight className="h-3 w-3 text-primary" />}
            </Link>
          )
        })}
      </nav>

      {/* User / Logout */}
      <div className="border-t border-[var(--c-border)] px-3 py-4">
        <div className="flex items-center gap-3 rounded-xl px-3 py-2 mb-1">
          <div className="flex h-8 w-8 items-center justify-center rounded-full bg-gradient-to-br from-primary to-secondary text-xs font-bold text-white shadow-md shadow-primary/20">
            {(username ?? 'U').charAt(0).toUpperCase()}
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-xs font-medium text-fg truncate">{username ?? 'Usuário'}</p>
          </div>
        </div>
        <button
          onClick={handleLogout}
          className="w-full flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm text-muted hover:text-danger hover:bg-danger/10 transition-all"
        >
          <LogOut className="h-4 w-4" />
          Sair
        </button>
      </div>
    </aside>
  )
}
