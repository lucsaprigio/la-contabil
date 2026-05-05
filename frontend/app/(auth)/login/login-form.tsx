'use client'

import { useState } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Loader2, Eye, EyeOff } from 'lucide-react'
import { toast } from 'sonner'
import { useAuthStore } from '@/store/auth.store'
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'

const schema = z.object({
  email: z.string().email('E-mail inválido'),
  password: z.string().min(1, 'Senha é obrigatória'),
})

type FormValues = z.infer<typeof schema>

export function LoginForm() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const { setUser } = useAuthStore()
  const [showPass, setShowPass] = useState(false)

  const form = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { email: '', password: '' },
  })

  async function onSubmit(values: FormValues) {
    const res = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(values),
    })

    if (!res.ok) {
      const err = await res.json().catch(() => ({ erro: 'Erro ao fazer login' }))
      toast.error(err.erro ?? 'Credenciais inválidas')
      return
    }

    const data = await res.json()
    setUser({ userId: data.userId, email: data.email, username: data.username })

    const redirectTo = searchParams.get('from') ?? '/'
    router.replace(redirectTo)
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="text-muted text-xs">E-mail</FormLabel>
              <FormControl>
                <Input
                  {...field}
                  type="email"
                  placeholder="seu@email.com"
                  autoComplete="email"
                  className="text-fg placeholder:text-subtle rounded-xl h-11 focus:border-primary/50" style={{ background: 'var(--c-input)', borderColor: 'var(--c-border)' }}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="password"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="text-muted text-xs">Senha</FormLabel>
              <FormControl>
                <div className="relative">
                  <Input
                    {...field}
                    type={showPass ? 'text' : 'password'}
                    placeholder="••••••••"
                    autoComplete="current-password"
                    className="text-fg placeholder:text-subtle rounded-xl h-11 pr-10 focus:border-primary/50" style={{ background: 'var(--c-input)', borderColor: 'var(--c-border)' }}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPass(!showPass)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-muted hover:text-fg transition-colors"
                  >
                    {showPass ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                  </button>
                </div>
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button
          type="submit"
          disabled={form.formState.isSubmitting}
          className="w-full h-11 bg-gradient-to-r from-[#7c3aed] to-[#06b6d4] hover:opacity-90 text-white border-0 rounded-xl font-medium text-sm shadow-lg shadow-[#7c3aed]/20 transition-all mt-2"
        >
          {form.formState.isSubmitting ? (
            <Loader2 className="h-4 w-4 animate-spin" />
          ) : (
            'Entrar'
          )}
        </Button>
      </form>
    </Form>
  )
}
