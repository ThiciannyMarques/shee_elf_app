import React, { useEffect } from 'react';
import { colors, typography, spacing } from '../../tokens';

interface DrawerProps {
  open: boolean;
  onClose: () => void;
  title?: string;
  children: React.ReactNode;
  side?: 'left' | 'right';
  width?: number;
}

export default function Drawer({ open, onClose, title, children, side = 'left', width = 300 }: DrawerProps) {
  useEffect(() => {
    if (!open) return;
    const handler = (e: KeyboardEvent) => { if (e.key === 'Escape') onClose(); };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [open, onClose]);

  return (
    <>
      {/* Overlay */}
      <div
        onClick={onClose}
        style={{
          position: 'fixed', inset: 0, zIndex: 900,
          background: 'rgba(23,21,29,0.75)',
          opacity: open ? 1 : 0,
          pointerEvents: open ? 'auto' : 'none',
          transition: 'opacity 0.25s ease',
        }}
      />
      {/* Panel */}
      <div
        style={{
          position: 'fixed', top: 0, bottom: 0,
          [side]: 0,
          width,
          zIndex: 950,
          background: colors.bg1,
          borderRight: side === 'left' ? `1px solid ${colors.lineStrong}` : undefined,
          borderLeft: side === 'right' ? `1px solid ${colors.lineStrong}` : undefined,
          transform: open
            ? 'translateX(0)'
            : side === 'left' ? `translateX(-${width}px)` : `translateX(${width}px)`,
          transition: 'transform 0.25s ease',
          display: 'flex', flexDirection: 'column',
          overflowY: 'auto',
        }}
      >
        {title && (
          <div style={{
            padding: `${spacing[6]} ${spacing[5]} ${spacing[4]}`,
            borderBottom: `1px solid ${colors.line}`,
            flexShrink: 0,
          }}>
            <h2 style={{
              fontFamily: typography.fontSerif,
              fontSize: typography.size.xl,
              fontWeight: typography.weight.medium,
              color: colors.ink,
            }}>{title}</h2>
          </div>
        )}
        <div style={{ flex: 1, overflowY: 'auto' }}>
          {children}
        </div>
      </div>
    </>
  );
}
