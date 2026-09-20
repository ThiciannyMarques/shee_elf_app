import React, { createContext, useContext, useState, useCallback } from 'react';
import type { ReactNode } from 'react';
import {
  currentUser as defaultUser,
  initialLibraries,
  initialLocations,
  initialBooks,
} from '../data';
import type { User, Library, Location, Book } from '../data';

interface AppState {
  user: User | null;
  isAuthenticated: boolean;
  currentLibraryId: string | null;
  libraries: Library[];
  locations: Location[];
  books: Book[];
}

interface AppActions {
  login: (email: string, password: string) => Promise<void>;
  loginBypass: () => void;
  logout: () => void;
  register: (name: string, email: string, password: string) => Promise<void>;
  setCurrentLibrary: (id: string) => void;
  createLibrary: (name: string) => Library;
  renameLibrary: (id: string, name: string) => void;
  deleteLibrary: (id: string) => void;
  joinLibrary: (code: string) => Library | null;
  createLocation: (name: string) => Location;
  renameLocation: (id: string, name: string) => void;
  deleteLocation: (id: string) => void;
  addBook: (book: Omit<Book, 'id' | 'addedBy' | 'addedAt' | 'libraryId'>) => Book;
  editBook: (id: string, title: string, author: string) => void;
  removeBook: (id: string) => void;
  moveBook: (bookId: string, locationId: string) => void;
  currentLibrary: Library | null;
  currentLocations: Location[];
  currentBooks: Book[];
  getBooksForLocation: (locationId: string) => Book[];
  getBookById: (id: string) => Book | undefined;
  getLocationById: (id: string) => Location | undefined;
}

type AppContextType = AppState & AppActions;

const AppContext = createContext<AppContextType | null>(null);

let nextId = 100;
const genId = () => `gen_${++nextId}`;

export function AppProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [currentLibraryId, setCurrentLibraryId] = useState<string | null>(null);
  const [libraries, setLibraries] = useState<Library[]>(initialLibraries);
  const [locations, setLocations] = useState<Location[]>(initialLocations);
  const [books, setBooks] = useState<Book[]>(initialBooks);

  const login = useCallback(async (_email: string, _password: string) => {
    await new Promise(r => setTimeout(r, 900));
    setUser(defaultUser);
    setIsAuthenticated(true);
    setCurrentLibraryId('lib1');
  }, []);

  const loginBypass = useCallback(() => {
    setUser(defaultUser);
    setIsAuthenticated(true);
    setCurrentLibraryId('lib1');
  }, []);

  const logout = useCallback(() => {
    setUser(null);
    setIsAuthenticated(false);
    setCurrentLibraryId(null);
  }, []);

  const register = useCallback(async (name: string, email: string, _password: string) => {
    await new Promise(r => setTimeout(r, 900));
    const newUser: User = { id: genId(), name, email };
    setUser(newUser);
    setIsAuthenticated(true);
    setCurrentLibraryId(null);
  }, []);

  const setCurrentLibrary = useCallback((id: string) => {
    setCurrentLibraryId(id);
  }, []);

  const createLibrary = useCallback((name: string): Library => {
    const lib: Library = {
      id: genId(),
      name,
      code: name.substring(0, 3).toUpperCase() + '-' + Math.floor(Math.random() * 90 + 10),
      ownerId: user?.id ?? 'u1',
      members: [{ userId: user?.id ?? 'u1', name: user?.name ?? 'Eu', role: 'owner' }],
    };
    setLibraries(prev => [...prev, lib]);
    return lib;
  }, [user]);

  const renameLibrary = useCallback((id: string, name: string) => {
    setLibraries(prev => prev.map(l => l.id === id ? { ...l, name } : l));
  }, []);

  const deleteLibrary = useCallback((id: string) => {
    setLibraries(prev => prev.filter(l => l.id !== id));
    setLocations(prev => prev.filter(l => l.libraryId !== id));
    setBooks(prev => prev.filter(b => b.libraryId !== id));
    setCurrentLibraryId(prev => prev === id ? null : prev);
  }, []);

  const joinLibrary = useCallback((code: string): Library | null => {
    const found = libraries.find(l => l.code.toLowerCase() === code.toLowerCase());
    if (found) {
      setCurrentLibraryId(found.id);
    }
    return found ?? null;
  }, [libraries]);

  const createLocation = useCallback((name: string): Location => {
    const loc: Location = {
      id: genId(),
      libraryId: currentLibraryId ?? 'lib1',
      name,
      roomType: name,
    };
    setLocations(prev => [...prev, loc]);
    return loc;
  }, [currentLibraryId]);

  const renameLocation = useCallback((id: string, name: string) => {
    setLocations(prev => prev.map(l => l.id === id ? { ...l, name } : l));
  }, []);

  const deleteLocation = useCallback((id: string) => {
    setLocations(prev => prev.filter(l => l.id !== id));
  }, []);

  const addBook = useCallback((data: Omit<Book, 'id' | 'addedBy' | 'addedAt' | 'libraryId'>): Book => {
    const book: Book = {
      ...data,
      id: genId(),
      libraryId: currentLibraryId ?? 'lib1',
      addedBy: user?.name ?? 'Eu',
      addedAt: new Date().toISOString().slice(0, 10),
    };
    setBooks(prev => [book, ...prev]);
    return book;
  }, [currentLibraryId, user]);

  const editBook = useCallback((id: string, title: string, author: string) => {
    setBooks(prev => prev.map(b => b.id === id ? { ...b, title, author } : b));
  }, []);

  const removeBook = useCallback((id: string) => {
    setBooks(prev => prev.filter(b => b.id !== id));
  }, []);

  const moveBook = useCallback((bookId: string, locationId: string) => {
    setBooks(prev => prev.map(b => b.id === bookId ? { ...b, locationId } : b));
  }, []);

  const currentLibrary = libraries.find(l => l.id === currentLibraryId) ?? null;
  const currentLocations = locations.filter(l => l.libraryId === currentLibraryId);
  const currentBooks = books.filter(b => b.libraryId === currentLibraryId);

  const getBooksForLocation = useCallback((locationId: string) =>
    books.filter(b => b.locationId === locationId && b.libraryId === currentLibraryId),
    [books, currentLibraryId]);

  const getBookById = useCallback((id: string) => books.find(b => b.id === id), [books]);
  const getLocationById = useCallback((id: string) => locations.find(l => l.id === id), [locations]);

  return (
    <AppContext.Provider value={{
      user, isAuthenticated, currentLibraryId, libraries, locations, books,
      login, loginBypass, logout, register,
      setCurrentLibrary, createLibrary, renameLibrary, deleteLibrary, joinLibrary,
      createLocation, renameLocation, deleteLocation,
      addBook, editBook, removeBook, moveBook,
      currentLibrary, currentLocations, currentBooks,
      getBooksForLocation, getBookById, getLocationById,
    }}>
      {children}
    </AppContext.Provider>
  );
}

export function useApp() {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error('useApp must be used within AppProvider');
  return ctx;
}
