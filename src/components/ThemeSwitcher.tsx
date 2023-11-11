'use client'

import { useTheme } from 'next-themes'

import { Button } from '@/components/ui/button'
import LightBulb from '@/components/LightBulb'
import Moon from '@/components/Moon'

const ThemeSwitcher = () => {
  const { theme, setTheme } = useTheme()
  const isDarkMode = theme === 'dark'

  return (
    <Button
      className={`absolute right-5 top-2 w-fit rounded-md bg-slate-200 p-2 duration-200 hover:scale-110 active:scale-100 dark:bg-[#212933]`}
      onClick={() => setTheme(isDarkMode ? 'light' : 'dark')}
    >
      {isDarkMode ? <LightBulb /> : <Moon />}
    </Button>
  )
}

export default ThemeSwitcher
