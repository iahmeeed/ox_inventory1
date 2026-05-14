// Theme Helper - Get CSS Variable Values Dynamically
// This allows components to use theme colors from config

export const getThemeColor = (variable: string, fallback: string = ''): string => {
  if (typeof document === 'undefined') return fallback;
  
  const root = document.documentElement;
  const value = getComputedStyle(root).getPropertyValue(variable).trim();
  
  return value || fallback;
};

// Rarity colors with fallback to hardcoded values
export const getRarityColor = (rarity?: string): string => {
  if (!rarity) return '';
  
  const rarityMap: Record<string, { variable: string; fallback: string }> = {
    common: { variable: '--color-quality-common', fallback: '#9ca3af' },
    uncommon: { variable: '--color-quality-uncommon', fallback: '#10b981' },
    rare: { variable: '--color-quality-rare', fallback: '#3b82f6' },
    epic: { variable: '--color-quality-epic', fallback: '#ff69b4' },
    legendary: { variable: '--color-quality-legendary', fallback: '#ffb12bff' },
    unique: { variable: '--color-quality-unique', fallback: '#ef4444' },
  };
  
  const config = rarityMap[rarity.toLowerCase()];
  if (!config) return '';
  
  return getThemeColor(config.variable, config.fallback);
};

// Get rarity Tailwind class with theme support
export const getRarityClass = (rarity?: string): string => {
  if (!rarity) return '';
  
  // Check if theme is enabled
  const themeEnabled = getThemeColor('--primary') !== '';
  
  if (!themeEnabled) {
    // Use hardcoded colors if theme is disabled
    const hardcodedColors: Record<string, string> = {
      uncommon: '#23db0bcc',
      rare: '#0796c2cc',
      epic: '#ff69b4cc',
      legendary: '#ffc011ff',
      unique: '#e1e432cc',
    };
    
    const color = hardcodedColors[rarity.toLowerCase()];
    return color ? `text-[${color}]` : '';
  }
  
  // Use theme CSS variables
  const rarityVarMap: Record<string, string> = {
    common: 'text-[var(--color-quality-common)]',
    uncommon: 'text-[var(--color-quality-uncommon)]',
    rare: 'text-[var(--color-quality-rare)]',
    epic: 'text-[var(--color-quality-epic)]',
    legendary: 'text-[var(--color-quality-legendary)]',
    unique: 'text-[var(--color-quality-unique)]',
  };
  
  return rarityVarMap[rarity.toLowerCase()] || '';
};

// Currency color helper
export const getCurrencyColor = (currency?: string): string => {
  const themeEnabled = getThemeColor('--primary') !== '';
  
  if (!themeEnabled) {
    return currency === 'money' || !currency ? '#2ECC71' : '#E74C3C';
  }
  
  // Use theme colors for currency
  return currency === 'money' || !currency 
    ? getThemeColor('--color-primary', '#2ECC71')
    : getThemeColor('--destructive', '#E74C3C');
};

// Background color helper with theme support
export const getBackgroundClass = (active: boolean = false): string => {
  const themeEnabled = getThemeColor('--primary') !== '';
  
  if (!themeEnabled) {
    return active ? 'bg-primary/20 border-primary/40' : 'bg-[#2b2b2b81] border-white/20';
  }
  
  return active ? 'bg-primary/20 border-primary/40' : 'bg-secondary/50 border-border';
};
