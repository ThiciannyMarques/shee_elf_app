import React, { useEffect } from 'react';
import { colors, typography, spacing, radius } from '../../tokens';

interface ModalProps {
  open: boolean;
  onClose: () => void;
  title?: string;
  children: React.ReactNode;
  maxWidth?: number;
}

export default function Modal({ open, onClose, title, children, maxWidth = 360 }: ModalProps) {
  useEffect(() => {
    if (!open) return;
    const handler = (e: KeyboardEvent) => { if (e.key === 'Escape') onClose(); };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div
      onClick={onClose}
      style={{
        position: 'fixed', inset: 0, zIndex: 1000,
        background: 'rgba(23,21,29,0.85)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        padding: spacing[4],
        animation: 'fadeIn 0.15s ease',
      }}
    >
      <div
        onClick={e => e.stopPropagation()}
        style={{
          width: '100%', maxWidth,
          background: colors.bg1,
          border: `1px solid ${colors.lineStrong}`,
          borderRadius: radius.lg,
          overflow: 'hidden',
          animation: 'slideUp 0.18s ease',
        }}
      >
        {title && (
          <div style={{
            padding: `${spacing[5]} ${spacing[5]} ${spacing[3]}`,
            borderBottom: `1px solid ${colors.line}`,
          }}>
            <h2 style={{
              fontFamily: typography.fontSerif,
              fontSize: typography.size.lg,
              fontWeight: typography.weight.medium,
              color: colors.ink,
            }}>{title}</h2>
          </div>
        )}
        <div style={{ padding: spacing[5] }}>
          {children}
        </div>
      </div>
    </div>
  );
}
