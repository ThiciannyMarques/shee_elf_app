import React from 'react';
import { colors } from '../tokens';

interface SceneSlotProps {
  children: React.ReactNode;
  height?: number | string;
  style?: React.CSSProperties;
}

export default function SceneSlot({ children, height = 280, style }: SceneSlotProps) {
  return (
    <div style={{
      width: '100%',
      height,
      backgroundColor: colors.bg1,
      border: `1px solid ${colors.line}`,
      borderRadius: '8px',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      overflow: 'hidden',
      ...style,
    }}>
      {children}
    </div>
  );
}
