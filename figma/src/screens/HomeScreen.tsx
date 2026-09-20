import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import { useUI } from '../context/UIContext';
import AppHeader from '../components/AppHeader';
import Modal from '../components/ui/Modal';
import Input from '../components/ui/Input';
import { colors, typography, spacing, radius } from '../tokens';
import { KeyIcon, MenuIcon, PlusIcon, ChevronRightIcon, ScanIcon } from '../icons';

function BookCard({ book, onClick }: { book: any; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      style={{
        width: 110, flexShrink: 0,
        background: 'var(--bg1)',
        border: '1px solid var(--line)',
        borderRadius: radius.lg,
        overflow: 'hidden',
        cursor: 'pointer',
        textAlign: 'left',
      }}
    >
      {book.coverUrl ? (
        <div style={{ height: 140, overflow: 'hidden' }}>
          <img
            src={book.coverUrl}
            alt={book.title}
            style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
            loading="lazy"
          />
        </div>
      ) : (
        <div style={{ height: 140, background: book.color, display: 'flex', alignItems: 'flex-end', padding: spacing[2] }}>
          <span style={{ fontFamily: typography.fontSerif, fontSize: '10px', color: 'rgba(237,230,214,0.8)', lineHeight: 1.3, overflow: 'hidden', display: '-webkit-box', WebkitLineClamp: 3, WebkitBoxOrient: 'vertical' as const }}>{book.title}</span>
        </div>
      )}
      <div style={{ padding: `${spacing[2]} ${spacing[2]} ${spacing[3]}` }}>
        <div style={{ fontFamily: typography.fontSans, fontSize: '11px', fontWeight: 600, color: 'var(--ink)', lineHeight: 1.3, overflow: 'hidden', display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical' as const }}>{book.title}</div>
        <div style={{ fontFamily: typography.fontSans, fontSize: '10px', color: 'var(--ink-faint)', marginTop: 2, overflow: 'hidden', whiteSpace: 'nowrap', textOverflow: 'ellipsis' }}>{book.author}</div>
      </div>
    </button>
  );
}

export default function HomeScreen() {
  const navigate = useNavigate();
  const { currentLibrary, currentLocations, currentBooks, getBooksForLocation, createLocation } = useApp();
  const { openDrawer, showSnackbar } = useUI();
  const [newLocModal, setNewLocModal] = useState(false);
  const [locName, setLocName] = useState('');
  const [locLoading, setLocLoading] = useState(false);

  const recentBooks = currentBooks.slice(0, 12);

  const handleCreateLocation = async () => {
    if (!locName.trim()) return;
    setLocLoading(true);
    await new Promise(r => setTimeout(r, 400));
    createLocation(locName.trim());
    setLocName('');
    setNewLocModal(false);
    setLocLoading(false);
    showSnackbar('Lugar criado!', 'success');
  };

  if (!currentLibrary) {
    return (
      <div style={{ minHeight: '100vh', background: colors.bg0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: spacing[6], gap: spacing[5] }}>
        <div style={{ width: 64, height: 64, borderRadius: radius.xl, background: colors.bg2, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <KeyIcon size={28} color={colors.terracotta}/>
        </div>
        <div style={{ textAlign: 'center' }}>
          <h2 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.xl, color: colors.ink }}>Nenhuma coleção</h2>
          <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkFaint, marginTop: spacing[2], lineHeight: 1.6 }}>Crie ou entre em uma coleção para começar a catalogar seus livros.</p>
        </div>
        <button onClick={() => openDrawer()} style={{ background: colors.moss, border: 'none', borderRadius: radius.md, padding: `${spacing[3]} ${spacing[6]}`, height: 48, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.ink, cursor: 'pointer' }}>Gerenciar coleções</button>
      </div>
    );
  }

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      {/* Hero header with background image */}
      <div style={{ position: 'relative', flexShrink: 0 }}>
        <div style={{
          height: 180,
          background: `url(https://images.unsplash.com/photo-1603745676022-d1b77e3cbce8?w=480&h=360&fit=crop&q=75) center/cover`,
          position: 'relative',
        }}>
          <div style={{
            position: 'absolute', inset: 0,
            background: 'linear-gradient(to bottom, rgba(23,21,29,0.55) 0%, rgba(23,21,29,0.92) 100%)',
          }}/>
          <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', padding: `${spacing[4]} ${spacing[5]}` }}>
            <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between' }}>
              <div>
                <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: 'rgba(237,230,214,0.6)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>Sua biblioteca</p>
                <h1 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.xl, fontWeight: typography.weight.medium, color: '#EDE6D6', lineHeight: 1.1 }}>{currentLibrary.name}</h1>
              </div>
              <button onClick={() => openDrawer()} style={{ background: 'rgba(237,230,214,0.12)', border: '1px solid rgba(237,230,214,0.2)', borderRadius: radius.md, width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#EDE6D6', cursor: 'pointer', flexShrink: 0 }}>
                <MenuIcon size={20}/>
              </button>
            </div>
          </div>
        </div>

        {/* Stats strip */}
        <div style={{ display: 'flex', background: colors.bg1, borderBottom: `1px solid ${colors.line}` }}>
          {[
            { value: currentBooks.length, label: 'livros' },
            { value: currentLocations.length, label: 'lugares' },
            { value: currentLibrary.members.length, label: 'leitores' },
          ].map((s, i) => (
            <React.Fragment key={s.label}>
              {i > 0 && <div style={{ width: 1, background: colors.line }}/>}
              <div style={{ flex: 1, padding: `${spacing[3]} ${spacing[2]}`, textAlign: 'center' }}>
                <div style={{ fontFamily: typography.fontSerif, fontSize: typography.size.lg, fontWeight: typography.weight.medium, color: colors.ink }}>{s.value}</div>
                <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint }}>{s.label}</div>
              </div>
            </React.Fragment>
          ))}
        </div>
      </div>

      {/* Scrollable body */}
      <div style={{ flex: 1, overflowY: 'auto', overflowX: 'hidden' }}>
        {/* Recent books */}
        <div style={{ paddingTop: spacing[5] }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: `0 ${spacing[5]}`, marginBottom: spacing[3] }}>
            <h2 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.md, fontWeight: typography.weight.medium, color: colors.ink }}>Adicionados recentemente</h2>
            <button onClick={() => navigate('/locations')} style={{ background: 'transparent', border: 'none', fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.terracotta, cursor: 'pointer', height: 36, letterSpacing: '0.02em' }}>Ver todos</button>
          </div>
          {recentBooks.length === 0 ? (
            <div style={{ margin: `0 ${spacing[5]}`, padding: spacing[5], background: colors.bg1, border: `1px solid ${colors.line}`, borderRadius: radius.lg, textAlign: 'center' }}>
              <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkFaint }}>Nenhum livro ainda.</p>
              <button onClick={() => navigate('/scan')} style={{ background: 'transparent', border: 'none', fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.terracotta, cursor: 'pointer', marginTop: spacing[2] }}>Adicionar primeiro livro →</button>
            </div>
          ) : (
            <div style={{ display: 'flex', gap: spacing[3], overflowX: 'auto', padding: `0 ${spacing[5]} ${spacing[2]}`, scrollbarWidth: 'none' }}>
              {recentBooks.map(b => <BookCard key={b.id} book={b} onClick={() => navigate(`/book/${b.id}`)}/>)}
            </div>
          )}
        </div>

        {/* Locations */}
        <div style={{ marginTop: spacing[5], paddingBottom: spacing[4] }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: `0 ${spacing[5]}`, marginBottom: spacing[3] }}>
            <h2 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.md, fontWeight: typography.weight.medium, color: colors.ink }}>Seus lugares</h2>
            <button onClick={() => setNewLocModal(true)} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.full, width: 34, height: 34, display: 'flex', alignItems: 'center', justifyContent: 'center', color: colors.inkSoft, cursor: 'pointer' }}>
              <PlusIcon size={16}/>
            </button>
          </div>

          {currentLocations.length === 0 ? (
            <div style={{ margin: `0 ${spacing[5]}`, padding: `${spacing[5]} ${spacing[4]}`, background: colors.bg1, border: `1px solid ${colors.line}`, borderRadius: radius.lg, textAlign: 'center' }}>
              <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkFaint }}>Nenhum lugar cadastrado ainda.</p>
              <button onClick={() => setNewLocModal(true)} style={{ background: 'transparent', border: 'none', fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.terracotta, cursor: 'pointer', marginTop: spacing[2] }}>Adicionar primeiro lugar →</button>
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column' }}>
              {currentLocations.map((loc) => {
                const count = getBooksForLocation(loc.id).length;
                return (
                  <button
                    key={loc.id}
                    onClick={() => navigate(`/location/${loc.id}`)}
                    style={{ display: 'flex', alignItems: 'center', gap: spacing[3], padding: `${spacing[3]} ${spacing[5]}`, background: 'transparent', border: 'none', borderBottom: `1px solid ${colors.line}`, cursor: 'pointer', textAlign: 'left', width: '100%', minHeight: 60 }}
                  >
                    {loc.imageUrl ? (
                      <div style={{ width: 44, height: 44, borderRadius: radius.md, overflow: 'hidden', flexShrink: 0 }}>
                        <img src={loc.imageUrl} alt={loc.name} style={{ width: '100%', height: '100%', objectFit: 'cover' }} loading="lazy"/>
                      </div>
                    ) : (
                      <div style={{ width: 44, height: 44, borderRadius: radius.md, background: colors.bg2, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                        <KeyIcon size={20} color={colors.terracotta}/>
                      </div>
                    )}
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.medium, color: colors.ink }}>{loc.name}</div>
                      <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, marginTop: 2 }}>{count} {count === 1 ? 'livro' : 'livros'}</div>
                    </div>
                    <ChevronRightIcon color={colors.inkFaint}/>
                  </button>
                );
              })}
            </div>
          )}
        </div>

        {/* Quick add FAB area */}
        <div style={{ padding: `${spacing[3]} ${spacing[5]} ${spacing[8]}`, display: 'flex', gap: spacing[3] }}>
          <button onClick={() => navigate('/scan')} style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: spacing[2], background: colors.terracotta, border: 'none', borderRadius: radius.lg, height: 50, fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.ink, cursor: 'pointer' }}>
            <ScanIcon size={18}/> Escanear livro
          </button>
        </div>
      </div>

      {/* New location modal */}
      <Modal open={newLocModal} onClose={() => { setNewLocModal(false); setLocName(''); }} title="Nova Localização">
        <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
          <Input label="Nome do lugar" placeholder="ex: Sala de Estar, Quarto, Caixa 1…" value={locName} onChange={e => setLocName(e.target.value)} autoFocus onKeyDown={e => { if (e.key === 'Enter') handleCreateLocation(); }}/>
          <div style={{ display: 'flex', gap: spacing[3], justifyContent: 'flex-end' }}>
            <button onClick={() => { setNewLocModal(false); setLocName(''); }} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, padding: `${spacing[2]} ${spacing[4]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer', height: 44 }}>Cancelar</button>
            <button onClick={handleCreateLocation} disabled={!locName.trim() || locLoading} style={{ background: locLoading || !locName.trim() ? colors.bg3 : colors.moss, border: 'none', borderRadius: radius.md, padding: `${spacing[2]} ${spacing[5]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.ink, cursor: !locName.trim() || locLoading ? 'not-allowed' : 'pointer', height: 44 }}>{locLoading ? 'Criando…' : 'Criar'}</button>
          </div>
        </div>
      </Modal>
    </div>
  );
}
