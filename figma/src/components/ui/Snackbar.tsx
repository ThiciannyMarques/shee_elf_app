import React from 'react';
import { colors, typography, spacing, radius } from '../../tokens';
import { useUI } from '../../context/UIContext';

export default function SnackbarStack() {
  const { snackbars } = useUI();

  return (
    <div style={{
      position: 'fixed', bottom: 80, left: '50%', transform: 'translateX(-50%)',
      zIndex: 2000, display: 'flex', flexDirection: 'column', gap: spacing[2],
      alignItems: 'center', pointerEvents: 'none',
    }}>
      {snackbars.map(s => {
        const bg = s.type === 'success' ? colors.mossDeep
          : s.type === 'error' ? colors.wine
          : colors.bg2;
        return (
          <div key={s.id} style={{
            background: bg,
            border: `1px solid ${colors.lineStrong}`,
            borderRadius: radius.full,
            padding: `${spacing[2]} ${spacing[5]}`,
            fontFamily: typography.fontSans,
            fontSize: typography.size.sm,
            fontWeight: typography.weight.medium,
            color: colors.ink,
            animation: 'slideUp 0.2s ease',
            whiteSpace: 'nowrap',
          }}>
            {s.message}
          </div>
        );
      })}
    </div>
  );
}
