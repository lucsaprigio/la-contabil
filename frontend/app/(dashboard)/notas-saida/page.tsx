import { Suspense } from 'react'
import { redirect } from 'next/navigation'
import { getServerUser } from '@/lib/auth'
import { getBusinessByUser } from '@/services/business.service'
import { getNotasSaida } from '@/services/notas.service'
import { NotasSaidaTable } from '@/components/notas/notas-saida-table'
import { PageHeader } from '@/components/shared/page-header'
import { SelectBusinessPrompt } from '@/components/shared/select-business-prompt'
import { Skeleton } from '@/components/ui/skeleton'
import type { TNotaSaida } from '@/types'

interface PageProps {
  searchParams: Promise<{ businessId?: string }>
}

async function NotasSaidaContent({ businessId }: { businessId: string | null }) {
  const user = await getServerUser()
  if (!user?.sub) redirect('/login')

  if (!businessId) {
    return (
      <div className="space-y-6">
        <PageHeader title="Notas de Saída" description="Selecione uma empresa no topo para visualizar as notas." />
        <SelectBusinessPrompt />
      </div>
    )
  }

  let notas: TNotaSaida[] = []
  let empresaNome = businessId

  try {
    const [n, businesses] = await Promise.all([
      getNotasSaida(businessId),
      getBusinessByUser(user.sub),
    ])
    notas = n
    const empresa = businesses.find((b) => b.businessId === businessId)
    if (empresa) empresaNome = empresa.fantasyName ?? empresa.corporateName
  } catch {
    notas = []
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title="Notas de Saída"
        description={`${empresaNome} · ${notas.length} nota${notas.length !== 1 ? 's' : ''}`}
      />
      <NotasSaidaTable notas={notas} />
    </div>
  )
}

export default async function NotasSaidaPage({ searchParams }: PageProps) {
  const params = await searchParams
  const businessId = params.businessId ?? null

  return (
    <Suspense fallback={
      <div className="space-y-6">
        <Skeleton className="h-10 w-64 bg-white/5 rounded-xl" />
        <Skeleton className="h-72 bg-white/5 rounded-2xl" />
      </div>
    }>
      <NotasSaidaContent businessId={businessId} />
    </Suspense>
  )
}
