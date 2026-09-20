import React, { useState } from 'react';
import { useApp } from '../context/AppContext';
import { useUI } from '../context/UIContext';
import Drawer from '../components/ui/Drawer';
import Modal from '../components/ui/Modal';
import Dialog from '../components/ui/Dialog';
import Input from '../components/ui/Input';
import { colors, typography, spacing, radius } from '../tokens';
import { PlusIcon, BrushIcon, XIcon, CheckIcon } from '../icons';

export default function CollectionsDrawer() {
  const { libraries, currentLibraryId, setCurrentLibrary, createLibrary, renameLibrary, deleteLibrary } = useApp();
  const { drawerOpen, closeDrawer, showSnackbar } = useUI();

  const [newModal, setNewModal] = useState(false);
  const [renameModal, setRenameModal] = useState<string | null>(null);
  const [deleteDialog, setDeleteDialog] = useState<string | null>(null);
  const [newName, setNewName] = useState('');
  const [renameName, setRenameName] = useState('');

  const handleCreate = () => {
    if (!newName.trim()) return;
    const lib = createLibrary(newName.trim());
    setCurrentLibrary(lib.id);
    setNewName('');
    setNewModal(false);
    closeDrawer();
    showSnackbar('Coleção criada!', 'success');
  };

  const handleRename = () => {
    if (!renameModal || !renameName.trim()) return;
    renameLibrary(renameModal, renameName.trim());
    setRenameModal(null);
    setRenameName('');
  };

  const handleDelete = (id: string) => {
    deleteLibrary(id);
    setDeleteDialog(null);
    showSnackbar('Coleção excluída.', 'info');
  };

  const libToDelete = libraries.find(l => l.id === deleteDialog);

  return (
    <>
      <Drawer open={drawerOpen} onClose={closeDrawer} title="Minhas Coleções">
        <div style={{ padding: `${spacing[3]} ${spacing[4]}`, display: 'flex', flexDirection: 'column', gap: spacing[1] }}>
          {libraries.map(lib => {
            const isActive = lib.id === currentLibraryId;
            return (
              <div
                key={lib.id}
                style={{
                  borderRadius: radius.md,
                  border: `1px solid ${isActive ? colors.terracotta : 'transparent'}`,
                  borderLeft: `3px solid ${isActive ? colors.terracotta : 'transparent'}`,
                  background: isActive ? colors.bg2 : 'transparent',
                  overflow: 'hidden',
                }}
              >
                <button
                  onClick={() => { setCurrentLibrary(lib.id); closeDrawer(); }}
                  style={{
                    width: '100%', display: 'flex', alignItems: 'center', gap: spacing[3],
                    padding: `${spacing[3]} ${spacing[4]}`,
                    background: 'transparent', border: 'none',
                    cursor: 'pointer', textAlign: 'left', minHeight: 56,
                  }}
                >
                  {isActive && <CheckIcon size={14} color={colors.terracotta}/>}
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.base, fontWeight: isActive ? typography.weight.semibold : typography.weight.regular, color: isActive ? colors.ink : colors.inkSoft, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{lib.name}</div>
                    <div style={{ fontFamily: typography.fontSans, fontSize: typography.size.xs, color: colors.inkFaint, marginTop: 2 }}>{lib.members.length} {lib.members.length === 1 ? 'leitor' : 'leitores'} · Código: {lib.code}</div>
                  </div>
                </button>
                <div style={{ display: 'flex', padding: `0 ${spacing[2]} ${spacing[2]}`, gap: 4, justifyContent: 'flex-end' }}>
                  <button onClick={() => { setRenameModal(lib.id); setRenameName(lib.name); }} style={{ background: 'transparent', border: 'none', width: 36, height: 36, display: 'flex', alignItems: 'center', justifyContent: 'center', color: colors.inkFaint, cursor: 'pointer', borderRadius: radius.sm }}>
                    <BrushIcon size={15}/>
                  </button>
                  {libraries.length > 1 && (
                    <button onClick={() => setDeleteDialog(lib.id)} style={{ background: 'transparent', border: 'none', width: 36, height: 36, display: 'flex', alignItems: 'center', justifyContent: 'center', color: colors.inkFaint, cursor: 'pointer', borderRadius: radius.sm }}>
                      <XIcon size={15}/>
                    </button>
                  )}
                </div>
              </div>
            );
          })}

          <button
            onClick={() => setNewModal(true)}
            style={{
              display: 'flex', alignItems: 'center', gap: spacing[2],
              marginTop: spacing[2], padding: `${spacing[3]} ${spacing[4]}`,
              background: 'transparent', border: `1px dashed ${colors.lineStrong}`,
              borderRadius: radius.md, height: 48,
              fontFamily: typography.fontSans, fontSize: typography.size.sm,
              color: colors.inkFaint, cursor: 'pointer', width: '100%',
            }}
          >
            <PlusIcon size={16}/> Nova coleção
          </button>
        </div>
      </Drawer>

      {/* New collection modal */}
      <Modal open={newModal} onClose={() => { setNewModal(false); setNewName(''); }} title="Nova Coleção">
        <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
          <Input label="Nome da Coleção" placeholder="ex: Casa, Trabalho, Vovó..." value={newName} onChange={e => setNewName(e.target.value)} autoFocus onKeyDown={e => { if (e.key === 'Enter') handleCreate(); }}/>
          <div style={{ display: 'flex', gap: spacing[3], justifyContent: 'flex-end' }}>
            <button onClick={() => { setNewModal(false); setNewName(''); }} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, padding: `${spacing[2]} ${spacing[4]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer', height: 44 }}>Cancelar</button>
            <button onClick={handleCreate} disabled={!newName.trim()} style={{ background: !newName.trim() ? colors.bg3 : colors.moss, border: 'none', borderRadius: radius.md, padding: `${spacing[2]} ${spacing[5]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.ink, cursor: !newName.trim() ? 'not-allowed' : 'pointer', height: 44 }}>Criar</button>
          </div>
        </div>
      </Modal>

      {/* Rename modal */}
      <Modal open={!!renameModal} onClose={() => setRenameModal(null)} title="Renomear coleção">
        <div style={{ display: 'flex', flexDirection: 'column', gap: spacing[4] }}>
          <Input label="Novo nome" value={renameName} onChange={e => setRenameName(e.target.value)} autoFocus onKeyDown={e => { if (e.key === 'Enter') handleRename(); }}/>
          <div style={{ display: 'flex', gap: spacing[3], justifyContent: 'flex-end' }}>
            <button onClick={() => setRenameModal(null)} style={{ background: 'transparent', border: `1px solid ${colors.lineStrong}`, borderRadius: radius.md, padding: `${spacing[2]} ${spacing[4]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, color: colors.inkSoft, cursor: 'pointer', height: 44 }}>Cancelar</button>
            <button onClick={handleRename} disabled={!renameName.trim()} style={{ background: !renameName.trim() ? colors.bg3 : colors.moss, border: 'none', borderRadius: radius.md, padding: `${spacing[2]} ${spacing[5]}`, fontFamily: typography.fontSans, fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.ink, cursor: !renameName.trim() ? 'not-allowed' : 'pointer', height: 44 }}>Salvar</button>
          </div>
        </div>
      </Modal>

      {/* Delete dialog */}
      <Dialog open={!!deleteDialog} onClose={() => setDeleteDialog(null)} onConfirm={() => deleteDialog && handleDelete(deleteDialog)} title="Excluir coleção" message={`Tem certeza que deseja excluir "${libToDelete?.name}"? Todos os livros e lugares desta coleção serão removidos.`} confirmLabel="Excluir" danger/>
    </>
  );
}
