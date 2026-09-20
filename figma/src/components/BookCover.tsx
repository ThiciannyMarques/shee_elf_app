import React from 'react';
import { colors, typography } from '../tokens';

interface BookCoverProps {
  title: string;
  author: string;
  color: string;
  year?: number;
}

export default function BookCover({ title, author, color, year }: BookCoverProps) {
  return (
    <div style={{
      width: '100%',
      aspectRatio: '2/3',
      maxHeight: '60vh',
      backgroundColor: color,
      borderRadius: '4px 8px 8px 4px',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'flex-end',
      padding: '24px 20px',
      position: 'relative',
      overflow: 'hidden',
      borderLeft: `6px solid rgba(0,0,0,0.35)`,
      borderRight: `1px solid rgba(255,255,255,0.08)`,
    }}>
      {/* Background texture overlay */}
      <div style={{
        position: 'absolute',
        top: 0, left: 0, right: 0, bottom: 0,
        background: 'linear-gradient(160deg, rgba(255,255,255,0.06) 0%, transparent 50%, rgba(0,0,0,0.3) 100%)',
        pointerEvents: 'none',
      }} />
      {/* Decorative border inset */}
      <div style={{
        position: 'absolute',
        top: 12, left: 16, right: 12, bottom: 12,
        border: '1px solid rgba(255,255,255,0.15)',
        borderRadius: '2px',
        pointerEvents: 'none',
      }} />
      {/* Year */}
      {year && (
        <span style={{
          fontFamily: typography.fontSans,
          fontSize: '11px',
          color: 'rgba(255,255,255,0.55)',
          letterSpacing: '0.12em',
          textTransform: 'uppercase',
          marginBottom: '8px',
          zIndex: 1,
        }}>{year}</span>
      )}
      <h1 style={{
        fontFamily: typography.fontSerif,
        fontSize: '22px',
        fontWeight: 600,
        color: 'rgba(255,255,255,0.92)',
        lineHeight: 1.2,
        marginBottom: '8px',
        zIndex: 1,
      }}>{title}</h1>
      <p style={{
        fontFamily: typography.fontSans,
        fontSize: '13px',
        color: 'rgba(255,255,255,0.65)',
        zIndex: 1,
      }}>{author}</p>
    </div>
  );
}
