import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import { useUI } from '../context/UIContext';
import { useTheme } from '../context/ThemeContext';
import AppHeader from '../components/AppHeader';
import { colors, typography, spacing, radius } from '../tokens';
import { BookIcon, KeyIcon, ShareIcon, UsersIcon, ChevronRightIcon } from '../icons';

function SunIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round">
      <circle cx="12" cy="12" r="5"/>
      <line x1="12" y1="1" x2="12" y2="3"/>
      <line x1="12" y1="21" x2="12" y2="23"/>
      <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/>
      <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
      <line x1="1" y1="12" x2="3" y2="12"/>
      <line x1="21" y1="12" x2="23" y2="12"/>
      <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/>
      <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
    </svg>
  );
}

function MoonIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round">
      <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
    </svg>
  );
}

export default function MoreScreen() {
  const navigate = useNavigate();
  const { user, currentLibrary, logout } = useApp();
  const { openDrawer } = useUI();
  const { theme, toggleTheme, isDark } = useTheme();

  const items = [
    { label: 'Gerenciar coleções', icon: <BookIcon size={18} color={colors.terracotta}/>, action: () => openDrawer() },
    { label: 'Lugares', icon: <KeyIcon size={18} color={colors.terracotta}/>, action: () => navigate('/locations') },
    { label: 'Compartilhar biblioteca', icon: <ShareIcon size={18} color={colors.terracotta}/>, action: () => navigate('/share') },
    { label: 'Membros da coleção', icon: <UsersIcon size={18} color={colors.terracotta}/>, action: () => navigate('/share') },
  ];

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <AppHeader title="Mais"/>
      <div style={{ flex: 1, overflowY: 'auto' }}>
        {/* User card */}
        <div style={{ margin: `${spacing[4]} ${spacing[4]} 0`, padding: spacing[4], background: colors.bg1, border: `1px solid ${colors.line}`, borderRadius: radius.lg, display: 'flex', alignItems: 'center', gap: spacing[3] }}>
          <div style={{ width: 52, height: 52, borderRadius: '50%', background: colors.bg3, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
            <span style={{ fontFamily: typography.fontSerif, fontSize: typography.size.lg, color: colors.inkSoft }}>{user?.name[0] ?? '?'}</span>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.ink }}>{user?.name ?? 'Usuário'}</div>
            <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, marginTop: 2 }}>{user?.email ?? ''}</div>
          </div>
        </div>

        {currentLibrary && (
          <div style={{ margin: `${spacing[2]} ${spacing[4]} 0`, padding: `${spacing[2]} ${spacing[4]}`, background: colors.bg2, borderRadius: radius.md, display: 'flex', alignItems: 'center', gap: spacing[2] }}>
            <div style={{ width: 6, height: 6, borderRadius: '50%', background: colors.terracotta }}/>
            <span style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint }}>Coleção ativa:</span>
            <span style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.terracotta, fontWeight: typography.weight.semibold }}>{currentLibrary.name}</span>
          </div>
        )}

        {/* Menu items */}
        <div style={{ margin: `${spacing[5]} ${spacing[4]} 0` }}>
          {items.map((item, i) => (
            <button key={item.label} onClick={item.action} style={{ display: 'flex', alignItems: 'center', gap: spacing[3], width: '100%', padding: `${spacing[4]} 0`, background: 'transparent', border: 'none', borderBottom: i < items.length - 1 ? `1px solid ${colors.line}` : 'none', cursor: 'pointer', textAlign: 'left', minHeight: 56 }}>
              <div style={{ width: 36, height: 36, borderRadius: radius.md, background: colors.bg2, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                {item.icon}
              </div>
              <span style={{ flex: 1, fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.ink }}>{item.label}</span>
              <ChevronRightIcon color={colors.inkFaint}/>
            </button>
          ))}
        </div>

        {/* Theme toggle */}
        <div style={{ margin: `${spacing[5]} ${spacing[4]} 0`, background: colors.bg1, border: `1px solid ${colors.line}`, borderRadius: radius.lg, overflow: 'hidden' }}>
          <div style={{ padding: `${spacing[3]} ${spacing[4]}`, borderBottom: `1px solid ${colors.line}` }}>
            <span style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.08em', textTransform: 'uppercase' }}>Aparência</span>
          </div>
          <div style={{ display: 'flex' }}>
            {(['dark', 'light'] as const).map(t => (
              <button
                key={t}
                onClick={() => { if (theme !== t) toggleTheme(); }}
                style={{
                  flex: 1, height: 56, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: spacing[2],
                  background: theme === t ? colors.bg3 : 'transparent', border: 'none', cursor: 'pointer',
                  fontFamily: typography.fontSans, fontSize: typography.size.sm,
                  fontWeight: theme === t ? typography.weight.semibold : typography.weight.regular,
                  color: theme === t ? colors.ink : colors.inkFaint,
                  borderRight: t === 'dark' ? `1px solid ${colors.line}` : 'none',
                  transition: 'all 0.2s',
                }}
              >
                {t === 'dark' ? <MoonIcon/> : <SunIcon/>}
                {t === 'dark' ? 'Escuro' : 'Claro'}
              </button>
            ))}
          </div>
        </div>

        {/* Logout */}
        <div style={{ padding: `${spacing[6]} ${spacing[4]} ${spacing[8]}` }}>
          <button onClick={() => { logout(); navigate('/', { replace: true }); }} style={{ background: 'transparent', border: `1px solid ${colors.wine}`, borderRadius: radius.md, height: 48, width: '100%', fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.wine, cursor: 'pointer' }}>
            Sair da conta
          </button>
        </div>
      </div>
    </div>
  );
}
