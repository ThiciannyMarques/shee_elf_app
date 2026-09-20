import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import AppHeader from '../components/AppHeader';
import { colors, typography, spacing, radius } from '../tokens';
import { ScanIcon } from '../icons';

export default function ShelfScreen() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { getLocationById, getBooksForLocation } = useApp();
  const [filter, setFilter] = useState('Todos');

  const location = id ? getLocationById(id) : null;
  const books = id ? getBooksForLocation(id) : [];
  const genres = ['Todos', ...Array.from(new Set(books.flatMap(b => b.genre)))];
  const filtered = filter === 'Todos' ? books : books.filter(b => b.genre.includes(filter));

  const BOOKS_PER_ROW = 6;
  const rows: typeof filtered[] = [];
  for (let i = 0; i < filtered.length; i += BOOKS_PER_ROW) rows.push(filtered.slice(i, i + BOOKS_PER_ROW));

  if (!location) {
    return (
      <div style={{ minHeight: '100vh', background: colors.bg0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <p style={{ fontFamily: typography.fontSans, color: colors.inkFaint }}>Lugar não encontrado.</p>
      </div>
    );
  }

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      {/* Location hero */}
      {location.imageUrl ? (
        <div style={{ position: 'relative', height: 120, flexShrink: 0, overflow: 'hidden' }}>
          <img src={location.imageUrl} alt={location.name} style={{ width: '100%', height: '100%', objectFit: 'cover' }}/>
          <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(23,21,29,0.85) 0%, rgba(23,21,29,0.2) 100%)' }}/>
          <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: `0 ${spacing[5]} ${spacing[4]}`, display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between' }}>
            <div>
              <button onClick={() => navigate(-1)} style={{ background: 'transparent', border: 'none', color: 'rgba(237,230,214,0.7)', fontFamily: typography.fontSans, fontSize: typography.size.xs, cursor: 'pointer', padding: '0 0 4px', display: 'block' }}>← Voltar</button>
              <h1 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.xl, color: '#EDE6D6' }}>{location.name}</h1>
            </div>
            <span style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: 'rgba(237,230,214,0.6)' }}>{books.length} livros</span>
          </div>
        </div>
      ) : (
        <AppHeader title={location.name} showBack subtitle={`${books.length} ${books.length === 1 ? 'livro' : 'livros'}`}/>
      )}

      {/* Genre chips */}
      <div style={{ overflowX: 'auto', display: 'flex', gap: spacing[2], padding: `${spacing[3]} ${spacing[4]}`, borderBottom: `1px solid ${colors.line}`, scrollbarWidth: 'none', flexShrink: 0 }}>
        {genres.map(g => (
          <button key={g} onClick={() => setFilter(g)} style={{ flexShrink: 0, background: filter === g ? colors.terracotta : colors.bg2, border: filter === g ? 'none' : `1px solid ${colors.lineStrong}`, borderRadius: radius.full, padding: `${spacing[1]} ${spacing[4]}`, fontFamily: typography.fontSans, fontSize: typography.size.xs, fontWeight: filter === g ? typography.weight.semibold : typography.weight.regular, color: filter === g ? '#EDE6D6' : colors.inkSoft, cursor: 'pointer', height: 32, whiteSpace: 'nowrap' }}>
            {g}
          </button>
        ))}
      </div>

      {/* Books + shelves - scrollable */}
      <div style={{ flex: 1, overflowY: 'auto', padding: spacing[4] }}>
        {filtered.length === 0 ? (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: `${spacing[10]} ${spacing[6]}`, gap: spacing[4] }}>
            <div style={{ width: 64, height: 64, borderRadius: radius.xl, background: colors.bg2, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <ScanIcon size={28} color={colors.inkFaint}/>
            </div>
            <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkFaint, textAlign: 'center', lineHeight: 1.6 }}>
              {books.length === 0 ? 'Esta prateleira está vazia.\nAdicione livros pelo scanner.' : `Nenhum livro com o gênero "${filter}".`}
            </p>
            {books.length === 0 && (
              <button onClick={() => navigate('/scan')} style={{ background: colors.terracotta, border: 'none', borderRadius: radius.md, padding: `${spacing[3]} ${spacing[6]}`, height: 48, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.ink, cursor: 'pointer' }}>Escanear livro</button>
            )}
          </div>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[6] }}>
            {rows.map((row, ri) => (
              <div key={ri}>
                <div style={{ display: 'flex', alignItems: 'flex-end', gap: 4, overflowX: 'auto', scrollbarWidth: 'none' }}>
                  {row.map(book => {
                    const thickness = Math.max(22, Math.min(44, Math.floor(book.pages / 18)));
                    const height = Math.max(130, Math.min(190, 130 + book.pages / 12));
                    return (
                      <button
                        key={book.id}
                        onClick={() => navigate(`/book/${book.id}`)}
                        title={`${book.title} — ${book.author}`}
                        style={{ width: thickness, height, background: book.color, borderRadius: '3px 3px 0 0', flexShrink: 0, border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', overflow: 'hidden', position: 'relative' }}
                      >
                        {book.coverUrl && (
                          <img src={book.coverUrl} alt="" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', objectFit: 'cover', opacity: 0.6 }} loading="lazy"/>
                        )}
                        <span style={{ position: 'relative', fontFamily: typography.fontSerif, fontSize: '9px', color: 'rgba(237,230,214,0.9)', writingMode: 'vertical-rl', textOrientation: 'mixed', transform: 'rotate(180deg)', maxHeight: '88%', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', lineHeight: 1.2, letterSpacing: '0.04em', padding: '0 3px' }}>{book.title}</span>
                      </button>
                    );
                  })}
                </div>
                <div style={{ height: 14, background: colors.woodMid, borderRadius: '0 0 4px 4px', borderTop: `3px solid ${colors.wood}` }}/>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
