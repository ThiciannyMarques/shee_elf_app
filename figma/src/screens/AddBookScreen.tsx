import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import { useUI } from '../context/UIContext';
import AppHeader from '../components/AppHeader';
import Input from '../components/ui/Input';
import { colors, typography, spacing, radius, bookSpineColors } from '../tokens';
import { LanternIcon, ScanIcon, KeyIcon, PlusIcon } from '../icons';

type Stage = 'scanning' | 'permission-denied' | 'found' | 'manual' | 'adding' | 'success';

const FAKE_RESULT = {
  title: 'A Roda do Tempo — As Origens',
  author: 'Robert Jordan',
  isbn: '9788576574392',
  year: 2004,
  pages: 680,
  genre: ['Fantasia', 'Épico'],
  synopsis: 'A história que antecede a grande saga A Roda do Tempo.',
  color: bookSpineColors[0],
  coverUrl: 'https://images.unsplash.com/photo-1633477189729-9290b3261d0a?w=400&h=600&fit=crop&q=80',
};

const GENRES_LIST = ['Fantasia', 'Ficção Científica', 'Romance', 'Clássico', 'Histórico', 'Sátira', 'Distopia', 'Aventura', 'Terror', 'Poesia', 'Biográfico', 'Autoajuda', 'Técnico'];

