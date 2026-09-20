import React, { useMemo } from 'react';
import { colors, typography } from '../tokens';

interface BookSpineProps {
  title: string;
  color: string;
  thickness?: number;
  height?: number;
  onClick?: () => void;
  seed?: number;
}

export default function BookSpine({ title, color, thickness = 32, height = 190, onClick, seed = 0 }: BookSpineProps) {
  const rotation = useMemo(() => {
    const val = ((seed * 7919) % 5) - 2;
    return val;
  }, [seed]);

  return (
    <div
      onClick={onClick}
      style={{
        width: thickness,
        height,
        backgroundColor: color,
        borderRadius: '2px 0 0 2px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        cursor: onClick ? 'pointer' : 'default',
        transform: `rotate(${rotation}deg)`,
        transformOrigin: 'bottom center',
        flexShrink: 0,
        position: 'relative',
        borderLeft: `1px solid rgba(255,255,255,0.12)`,
        borderTop: `1px solid rgba(255,255,255,0.10)`,
        borderRight: `2px solid rgba(0,0,0,0.30)`,
        boxSizing: 'border-box',
        marginBottom: '2px',
      }}
    >
      {/* Spine shadow overlay */}
      <div style={{
        position: 'absolute',
        top: 0, left: 0, right: 0, bottom: 0,
        background: 'linear-gradient(90deg, rgba(0,0,0,0.18) 0%, transparent 30%, transparent 70%, rgba(0,0,0,0.25) 100%)',
        pointerEvents: 'none',
        borderRadius: '2px 0 0 2px',
      }} />
      {/* Title text rotated */}
      <span style={{
        writingMode: 'vertical-rl',
        textOrientation: 'mixed',
        transform: 'rotate(180deg)',
        fontFamily: typography.fontSerif,
        fontSize: thickness > 30 ? '11px' : '9px',
        fontWeight: 500,
        color: 'rgba(255,255,255,0.85)',
        letterSpacing: '0.04em',
        overflow: 'hidden',
        maxHeight: height - 16,
        textOverflow: 'ellipsis',
        whiteSpace: 'nowrap',
        padding: '8px 0',
        zIndex: 1,
        userSelect: 'none',
      }}>
        {title}
      </span>
    </div>
  );
}
