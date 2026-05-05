import type { Metadata } from 'next'
import { Geist, Geist_Mono } from 'next/font/google'
import './globals.css'
import { Providers } from '@/components/layout/providers'

const geistSans = Geist({ variable: '--font-geist-sans', subsets: ['latin'] })
const geistMono = Geist_Mono({ variable: '--font-geist-mono', subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'LA Contábil — Sistema Fiscal',
  description: 'Gestão de Documentos Fiscais Eletrônicos',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html
      lang="pt-BR"
      data-theme="dark"
      className={`${geistSans.variable} ${geistMono.variable} h-full`}
    >
      <body className="h-full bg-bg text-fg antialiased">
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}