export default function AddBookScreen() {
  const navigate = useNavigate();
  const { currentLocations, addBook } = useApp();
  const { showSnackbar } = useUI();

  const [stage, setStage] = useState<Stage>('scanning');
  const [selectedLocation, setSelectedLocation] = useState(currentLocations[0]?.id ?? '');
  const [addedBook, setAddedBook] = useState<ReturnType<typeof addBook> | null>(null);

  // Manual form state
  const [manualTitle, setManualTitle] = useState('');
  const [manualAuthor, setManualAuthor] = useState('');
  const [manualIsbn, setManualIsbn] = useState('');
  const [manualYear, setManualYear] = useState('');
  const [manualPages, setManualPages] = useState('');
  const [manualSynopsis, setManualSynopsis] = useState('');
  const [manualGenres, setManualGenres] = useState<string[]>([]);
  const [manualErrors, setManualErrors] = useState<Record<string, string>>({});

  const handleSimulateScan = () => setStage('found');

  const handleConfirmAdd = () => {
    if (!selectedLocation) return;
    setStage('adding');
    setTimeout(() => {
      const book = addBook({ ...FAKE_RESULT, locationId: selectedLocation });
      setAddedBook(book);
      setStage('success');
    }, 1200);
  };

  const validateManual = () => {
    const errs: Record<string, string> = {};
    if (!manualTitle.trim()) errs.title = 'Título é obrigatório';
    if (!manualAuthor.trim()) errs.author = 'Autor é obrigatório';
    if (!selectedLocation) errs.location = 'Selecione um lugar';
    setManualErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleManualAdd = () => {
    if (!validateManual()) return;
    setStage('adding');
    setTimeout(() => {
      const book = addBook({
        title: manualTitle.trim(),
        author: manualAuthor.trim(),
        isbn: manualIsbn.trim() || 'sem ISBN',
        year: parseInt(manualYear) || new Date().getFullYear(),
        pages: parseInt(manualPages) || 200,
        genre: manualGenres,
        synopsis: manualSynopsis.trim(),
        locationId: selectedLocation,
        color: bookSpineColors[Math.floor(Math.random() * bookSpineColors.length)],
      });
      setAddedBook(book);
      setStage('success');
    }, 1200);
  };

  const toggleGenre = (g: string) => setManualGenres(prev => prev.includes(g) ? prev.filter(x => x !== g) : [...prev, g]);

  const locationName = currentLocations.find(l => l.id === selectedLocation)?.name ?? '—';

  const LocationPicker = () => (
    <div>
      <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: spacing[2] }}>Guardar em {manualErrors.location && <span style={{ color: colors.wine, textTransform: 'none', letterSpacing: 0 }}>— {manualErrors.location}</span>}</div>
      {currentLocations.length === 0 ? (
        <div style={{ background: colors.bg2, border: `1px solid ${colors.line}`, borderRadius: radius.md, padding: spacing[4], textAlign: 'center' }}>
          <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkFaint }}>Nenhum lugar cadastrado.</p>
          <button onClick={() => navigate('/locations')} style={{ background: 'transparent', border: 'none', color: colors.terracotta, fontFamily: typography.fontSans, fontSize: typography.size.sm, cursor: 'pointer', marginTop: spacing[1] }}>Criar um lugar →</button>
        </div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[2], maxHeight: 180, overflowY: 'auto' }}>
          {currentLocations.map(loc => (
            <button key={loc.id} onClick={() => { setSelectedLocation(loc.id); setManualErrors(e => ({ ...e, location: '' })); }} style={{ display: 'flex', alignItems: 'center', gap: spacing[3], background: selectedLocation === loc.id ? colors.bg3 : colors.bg1, border: `1px solid ${selectedLocation === loc.id ? colors.terracotta : colors.line}`, borderRadius: radius.md, padding: `${spacing[2]} ${spacing[3]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.ink, cursor: 'pointer', height: 48, textAlign: 'left', transition: 'all 0.15s' }}>
              <KeyIcon size={16} color={selectedLocation === loc.id ? colors.terracotta : colors.inkFaint}/>{loc.name}
            </button>
          ))}
        </div>
      )}
    </div>
  );

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <AppHeader title="Adicionar livro" showBack/>

      <div style={{ flex: 1, overflowY: 'auto' }}>

        {/* ── SCANNING ── */}
        {stage === 'scanning' && (
          <div style={{ padding: `${spacing[5]} ${spacing[4]}`, display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
            {/* Camera viewport with embedded "tutorial" */}
            <div style={{ width: '100%', height: 260, borderRadius: radius.xl, overflow: 'hidden', position: 'relative', background: colors.bg2, border: `2px dashed ${colors.lineStrong}` }}>
              {/* Embedded video - cozy library atmosphere */}
              <iframe
                src="https://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=0&mute=1&controls=0&loop=1&playlist=dQw4w9WgXcQ&modestbranding=1"
                style={{ position: 'absolute', inset: '-60px', width: 'calc(100% + 120px)', height: 'calc(100% + 120px)', border: 'none', pointerEvents: 'none', filter: 'brightness(0.35)' }}
                allow="autoplay"
                title="camera-preview"
              />
              {/* Corner brackets */}
              {[['top','left'],['top','right'],['bottom','left'],['bottom','right']].map(([v,h]) => (
                <div key={`${v}${h}`} style={{ position: 'absolute', [v]: 16, [h]: 16, width: 28, height: 28, borderTop: v==='top' ? `2.5px solid ${colors.butter}` : 'none', borderBottom: v==='bottom' ? `2.5px solid ${colors.butter}` : 'none', borderLeft: h==='left' ? `2.5px solid ${colors.butter}` : 'none', borderRight: h==='right' ? `2.5px solid ${colors.butter}` : 'none', borderRadius: v==='top'&&h==='left' ? '4px 0 0 0' : v==='top'&&h==='right' ? '0 4px 0 0' : v==='bottom'&&h==='left' ? '0 0 0 4px' : '0 0 4px 0' }}/>
              ))}
              {/* Animated scan line */}
              <div style={{ position: 'absolute', left: 20, right: 20, height: 2, background: colors.butter, opacity: 0.7, animation: 'scanLine 2s linear infinite', top: '30%' }}/>
              <div style={{ position: 'absolute', bottom: spacing[4], left: 0, right: 0, textAlign: 'center' }}>
                <span style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: 'rgba(237,230,214,0.8)', letterSpacing: '0.06em' }}>Aponte para o código de barras</span>
              </div>
            </div>

            <button onClick={handleSimulateScan} style={{ background: colors.terracotta, border: 'none', borderRadius: radius.lg, height: 52, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: '#EDE6D6', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: spacing[2] }}>
              <ScanIcon size={20}/> Simular leitura
            </button>

            <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[2], alignItems: 'center' }}>
              <button onClick={() => setStage('manual')} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, height: 48, width: '100%', fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer' }}>
                Não tem código de barras? Cadastrar manualmente
              </button>
              <button onClick={() => setStage('permission-denied')} style={{ background: 'transparent', border: 'none', fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, cursor: 'pointer', opacity: 0.5, height: 36 }}>Simular permissão negada</button>
            </div>
          </div>
        )}

        {/* ── PERMISSION DENIED ── */}
        {stage === 'permission-denied' && (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: `${spacing[10]} ${spacing[5]}`, gap: spacing[5] }}>
            <div style={{ width: 80, height: 80, borderRadius: '50%', background: 'rgba(180,105,108,0.15)', border: `1px solid ${colors.wine}`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke={colors.wine} strokeWidth="1.5" strokeLinecap="round"><circle cx="12" cy="12" r="9"/><path d="M5.7 5.7l12.6 12.6"/></svg>
            </div>
            <div style={{ textAlign: 'center' }}>
              <h2 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.xl, color: colors.ink }}>Câmera não disponível</h2>
              <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, lineHeight: 1.6, marginTop: spacing[2] }}>Permita o acesso à câmera nas configurações do dispositivo para usar o scanner.</p>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', width: '100%', gap: spacing[3] }}>
              <button onClick={() => setStage('scanning')} style={{ background: colors.moss, border: 'none', borderRadius: radius.md, height: 50, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: '#EDE6D6', cursor: 'pointer' }}>Tentar novamente</button>
              <button onClick={() => setStage('manual')} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, height: 48, fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.inkSoft, cursor: 'pointer' }}>Cadastrar manualmente</button>
            </div>
          </div>
        )}

        {/* ── FOUND ── */}
        {stage === 'found' && (
          <div style={{ padding: `${spacing[5]} ${spacing[4]}`, display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
            <div style={{ display: 'flex', gap: spacing[4], background: colors.bg1, border: `1px solid ${colors.lineStrong}`, borderRadius: radius.lg, padding: spacing[4] }}>
              {FAKE_RESULT.coverUrl && (
                <div style={{ width: 80, height: 110, borderRadius: radius.md, overflow: 'hidden', flexShrink: 0 }}>
                  <img src={FAKE_RESULT.coverUrl} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }}/>
                </div>
              )}
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.moss, letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: spacing[1] }}>Livro encontrado</div>
                <h2 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.md, fontWeight: typography.weight.medium, color: colors.ink, lineHeight: 1.3 }}>{FAKE_RESULT.title}</h2>
                <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, marginTop: 4 }}>{FAKE_RESULT.author}</p>
                <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, marginTop: 4 }}>{FAKE_RESULT.year} · {FAKE_RESULT.pages} págs.</p>
              </div>
            </div>

            <LocationPicker/>

            <div style={{ display: 'flex', gap: spacing[3] }}>
              <button onClick={() => setStage('scanning')} style={{ flex: 1, background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, height: 50, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer' }}>Não é este livro</button>
              <button onClick={handleConfirmAdd} disabled={!selectedLocation} style={{ flex: 2, background: !selectedLocation ? colors.bg3 : colors.moss, border: 'none', borderRadius: radius.md, height: 50, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: '#EDE6D6', cursor: !selectedLocation ? 'not-allowed' : 'pointer' }}>Adicionar à biblioteca</button>
            </div>
          </div>
        )}

        {/* ── MANUAL ── */}
        {stage === 'manual' && (
          <div style={{ padding: `${spacing[4]} ${spacing[4]} ${spacing[8]}`, display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
            <div style={{ background: colors.bg1, border: `1px solid ${colors.line}`, borderRadius: radius.md, padding: spacing[3] }}>
              <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, lineHeight: 1.5 }}>Preencha os dados do livro. Campos marcados com * são obrigatórios.</p>
            </div>

            {/* Required fields */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[3] }}>
              <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.08em', textTransform: 'uppercase' }}>Dados principais</div>
              <Input label="Título *" placeholder="Título do livro" value={manualTitle} onChange={e => { setManualTitle(e.target.value); setManualErrors(er => ({ ...er, title: '' })); }} error={manualErrors.title}/>
              <Input label="Autor *" placeholder="Nome do autor" value={manualAuthor} onChange={e => { setManualAuthor(e.target.value); setManualErrors(er => ({ ...er, author: '' })); }} error={manualErrors.author}/>
            </div>

            {/* Optional fields */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[3] }}>
              <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.08em', textTransform: 'uppercase' }}>Informações adicionais</div>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: spacing[3] }}>
                <Input label="ISBN" placeholder="9780000000000" value={manualIsbn} onChange={e => setManualIsbn(e.target.value)}/>
                <Input label="Ano" placeholder="2024" type="number" value={manualYear} onChange={e => setManualYear(e.target.value)}/>
              </div>
              <Input label="Número de páginas" placeholder="280" type="number" value={manualPages} onChange={e => setManualPages(e.target.value)}/>
              <div>
                <label style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.08em', textTransform: 'uppercase', display: 'block', marginBottom: spacing[2] }}>Sinopse</label>
                <textarea
                  value={manualSynopsis}
                  onChange={e => setManualSynopsis(e.target.value)}
                  placeholder="Breve descrição do livro..."
                  rows={3}
                  style={{ background: colors.bg2, border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, padding: spacing[3], fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.ink, outline: 'none', width: '100%', resize: 'vertical', minHeight: 80 }}
                />
              </div>
            </div>

            {/* Genre picker */}
            <div>
              <div style={{ fontFamily: typography.fontSans, fontSize: '11px', color: colors.inkFaint, letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: spacing[2] }}>Gêneros</div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: spacing[2] }}>
                {GENRES_LIST.map(g => (
                  <button key={g} onClick={() => toggleGenre(g)} style={{ background: manualGenres.includes(g) ? colors.plum : colors.bg2, border: `1px solid ${manualGenres.includes(g) ? colors.plum : colors.lineStrong}`, borderRadius: radius.full, padding: `${spacing[1]} ${spacing[3]}`, fontFamily: typography.fontSans, fontSize: typography.size.xs, color: manualGenres.includes(g) ? '#EDE6D6' : colors.inkSoft, cursor: 'pointer', height: 32, transition: 'all 0.15s' }}>
                    {g}
                  </button>
                ))}
              </div>
            </div>

            {/* Location */}
            <LocationPicker/>

            {/* Actions */}
            <div style={{ display: 'flex', gap: spacing[3] }}>
              <button onClick={() => setStage('scanning')} style={{ flex: 1, background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, height: 50, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer' }}>Cancelar</button>
              <button onClick={handleManualAdd} style={{ flex: 2, background: colors.moss, border: 'none', borderRadius: radius.md, height: 50, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: '#EDE6D6', cursor: 'pointer' }}>
                <PlusIcon size={16} color="#EDE6D6"/> Adicionar
              </button>
            </div>
          </div>
        )}

        {/* ── LOADING ── */}
        {stage === 'adding' && (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '60vh', gap: spacing[5] }}>
            <div style={{ animation: 'lanternSway 1.5s ease-in-out infinite alternate', transformOrigin: 'top center' }}>
              <LanternIcon size={64} color={colors.butter}/>
            </div>
            <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, fontStyle: 'italic' }}>Guardando nas prateleiras…</p>
          </div>
        )}

        {/* ── SUCCESS ── */}
        {stage === 'success' && addedBook && (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: `${spacing[10]} ${spacing[5]}`, gap: spacing[5] }}>
            <div style={{ position: 'relative' }}>
              {addedBook.coverUrl ? (
                <div style={{ width: 120, height: 160, borderRadius: radius.lg, overflow: 'hidden' }}>
                  <img src={addedBook.coverUrl} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }}/>
                </div>
              ) : (
                <div style={{ width: 120, height: 160, borderRadius: radius.lg, background: addedBook.color }}/>
              )}
              {/* Sparkles */}
              {[['-20px','-16px'],['130px','-10px'],['125px','155px'],['-15px','150px']].map(([l, t], i) => (
                <div key={i} style={{ position: 'absolute', left: l, top: t }}>
                  <svg width="18" height="18" viewBox="0 0 24 24" fill={colors.butter}>
                    <path d="M12 2 L13.5 10.5 L22 12 L13.5 13.5 L12 22 L10.5 13.5 L2 12 L10.5 10.5 Z"/>
                  </svg>
                </div>
              ))}
            </div>
            <div style={{ textAlign: 'center' }}>
              <h2 style={{ fontFamily: typography.fontSerif, fontSize: typography.size['2xl'], fontWeight: typography.weight.medium, color: colors.ink }}>Livro adicionado!</h2>
              <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, marginTop: spacing[2], lineHeight: 1.6 }}>
                <strong style={{ color: colors.ink }}>{addedBook.title}</strong><br/>guardado em <strong style={{ color: colors.terracotta }}>{locationName}</strong>
              </p>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[3], width: '100%' }}>
              <button onClick={() => navigate(`/book/${addedBook.id}`)} style={{ background: colors.moss, border: 'none', borderRadius: radius.md, height: 50, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: '#EDE6D6', cursor: 'pointer' }}>Ver detalhes do livro</button>
              <button onClick={() => { setStage('scanning'); setAddedBook(null); setManualTitle(''); setManualAuthor(''); setManualIsbn(''); setManualYear(''); setManualPages(''); setManualSynopsis(''); setManualGenres([]); }} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, height: 48, fontFamily: typography.fontSans, fontSize: typography.size.base, color: colors.inkSoft, cursor: 'pointer' }}>Adicionar outro livro</button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
