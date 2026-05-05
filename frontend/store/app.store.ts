'use client'

import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { TEmpresa } from '@/types'

interface AppState {
  selectedBusinessId: string | null
  selectedBusiness: TEmpresa | null
  setSelectedBusiness: (business: TEmpresa) => void
  clearBusiness: () => void
}

export const useAppStore = create<AppState>()(
  persist(
    (set) => ({
      selectedBusinessId: null,
      selectedBusiness: null,
      setSelectedBusiness: (business) =>
        set({ selectedBusinessId: business.businessId, selectedBusiness: business }),
      clearBusiness: () =>
        set({ selectedBusinessId: null, selectedBusiness: null }),
    }),
    {
      name: 'lac-app',
    }
  )
)
