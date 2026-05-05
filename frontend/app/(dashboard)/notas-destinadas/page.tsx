import { Suspense } from 'react'
import { redirect } from 'next/navigation'
import { getServerUser } from '@/lib/auth'
import { getBusinessByUser } from '@/services/business.service'
import { getNotasDestinadas } from '@/services/notas.service'
import { NotasDestinadasTable } from '@/components/notas/notas-destinadas-table'
import { PageHeader } from '@/components/shared/page-header'
import { SelectBusinessPrompt } from '@/components/shared/select-business-prompt'
import { Skeleton } from '@/components/ui/skeleton'
import type { TNotaDestinada } from '@/types'

interface PageProps {
  searchParams: Promise<{ businessId?: string }>
}

async function NotasDestinadasContent({ businessId }: { businessId: string | null }) {
  const user = await getServerUser()
  if (!user?.sub) redirect('/login')

  if (!businessId) {
    return (
      <div className="space-y-6">
        <PageHeader
          title="Notas Destinadas"
          description="Selecione uma empresa no topo para visualizar as notas recebidas da SEFAZ."
        />
        <SelectBusinessPrompt />
      </div>
    )
  }

  let notas: TNotaDestinada[] = []
  let empresaNome = businessId

  try {
    const [n, businesses] = await Promise.all([
      getNotasDestinadas(businessId),
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
        title="Notas Destinadas"
        description={`${empresaNome} · ${notas.length} nota${notas.length !== 1 ? 's' : ''} recebida${notas.length !== 1 ? 's' : ''}`}
      />
      <NotasDestinadasTable notas={notas} businessId={businessId} />
    </div>
  )
}

export default async function NotasDestinadasPage({ searchParams }: PageProps) {
  const params = await searchParams
  const businessId = params.businessId ?? null

  return (
    <Suspense fallback={
      <div className="space-y-6">
        <Skeleton className="h-10 w-64 bg-white/5 rounded-xl" />
        <Skeleton className="h-72 bg-white/5 rounded-2xl" />
      </div>
    }>
      <NotasDestinadasContent businessId={businessId} />
    </Suspense>
  )
}
