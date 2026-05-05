'use client'

import { useState } from 'react'
import { Search } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { EmptyState } from '@/components/shared/empty-state'
import { cn, formatCurrency, formatDate, formatCpfCnpj } from '@/lib/utils'
import type { TNotaDestinada } from '@/types'
import { NotaXmlDialog } from './nota-xml-dialog'

interface NotasDestinadasTableProps {
  notas: TNotaDestinada[]
  businessId: string
}

export function NotasDestinadasTable({ notas, businessId }: NotasDestinadasTableProps) {
  const [search, setSearch] = useState('')

  const filtered = notas.filter((n) => {
    const q = search.toLowerCase()
    return (
      n.numero.includes(q) ||
      n.nomeEmitente?.toLowerCase().includes(q) ||
      n.cpfCnpjEmitente?.includes(q) ||
      n.chaveAcesso?.includes(q)
    )
  })

  return (
    <div className="space-y-4">
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted" />
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Buscar por número, emitente ou chave de acesso..."
          className="w-full pl-10 pr-4 py-2.5 rounded-xl text-sm text-fg placeholder:text-muted outline-none transition-all"
          style={{ background: 'var(--c-input)', border: '1px solid var(--c-border)' }}
        />
      </div>

      {filtered.length === 0 ? (
        <EmptyState
          title="Nenhuma nota destinada encontrada"
          description="As notas são sincronizadas automaticamente a cada 10 minutos."
        />
      ) : (
        <div className="rounded-2xl overflow-hidden border border-[var(--c-border)] bg-surface">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-[var(--c-border)] bg-[var(--c-overlay)]">
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Número / Série</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Emitente</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Emissão</th>
                <th className="text-right px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Valor Total</th>
                <th className="text-left px-4 py-3 text-[11px] font-medium text-subtle uppercase tracking-wider">Situação</th>
                <th className="px-4 py-3" />
              </tr>
            </thead>
            <tbody>
              {filtered.map((n, i) => (
                <tr
                  key={n.id}
                  className={cn(
                    'border-b border-[var(--c-border)] hover:bg-[var(--c-overlay)] transition-colors',
                    i === filtered.length - 1 && 'border-b-0'
                  )}
                >
                  <td className="px-4 py-3">
                    <p className="font-mono font-medium text-fg">{n.numero}</p>
                    <p className="text-xs text-muted">Série {n.serie} · NSU {n.nsu ?? '-'}</p>
                  </td>
                  <td className="px-4 py-3">
                    <p className="text-fg text-xs">{n.nomeEmitente ?? '-'}</p>
                    {n.cpfCnpjEmitente && (
                      <p className="text-muted font-mono text-[10px]">{formatCpfCnpj(n.cpfCnpjEmitente)}</p>
                    )}
                  </td>
                  <td className="px-4 py-3 text-muted text-xs">{formatDate(n.dataEmissao)}</td>
                  <td className="px-4 py-3 text-right">
                    <span className="font-semibold text-fg">{formatCurrency(n.valorTotal)}</span>
                  </td>
                  <td className="px-4 py-3">
                    {n.situacao && (
                      <Badge variant="outline" className="text-[10px] border-secondary/30 text-secondary bg-secondary/10">
                        {n.situacao}
                      </Badge>
                    )}
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex justify-end">
                      <NotaXmlDialog notaId={n.id} businessId={businessId} tipo="destinada" numero={n.numero} />
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
