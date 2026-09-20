import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import { useUI } from '../context/UIContext';
import AppHeader from '../components/AppHeader';
import Modal from '../components/ui/Modal';
import Dialog from '../components/ui/Dialog';
import Input from '../components/ui/Input';
import { colors, typography, spacing, radius } from '../tokens';
import { KeyIcon, PlusIcon, ChevronRightIcon, BrushIcon, XIcon } from '../icons';

export default function LocationsScreen() {
  const navigate = useNavigate();
  const { currentLocations, getBooksForLocation, createLocation, renameLocation, deleteLocation } = useApp();
  const { showSnackbar } = useUI();

  const [newModal, setNewModal] = useState(false);
  const [renameModal, setRenameModal] = useState<string | null>(null);
  const [deleteDialog, setDeleteDialog] = useState<string | null>(null);
  const [newName, setNewName] = useState('');
  const [renameName, setRenameName] = useState('');

  const handleCreate = () => {
    if (!newName.trim()) return;
    createLocation(newName.trim());
    setNewName('');
    setNewModal(false);
    showSnackbar('Lugar criado!', 'success');
  };

  const handleRename = () => {
    if (!renameModal || !renameName.trim()) return;
    renameLocation(renameModal, renameName.trim());
    setRenameModal(null);
    setRenameName('');
  };

  const handleDelete = (id: string) => {
    deleteLocation(id);
    setDeleteDialog(null);
    showSnackbar('Lugar removido.', 'info');
  };

  const locToDelete = currentLocations.find(l => l.id === deleteDialog);

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <AppHeader
        title="Lugares"
        subtitle="Onde seus livros estão guardados"
        rightAction={
          <button onClick={() => setNewModal(true)} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.full, width: 40, height: 40, display: 'flex', alignItems: 'center', justifyContent: 'center', color: colors.inkSoft, cursor: 'pointer' }}>
            <PlusIcon size={18}/>
          </button>
        }
      />

      {currentLocations.length === 0 ? (
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: `${spacing[8]} ${spacing[6]}`, gap: spacing[5] }}>
          <div style={{ width: 80, height: 80, borderRadius: radius.xl, background: colors.bg2, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <KeyIcon size={36} color={colors.terracotta}/>
          </div>
          <div style={{ textAlign: 'center' }}>
            <h2 style={{ fontFamily: typography.fontSerif, fontSize: typography.size.xl, color: colors.ink }}>Nenhum lugar ainda</h2>
            <p style={{ fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkFaint, marginTop: spacing[2], lineHeight: 1.6 }}>Adicione lugares como "Sala de Estar", "Quarto" ou "Caixa 1" para organizar seus livros.</p>
          </div>
          <button onClick={() => setNewModal(true)} style={{ background: colors.moss, border: 'none', borderRadius: radius.md, padding: `${spacing[3]} ${spacing[6]}`, height: 48, fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.ink, cursor: 'pointer' }}>Adicionar primeiro lugar</button>
        </div>
      ) : (
        <div style={{ flex: 1, overflowY: 'auto' }}>
          {currentLocations.map(loc => {
            const count = getBooksForLocation(loc.id).length;
            return (
              <div key={loc.id} style={{ display: 'flex', alignItems: 'center', borderBottom: `1px solid ${colors.line}` }}>
                <button onClick={() => navigate(`/location/${loc.id}`)} style={{ flex: 1, display: 'flex', alignItems: 'center', gap: spacing[3], padding: `${spacing[3]} ${spacing[5]}`, background: 'transparent', border: 'none', cursor: 'pointer', textAlign: 'left', minHeight: 64 }}>
                  {loc.imageUrl ? (
                    <div style={{ width: 48, height: 48, borderRadius: radius.md, overflow: 'hidden', flexShrink: 0 }}>
                      <img src={loc.imageUrl} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} loading="lazy"/>
                    </div>
                  ) : (
                    <div style={{ width: 48, height: 48, borderRadius: radius.md, background: colors.bg2, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                      <KeyIcon size={22} color={colors.terracotta}/>
                    </div>
                  )}
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: typography.weight.medium, color: colors.ink }}>{loc.name}</div>
                    <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, marginTop: 2 }}>{count} {count === 1 ? 'livro' : 'livros'}</div>
                  </div>
                  <ChevronRightIcon color={colors.inkFaint}/>
                </button>
                <div style={{ display: 'flex', gap: 2, paddingRight: spacing[3], flexShrink: 0 }}>
                  <button onClick={() => { setRenameModal(loc.id); setRenameName(loc.name); }} style={{ background: 'transparent', border: 'none', width: 40, height: 40, display: 'flex', alignItems: 'center', justifyContent: 'center', color: colors.inkFaint, cursor: 'pointer', borderRadius: radius.sm }}>
                    <BrushIcon size={16}/>
                  </button>
                  <button onClick={() => setDeleteDialog(loc.id)} style={{ background: 'transparent', border: 'none', width: 40, height: 40, display: 'flex', alignItems: 'center', justifyContent: 'center', color: colors.inkFaint, cursor: 'pointer', borderRadius: radius.sm }}>
                    <XIcon size={16}/>
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      )}

      <Modal open={newModal} onClose={() => { setNewModal(false); setNewName(''); }} title="Nova Localização">
        <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
          <Input label="Nome" placeholder="ex: Sala de Estar, Quarto, Caixa 1…" value={newName} onChange={e => setNewName(e.target.value)} autoFocus onKeyDown={e => { if (e.key === 'Enter') handleCreate(); }}/>
          <div style={{ display: 'flex', gap: spacing[3], justifyContent: 'flex-end' }}>
            <button onClick={() => { setNewModal(false); setNewName(''); }} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, padding: `${spacing[2]} ${spacing[4]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer', height: 44 }}>Cancelar</button>
            <button onClick={handleCreate} disabled={!newName.trim()} style={{ background: !newName.trim() ? colors.bg3 : colors.moss, border: 'none', borderRadius: radius.md, padding: `${spacing[2]} ${spacing[5]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.ink, cursor: !newName.trim() ? 'not-allowed' : 'pointer', height: 44 }}>Criar</button>
          </div>
        </div>
      </Modal>

      <Modal open={!!renameModal} onClose={() => setRenameModal(null)} title="Renomear localização">
        <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
          <Input label="Novo nome" value={renameName} onChange={e => setRenameName(e.target.value)} autoFocus onKeyDown={e => { if (e.key === 'Enter') handleRename(); }}/>
          <div style={{ display: 'flex', gap: spacing[3], justifyContent: 'flex-end' }}>
            <button onClick={() => setRenameModal(null)} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, padding: `${spacing[2]} ${spacing[4]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer', height: 44 }}>Cancelar</button>
            <button onClick={handleRename} disabled={!renameName.trim()} style={{ background: !renameName.trim() ? colors.bg3 : colors.moss, border: 'none', borderRadius: radius.md, padding: `${spacing[2]} ${spacing[5]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.ink, cursor: !renameName.trim() ? 'not-allowed' : 'pointer', height: 44 }}>Salvar</button>
          </div>
        </div>
      </Modal>

      <Dialog open={!!deleteDialog} onClose={() => setDeleteDialog(null)} onConfirm={() => deleteDialog && handleDelete(deleteDialog)} title="Remover lugar" message={`Tem certeza que deseja remover "${locToDelete?.name}"? Os livros não serão excluídos.`} confirmLabel="Remover" danger/>
    </div>
  );
}
