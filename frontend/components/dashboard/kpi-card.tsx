import { type LucideIcon } from 'lucide-react'
import { cn } from '@/lib/utils'

interface KpiCardProps {
  title: string
  value: string | number
  subtitle?: string
  icon: LucideIcon
  variant?: 'primary' | 'secondary' | 'success' | 'warning'
}

const VARIANTS = {
  primary: {
    iconBg: 'bg-primary/15',
    iconColor: 'text-primary',
    leftBorder: 'border-l-primary',
    glow: '[box-shadow:inset_0_0_0_1px_rgba(124,58,237,0.10),_-3px_0_20px_-4px_rgba(124,58,237,0.20)]',
  },
  secondary: {
    iconBg: 'bg-secondary/15',
    iconColor: 'text-secondary',
    leftBorder: 'border-l-secondary',
    glow: '[box-shadow:inset_0_0_0_1px_rgba(6,182,212,0.10),_-3px_0_20px_-4px_rgba(6,182,212,0.20)]',
  },
  success: {
    iconBg: 'bg-success/15',
    iconColor: 'text-success',
    leftBorder: 'border-l-success',
    glow: '[box-shadow:inset_0_0_0_1px_rgba(34,197,94,0.10),_-3px_0_20px_-4px_rgba(34,197,94,0.20)]',
  },
  warning: {
    iconBg: 'bg-warning/15',
    iconColor: 'text-warning',
    leftBorder: 'border-l-warning',
    glow: '[box-shadow:inset_0_0_0_1px_rgba(245,158,11,0.10),_-3px_0_20px_-4px_rgba(245,158,11,0.20)]',
  },
}

export function KpiCard({ title, value, subtitle, icon: Icon, variant = 'primary' }: KpiCardProps) {
  const v = VARIANTS[variant]
  return (
    <div
      className={cn(
        'relative flex items-center gap-4 rounded-xl px-5 py-4',
        'bg-surface border border-[var(--c-border)] border-l-2',
        v.leftBorder,
        v.glow,
        'transition-all duration-200 hover:bg-[var(--c-surface-2)]'
      )}
    >
      <div className={cn('flex h-9 w-9 shrink-0 items-center justify-center rounded-lg', v.iconBg)}>
        <Icon className={cn('h-4 w-4', v.iconColor)} />
      </div>
      <div className="min-w-0 flex-1">
        <p className="text-[11px] font-medium text-subtle uppercase tracking-widest leading-none mb-1">
          {title}
        </p>
        <p className="text-xl font-bold text-fg leading-none">{value}</p>
        {subtitle && (
          <p className="text-[11px] text-muted mt-1 leading-none">{subtitle}</p>
        )}
      </div>
    </div>
  )
}
