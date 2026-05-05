'use client'

import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Plus, Pencil, Loader2 } from 'lucide-react'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import { Input } from '@/components/ui/input'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { maskCnpj } from '@/lib/utils'
import type { TEmpresa } from '@/types'

const schema = z.object({
  corporateName: z.string().min(3, 'Razão social é obrigatória'),
  fantasyName: z.string().min(1, 'Nome fantasia é obrigatório'),
  cnpj: z.string().min(14, 'CNPJ inválido'),
  ie: z.string().optional(),
  uf: z.string().length(2, 'UF deve ter 2 letras'),
  environment: z.enum(['1', '2']),
})

type FormValues = z.infer<typeof schema>

interface EmpresaDialogProps {
  empresa?: TEmpresa
  onSuccess?: () => void
}

const UF_OPTIONS = [
  'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA',
  'MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN',
  'RS','RO','RR','SC','SP','SE','TO',
]

export function EmpresaDialog({ empresa, onSuccess }: EmpresaDialogProps) {
  const [open, setOpen] = useState(false)
  const isEditing = !!empresa

  const form = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      corporateName: empresa?.corporateName ?? '',
      fantasyName: empresa?.fantasyName ?? '',
      cnpj: empresa?.cnpj ?? '',
      ie: empresa?.ie ?? '',
      uf: empresa?.uf ?? '',
      environment: String(empresa?.environment ?? 2) as '1' | '2',
    },
  })

  async function onSubmit(values: FormValues) {
    const endpoint = isEditing
      ? `/api/business/${empresa!.businessId}`
      : '/api/business'
    const method = isEditing ? 'PUT' : 'POST'

    const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}${endpoint}`, {
      method,
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ ...values, environment: Number(values.environment) }),
    })

    if (!res.ok) {
      const err = await res.json().catch(() => ({ erro: 'Erro desconhecido' }))
      toast.error(err.erro ?? 'Erro ao salvar empresa')
      return
    }

    toast.success(isEditing ? 'Empresa atualizada!' : 'Empresa criada!')
    setOpen(false)
    onSuccess?.()
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        {isEditing ? (
          <button className="flex items-center gap-1.5 text-xs text-[#94a3b8] hover:text-white px-2 py-1 rounded-lg hover:bg-white/5 transition-all">
            <Pencil className="h-3.5 w-3.5" /> Editar
          </button>
        ) : (
          <Button className="bg-gradient-to-r from-[#7c3aed] to-[#06b6d4] hover:opacity-90 text-white border-0 rounded-xl gap-2">
            <Plus className="h-4 w-4" /> Nova Empresa
          </Button>
        )}
      </DialogTrigger>
      <DialogContent className="max-w-lg border-[var(--c-border)]" style={{ background: 'var(--c-surface)', color: 'var(--c-fg)' }}>
        <DialogHeader>
          <DialogTitle>{isEditing ? 'Editar Empresa' : 'Nova Empresa'}</DialogTitle>
        </DialogHeader>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="corporateName"
                render={({ field }) => (
                  <FormItem className="col-span-2">
                    <FormLabel className="text-muted text-xs">Razão Social</FormLabel>
                    <FormControl>
                      <Input {...field} className="text-fg placeholder:text-muted" style={{ background: 'var(--c-input)', borderColor: 'var(--c-border)' }} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="fantasyName"
                render={({ field }) => (
                  <FormItem className="col-span-2">
                    <FormLabel className="text-muted text-xs">Nome Fantasia</FormLabel>
                    <FormControl>
                      <Input {...field} className="text-fg placeholder:text-muted" style={{ background: 'var(--c-input)', borderColor: 'var(--c-border)' }} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="cnpj"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-muted text-xs">CNPJ</FormLabel>
                    <FormControl>
                      <Input
                        {...field}
                        onChange={(e) => field.onChange(maskCnpj(e.target.value))}
                        placeholder="00.000.000/0001-00"
                        className="text-fg placeholder:text-muted" style={{ background: 'var(--c-input)', borderColor: 'var(--c-border)' }}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="ie"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-muted text-xs">Inscrição Estadual</FormLabel>
                    <FormControl>
                      <Input {...field} className="text-fg placeholder:text-muted" style={{ background: 'var(--c-input)', borderColor: 'var(--c-border)' }} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="uf"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-muted text-xs">UF</FormLabel>
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <FormControl>
                        <SelectTrigger className="text-fg" style={{ background: 'var(--c-input)', borderColor: 'var(--c-border)' }}>
                          <SelectValue placeholder="UF" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent className="border-[var(--c-border)] text-fg" style={{ background: 'var(--c-surface)' }}>
                        {UF_OPTIONS.map((uf) => (
                          <SelectItem key={uf} value={uf}>{uf}</SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="environment"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-muted text-xs">Ambiente</FormLabel>
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <FormControl>
                        <SelectTrigger className="text-fg" style={{ background: 'var(--c-input)', borderColor: 'var(--c-border)' }}>
                          <SelectValue />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent className="border-[var(--c-border)] text-fg" style={{ background: 'var(--c-surface)' }}>
                        <SelectItem value="1">Produção</SelectItem>
                        <SelectItem value="2">Homologação</SelectItem>
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
            <div className="flex justify-end gap-3 pt-2">
              <Button
                type="button"
                variant="outline"
                onClick={() => setOpen(false)}
                className="border-[var(--c-border)] text-muted hover:text-fg hover:bg-[var(--c-overlay-md)]"
              >
                Cancelar
              </Button>
              <Button
                type="submit"
                disabled={form.formState.isSubmitting}
                className="bg-gradient-to-r from-[#7c3aed] to-[#06b6d4] hover:opacity-90 text-white border-0 rounded-xl"
              >
                {form.formState.isSubmitting && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
                {isEditing ? 'Salvar' : 'Criar Empresa'}
              </Button>
            </div>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  )
}
