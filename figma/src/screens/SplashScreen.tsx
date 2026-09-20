import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import splashSvg from '../imports/splash_dark.svg';

export default function SplashScreen() {
  const navigate = useNavigate();
  const { isAuthenticated } = useApp();

  useEffect(() => {
    const timer = setTimeout(() => {
      navigate(isAuthenticated ? '/home' : '/auth', { replace: true });
    }, 2800);
    return () => clearTimeout(timer);
  }, [navigate, isAuthenticated]);

  return (
    <div style={{
      position: 'fixed', inset: 0,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      background: '#17151D',
      overflow: 'hidden',
    }}>
      <img
        src={splashSvg}
        alt="She Elf"
        style={{
          width: '100%',
          height: '100%',
          objectFit: 'cover',
          objectPosition: 'center',
          animation: 'fadeIn 0.6s ease',
        }}
      />
    </div>
  );
}
