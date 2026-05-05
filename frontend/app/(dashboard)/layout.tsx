import { redirect } from 'next/navigation'
import { getServerUser } from '@/lib/auth'
import { getBusinessByUser } from '@/services/business.service'
import { Sidebar } from '@/components/layout/sidebar'
import { Header } from '@/components/layout/header'
import type { TEmpresa } from '@/types'

const PAGE_TITLES: Record<string, string> = {
  '/': 'Dashboard',
  '/empresas': 'Empresas',
  '/clientes': 'Clientes',
  '/notas-saida': 'Notas de Saída',
  '/notas-destinadas': 'Notas Destinadas',
}

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const user = await getServerUser()
  if (!user?.sub) redirect('/login')

  let businesses: TEmpresa[] = []
  try {
    businesses = await getBusinessByUser(user.sub)
  } catch {
    // If fails, continue with empty list
  }

  return (
    <div className="flex h-screen bg-bg overflow-hidden">
      <Sidebar />
      <div className="flex flex-1 flex-col overflow-hidden pl-64">
        <Header businesses={businesses} pageTitle="LA Contábil" />
        <main className="flex-1 overflow-y-auto p-6">{children}</main>
      </div>
    </div>
  )
}
