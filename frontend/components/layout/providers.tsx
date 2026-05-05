'use client'

import { useEffect } from 'react'
import { Toaster } from '@/components/ui/sonner'
import { useThemeStore } from '@/store/theme.store'

function ThemeApplier() {
  const theme = useThemeStore((s) => s.theme)

  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme)
  }, [theme])

  return null
}

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <>
      <ThemeApplier />
      {children}
      <Toaster
        position="top-right"
        toastOptions={{
          style: {
            background: 'var(--c-surface)',
            color: 'var(--c-fg)',
            border: '1px solid var(--c-border)',
          },
        }}
      />
    </>
  )
}
