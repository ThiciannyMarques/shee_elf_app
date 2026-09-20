import React from 'react';
import { useNavigate } from 'react-router-dom';
import { colors, typography, spacing } from '../tokens';

interface AppHeaderProps {
  title: string;
  subtitle?: string;
  showBack?: boolean;
  rightAction?: React.ReactNode;
  onBack?: () => void;
}

function ArrowLeftIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M19 12H5M12 5l-7 7 7 7"/>
    </svg>
  );
}

export default function AppHeader({ title, subtitle, showBack = false, rightAction, onBack }: AppHeaderProps) {
  const navigate = useNavigate();

  const handleBack = () => {
    if (onBack) onBack();
    else navigate(-1);
  };

  return (
    <header style={{
      display: 'flex', alignItems: 'center',
      padding: `${spacing[4]} ${spacing[5]}`,
      paddingTop: `calc(${spacing[4]} + env(safe-area-inset-top, 0px))`,
      background: colors.bg0,
      borderBottom: `1px solid ${colors.line}`,
      position: 'sticky', top: 0, zIndex: 10,
      gap: spacing[3],
      minHeight: 60,
    }}>
      {showBack && (
        <button
          onClick={handleBack}
          style={{
            background: 'transparent', border: 'none',
            color: colors.inkSoft, cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            width: 44, height: 44, flexShrink: 0, marginLeft: -8,
          }}
        >
          <ArrowLeftIcon />
        </button>
      )}
      <div style={{ flex: 1, minWidth: 0 }}>
        <h1 style={{
          fontFamily: typography.fontSerif,
          fontSize: typography.size.lg,
          fontWeight: typography.weight.medium,
          color: colors.ink,
          lineHeight: 1.2,
          overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
        }}>{title}</h1>
        {subtitle && (
          <p style={{
            fontFamily: typography.fontSans,
            fontSize: typography.size.xs,
            color: colors.inkFaint,
            marginTop: 2,
          }}>{subtitle}</p>
        )}
      </div>
      {rightAction && (
        <div style={{ flexShrink: 0 }}>{rightAction}</div>
      )}
    </header>
  );
}
