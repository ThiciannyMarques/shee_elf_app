import React from 'react';
import { colors, typography } from '../tokens';

interface PrimaryButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  fullWidth?: boolean;
  style?: React.CSSProperties;
  disabled?: boolean;
}

export default function PrimaryButton({ children, onClick, fullWidth, style, disabled }: PrimaryButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: '8px',
        minHeight: '48px',
        padding: '0 24px',
        width: fullWidth ? '100%' : undefined,
        backgroundColor: disabled ? colors.mossDeep : colors.moss,
        color: disabled ? colors.inkFaint : '#fff',
        border: 'none',
        borderRadius: '4px',
        fontFamily: typography.fontSans,
        fontSize: '15px',
        fontWeight: 600,
        cursor: disabled ? 'not-allowed' : 'pointer',
        letterSpacing: '0.02em',
        opacity: disabled ? 0.6 : 1,
        ...style,
      }}
    >
      {children}
    </button>
  );
}
