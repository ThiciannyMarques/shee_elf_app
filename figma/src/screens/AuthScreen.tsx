import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import Input from '../components/ui/Input';
import { colors, typography, spacing, radius } from '../tokens';

type Mode = 'login' | 'register';

export default function AuthScreen() {
  const navigate = useNavigate();
  const { login, register, loginBypass } = useApp();
  const [mode, setMode] = useState<Mode>('login');
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      if (mode === 'login') await login(email, password);
      else await register(name, email, password);
      navigate('/home', { replace: true });
    } catch {
      setError('Algo deu errado. Tente novamente.');
    } finally {
      setLoading(false);
    }
  };

  const isLogin = mode === 'login';

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column', background: 'var(--bg0)' }}>
      {/* Hero with ambient video */}
      <div style={{ position: 'relative', height: 240, flexShrink: 0, overflow: 'hidden' }}>
        <iframe
          src="https://www.youtube.com/embed/jAKFBXCRHCE?autoplay=1&mute=1&controls=0&loop=1&playlist=jAKFBXCRHCE&modestbranding=1&playsinline=1"
          style={{ position: 'absolute', inset: '-60px', width: 'calc(100% + 120px)', height: 'calc(100% + 120px)', border: 'none', pointerEvents: 'none', filter: 'brightness(0.25)' }}
          allow="autoplay"
          title="ambient-video"
        />
        {/* Ambient overlay from Unsplash as fallback */}
        <div style={{ position: 'absolute', inset: 0, background: `url(https://images.unsplash.com/photo-1603745676022-d1b77e3cbce8?w=480&h=480&fit=crop&q=60) center/cover`, opacity: 0.35 }}/>
        <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to bottom, rgba(23,21,29,0.3) 0%, rgba(23,21,29,0.95) 100%)' }}/>

        {/* Logo */}
        <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: `0 ${spacing[6]} ${spacing[5]}`, textAlign: 'center' }}>
          {/* Small SVG mark */}
          <svg width="36" height="36" viewBox="0 0 36 36" fill="none" style={{ marginBottom: spacing[2] }}>
            <rect x="6" y="6" width="24" height="30" rx="3" fill="none" stroke="#E8C06B" strokeWidth="1.5"/>
            <line x1="10" y1="14" x2="26" y2="14" stroke="#E8C06B" strokeWidth="1" opacity="0.5"/>
            <line x1="10" y1="18" x2="26" y2="18" stroke="#E8C06B" strokeWidth="1" opacity="0.5"/>
            <line x1="10" y1="22" x2="20" y2="22" stroke="#E8C06B" strokeWidth="1" opacity="0.5"/>
            <circle cx="24" cy="10" r="5" fill="#17151D" stroke="#E8C06B" strokeWidth="1"/>
            <path d="M22 10 Q24 7.5 26 10" fill="none" stroke="#E8C06B" strokeWidth="1" strokeLinecap="round"/>
          </svg>
          <h1 style={{ fontFamily: typography.fontSerif, fontSize: typography.size['2xl'], fontWeight: typography.weight.medium, color: '#EDE6D6', letterSpacing: '0.03em' }}>She Elf</h1>
          <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: 'rgba(237,230,214,0.55)', marginTop: 4, letterSpacing: '0.08em' }}>a biblioteca que vive em casa</p>
        </div>
      </div>

      {/* Form panel — scrollable */}
      <div style={{ flex: 1, overflowY: 'auto', padding: `${spacing[5]} ${spacing[5]} ${spacing[8]}`, display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
        {/* Mode tabs */}
        <div style={{ display: 'flex', background: colors.bg2, border: `1px solid ${colors.line}`, borderRadius: radius.lg, overflow: 'hidden', padding: 3 }}>
          {(['login', 'register'] as Mode[]).map(m => (
            <button key={m} onClick={() => { setMode(m); setError(''); }} style={{ flex: 1, height: 42, background: mode === m ? colors.bg1 : 'transparent', border: 'none', fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: mode === m ? typography.weight.semibold : typography.weight.regular, color: mode === m ? colors.ink : colors.inkFaint, cursor: 'pointer', transition: 'all 0.2s', borderRadius: radius.md }}>
              {m === 'login' ? 'Entrar' : 'Criar conta'}
            </button>
          ))}
        </div>

        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: spacing[3] }}>
          {!isLogin && (
            <Input label="Nome" placeholder="Seu nome" value={name} onChange={e => setName(e.target.value)} required autoComplete="name"/>
          )}
          <Input label="E-mail" type="email" placeholder="seu@email.com" value={email} onChange={e => setEmail(e.target.value)} required autoComplete="email"/>
          <Input label="Senha" type="password" placeholder="••••••••" value={password} onChange={e => setPassword(e.target.value)} required autoComplete={isLogin ? 'current-password' : 'new-password'} error={error}/>

          <button type="submit" disabled={loading} style={{ marginTop: spacing[2], background: loading ? colors.bg3 : colors.moss, border: 'none', borderRadius: radius.lg, height: 52, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: '#EDE6D6', cursor: loading ? 'not-allowed' : 'pointer', letterSpacing: '0.02em', transition: 'background 0.2s' }}>
            {loading ? 'Aguarde…' : isLogin ? 'Entrar na biblioteca' : 'Criar conta'}
          </button>
        </form>

        {/* Dev bypass */}
        <div style={{ borderTop: `1px dashed ${colors.line}`, paddingTop: spacing[4], display: 'flex', flexDirection: 'column', alignItems: 'center', gap: spacing[2] }}>
          <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, letterSpacing: '0.06em', textTransform: 'uppercase' }}>Desenvolvimento</p>
          <button onClick={() => { loginBypass(); navigate('/home', { replace: true }); }} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, padding: `${spacing[2]} ${spacing[5]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer', height: 44 }}>
            Entrar sem autenticação →
          </button>
        </div>
      </div>
    </div>
  );
}
