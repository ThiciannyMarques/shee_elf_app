import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AppProvider, useApp } from './context/AppContext';
import { UIProvider } from './context/UIContext';
import { ThemeProvider } from './context/ThemeContext';
import AppShell from './components/AppShell';

import SplashScreen from './screens/SplashScreen';
import AuthScreen from './screens/AuthScreen';
import OnboardingScreen from './screens/OnboardingScreen';
import HomeScreen from './screens/HomeScreen';
import LocationsScreen from './screens/LocationsScreen';
import ShelfScreen from './screens/ShelfScreen';
import BookDetailScreen from './screens/BookDetailScreen';
import AddBookScreen from './screens/AddBookScreen';
import ConsultScreen from './screens/ConsultScreen';
import ShareScreen from './screens/ShareScreen';
import MoreScreen from './screens/MoreScreen';

function RequireAuth({ children }: { children: React.ReactNode }) {
  const { isAuthenticated } = useApp();
  if (!isAuthenticated) return <Navigate to="/auth" replace/>;
  return <>{children}</>;
}

function RootRedirect() {
  const { isAuthenticated } = useApp();
  return <Navigate to={isAuthenticated ? '/home' : '/splash'} replace/>;
}

export default function App() {
  return (
    <ThemeProvider>
      <BrowserRouter>
        <AppProvider>
          <UIProvider>
            <div style={{ width: '100%', height: '100vh', background: 'var(--bg0)', overflow: 'hidden' }}>
              <div style={{ maxWidth: 480, height: '100%', margin: '0 auto', position: 'relative', overflow: 'hidden' }}>
                <Routes>
                  <Route path="/" element={<RootRedirect/>}/>
                  <Route path="/splash" element={<SplashScreen/>}/>
                  <Route path="/auth" element={<AuthScreen/>}/>
                  <Route path="/onboarding" element={<OnboardingScreen/>}/>
                  <Route element={<RequireAuth><AppShell/></RequireAuth>}>
                    <Route path="/home" element={<HomeScreen/>}/>
                    <Route path="/locations" element={<LocationsScreen/>}/>
                    <Route path="/location/:id" element={<ShelfScreen/>}/>
                    <Route path="/book/:id" element={<BookDetailScreen/>}/>
                    <Route path="/scan" element={<AddBookScreen/>}/>
                    <Route path="/consult" element={<ConsultScreen/>}/>
                    <Route path="/share" element={<ShareScreen/>}/>
                    <Route path="/more" element={<MoreScreen/>}/>
                  </Route>
                  <Route path="*" element={<Navigate to="/" replace/>}/>
                </Routes>
              </div>
            </div>
          </UIProvider>
        </AppProvider>
      </BrowserRouter>
    </ThemeProvider>
  );
}
