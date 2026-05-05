'use client'

import { useState } from 'react'
import { Search, RefreshCw, Shield, ShieldAlert } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { EmpresaDialog } from './empresa-dialog'
import { EmptyState } from '@/components/shared/empty-state'
import { cn, formatCpfCnpj, getEnvironmentLabel } from '@/lib/utils'
import type { TEmpresa } from '@/types'
import { toast } from 'sonner'

interface EmpresasTableProps {
  empresas: TEmpresa[]
  userId: string
}

export function EmpresasTable({ empresas, userId }: EmpresasTableProps) {
  const [search, setSearch] = useState('')
  const [syncing, setSyncing] = useState<string | null>(null)

  const filtered = empresas.filter((e) => {
    const q = search.toLowerCase()
    return (
      e.corporateName.toLowerCase().includes(q) ||
      e.fantasyName?.toLowerCase().includes(q) ||
      e.cnpj.includes(q)
    )
  })

  async function handleSync(e: TEmpresa) {
    setSyncing(e.businessId)
    try {
      const res = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/business/dfe/${e.businessId}/${e.cnpj}`,
        { credentials: 'include' }
      )
      if (!res.ok) throw new Error()
      toast.success(`Sincronização iniciada para ${e.fantasyName ?? e.corporateName}`)
    } catch {
      toast.error('Erro ao sincronizar DFe')
    } finally {
      setSyncing(null)
    }
  }

  return (
    <div className="space-y-4">
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted" />
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Buscar por razão social, fantasia ou CNPJ..."
          className="w-full pl-10 pr-4 py-2.5 rounded-xl text-sm text-fg placeholder:text-muted outline-none transition-all"
          style={{
            background: 'var(--c-input)',
            border: '1px solid var(--c-border)',
          }}
        />
      </div>

      {filtered.length === 0 ? (
        <EmptyState
          title="Nenhuma empresa encontrada"
          description={search ? 'Tente ajustar o filtro.' : 'Crie sua primeira empresa.'}
        />
      ) : (
        <div className="rounded-2xl overflow-hidden border border-[var(--c-border)] bg-surface">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-[var(--c-border)] bg-[var(--c-overlay)]">
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Empresa</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">CNPJ</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">UF</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Ambiente</th>
                <th className="px-4 py-3" />
              </tr>
            </thead>
            <tbody>
              {filtered.map((e, i) => (
                <tr
                  key={e.businessId}
                  className={cn(
                    'border-b border-[var(--c-border)] transition-colors hover:bg-[var(--c-overlay)]',
                    i === filtered.length - 1 && 'border-b-0'
                  )}
                >
                  <td className="px-4 py-3">
                    <p className="font-medium text-fg">{e.fantasyName ?? e.corporateName}</p>
                    {e.fantasyName && <p className="text-xs text-muted">{e.corporateName}</p>}
                  </td>
                  <td className="px-4 py-3 text-muted font-mono text-xs">{formatCpfCnpj(e.cnpj)}</td>
                  <td className="px-4 py-3 text-muted">{e.uf ?? '-'}</td>
                  <td className="px-4 py-3">
                    <Badge
                      variant="outline"
                      className={cn(
                        'text-xs border rounded-lg gap-1',
                        e.environment === 1
                          ? 'text-success border-success/30 bg-success/10'
                          : 'text-warning border-warning/30 bg-warning/10'
                      )}
                    >
                      {e.environment === 1
                        ? <Shield className="h-3 w-3" />
                        : <ShieldAlert className="h-3 w-3" />}
                      {getEnvironmentLabel(e.environment)}
                    </Badge>
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex items-center justify-end gap-1">
                      <button
                        onClick={() => handleSync(e)}
                        disabled={syncing === e.businessId}
                        title="Sincronizar DFe"
                        className="flex items-center gap-1.5 text-xs text-muted hover:text-secondary px-2 py-1 rounded-lg hover:bg-[var(--c-overlay-md)] transition-all"
                      >
                        <RefreshCw className={cn('h-3.5 w-3.5', syncing === e.businessId && 'animate-spin')} />
                        Sincronizar
                      </button>
                      <EmpresaDialog empresa={e} />
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
