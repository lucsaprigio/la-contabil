import { Suspense } from 'react'
import { redirect } from 'next/navigation'
import { getServerUser } from '@/lib/auth'
import { getBusinessByUser } from '@/services/business.service'
import { KpiCard } from '@/components/dashboard/kpi-card'
import { GlassCard } from '@/components/shared/glass-card'
import { PageHeader } from '@/components/shared/page-header'
import { Skeleton } from '@/components/ui/skeleton'
import {
  Building2,
  FileText,
  FileInput,
  Users,
  RefreshCw,
  Shield,
  ShieldAlert,
} from 'lucide-react'
import { getEnvironmentLabel, formatCpfCnpj } from '@/lib/utils'
import type { TEmpresa } from '@/types'

async function DashboardContent() {
  const user = await getServerUser()
  if (!user?.sub) redirect('/login')

  let businesses: TEmpresa[] = []
  try {
    businesses = await getBusinessByUser(user.sub)
  } catch {
    businesses = []
  }

  const prodCount = businesses.filter((b) => b.environment === 1).length
  const homCount = businesses.filter((b) => b.environment === 2).length

  return (
    <div className="space-y-6">
      <PageHeader
        title={`Olá${user.email ? `, ${user.email.split('@')[0]}` : ''}!`}
        description="Visão geral do sistema LA Contábil"

      />

      {/* KPIs */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        <KpiCard
          title="Empresas Vinculadas"
          value={businesses.length}
          subtitle="total de empresas"
          icon={Building2}
          variant="primary"
        />
        <KpiCard
          title="Produção"
          value={prodCount}
          subtitle="ambientes ativos"
          icon={Shield}
          variant="success"
        />
        <KpiCard
          title="Homologação"
          value={homCount}
          subtitle="ambientes de teste"
          icon={ShieldAlert}
          variant="warning"
        />
        <KpiCard
          title="Sync Automático"
          value="10 min"
          subtitle="intervalo de sincronização"
          icon={RefreshCw}
          variant="secondary"
        />
      </div>

      {/* Empresas resumo */}
      {businesses.length > 0 && (
        <div>
          <h3 className="text-sm font-medium text-muted uppercase tracking-wider mb-3">
            Suas Empresas
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {businesses.map((b) => (
              <GlassCard key={b.businessId} hover className="p-4 border border-[var(--c-border)]">
                <div className="flex items-start gap-3">
                  <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-primary/20 to-secondary/20 text-primary font-bold text-sm">
                    {(b.fantasyName ?? b.corporateName).charAt(0)}
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="font-medium text-fg truncate">{b.fantasyName ?? b.corporateName}</p>
                    <p className="text-xs text-muted font-mono mt-0.5">{formatCpfCnpj(b.cnpj)}</p>
                    <div className="flex items-center gap-1.5 mt-2">
                      <span className={`text-[10px] px-2 py-0.5 rounded-full border ${
                        b.environment === 1
                          ? 'text-success border-success/30 bg-success/10'
                          : 'text-warning border-warning/30 bg-warning/10'
                      }`}>
                        {getEnvironmentLabel(b.environment)}
                      </span>
                      <span className="text-[10px] text-muted">{b.uf}</span>
                    </div>
                  </div>
                </div>
              </GlassCard>
            ))}
          </div>
        </div>
      )}

      {businesses.length === 0 && (
        <GlassCard className="p-8 text-center border border-[var(--c-border)]">
          <Building2 className="h-12 w-12 text-primary/40 mx-auto mb-3" />
          <p className="text-fg font-medium">Nenhuma empresa vinculada</p>
          <p className="text-sm text-muted mt-1">
            Acesse a seção de Empresas para cadastrar e vincular sua primeira empresa.
          </p>
        </GlassCard>
      )}

      {/* Quick links */}
      <div>
        <h3 className="text-sm font-medium text-muted uppercase tracking-wider mb-3">
          Acesso Rápido
        </h3>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {[
            { label: 'Empresas',         href: '/empresas',          icon: Building2,  color: 'from-primary/20 to-primary/10',   iconColor: 'text-primary'   },
            { label: 'Clientes',         href: '/clientes',           icon: Users,      color: 'from-secondary/20 to-secondary/10', iconColor: 'text-secondary' },
            { label: 'Notas de Saída',   href: '/notas-saida',        icon: FileText,   color: 'from-success/20 to-success/10',   iconColor: 'text-success'   },
            { label: 'Notas Destinadas', href: '/notas-destinadas',   icon: FileInput,  color: 'from-warning/20 to-warning/10',   iconColor: 'text-warning'   },
          ].map(({ label, href, icon: Icon, color, iconColor }) => (
            <a
              key={href}
              href={href}
              className="group glass rounded-xl p-4 border border-[var(--c-border)] hover:bg-[var(--c-overlay-md)] transition-all text-center"
            >
              <div className={`flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br ${color} mx-auto mb-2`}>
                <Icon className={`h-5 w-5 ${iconColor}`} />
              </div>
              <p className="text-xs font-medium text-muted group-hover:text-fg transition-colors">{label}</p>
            </a>
          ))}
        </div>
      </div>
    </div>
  )
}

function DashboardSkeleton() {
  return (
    <div className="space-y-6">
      <div className="space-y-1">
        <Skeleton className="h-8 w-48 bg-[var(--c-overlay-md)] rounded-xl" />
        <Skeleton className="h-4 w-64 bg-[var(--c-overlay-md)] rounded-lg" />
      </div>
      <div className="grid grid-cols-4 gap-4">
        {Array.from({ length: 4 }).map((_, i) => (
          <Skeleton key={i} className="h-14 bg-[var(--c-overlay-md)] rounded-xl" />
        ))}
      </div>
    </div>
  )
}

export default function DashboardPage() {
  return (
    <Suspense fallback={<DashboardSkeleton />}>
      <DashboardContent />
    </Suspense>
  )
}
