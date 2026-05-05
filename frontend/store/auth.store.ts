'use client'

import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AuthState {
  userId: string | null
  email: string | null
  username: string | null
  isAuthenticated: boolean
  setUser: (user: { userId: string; email: string; username: string }) => void
  clear: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      userId: null,
      email: null,
      username: null,
      isAuthenticated: false,
      setUser: ({ userId, email, username }) =>
        set({ userId, email, username, isAuthenticated: true }),
      clear: () =>
        set({ userId: null, email: null, username: null, isAuthenticated: false }),
    }),
    {
      name: 'lac-auth',
    }
  )
)
