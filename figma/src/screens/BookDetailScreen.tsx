import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import { useUI } from '../context/UIContext';
import AppHeader from '../components/AppHeader';
import Modal from '../components/ui/Modal';
import Dialog from '../components/ui/Dialog';
import Input from '../components/ui/Input';
import { colors, typography, spacing, radius } from '../tokens';
import { KeyIcon, BrushIcon } from '../icons';

export default function BookDetailScreen() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { getBookById, getLocationById, currentLocations, editBook, removeBook, moveBook } = useApp();
  const { showSnackbar } = useUI();

  const book = id ? getBookById(id) : null;
  const location = book ? getLocationById(book.locationId) : null;

  const [editModal, setEditModal] = useState(false);
  const [removeDialog, setRemoveDialog] = useState(false);
  const [moveModal, setMoveModal] = useState(false);
  const [editTitle, setEditTitle] = useState('');
  const [editAuthor, setEditAuthor] = useState('');

  if (!book) {
    return (
      <div style={{ minHeight: '100vh', background: colors.bg0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: spacing[4] }}>
        <p style={{ fontFamily: typography.fontSerif, fontSize: typography.size.xl, color: colors.ink }}>Livro não encontrado</p>
        <button onClick={() => navigate(-1)} style={{ background: 'transparent', border: 'none', color: colors.terracotta, fontFamily: typography.fontSans, fontSize: typography.size.sm, cursor: 'pointer' }}>← Voltar</button>
      </div>
    );
  }

  const handleEdit = () => {
    editBook(book.id, editTitle, editAuthor);
    setEditModal(false);
    showSnackbar('Livro atualizado.', 'success');
  };

  const handleRemove = () => {
    removeBook(book.id);
    setRemoveDialog(false);
    navigate(-1);
    showSnackbar('Livro removido.', 'info');
  };

  const handleMove = (locationId: string) => {
    moveBook(book.id, locationId);
    setMoveModal(false);
    showSnackbar('Livro movido!', 'success');
  };

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <AppHeader
        title="Detalhes"
        showBack
        rightAction={
          <button onClick={() => { setEditTitle(book.title); setEditAuthor(book.author); setEditModal(true); }} style={{ background: 'transparent', border: 'none', color: colors.inkSoft, cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <BrushIcon size={20}/>
          </button>
        }
      />

      <div style={{ flex: 1, overflowY: 'auto' }}>
        {/* Cover hero */}
        <div style={{ position: 'relative', height: 280, overflow: 'hidden', flexShrink: 0 }}>
          {book.coverUrl ? (
            <img src={book.coverUrl} alt={book.title} style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}/>
          ) : (
            <div style={{ width: '100%', height: '100%', background: book.color }}/>
          )}
          {/* Overlay gradient for text legibility */}
          <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(23,21,29,0.92) 0%, rgba(23,21,29,0.2) 60%, transparent 100%)' }}/>
          <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: `${spacing[5]} ${spacing[5]} ${spacing[4]}` }}>
            <h1 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.xl, fontWeight: typography.weight.medium, color: '#EDE6D6', lineHeight: 1.2 }}>{book.title}</h1>
            <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: 'rgba(237,230,214,0.75)', marginTop: spacing[1] }}>{book.author}</p>
          </div>
        </div>

        <div style={{ padding: spacing[5], display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
          {/* Location */}
          <div style={{ background: colors.bg1, border: `1px solid ${colors.line}`, borderLeft: `3px solid ${colors.terracotta}`, borderRadius: radius.md, padding: spacing[4], display: 'flex', alignItems: 'center', gap: spacing[3] }}>
            <KeyIcon size={18} color={colors.terracotta}/>
            <div style={{ flex: 1 }}>
              <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.07em', textTransform: 'uppercase', marginBottom: 2 }}>Localização</div>
              <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.ink, fontWeight: typography.weight.medium }}>{location?.name ?? '—'}</div>
            </div>
            <button onClick={() => setMoveModal(true)} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.sm, padding: `${spacing[1]} ${spacing[3]}`, fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkSoft, cursor: 'pointer', height: 34, flexShrink: 0 }}>Mover</button>
          </div>

          {/* Genres */}
          {book.genre.length > 0 && (
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: spacing[2] }}>
              {book.genre.map(g => (
                <span key={g} style={{ background: colors.bg2, border: `1px solid ${colors.line}`, borderRadius: radius.full, padding: `${spacing[1]} ${spacing[3]}`, fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkSoft }}>
                  {g}
                </span>
              ))}
            </div>
          )}

          {/* Metadata grid */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: spacing[3] }}>
            {[
              { label: 'Ano', value: book.year },
              { label: 'Páginas', value: book.pages },
              { label: 'Adicionado por', value: book.addedBy },
              { label: 'Em', value: book.addedAt },
            ].map(({ label, value }) => (
              <div key={label} style={{ background: colors.bg1, border: `1px solid ${colors.line}`, borderRadius: radius.md, padding: spacing[3] }}>
                <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.07em', textTransform: 'uppercase', marginBottom: 4 }}>{label}</div>
                <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.ink }}>{value}</div>
              </div>
            ))}
          </div>

          {/* ISBN */}
          <div style={{ background: colors.bg1, border: `1px solid ${colors.line}`, borderRadius: radius.md, padding: spacing[3] }}>
            <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.07em', textTransform: 'uppercase', marginBottom: 4 }}>ISBN</div>
            <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.ink, letterSpacing: '0.05em' }}>{book.isbn}</div>
          </div>

          {/* Synopsis */}
          {book.synopsis && (
            <div>
              <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.07em', textTransform: 'uppercase', marginBottom: spacing[2] }}>Sinopse</div>
              <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, lineHeight: 1.7 }}>{book.synopsis}</p>
            </div>
          )}

          {/* Remove */}
          <button onClick={() => setRemoveDialog(true)} style={{ background: 'transparent', border: 'none', fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.wine, cursor: 'pointer', height: 44, textAlign: 'left', padding: `${spacing[2]} 0`, marginTop: spacing[2] }}>
            Remover da coleção
          </button>
        </div>
      </div>

      {/* Modals */}
      <Modal open={editModal} onClose={() => setEditModal(false)} title="Editar livro">
        <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
          <Input label="Título" value={editTitle} onChange={e => setEditTitle(e.target.value)}/>
          <Input label="Autor" value={editAuthor} onChange={e => setEditAuthor(e.target.value)}/>
          <div style={{ display: 'flex', gap: spacing[3], justifyContent: 'flex-end' }}>
            <button onClick={() => setEditModal(false)} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, padding: `${spacing[2]} ${spacing[4]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer', height: 44 }}>Cancelar</button>
            <button onClick={handleEdit} style={{ background: colors.moss, border: 'none', borderRadius: radius.md, padding: `${spacing[2]} ${spacing[5]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.ink, cursor: 'pointer', height: 44 }}>Salvar</button>
          </div>
        </div>
      </Modal>

      <Modal open={moveModal} onClose={() => setMoveModal(false)} title="Mover para">
        <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[2], maxHeight: 300, overflowY: 'auto' }}>
          {currentLocations.map(loc => (
            <button key={loc.id} onClick={() => handleMove(loc.id)} style={{ display: 'flex', alignItems: 'center', gap: spacing[3], background: loc.id === book.locationId ? colors.bg3 : colors.bg2, border: `1px solid ${loc.id === book.locationId ? colors.terracotta : colors.line}`, borderRadius: radius.md, padding: spacing[3], fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.ink, cursor: 'pointer', height: 52, textAlign: 'left' }}>
              <KeyIcon size={18} color={loc.id === book.locationId ? colors.terracotta : colors.inkFaint}/>{loc.name}
              {loc.id === book.locationId && <span style={{ marginLeft: 'auto', fontSize: typography.size.xs, color: colors.terracotta }}>atual</span>}
            </button>
          ))}
        </div>
      </Modal>

      <Dialog open={removeDialog} onClose={() => setRemoveDialog(false)} onConfirm={handleRemove} title="Remover livro" message={`Tem certeza que deseja remover "${book.title}" da coleção?`} confirmLabel="Remover" danger/>
    </div>
  );
}
