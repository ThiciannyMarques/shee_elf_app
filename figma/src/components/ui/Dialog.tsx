import React from 'react';
import { colors, typography, spacing, radius } from '../../tokens';

interface DialogProps {
  open: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  message: string;
  confirmLabel?: string;
  cancelLabel?: string;
  danger?: boolean;
}

export default function Dialog({
  open, onClose, onConfirm, title, message,
  confirmLabel = 'Confirmar', cancelLabel = 'Cancelar', danger = false,
}: DialogProps) {
  if (!open) return null;
  return (
    <div
      onClick={onClose}
      style={{
        position: 'fixed', inset: 0, zIndex: 1100,
        background: 'rgba(23,21,29,0.88)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        padding: spacing[4], animation: 'fadeIn 0.15s ease',
      }}
    >
      <div
        onClick={e => e.stopPropagation()}
        style={{
          width: '100%', maxWidth: 320,
          background: colors.bg1,
          border: `1px solid ${colors.lineStrong}`,
          borderRadius: radius.lg,
          padding: spacing[5],
          animation: 'slideUp 0.18s ease',
        }}
      >
        <h3 style={{
          fontFamily: typography.fontSerif,
          fontSize: typography.size.md,
          fontWeight: typography.weight.medium,
          color: colors.ink,
          marginBottom: spacing[2],
        }}>{title}</h3>
        <p style={{
          fontFamily: typography.fontSans,
          fontSize: typography.size.sm,
          color: colors.inkSoft,
          lineHeight: 1.5,
          marginBottom: spacing[5],
        }}>{message}</p>
        <div style={{ display: 'flex', gap: spacing[3], justifyContent: 'flex-end' }}>
          <button
            onClick={onClose}
            style={{
              background: 'transparent',
              border: `1px solid ${colors.lineStrong}`,
              borderRadius: radius.md,
              padding: `${spacing[2]} ${spacing[4]}`,
              fontFamily: typography.fontSans,
              fontSize: typography.size.sm,
              color: colors.inkSoft,
              cursor: 'pointer',
              minHeight: 44,
            }}
          >{cancelLabel}</button>
          <button
            onClick={() => { onConfirm(); onClose(); }}
            style={{
              background: danger ? colors.wine : colors.moss,
              border: 'none',
              borderRadius: radius.md,
              padding: `${spacing[2]} ${spacing[4]}`,
              fontFamily: typography.fontSans,
              fontSize: typography.size.sm,
              fontWeight: typography.weight.semibold,
              color: colors.ink,
              cursor: 'pointer',
              minHeight: 44,
            }}
          >{confirmLabel}</button>
        </div>
      </div>
    </div>
  );
}
