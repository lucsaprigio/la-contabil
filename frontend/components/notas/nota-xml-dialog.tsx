'use client'

import { useState } from 'react'
import { Eye, Loader2, Copy, Check } from 'lucide-react'
import { toast } from 'sonner'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'

interface NotaXmlDialogProps {
  notaId: string
  businessId: string
  tipo: 'saida' | 'destinada'
  numero: string
}

export function NotaXmlDialog({ notaId, businessId, tipo, numero }: NotaXmlDialogProps) {
  const [open, setOpen] = useState(false)
  const [xml, setXml] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [copied, setCopied] = useState(false)

  async function loadXml() {
    if (xml) return
    setLoading(true)
    try {
      const endpoint = tipo === 'saida'
        ? `/api/nfe/saida/${businessId}/xml/${notaId}`
        : `/api/nfe/destinadas/${businessId}/xml/${notaId}`
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}${endpoint}`, { credentials: 'include' })
      if (!res.ok) throw new Error()
      setXml(await res.text())
    } catch {
      toast.error('Não foi possível carregar o XML desta nota.')
      setOpen(false)
    } finally {
      setLoading(false)
    }
  }

  function handleOpen(v: boolean) {
    setOpen(v)
    if (v) loadXml()
  }

  async function copyXml() {
    if (!xml) return
    await navigator.clipboard.writeText(xml)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
    toast.success('XML copiado!')
  }

  return (
    <Dialog open={open} onOpenChange={handleOpen}>
      <DialogTrigger asChild>
        <button className="flex items-center gap-1.5 text-xs text-muted hover:text-secondary px-2 py-1 rounded-lg hover:bg-[var(--c-overlay-md)] transition-all">
          <Eye className="h-3.5 w-3.5" /> XML
        </button>
      </DialogTrigger>
      <DialogContent
        className="max-w-3xl max-h-[80vh] flex flex-col border-[var(--c-border)]"
        style={{ background: 'var(--c-surface)', color: 'var(--c-fg)' }}
      >
        <DialogHeader className="flex-row items-center justify-between">
          <DialogTitle className="text-base text-fg">XML — Nota {numero}</DialogTitle>
          {xml && (
            <button
              onClick={copyXml}
              className="flex items-center gap-1.5 text-xs text-muted hover:text-fg px-2 py-1.5 rounded-lg hover:bg-[var(--c-overlay-md)] transition-all mr-8"
            >
              {copied ? <Check className="h-3.5 w-3.5 text-success" /> : <Copy className="h-3.5 w-3.5" />}
              {copied ? 'Copiado!' : 'Copiar'}
            </button>
          )}
        </DialogHeader>
        <div className="flex-1 overflow-auto">
          {loading && (
            <div className="flex items-center justify-center py-12">
              <Loader2 className="h-6 w-6 animate-spin text-primary" />
            </div>
          )}
          {xml && (
            <pre
              className="text-[10px] text-muted font-mono rounded-xl p-4 overflow-auto whitespace-pre-wrap break-all"
              style={{ background: 'var(--c-overlay)' }}
            >
              {xml}
            </pre>
          )}
        </div>
      </DialogContent>
    </Dialog>
  )
}
