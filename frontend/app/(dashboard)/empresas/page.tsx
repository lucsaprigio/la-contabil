import { Suspense } from 'react'
import { redirect } from 'next/navigation'
import { getServerUser } from '@/lib/auth'
import { getBusinessByUser } from '@/services/business.service'
import { EmpresasTable } from '@/components/empresas/empresas-table'
import { EmpresaDialog } from '@/components/empresas/empresa-dialog'
import { PageHeader } from '@/components/shared/page-header'
import { Skeleton } from '@/components/ui/skeleton'
import type { TEmpresa } from '@/types'

async function EmpresasContent() {
  const user = await getServerUser()
  if (!user?.sub) redirect('/login')

  let empresas: TEmpresa[] = []
  try {
    empresas = await getBusinessByUser(user.sub)
  } catch {
    empresas = []
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title="Empresas"
        description={`${empresas.length} empresa${empresas.length !== 1 ? 's' : ''} vinculada${empresas.length !== 1 ? 's' : ''}`}
        action={<EmpresaDialog />}
      />
      <EmpresasTable empresas={empresas} userId={user.sub} />
    </div>
  )
}

export default function EmpresasPage() {
  return (
    <Suspense fallback={
      <div className="space-y-6">
        <Skeleton className="h-10 w-64 bg-white/5 rounded-xl" />
        <Skeleton className="h-64 bg-white/5 rounded-2xl" />
      </div>
    }>
      <EmpresasContent />
    </Suspense>
  )
}
