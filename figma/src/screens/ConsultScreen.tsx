import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import AppHeader from '../components/AppHeader';
import { colors, typography, spacing, radius } from '../tokens';
import { LanternIcon, ScanIcon, KeyIcon, CheckIcon, XIcon } from '../icons';

type Stage = 'scanning' | 'searching' | 'found' | 'not-found';

const FAKE_ISBN = '9788535902772';

export default function ConsultScreen() {
  const navigate = useNavigate();
  const { currentBooks, getLocationById } = useApp();
  const [stage, setStage] = useState<Stage>('scanning');
  const [foundBook, setFoundBook] = useState<typeof currentBooks[0] | null>(null);

  const handleScan = () => {
    setStage('searching');
    setTimeout(() => {
      const book = currentBooks.find(b => b.isbn === FAKE_ISBN);
      if (book) {
        setFoundBook(book);
        setStage('found');
      } else {
        setStage('not-found');
      }
    }, 1400);
  };

  const handleNotFound = () => {
    setStage('searching');
    setTimeout(() => {
      setFoundBook(null);
      setStage('not-found');
    }, 1400);
  };

  return (
    <div style={{ minHeight: '100vh', background: colors.bg0, paddingBottom: 80 }}>
      <AppHeader title="Tenho este livro?" showBack/>

      {stage === 'scanning' && (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: `${spacing[6]} ${spacing[4]}`, gap: spacing[5] }}>
          <div style={{ width: '100%', height: 240, border: `2px dashed ${colors.lineStrong}`, borderRadius: radius.xl, background: colors.bg1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', position: 'relative' }}>
            {[['top','left'],['top','right'],['bottom','left'],['bottom','right']].map(([v,h]) => (
              <div key={`${v}${h}`} style={{ position: 'absolute', [v]: 14, [h]: 14, width: 22, height: 22, borderTop: v==='top'?`2px solid ${colors.deepBlue}`:'none', borderBottom: v==='bottom'?`2px solid ${colors.deepBlue}`:'none', borderLeft: h==='left'?`2px solid ${colors.deepBlue}`:'none', borderRight: h==='right'?`2px solid ${colors.deepBlue}`:'none' }}/>
            ))}
            <ScanIcon size={44} color={colors.inkFaint}/>
            <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkFaint, marginTop: spacing[3], textAlign: 'center', maxWidth: 200 }}>Aponte para o código de barras para verificar se está na coleção</p>
          </div>

          <button onClick={handleScan} style={{ background: colors.deepBlue, border: 'none', borderRadius: radius.md, height: 50, width: '100%', fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.ink, cursor: 'pointer' }}>Simular — encontrar livro ▸</button>
          <button onClick={handleNotFound} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, height: 48, width: '100%', fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.inkSoft, cursor: 'pointer' }}>Simular — livro não encontrado ▸</button>
        </div>
      )}

      {stage === 'searching' && (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '60vh', gap: spacing[5] }}>
          <div style={{ animation: 'lanternSway 1.5s ease-in-out infinite alternate', transformOrigin: 'top center' }}>
            <LanternIcon size={60} color={colors.deepBlue}/>
          </div>
          <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, fontStyle: 'italic' }}>Consultando os pergaminhos...</p>
        </div>
      )}

      {stage === 'found' && foundBook && (
        <div style={{ padding: `${spacing[6]} ${spacing[4]}`, display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: spacing[3], padding: `${spacing[3]} ${spacing[4]}`, background: colors.mossDeep, borderRadius: radius.md, border: `1px solid ${colors.moss}` }}>
            <CheckIcon size={20} color={colors.moss}/>
            <span style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.moss }}>Este livro está na sua coleção!</span>
          </div>

          <button onClick={() => navigate(`/book/${foundBook.id}`)} style={{ display: 'flex', gap: spacing[4], background: colors.bg1, border: `1px solid ${colors.lineStrong}`, borderRadius: radius.lg, padding: spacing[4], cursor: 'pointer', textAlign: 'left', width: '100%' }}>
            <div style={{ width: 70, height: 96, background: foundBook.color, borderRadius: radius.sm, flexShrink: 0, display: 'flex', alignItems: 'flex-end', padding: 6 }}>
              <span style={{ fontFamily: typography.fontSerif, fontSize: '8px', color: 'rgba(237,230,214,0.8)', lineHeight: 1.2 }}>{foundBook.title}</span>
            </div>
            <div>
              <h2 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.md, fontWeight: typography.weight.medium, color: colors.ink }}>{foundBook.title}</h2>
              <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, marginTop: 4 }}>{foundBook.author}</p>
              <div style={{ display: 'flex', alignItems: 'center', gap: spacing[1], marginTop: spacing[3] }}>
                <KeyIcon size={14} color={colors.terracotta}/>
                <span style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.terracotta }}>{getLocationById(foundBook.locationId)?.name ?? '—'}</span>
              </div>
            </div>
          </button>

          <button onClick={() => setStage('scanning')} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, height: 48, fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.inkSoft, cursor: 'pointer' }}>Consultar outro livro</button>
        </div>
      )}

      {stage === 'not-found' && (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: `${spacing[8]} ${spacing[4]}`, gap: spacing[5] }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: spacing[3], padding: `${spacing[3]} ${spacing[4]}`, background: 'rgba(180,105,108,0.15)', borderRadius: radius.md, border: `1px solid ${colors.wine}`, width: '100%' }}>
            <XIcon size={20} color={colors.wine}/>
            <span style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.wine }}>Este livro não está na coleção.</span>
          </div>

          <svg width="140" height="110" viewBox="0 0 140 110" fill="none">
            <rect x="10" y="92" width="120" height="10" rx="2" fill={colors.woodMid} opacity="0.5"/>
            <rect x="20" y="60" width="100" height="8" rx="2" fill={colors.wood} opacity="0.4"/>
            <rect x="55" y="25" width="30" height="35" rx="2" stroke={colors.inkFaint} strokeWidth="1.5" strokeDasharray="4 3" fill="none"/>
            <path d="M65 40 Q70 33 75 40" stroke={colors.inkFaint} strokeWidth="1.5" fill="none" strokeLinecap="round"/>
          </svg>

          <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[3], width: '100%' }}>
            <button onClick={() => navigate('/scan')} style={{ background: colors.moss, border: 'none', borderRadius: radius.md, height: 50, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.ink, cursor: 'pointer' }}>Adicionar à coleção →</button>
            <button onClick={() => setStage('scanning')} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, height: 48, fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.inkSoft, cursor: 'pointer' }}>Consultar outro livro</button>
          </div>
        </div>
      )}
    </div>
  );
}
