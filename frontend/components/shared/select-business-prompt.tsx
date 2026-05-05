import { Building2 } from 'lucide-react'

export function SelectBusinessPrompt() {
  return (
    <div className="flex flex-col items-center justify-center py-24 text-center">
      <div className="flex h-20 w-20 items-center justify-center rounded-3xl glass mb-6">
        <Building2 className="h-10 w-10 text-primary" />
      </div>
      <p className="text-lg font-semibold text-fg">Selecione uma empresa</p>
      <p className="text-sm text-muted mt-2 max-w-sm">
        Use o seletor de empresa no topo da página para visualizar os dados desta seção.
      </p>
    </div>
  )
}
