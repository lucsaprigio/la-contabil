import { cn } from '@/lib/utils'

interface GlassCardProps extends React.HTMLAttributes<HTMLDivElement> {
  children: React.ReactNode
  hover?: boolean
}

export function GlassCard({ children, className, hover = false, ...props }: GlassCardProps) {
  return (
    <div
      className={cn(
        'glass rounded-2xl',
        hover && 'transition-all duration-200 hover:bg-white/8 hover:border-white/15',
        className
      )}
      {...props}
    >
      {children}
    </div>
  )
}
