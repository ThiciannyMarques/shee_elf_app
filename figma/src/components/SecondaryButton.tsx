import React from 'react';
import { colors, typography } from '../tokens';

interface SecondaryButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  fullWidth?: boolean;
  variant?: 'outline' | 'terracotta';
  style?: React.CSSProperties;
}

export default function SecondaryButton({ children, onClick, fullWidth, variant = 'outline', style }: SecondaryButtonProps) {
  const isTC = variant === 'terracotta';
  return (
    <button
      onClick={onClick}
      style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: '8px',
        minHeight: '48px',
        padding: '0 24px',
        width: fullWidth ? '100%' : undefined,
        backgroundColor: isTC ? colors.terracottaDeep : 'transparent',
        color: isTC ? '#fff' : colors.terracotta,
        border: isTC ? 'none' : `1px solid ${colors.terracotta}`,
        borderRadius: '4px',
        fontFamily: typography.fontSans,
        fontSize: '15px',
        fontWeight: 500,
        cursor: 'pointer',
        letterSpacing: '0.02em',
        ...style,
      }}
    >
      {children}
    </button>
  );
}
