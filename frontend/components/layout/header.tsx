'use client'

import { Bell } from 'lucide-react'
import { BusinessSelector } from './business-selector'
import { ThemeToggle } from './theme-toggle'
import type { TEmpresa } from '@/types'

interface HeaderProps {
  businesses: TEmpresa[]
  pageTitle: string
}

export function Header({ businesses, pageTitle }: HeaderProps) {
  return (
    <header className="sticky top-0 z-40 flex items-center justify-between px-6 py-3.5 glass border-b border-[var(--c-border)]">
      <h1 className="text-base font-semibold text-fg">{pageTitle}</h1>
      <div className="flex items-center gap-3">
        <BusinessSelector businesses={businesses} />
        <ThemeToggle />
        <button className="flex h-9 w-9 items-center justify-center rounded-xl bg-[var(--c-overlay)] border border-[var(--c-border)] hover:bg-[var(--c-overlay-md)] transition-all text-muted hover:text-fg">
          <Bell className="h-4 w-4" />
        </button>
      </div>
    </header>
  )
}
