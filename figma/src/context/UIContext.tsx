import React, { createContext, useContext, useState, useCallback } from 'react';
import type { ReactNode } from 'react';

export type SnackbarType = 'success' | 'error' | 'info';

interface SnackbarMessage {
  id: number;
  message: string;
  type: SnackbarType;
}

interface UIState {
  snackbars: SnackbarMessage[];
  showSnackbar: (message: string, type?: SnackbarType) => void;
  drawerOpen: boolean;
  openDrawer: () => void;
  closeDrawer: () => void;
}

const UIContext = createContext<UIState | null>(null);

let snackId = 0;

export function UIProvider({ children }: { children: ReactNode }) {
  const [snackbars, setSnackbars] = useState<SnackbarMessage[]>([]);
  const [drawerOpen, setDrawerOpen] = useState(false);

  const showSnackbar = useCallback((message: string, type: SnackbarType = 'info') => {
    const id = ++snackId;
    setSnackbars(prev => [...prev, { id, message, type }]);
    setTimeout(() => {
      setSnackbars(prev => prev.filter(s => s.id !== id));
    }, 3500);
  }, []);

  const openDrawer = useCallback(() => setDrawerOpen(true), []);
  const closeDrawer = useCallback(() => setDrawerOpen(false), []);

  return (
    <UIContext.Provider value={{ snackbars, showSnackbar, drawerOpen, openDrawer, closeDrawer }}>
      {children}
    </UIContext.Provider>
  );
}

export function useUI() {
  const ctx = useContext(UIContext);
  if (!ctx) throw new Error('useUI must be used within UIProvider');
  return ctx;
}
