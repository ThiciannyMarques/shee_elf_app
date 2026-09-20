import React from 'react';
import { colors, typography, spacing, radius } from '../../tokens';

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
}

export default function Input({ label, error, style, ...props }: InputProps) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[1] }}>
      {label && (
        <label style={{
          fontFamily: typography.fontSans,
          fontSize: typography.size.xs,
          fontWeight: typography.weight.medium,
          color: colors.inkFaint,
          letterSpacing: '0.08em',
          textTransform: 'uppercase',
        }}>{label}</label>
      )}
      <input
        {...props}
        style={{
          background: colors.bg2,
          border: `1px solid ${error ? colors.wine : colors.lineStrong}`,
          borderRadius: radius.md,
          padding: `${spacing[3]} ${spacing[4]}`,
          fontFamily: typography.fontSans,
          fontSize: typography.size.base,
          color: colors.ink,
          outline: 'none',
          minHeight: 48,
          width: '100%',
          boxSizing: 'border-box',
          ...style,
        }}
        onFocus={e => {
          e.currentTarget.style.borderColor = colors.terracotta;
        }}
        onBlur={e => {
          e.currentTarget.style.borderColor = error ? colors.wine : colors.lineStrong;
        }}
      />
      {error && (
        <span style={{
          fontFamily: typography.fontSans,
          fontSize: typography.size.xs,
          color: colors.wine,
        }}>{error}</span>
      )}
    </div>
  );
}
