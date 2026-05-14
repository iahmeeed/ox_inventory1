// Theme Configuration Type Definition
export interface UITheme {
  enabled: boolean;
  primaryColor: string;
  primaryHover: string;
  primaryLight: string;
  primaryDark: string;
  backgroundColor: string;
  backgroundSecondary: string;
  backgroundTertiary: string;
  textPrimary: string;
  textSecondary: string;
  textMuted: string;
  borderColor: string;
  borderRadius: string;
  slotBackground: string;
  slotBorder: string;
  slotHover: string;
  slotActive: string;

  qualityColors: {
    common: string;
    uncommon: string;
    rare: string;
    epic: string;
    legendary: string;
    unique: string;
  };

  fontFamily: string;
  fontSize: {
    small: string;
    normal: string;
    medium: string;
    large: string;
  };
  enableAnimations: boolean;
  animationSpeed: string;
  inventoryOpacity: number;
  enableBlur: boolean;
  blurAmount: string;
  notificationPosition: string;
  notificationDuration: number;
}

export const defaultTheme: UITheme = {
  enabled: false,
  primaryColor: '#3b82f6',
  primaryHover: '#2563eb',
  primaryLight: '#60a5fa',
  primaryDark: '#1e40af',
  backgroundColor: '#1f2937',
  backgroundSecondary: '#374151',
  backgroundTertiary: '#4b5563',
  textPrimary: '#f9fafb',
  textSecondary: '#d1d5db',
  textMuted: '#9ca3af',
  borderColor: '#4b5563',
  borderRadius: '0.5rem',
  slotBackground: '#374151',
  slotBorder: '#4b5563',
  slotHover: '#4b5563',
  slotActive: '#3b82f6',
qualityColors: {
    common: '#9ca3af',
    uncommon: '#10b981',
    rare: '#3b82f6',
    epic: '#ff69b4', // Changed from #8b5cf6 to pink
    legendary: '#ffb129ff',
    unique: '#ef4444',
  },
  fontFamily: 'Inter, system-ui, -apple-system, sans-serif',
  fontSize: {
    small: '0.75rem',
    normal: '0.875rem',
    medium: '1rem',
    large: '1.125rem',
  },
  enableAnimations: true,
  animationSpeed: '200ms',
  inventoryOpacity: 0.95,
  enableBlur: false,
  blurAmount: '8px',
  notificationPosition: 'top-right',
  notificationDuration: 3000,
};

