import React from 'react';
import { colors, typography } from '../tokens';

interface Screen {
  id: string;
  label: string;
}

interface NavSidebarProps {
  screens: Screen[];
  current: string;
  onSelect: (id: string) => void;
}

const sections = [
  { label: 'Início', ids: ['splash', 'auth', 'onboarding', 'loading'] },
  { label: 'Biblioteca', ids: ['home', 'collection', 'locations', 'shelf', 'book-detail'] },
  { label: 'Acervo', ids: ['scanner', 'lookup', 'success', 'empty', 'error'] },
  { label: 'Social', ids: ['share'] },
];

export default function NavSidebar({ screens, current, onSelect }: NavSidebarProps) {
  const screenMap = Object.fromEntries(screens.map(s => [s.id, s]));

  return (
    <nav style={{
      width: '220px',
      flexShrink: 0,
      height: '100vh',
      backgroundColor: colors.wood,
      borderRight: `1px solid ${colors.woodMid}`,
      overflowY: 'auto',
      display: 'flex',
      flexDirection: 'column',
      padding: '0 0 24px',
    }}>
      {/* App name */}
      <div style={{
        padding: '20px 16px 16px',
        borderBottom: `1px solid rgba(237,230,214,0.12)`,
        marginBottom: '8px',
      }}>
        <div style={{
          fontFamily: typography.fontSerif,
          fontSize: '20px',
          fontWeight: 600,
          color: colors.butter,
          letterSpacing: '0.02em',
        }}>She Elf</div>
        <div style={{
          fontFamily: typography.fontSans,
          fontSize: '11px',
          color: colors.inkFaint,
          marginTop: '2px',
          letterSpacing: '0.06em',
          textTransform: 'uppercase',
        }}>Protótipo</div>
      </div>

      {sections.map(section => {
        const sectionScreens = section.ids.map(id => screenMap[id]).filter(Boolean);
        if (sectionScreens.length === 0) return null;
        return (
          <div key={section.label} style={{ marginBottom: '4px' }}>
            <div style={{
              padding: '10px 16px 6px',
              fontFamily: typography.fontSerif,
              fontSize: '11px',
              fontWeight: 400,
              color: colors.inkFaint,
              letterSpacing: '0.1em',
              textTransform: 'uppercase',
            }}>{section.label}</div>
            {sectionScreens.map(screen => {
              const isActive = screen.id === current;
              return (
                <button
                  key={screen.id}
                  onClick={() => onSelect(screen.id)}
                  style={{
                    display: 'block',
                    width: '100%',
                    textAlign: 'left',
                    padding: '9px 16px 9px 20px',
                    fontFamily: typography.fontSans,
                    fontSize: '13px',
                    fontWeight: isActive ? 600 : 400,
                    color: isActive ? colors.ink : colors.inkSoft,
                    backgroundColor: isActive ? 'rgba(237,230,214,0.08)' : 'transparent',
                    border: 'none',
                    borderLeft: isActive ? `3px solid ${colors.terracotta}` : '3px solid transparent',
                    cursor: 'pointer',
                    letterSpacing: '0.01em',
                    lineHeight: 1.4,
                    paddingLeft: isActive ? '17px' : '20px',
                  }}
                >
                  {screen.label}
                </button>
              );
            })}
          </div>
        );
      })}

      {/* Decorative bottom rule */}
      <div style={{
        marginTop: 'auto',
        padding: '16px',
        borderTop: `1px solid rgba(237,230,214,0.10)`,
      }}>
        <div style={{
          fontFamily: typography.fontSans,
          fontSize: '11px',
          color: colors.inkFaint,
          textAlign: 'center',
        }}>She Elf · v0.1</div>
      </div>
    </nav>
  );
}
