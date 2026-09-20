import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { colors, typography, spacing, radius } from '../tokens';

const STEPS = [
  {
    title: 'Sua biblioteca, mapeada.',
    body: 'Escaneie o código de barras de qualquer livro e ele entra automaticamente na sua coleção.',
    illustration: (
      <svg width="200" height="140" viewBox="0 0 200 140" fill="none">
        {/* shelf board */}
        <rect x="10" y="100" width="180" height="10" rx="2" fill="#6B4C30"/>
        {/* books */}
        {[
          { x: 20, w: 22, h: 70, color: '#B4696C' },
          { x: 44, w: 18, h: 85, color: '#9576A0' },
          { x: 64, w: 24, h: 65, color: '#7C93B5' },
          { x: 90, w: 20, h: 78, color: '#7FA277' },
          { x: 112, w: 16, h: 90, color: '#D08653' },
          { x: 130, w: 22, h: 68, color: '#C99A8E' },
          { x: 154, w: 18, h: 80, color: '#9576A0' },
        ].map((b, i) => (
          <rect key={i} x={b.x} y={100 - b.h} width={b.w} height={b.h} rx="2" fill={b.color} opacity="0.9"/>
        ))}
        {/* scan beam */}
        <line x1="10" y1="60" x2="190" y2="60" stroke="#E8C06B" strokeWidth="1.5" strokeDasharray="6 4" opacity="0.6"/>
        <rect x="75" y="30" width="50" height="60" rx="4" stroke="#E8C06B" strokeWidth="1.5" fill="none" opacity="0.5"/>
      </svg>
    ),
  },
  {
    title: 'Cada livro tem um lar.',
    body: 'Registre em qual cômodo, prateleira ou caixa cada livro está guardado. Nunca mais perca um livro de vista.',
    illustration: (
      <svg width="200" height="140" viewBox="0 0 200 140" fill="none">
        {/* house outline */}
        <path d="M100 20L170 70V130H30V70L100 20Z" stroke="#6B4C30" strokeWidth="2" fill="#211C2B"/>
        {/* door */}
        <rect x="85" y="95" width="30" height="35" rx="3" fill="#4A3320"/>
        <circle cx="111" cy="112" r="2.5" fill="#E8C06B"/>
        {/* window */}
        <rect x="45" y="75" width="28" height="22" rx="3" fill="#2A2438" stroke="#6B4C30" strokeWidth="1.5"/>
        <line x1="59" y1="75" x2="59" y2="97" stroke="#6B4C30" strokeWidth="1"/>
        {/* key icon */}
        <circle cx="145" cy="80" r="12" fill="none" stroke="#D08653" strokeWidth="1.5"/>
        <line x1="154" y1="89" x2="163" y2="98" stroke="#D08653" strokeWidth="1.5" strokeLinecap="round"/>
        <line x1="159" y1="93" x2="161" y2="91" stroke="#D08653" strokeWidth="1.5" strokeLinecap="round"/>
      </svg>
    ),
  },
  {
    title: 'Leia junto com quem você ama.',
    body: 'Compartilhe sua biblioteca com quem mora com você. Uma coleção, vários leitores.',
    illustration: (
      <svg width="200" height="140" viewBox="0 0 200 140" fill="none">
        {/* person 1 reading */}
        <circle cx="70" cy="45" r="18" fill="#2A2438" stroke="#6B4C30" strokeWidth="1.5"/>
        <path d="M45 90 Q70 75 95 90 L90 130 H50 Z" fill="#2A2438" stroke="#6B4C30" strokeWidth="1.5"/>
        <rect x="52" y="95" width="36" height="25" rx="3" fill="#B4696C" opacity="0.8"/>
        {/* person 2 reading */}
        <circle cx="135" cy="45" r="18" fill="#2A2438" stroke="#6B4C30" strokeWidth="1.5"/>
        <path d="M110 90 Q135 75 160 90 L155 130 H115 Z" fill="#2A2438" stroke="#6B4C30" strokeWidth="1.5"/>
        <rect x="117" y="95" width="36" height="25" rx="3" fill="#9576A0" opacity="0.8"/>
        {/* link between */}
        <path d="M95 100 Q102 90 110 100" stroke="#E8C06B" strokeWidth="1.5" strokeDasharray="4 3" fill="none" opacity="0.7"/>
      </svg>
    ),
  },
];

export default function OnboardingScreen() {
  const navigate = useNavigate();
  const [step, setStep] = useState(0);
  const current = STEPS[step];
  const isLast = step === STEPS.length - 1;

  return (
    <div style={{
      minHeight: '100vh',
      background: colors.bg0,
      display: 'flex',
      flexDirection: 'column',
      padding: spacing[5],
      paddingTop: spacing[10],
    }}>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: spacing[8] }}>
        {/* Illustration */}
        <div style={{
          background: colors.bg1,
          border: `1px solid ${colors.lineStrong}`,
          borderRadius: radius.xl,
          padding: `${spacing[8]} ${spacing[6]}`,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          width: '100%',
        }}>
          {current.illustration}
        </div>

        {/* Text */}
        <div style={{ textAlign: 'center', display: 'flex', flexDirection: 'column', gap: spacing[3] }}>
          <h1 style={{
            fontFamily: typography.fontSerif,
            fontSize: typography.size.xl,
            fontWeight: typography.weight.medium,
            color: colors.ink,
            lineHeight: 1.3,
          }}>{current.title}</h1>
          <p style={{
            fontFamily: typography.fontSans,
            fontSize: typography.size.base,
            color: colors.inkSoft,
            lineHeight: 1.6,
            maxWidth: 320,
          }}>{current.body}</p>
        </div>

        {/* Progress dots */}
        <div style={{ display: 'flex', gap: spacing[2] }}>
          {STEPS.map((_, i) => (
            <div key={i} style={{
              width: i === step ? 20 : 6, height: 6,
              borderRadius: radius.full,
              background: i === step ? colors.terracotta : colors.bg3,
              transition: 'all 0.25s ease',
            }}/>
          ))}
        </div>
      </div>

      {/* Actions */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[3], paddingBottom: spacing[6] }}>
        <button
          onClick={() => {
            if (isLast) navigate('/home', { replace: true });
            else setStep(s => s + 1);
          }}
          style={{
            background: colors.moss,
            border: 'none',
            borderRadius: radius.md,
            height: 50,
            fontFamily: typography.fontSans,
            fontSize: typography.size.base,
            fontWeight: typography.weight.semibold,
            color: colors.ink,
            cursor: 'pointer',
            letterSpacing: '0.03em',
          }}
        >{isLast ? 'Começar' : 'Próximo'}</button>

        {!isLast && (
          <button
            onClick={() => navigate('/home', { replace: true })}
            style={{
              background: 'transparent',
              border: 'none',
              fontFamily: typography.fontSans,
              fontSize: typography.size.sm,
              color: colors.inkFaint,
              cursor: 'pointer',
              height: 44,
            }}
          >Pular introdução</button>
        )}
        {step > 0 && (
          <button
            onClick={() => setStep(s => s - 1)}
            style={{
              background: 'transparent',
              border: 'none',
              fontFamily: typography.fontSans,
              fontSize: typography.size.sm,
              color: colors.inkFaint,
              cursor: 'pointer',
              height: 44,
            }}
          >← Voltar</button>
        )}
      </div>
    </div>
  );
}
