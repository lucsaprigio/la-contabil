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
import type { TCliente } from '@/types'

const schema = z.object({
  nomeRazao: z.string().min(2, 'Nome é obrigatório'),
  nomeFantasia: z.string().optional(),
  cpfCnpj: z.string().min(11, 'CPF/CNPJ inválido'),
  ie: z.string().optional(),
  email: z.string().email('Email inválido').optional().or(z.literal('')),
  telefone: z.string().optional(),
  municipio: z.string().optional(),
  uf: z.string().optional(),
  cep: z.string().optional(),
})

type FormValues = z.infer<typeof schema>

interface ClienteDialogProps {
  businessId: string
  cliente?: TCliente
  onSuccess?: () => void
}

export function ClienteDialog({ businessId, cliente, onSuccess }: ClienteDialogProps) {
  const [open, setOpen] = useState(false)
  const isEditing = !!cliente

  const form = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      nomeRazao: cliente?.nomeRazao ?? '',
      nomeFantasia: cliente?.nomeFantasia ?? '',
      cpfCnpj: cliente?.cpfCnpj ?? '',
      ie: cliente?.ie ?? '',
      email: cliente?.email ?? '',
      telefone: cliente?.telefone ?? '',
      municipio: cliente?.municipio ?? '',
      uf: cliente?.uf ?? '',
      cep: cliente?.cep ?? '',
    },
  })

  async function onSubmit(values: FormValues) {
    const apiUrl = process.env.NEXT_PUBLIC_API_URL
    const endpoint = isEditing
      ? `${apiUrl}/api/clientes/${businessId}/${cliente!.id}`
      : `${apiUrl}/api/clientes`
    const method = isEditing ? 'PUT' : 'POST'
    const body = isEditing ? values : { ...values, businessId }

    const res = await fetch(endpoint, {
      method,
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify(body),
    })

    if (!res.ok) {
      const err = await res.json().catch(() => ({ erro: 'Erro desconhecido' }))
      toast.error(err.erro ?? 'Erro ao salvar cliente')
      return
    }

    toast.success(isEditing ? 'Cliente atualizado!' : 'Cliente criado!')
    setOpen(false)
    onSuccess?.()
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        {isEditing ? (
          <button className="flex items-center gap-1.5 text-xs text-muted hover:text-fg px-2 py-1 rounded-lg hover:bg-[var(--c-overlay-md)] transition-all">
            <Pencil className="h-3.5 w-3.5" /> Editar
          </button>
        ) : (
          <Button className="bg-gradient-to-r from-[#7c3aed] to-[#06b6d4] hover:opacity-90 text-white border-0 rounded-xl gap-2">
            <Plus className="h-4 w-4" /> Novo Cliente
          </Button>
        )}
      </DialogTrigger>
      <DialogContent className="max-w-lg border-[var(--c-border)]" style={{ background: 'var(--c-surface)', color: 'var(--c-fg)' }}>
        <DialogHeader>
          <DialogTitle>{isEditing ? 'Editar Cliente' : 'Novo Cliente'}</DialogTitle>
        </DialogHeader>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              {([
                { name: 'nomeRazao', label: 'Nome / Razão Social', col: '2' },
                { name: 'nomeFantasia', label: 'Nome Fantasia', col: '2' },
                { name: 'cpfCnpj', label: 'CPF / CNPJ', col: '1' },
                { name: 'ie', label: 'Inscrição Estadual', col: '1' },
                { name: 'email', label: 'E-mail', col: '1' },
                { name: 'telefone', label: 'Telefone', col: '1' },
                { name: 'municipio', label: 'Município', col: '1' },
                { name: 'uf', label: 'UF', col: '1' },
              ] as const).map(({ name, label, col }) => (
                <FormField
                  key={name}
                  control={form.control}
                  name={name}
                  render={({ field }) => (
                    <FormItem className={col === '2' ? 'col-span-2' : ''}>
                      <FormLabel className="text-muted text-xs">{label}</FormLabel>
                      <FormControl>
                        <Input
                          {...field}
                          className="text-fg placeholder:text-muted" style={{ background: 'var(--c-input)', borderColor: 'var(--c-border)' }}
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              ))}
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
                {isEditing ? 'Salvar' : 'Criar Cliente'}
              </Button>
            </div>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  )
}
