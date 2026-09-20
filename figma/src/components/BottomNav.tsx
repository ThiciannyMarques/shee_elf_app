import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { colors, typography, spacing } from '../tokens';

function HomeIcon() {
  return (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
      <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/>
      <path d="M9 21V12h6v9"/>
    </svg>
  );
}

function KeyIcon() {
  return (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="8" cy="8" r="5"/>
      <path d="M16.5 13.5L21 18l-2 2-1.5-1.5M13 11l8 8"/>
    </svg>
  );
}

function ScanIcon() {
  return (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
      <path d="M3 7V5a2 2 0 012-2h2M17 3h2a2 2 0 012 2v2M21 17v2a2 2 0 01-2 2h-2M7 21H5a2 2 0 01-2-2v-2"/>
      <line x1="3" y1="12" x2="21" y2="12"/>
    </svg>
  );
}

function SearchIcon() {
  return (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="11" cy="11" r="7"/>
      <path d="M16.5 16.5L21 21"/>
    </svg>
  );
}

function MenuIcon() {
  return (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
      <path d="M4 8h16M4 12h16M4 16h16"/>
    </svg>
  );
}

const NAV_ITEMS = [
  { path: '/home', label: 'Início', Icon: HomeIcon },
  { path: '/locations', label: 'Lugares', Icon: KeyIcon },
  { path: '/scan', label: null, Icon: ScanIcon }, // FAB
  { path: '/consult', label: 'Consultar', Icon: SearchIcon },
  { path: '/more', label: 'Mais', Icon: MenuIcon },
];

export default function BottomNav() {
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <nav style={{
      position: 'fixed', bottom: 0, left: 0, right: 0,
      background: colors.bg1,
      borderTop: `1px solid ${colors.line}`,
      display: 'flex', alignItems: 'center',
      height: 64, zIndex: 100,
    }}>
      {NAV_ITEMS.map(({ path, label, Icon }) => {
        const isActive = location.pathname === path;
        const isFab = label === null;

        if (isFab) {
          return (
            <div key={path} style={{ flex: 1, display: 'flex', justifyContent: 'center' }}>
              <button
                onClick={() => navigate(path)}
                style={{
                  width: 52, height: 52,
                  borderRadius: '50%',
                  background: colors.terracotta,
                  border: 'none',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  color: colors.ink, cursor: 'pointer',
                  transform: 'translateY(-8px)',
                  boxShadow: `0 4px 12px rgba(0,0,0,0.4)`,
                }}
              >
                <Icon />
              </button>
            </div>
          );
        }

        return (
          <button
            key={path}
            onClick={() => navigate(path)}
            style={{
              flex: 1, height: '100%',
              background: 'transparent', border: 'none',
              display: 'flex', flexDirection: 'column',
              alignItems: 'center', justifyContent: 'center',
              gap: 3, cursor: 'pointer',
              color: isActive ? colors.terracotta : colors.inkFaint,
              transition: 'color 0.15s',
              minWidth: 44,
            }}
          >
            <Icon />
            {label && (
              <span style={{
                fontFamily: typography.fontSans,
                fontSize: '10px',
                fontWeight: isActive ? typography.weight.semibold : typography.weight.regular,
                letterSpacing: '0.03em',
              }}>{label}</span>
            )}
          </button>
        );
      })}
    </nav>
  );
}
