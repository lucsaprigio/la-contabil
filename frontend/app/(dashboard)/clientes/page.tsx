import { Suspense } from 'react'
import { redirect } from 'next/navigation'
import { getServerUser } from '@/lib/auth'
import { getBusinessByUser } from '@/services/business.service'
import { getClientes } from '@/services/clientes.service'
import { ClientesTable } from '@/components/clientes/clientes-table'
import { PageHeader } from '@/components/shared/page-header'
import { SelectBusinessPrompt } from '@/components/shared/select-business-prompt'
import { Skeleton } from '@/components/ui/skeleton'
import type { TCliente } from '@/types'

interface PageProps {
  searchParams: Promise<{ businessId?: string }>
}

async function ClientesContent({ businessId }: { businessId: string | null }) {
  const user = await getServerUser()
  if (!user?.sub) redirect('/login')

  if (!businessId) {
    return (
      <div className="space-y-6">
        <PageHeader title="Clientes" description="Selecione uma empresa no topo para visualizar os clientes." />
        <SelectBusinessPrompt />
      </div>
    )
  }

  let clientes: TCliente[] = []
  let empresaNome = businessId

  try {
    const [c, businesses] = await Promise.all([
      getClientes(businessId),
      getBusinessByUser(user.sub),
    ])
    clientes = c
    const empresa = businesses.find((b) => b.businessId === businessId)
    if (empresa) empresaNome = empresa.fantasyName ?? empresa.corporateName
  } catch {
    clientes = []
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title="Clientes"
        description={`${empresaNome} · ${clientes.length} cliente${clientes.length !== 1 ? 's' : ''}`}
      />
      <ClientesTable clientes={clientes} businessId={businessId} />
    </div>
  )
}

export default async function ClientesPage({ searchParams }: PageProps) {
  const params = await searchParams
  const businessId = params.businessId ?? null

  return (
    <Suspense fallback={
      <div className="space-y-6">
        <Skeleton className="h-10 w-64 bg-white/5 rounded-xl" />
        <Skeleton className="h-64 bg-white/5 rounded-2xl" />
      </div>
    }>
      <ClientesContent businessId={businessId} />
    </Suspense>
  )
}
