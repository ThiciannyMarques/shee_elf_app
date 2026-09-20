import React from 'react';
import { colors, typography } from '../tokens';
import { KeyIcon } from '../icons';

interface LocationBadgeProps {
  name: string;
  bookCount: number;
  onClick?: () => void;
}

export default function LocationBadge({ name, bookCount, onClick }: LocationBadgeProps) {
  return (
    <div
      onClick={onClick}
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '10px',
        padding: '12px 14px',
        border: `1px solid ${colors.woodMid}`,
        borderRadius: '4px',
        cursor: onClick ? 'pointer' : 'default',
        backgroundColor: colors.bg1,
        minHeight: '52px',
      }}
    >
      <KeyIcon size={16} color={colors.terracotta} />
      <span style={{
        fontFamily: typography.fontSerif,
        fontSize: '15px',
        color: colors.ink,
        flex: 1,
      }}>{name}</span>
      <span style={{
        fontFamily: typography.fontSans,
        fontSize: '12px',
        color: colors.inkFaint,
      }}>{bookCount} livros</span>
    </div>
  );
}