// Apply theme to CSS variables
export function applyTheme(theme: UITheme) {
  // console.log('[DEBUG THEME REACT] applyTheme called');
  // console.log('[DEBUG THEME REACT] theme:', theme);
  // console.log('[DEBUG THEME REACT] theme.enabled:', theme.enabled);
  
  if (!theme.enabled) {
    // console.log('[DEBUG THEME REACT] Theme is disabled, skipping apply');
    return;
  }

 //  console.log('[DEBUG THEME REACT] Applying theme to CSS variables...');
  // console.log('[DEBUG THEME REACT] primaryColor:', theme.primaryColor);
 //  console.log('[DEBUG THEME REACT] backgroundColor:', theme.backgroundColor);
  
  const root = document.documentElement;
  
  // Log current values BEFORE setting
 //  console.log('[DEBUG THEME REACT] BEFORE - Current --background:', getComputedStyle(root).getPropertyValue('--background'));

  // Apply color variables (custom naming)
  root.style.setProperty('--color-primary', theme.primaryColor);
  root.style.setProperty('--color-primary-hover', theme.primaryHover);
  root.style.setProperty('--color-primary-light', theme.primaryLight);
  root.style.setProperty('--color-primary-dark', theme.primaryDark);
  root.style.setProperty('--color-bg', theme.backgroundColor);
  root.style.setProperty('--color-bg-secondary', theme.backgroundSecondary);
  root.style.setProperty('--color-bg-tertiary', theme.backgroundTertiary);
  root.style.setProperty('--color-text-primary', theme.textPrimary);
  root.style.setProperty('--color-text-secondary', theme.textSecondary);
  root.style.setProperty('--color-text-muted', theme.textMuted);
  root.style.setProperty('--color-border', theme.borderColor);
  root.style.setProperty('--border-radius', theme.borderRadius);
  
  // Apply Tailwind CSS variables (used by components)
  root.style.setProperty('--primary', theme.primaryColor);
  root.style.setProperty('--primaryForeground', theme.textPrimary);
  root.style.setProperty('--background', theme.backgroundColor);
  root.style.setProperty('--foreground', theme.textPrimary);
  root.style.setProperty('--secondary', theme.backgroundSecondary);
  root.style.setProperty('--secondaryForeground', theme.textSecondary);
  root.style.setProperty('--muted', theme.backgroundTertiary);
  root.style.setProperty('--mutedForeground', theme.textMuted);
  root.style.setProperty('--border', theme.borderColor);
  root.style.setProperty('--input', theme.borderColor);
  root.style.setProperty('--ring', theme.primaryColor);
  root.style.setProperty('--radius', theme.borderRadius);
  
  // Apply custom inventory CSS variables (used in index.scss via $variables)
  root.style.setProperty('--mainColor', theme.backgroundColor);
  root.style.setProperty('--textColor', theme.textPrimary);
  root.style.setProperty('--secondaryColor', theme.backgroundSecondary);
  root.style.setProperty('--secondaryColorHighlight', theme.backgroundTertiary);
  
  //console.log('[DEBUG THEME REACT] Tailwind variables set');
  
  // Log values AFTER setting to verify they were applied
  //console.log('[DEBUG THEME REACT] AFTER - --background:', getComputedStyle(root).getPropertyValue('--background'));
  //console.log('[DEBUG THEME REACT] AFTER - --primary:', getComputedStyle(root).getPropertyValue('--primary'));
  
  // Force a repaint
  root.style.display = 'none';
  void root.offsetHeight; // Trigger reflow
  root.style.display = '';

  // Apply slot colors
  root.style.setProperty('--color-slot-bg', theme.slotBackground);
  root.style.setProperty('--color-slot-border', theme.slotBorder);
  root.style.setProperty('--color-slot-hover', theme.slotHover);
  root.style.setProperty('--color-slot-active', theme.slotActive);

  // Apply quality colors
  root.style.setProperty('--color-quality-common', theme.qualityColors.common);
  root.style.setProperty('--color-quality-uncommon', theme.qualityColors.uncommon);
  root.style.setProperty('--color-quality-rare', theme.qualityColors.rare);
  root.style.setProperty('--color-quality-epic', theme.qualityColors.epic);
  root.style.setProperty('--color-quality-legendary', theme.qualityColors.legendary);
  root.style.setProperty('--color-quality-unique', theme.qualityColors.unique);

  // Apply typography
  root.style.setProperty('--font-family', theme.fontFamily);
  root.style.setProperty('--font-size-small', theme.fontSize.small);
  root.style.setProperty('--font-size-normal', theme.fontSize.normal);
  root.style.setProperty('--font-size-medium', theme.fontSize.medium);
  root.style.setProperty('--font-size-large', theme.fontSize.large);

  // Apply animations
  root.style.setProperty('--animation-speed', theme.animationSpeed);
  if (!theme.enableAnimations) {
    root.style.setProperty('--animation-speed', '0ms');
  }

  // Apply inventory settings
  root.style.setProperty('--inventory-opacity', theme.inventoryOpacity.toString());
  root.style.setProperty('--blur-amount', theme.enableBlur ? theme.blurAmount : '0px');

  //console.log('[ox_inventory] Custom theme applied successfully');
}

// Generate CSS string for theme (for dynamic injection)
export function generateThemeCSS(theme: UITheme): string {
  if (!theme.enabled) return '';

  return `
    :root {
      --color-primary: ${theme.primaryColor};
      --color-primary-hover: ${theme.primaryHover};
      --color-primary-light: ${theme.primaryLight};
      --color-primary-dark: ${theme.primaryDark};
      --color-bg: ${theme.backgroundColor};
      --color-bg-secondary: ${theme.backgroundSecondary};
      --color-bg-tertiary: ${theme.backgroundTertiary};
      --color-text-primary: ${theme.textPrimary};
      --color-text-secondary: ${theme.textSecondary};
      --color-text-muted: ${theme.textMuted};
      --color-border: ${theme.borderColor};
      --border-radius: ${theme.borderRadius};
      --color-slot-bg: ${theme.slotBackground};
      --color-slot-border: ${theme.slotBorder};
      --color-slot-hover: ${theme.slotHover};
      --color-slot-active: ${theme.slotActive};
      --color-quality-common: ${theme.qualityColors.common};
      --color-quality-uncommon: ${theme.qualityColors.uncommon};
      --color-quality-rare: ${theme.qualityColors.rare};
      --color-quality-epic: ${theme.qualityColors.epic};
      --color-quality-legendary: ${theme.qualityColors.legendary};
      --color-quality-unique: ${theme.qualityColors.unique};
      --font-family: ${theme.fontFamily};
      --font-size-small: ${theme.fontSize.small};
      --font-size-normal: ${theme.fontSize.normal};
      --font-size-medium: ${theme.fontSize.medium};
      --font-size-large: ${theme.fontSize.large};
      --animation-speed: ${theme.enableAnimations ? theme.animationSpeed : '0ms'};
      --inventory-opacity: ${theme.inventoryOpacity};
      --blur-amount: ${theme.enableBlur ? theme.blurAmount : '0px'};
    }
  `;
}
