import { FileX } from 'lucide-react'

interface EmptyStateProps {
  title?: string
  description?: string
  action?: React.ReactNode
}

export function EmptyState({
  title = 'Nenhum resultado encontrado',
  description = 'Não há dados para exibir.',
  action,
}: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center py-16 text-center">
      <div className="flex h-16 w-16 items-center justify-center rounded-2xl glass mb-4">
        <FileX className="h-8 w-8 text-muted" />
      </div>
      <p className="text-base font-medium text-fg">{title}</p>
      <p className="text-sm text-muted mt-1 max-w-sm">{description}</p>
      {action && <div className="mt-4">{action}</div>}
    </div>
  )
}
