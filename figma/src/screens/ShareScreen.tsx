import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { useUI } from '../context/UIContext';
import AppHeader from '../components/AppHeader';
import Input from '../components/ui/Input';
import { colors, typography, spacing, radius } from '../tokens';
import { UsersIcon, CopyIcon, CheckIcon } from '../icons';

type Tab = 'share' | 'join';

export default function ShareScreen() {
  const { currentLibrary, libraries, joinLibrary } = useApp();
  const { showSnackbar } = useUI();
  const [tab, setTab] = useState<Tab>('share');
  const [code, setCode] = useState('');
  const [codeError, setCodeError] = useState('');
  const [copied, setCopied] = useState(false);
  const [joining, setJoining] = useState(false);

  const handleCopy = () => {
    if (currentLibrary?.code) {
      navigator.clipboard.writeText(currentLibrary.code).catch(() => {});
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
      showSnackbar('Código copiado!', 'success');
    }
  };

  const handleJoin = async () => {
    setCodeError('');
    if (!code.trim()) { setCodeError('Digite o código da coleção.'); return; }
    setJoining(true);
    await new Promise(r => setTimeout(r, 800));
    const found = joinLibrary(code.trim());
    setJoining(false);
    if (found) {
      showSnackbar(`Você entrou em "${found.name}"!`, 'success');
      setCode('');
    } else {
      setCodeError('Código inválido. Verifique e tente novamente.');
    }
  };

  return (
    <div style={{ minHeight: '100vh', background: colors.bg0, paddingBottom: 80 }}>
      <AppHeader title="Compartilhar" subtitle="Adicionar pessoas à coleção"/>

      {/* Tabs */}
      <div style={{ display: 'flex', background: colors.bg1, borderBottom: `1px solid ${colors.line}` }}>
        {(['share', 'join'] as Tab[]).map(t => (
          <button
            key={t}
            onClick={() => setTab(t)}
            style={{
              flex: 1, height: 48, background: 'transparent', border: 'none',
              borderBottom: `2px solid ${tab === t ? colors.terracotta : 'transparent'}`,
              fontFamily: typography.fontSans, fontSize: typography.size.sm,
              fontWeight: tab === t ? typography.weight.semibold : typography.weight.regular,
              color: tab === t ? colors.terracotta : colors.inkFaint, cursor: 'pointer',
              transition: 'all 0.15s',
            }}
          >{t === 'share' ? 'Compartilhar' : 'Entrar com código'}</button>
        ))}
      </div>

      {/* SHARE */}
      {tab === 'share' && (
        <div style={{ padding: `${spacing[6]} ${spacing[4]}`, display: 'flex', flexDirection: 'column', gap: spacing[5] }}>
          {currentLibrary ? (
            <>
              <div style={{ textAlign: 'center' }}>
                <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkFaint, marginBottom: spacing[4] }}>
                  Compartilhe este código com quem mora com você
                </p>
                {/* Code display */}
                <div style={{
                  background: colors.bg1,
                  border: `2px solid ${colors.lineStrong}`,
                  borderRadius: radius.lg,
                  padding: `${spacing[6]} ${spacing[5]}`,
                  display: 'inline-block',
                  width: '100%',
                }}>
                  <div style={{
                    fontFamily: typography.fontSerif,
                    fontSize: '42px',
                    letterSpacing: '0.4em',
                    color: colors.ink,
                    fontWeight: typography.weight.medium,
                  }}>{currentLibrary.code}</div>
                  <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, marginTop: spacing[2], letterSpacing: '0.06em', textTransform: 'uppercase' }}>
                    {currentLibrary.name}
                  </div>
                </div>

                <button
                  onClick={handleCopy}
                  style={{
                    marginTop: spacing[4],
                    display: 'flex', alignItems: 'center', gap: spacing[2],
                    background: 'transparent', border: `1px solid ${colors.lineStrong}`,
                    borderRadius: radius.md, padding: `${spacing[3]} ${spacing[5]}`,
                    fontFamily: typography.fontSans, fontSize: typography.size.sm,
                    color: copied ? colors.moss : colors.inkSoft, cursor: 'pointer', height: 44,
                    margin: `${spacing[4]} auto 0`,
                  }}
                >
                  {copied ? <CheckIcon size={16} color={colors.moss}/> : <CopyIcon size={16}/>}
                  {copied ? 'Copiado!' : 'Copiar código'}
                </button>
              </div>

              {/* Member list */}
              <div>
                <div style={{ display: 'flex', alignItems: 'center', gap: spacing[2], marginBottom: spacing[3] }}>
                  <UsersIcon size={16} color={colors.inkFaint}/>
                  <span style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, letterSpacing: '0.06em', textTransform: 'uppercase' }}>Membros ({currentLibrary.members.length})</span>
                </div>
                <div style={{ display: 'flex', flexDirection: 'column' }}>
                  {currentLibrary.members.map((m, i) => (
                    <div key={m.userId} style={{
                      display: 'flex', alignItems: 'center', gap: spacing[3],
                      padding: `${spacing[3]} 0`,
                      borderBottom: i < currentLibrary.members.length - 1 ? `1px solid ${colors.line}` : 'none',
                    }}>
                      <div style={{ width: 36, height: 36, borderRadius: '50%', background: colors.bg3, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                        <span style={{ fontFamily: typography.fontSerif, fontSize: typography.size.base, color: colors.inkSoft }}>{m.name[0]}</span>
                      </div>
                      <div style={{ flex: 1 }}>
                        <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.ink }}>{m.name}</div>
                        <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, marginTop: 2 }}>{m.role === 'owner' ? 'Proprietário' : 'Membro'}</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Other libraries */}
              <div style={{ paddingTop: spacing[4], borderTop: `1px solid ${colors.line}` }}>
                <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, marginBottom: spacing[3] }}>
                  Também disponível: tente o código <strong style={{ color: colors.ink, letterSpacing: '0.1em' }}>APT-07</strong> para testar o fluxo de entrada.
                </p>
              </div>
            </>
          ) : (
            <p style={{ fontFamily: typography.fontSans, color: colors.inkFaint, textAlign: 'center' }}>Nenhuma coleção selecionada.</p>
          )}
        </div>
      )}

      {/* JOIN */}
      {tab === 'join' && (
        <div style={{ padding: `${spacing[6]} ${spacing[4]}`, display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
          <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, lineHeight: 1.6 }}>
            Digite o código de convite recebido de alguém da sua casa.
          </p>
          <Input
            label="Código da coleção"
            placeholder="ex: IPE-42"
            value={code}
            onChange={e => { setCode(e.target.value.toUpperCase()); setCodeError(''); }}
            error={codeError}
            style={{ fontFamily: typography.fontSerif, fontSize: typography.size.xl, letterSpacing: '0.2em', textAlign: 'center' }}
          />
          <button
            onClick={handleJoin}
            disabled={!code.trim() || joining}
            style={{
              background: !code.trim() || joining ? colors.bg3 : colors.moss,
              border: 'none', borderRadius: radius.md, height: 50,
              fontFamily: typography.fontSans, fontSize: typography.size.base,
              fontWeight: typography.weight.semibold, color: colors.ink,
              cursor: !code.trim() || joining ? 'not-allowed' : 'pointer',
            }}
          >{joining ? 'Verificando...' : 'Entrar na biblioteca'}</button>

          <div style={{ paddingTop: spacing[4], borderTop: `1px solid ${colors.line}` }}>
            <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, lineHeight: 1.6 }}>
              Códigos disponíveis para teste: <strong style={{ color: colors.ink }}>IPE-42</strong>, <strong style={{ color: colors.ink }}>APT-07</strong>
            </p>
          </div>
        </div>
      )}
    </div>
  );
}
