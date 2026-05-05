'use client'

import { Building2, ChevronDown, Check } from 'lucide-react'
import { useAppStore } from '@/store/app.store'
import { useRouter, usePathname } from 'next/navigation'
import type { TEmpresa } from '@/types'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'

interface BusinessSelectorProps {
  businesses: TEmpresa[]
}

export function BusinessSelector({ businesses }: BusinessSelectorProps) {
  const { selectedBusiness, setSelectedBusiness } = useAppStore()
  const router = useRouter()
  const pathname = usePathname()

  const display = selectedBusiness?.fantasyName ?? selectedBusiness?.corporateName ?? 'Selecionar empresa'

  function handleSelect(b: TEmpresa) {
    setSelectedBusiness(b)
    const url = new URL(pathname, window.location.origin)
    url.searchParams.set('businessId', b.businessId)
    router.push(url.toString())
  }

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <button className="flex items-center gap-2 bg-[var(--c-overlay)] border border-[var(--c-border)] rounded-xl px-3 py-2 text-sm text-muted hover:text-fg hover:bg-[var(--c-overlay-md)] transition-all max-w-[200px]">
          <Building2 className="h-4 w-4 shrink-0 text-primary" />
          <span className="truncate">{display}</span>
          <ChevronDown className="h-3 w-3 shrink-0" />
        </button>
      </DropdownMenuTrigger>
      <DropdownMenuContent
        align="end"
        className="w-64 border-[var(--c-border)]"
        style={{ background: 'var(--c-surface)', color: 'var(--c-fg)' }}
      >
        <DropdownMenuLabel className="text-muted text-xs">Empresas disponíveis</DropdownMenuLabel>
        <DropdownMenuSeparator style={{ background: 'var(--c-border)' }} />
        {businesses.length === 0 && (
          <DropdownMenuItem disabled className="text-muted">
            Nenhuma empresa vinculada
          </DropdownMenuItem>
        )}
        {businesses.map((b) => (
          <DropdownMenuItem
            key={b.businessId}
            onClick={() => handleSelect(b)}
            className="hover:bg-[var(--c-overlay-md)] cursor-pointer focus:bg-[var(--c-overlay-md)]"
          >
            <div className="flex items-center gap-2 flex-1 min-w-0">
              <div className="flex h-6 w-6 shrink-0 items-center justify-center rounded-md bg-primary/20 text-primary text-[10px] font-bold">
                {(b.fantasyName ?? b.corporateName).charAt(0)}
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm truncate text-fg">{b.fantasyName ?? b.corporateName}</p>
                <p className="text-[10px] text-muted">{b.cnpj}</p>
              </div>
            </div>
            {selectedBusiness?.businessId === b.businessId && (
              <Check className="h-4 w-4 text-secondary ml-2" />
            )}
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
