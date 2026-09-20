/* All theme-sensitive colors point to CSS custom properties.
   This means toggling data-theme on <html> instantly re-themes the entire app
   without any JS color lookups. */
export const colors = {
  bg0:           'var(--bg0)',
  bg1:           'var(--bg1)',
  bg2:           'var(--bg2)',
  bg3:           'var(--bg3)',
  wood:          'var(--wood)',
  woodMid:       'var(--wood-mid)',
  ink:           'var(--ink)',
  inkSoft:       'var(--ink-soft)',
  inkFaint:      'var(--ink-faint)',
  line:          'var(--line)',
  lineStrong:    'var(--line-strong)',
  moss:          'var(--moss)',
  mossDeep:      'var(--moss-deep)',
  terracotta:    'var(--terracotta)',
  terracottaDeep:'var(--terracotta-deep)',
  wine:          'var(--wine)',
  plum:          'var(--plum)',
  deepBlue:      'var(--deep-blue)',
  butter:        'var(--butter)',
  rose:          'var(--rose)',
  skyNight:      'var(--sky-night)',
  overlay:       'var(--overlay)',
} as const;

export const typography = {
  fontSerif: "'Fraunces', Georgia, serif",
  fontSans:  "'Manrope', system-ui, sans-serif",
  size: {
    xs:   '11px',
    sm:   '13px',
    base: '15px',
    md:   '17px',
    lg:   '20px',
    xl:   '24px',
    '2xl':'32px',
    '3xl':'44px',
  },
  weight: {
    light:    300,
    regular:  400,
    medium:   500,
    semibold: 600,
    bold:     700,
  },
} as const;

export const spacing = {
  1:  '4px',
  2:  '8px',
  3:  '12px',
  4:  '16px',
  5:  '20px',
  6:  '24px',
  8:  '32px',
  10: '40px',
  12: '48px',
  16: '64px',
} as const;

export const radius = {
  sm:   '6px',
  md:   '10px',
  lg:   '14px',
  xl:   '20px',
  '2xl':'28px',
  full: '9999px',
} as const;

/* Book spine colors — actual hex values (used in SVGs and as data) */
export const bookSpineColors = [
  '#B4696C', // wine
  '#9576A0', // plum
  '#7C93B5', // deep blue
  '#7FA277', // moss
  '#D08653', // terracotta
  '#C99A8E', // rose
  '#6B4C30', // wood-mid
  '#8A6FA0', // muted purple
  '#6B8C7A', // muted teal
  '#A07855', // warm brown
] as const;
