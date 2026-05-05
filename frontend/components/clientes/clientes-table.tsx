'use client'

import { useState } from 'react'
import { Search } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { ClienteDialog } from './cliente-dialog'
import { EmptyState } from '@/components/shared/empty-state'
import { cn, formatCpfCnpj } from '@/lib/utils'
import type { TCliente } from '@/types'

interface ClientesTableProps {
  clientes: TCliente[]
  businessId: string
}

export function ClientesTable({ clientes, businessId }: ClientesTableProps) {
  const [search, setSearch] = useState('')

  const filtered = clientes.filter((c) => {
    const q = search.toLowerCase()
    return (
      c.nomeRazao.toLowerCase().includes(q) ||
      c.cpfCnpj.includes(q) ||
      c.email?.toLowerCase().includes(q)
    )
  })

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-3">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted" />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Buscar por nome, CPF/CNPJ ou e-mail..."
            className="w-full pl-10 pr-4 py-2.5 rounded-xl text-sm text-fg placeholder:text-muted outline-none transition-all"
            style={{ background: 'var(--c-input)', border: '1px solid var(--c-border)' }}
          />
        </div>
        <ClienteDialog businessId={businessId} />
      </div>

      {filtered.length === 0 ? (
        <EmptyState
          title="Nenhum cliente encontrado"
          description={search ? 'Tente ajustar o filtro.' : 'Cadastre o primeiro cliente desta empresa.'}
          action={!search ? <ClienteDialog businessId={businessId} /> : undefined}
        />
      ) : (
        <div className="rounded-2xl overflow-hidden border border-[var(--c-border)] bg-surface">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-[var(--c-border)] bg-[var(--c-overlay)]">
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Nome</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">CPF / CNPJ</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">E-mail</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Município / UF</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Status</th>
                <th className="px-4 py-3" />
              </tr>
            </thead>
            <tbody>
              {filtered.map((c, i) => (
                <tr
                  key={c.id}
                  className={cn(
                    'border-b border-[var(--c-border)] hover:bg-[var(--c-overlay)] transition-colors',
                    i === filtered.length - 1 && 'border-b-0'
                  )}
                >
                  <td className="px-4 py-3">
                    <p className="font-medium text-fg">{c.nomeRazao}</p>
                    {c.nomeFantasia && <p className="text-xs text-muted">{c.nomeFantasia}</p>}
                  </td>
                  <td className="px-4 py-3 text-muted font-mono text-xs">{formatCpfCnpj(c.cpfCnpj)}</td>
                  <td className="px-4 py-3 text-muted text-xs">{c.email ?? '-'}</td>
                  <td className="px-4 py-3 text-muted text-xs">
                    {c.municipio ? `${c.municipio} / ${c.uf}` : '-'}
                  </td>
                  <td className="px-4 py-3">
                    <Badge
                      variant="outline"
                      className={cn(
                        'text-xs border rounded-lg',
                        c.ativo === 'S'
                          ? 'text-success border-success/30 bg-success/10'
                          : 'text-muted border-[var(--c-border)] bg-[var(--c-overlay)]'
                      )}
                    >
                      {c.ativo === 'S' ? 'Ativo' : 'Inativo'}
                    </Badge>
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex justify-end">
                      <ClienteDialog businessId={businessId} cliente={c} />
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
