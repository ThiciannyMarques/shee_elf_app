import React from 'react';
import { Outlet } from 'react-router-dom';
import SnackbarStack from './ui/Snackbar';
import CollectionsDrawer from '../modals/CollectionsDrawer';

export default function AppShell() {
  return (
    <div style={{
      display: 'flex', flexDirection: 'column',
      height: '100%', overflow: 'hidden',
      background: 'var(--bg0)',
    }}>
      {/* Screen content - takes remaining space, scrolling managed per-screen */}
      <div style={{ flex: 1, overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
        <Outlet/>
      </div>

      {/* Bottom nav - always visible */}
      <BottomNavBar/>

      <SnackbarStack/>
      <CollectionsDrawer/>
    </div>
  );
}

import { useNavigate, useLocation } from 'react-router-dom';
import { colors, typography } from '../tokens';

const NAV = [
  { path: '/home', label: 'Início', icon: HomeNav },
  { path: '/locations', label: 'Lugares', icon: KeyNav },
  { path: '/scan', label: null, icon: ScanNav },
  { path: '/consult', label: 'Consultar', icon: SearchNav },
  { path: '/more', label: 'Mais', icon: MoreNav },
];

function BottomNavBar() {
  const navigate = useNavigate();
  const loc = useLocation();

  return (
    <nav style={{
      display: 'flex', alignItems: 'center',
      height: 60, flexShrink: 0,
      background: 'var(--bg1)',
      borderTop: '1px solid var(--line)',
    }}>
      {NAV.map(({ path, label, icon: Icon }) => {
        const isActive = loc.pathname === path || (path !== '/home' && loc.pathname.startsWith(path) && path !== '/');
        const isFab = label === null;

        if (isFab) {
          return (
            <div key={path} style={{ flex: 1, display: 'flex', justifyContent: 'center' }}>
              <button
                onClick={() => navigate(path)}
                style={{
                  width: 50, height: 50, borderRadius: '50%',
                  background: 'var(--terracotta)', border: 'none',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  color: '#EDE6D6', cursor: 'pointer',
                  transform: 'translateY(-8px)',
                  boxShadow: '0 4px 16px rgba(0,0,0,0.35)',
                  transition: 'transform 0.15s, box-shadow 0.15s',
                }}
              >
                <Icon active={false}/>
              </button>
            </div>
          );
        }

        return (
          <button
            key={path}
            onClick={() => navigate(path)}
            style={{
              flex: 1, height: '100%', background: 'transparent', border: 'none',
              display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
              gap: 3, cursor: 'pointer',
              color: isActive ? 'var(--terracotta)' : 'var(--ink-faint)',
              transition: 'color 0.15s',
              minWidth: 44,
            }}
          >
            <Icon active={isActive}/>
            {label && (
              <span style={{ fontFamily: typography.fontSans, fontSize: '10px', fontWeight: isActive ? 600 : 400, letterSpacing: '0.02em' }}>{label}</span>
            )}
          </button>
        );
      })}
    </nav>
  );
}

function HomeNav({ active }: { active: boolean }) {
  return <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={active ? 2 : 1.5} strokeLinecap="round" strokeLinejoin="round"><path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/><path d="M9 21V12h6v9"/></svg>;
}
function KeyNav({ active }: { active: boolean }) {
  return <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={active ? 2 : 1.5} strokeLinecap="round" strokeLinejoin="round"><circle cx="8.5" cy="8.5" r="5"/><path d="M21 21l-8-8M13 13l2-2"/></svg>;
}
function ScanNav(_: { active: boolean }) {
  return <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M3 7V5a2 2 0 012-2h2M17 3h2a2 2 0 012 2v2M21 17v2a2 2 0 01-2 2h-2M7 21H5a2 2 0 01-2-2v-2"/><line x1="3" y1="12" x2="21" y2="12"/></svg>;
}
function SearchNav({ active }: { active: boolean }) {
  return <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={active ? 2 : 1.5} strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7"/><path d="M16.5 16.5L21 21"/></svg>;
}
function MoreNav({ active }: { active: boolean }) {
  return <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={active ? 2 : 1.5} strokeLinecap="round" strokeLinejoin="round"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>;
}
