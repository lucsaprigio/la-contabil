'use client'

import { Sun, Moon } from 'lucide-react'
import { useThemeStore } from '@/store/theme.store'

export function ThemeToggle() {
  const { theme, toggle } = useThemeStore()

  function handleClick() {
    const next = theme === 'dark' ? 'light' : 'dark'
    document.documentElement.setAttribute('data-theme', next)
    toggle()
  }

  return (
    <button
      onClick={handleClick}
      aria-label={theme === 'dark' ? 'Ativar tema claro' : 'Ativar tema escuro'}
      className="relative flex h-9 w-16 items-center rounded-full border border-[var(--c-border)] bg-[var(--c-overlay-md)] p-1 transition-all hover:border-primary/40"
    >
      {/* Track glow on dark */}
      <span
        className={`absolute inset-0 rounded-full transition-opacity duration-300 ${
          theme === 'dark'
            ? 'opacity-100 shadow-[inset_0_0_10px_rgba(124,58,237,0.15)]'
            : 'opacity-0'
        }`}
      />
      {/* Thumb */}
      <span
        className={`relative z-10 flex h-6 w-6 items-center justify-center rounded-full transition-all duration-300 ease-in-out ${
          theme === 'dark'
            ? 'translate-x-0 bg-gradient-to-br from-primary to-secondary shadow-lg shadow-primary/30'
            : 'translate-x-7 bg-gradient-to-br from-warning to-[#f97316] shadow-lg shadow-warning/30'
        }`}
      >
        {theme === 'dark' ? (
          <Moon className="h-3 w-3 text-white" />
        ) : (
          <Sun className="h-3 w-3 text-white" />
        )}
      </span>
    </button>
  )
}
