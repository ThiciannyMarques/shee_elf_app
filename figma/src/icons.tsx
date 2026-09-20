import React from 'react';

interface IconProps {
  size?: number;
  color?: string;
  strokeWidth?: number;
}

const base = (size: number, color: string, sw: number) => ({
  width: size, height: size,
  fill: 'none', stroke: color,
  strokeWidth: sw, strokeLinecap: 'round' as const, strokeLinejoin: 'round' as const,
});

export function LanternIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <path d="M9 3h6l1 4H8L9 3z"/>
      <rect x="7" y="7" width="10" height="11" rx="2"/>
      <path d="M9 18l1 3h4l1-3"/>
      <line x1="12" y1="7" x2="12" y2="3"/>
    </svg>
  );
}

export function KeyIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <circle cx="8.5" cy="8.5" r="5"/>
      <path d="M21 21l-8-8M13 13l2-2"/>
    </svg>
  );
}

export function BookIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <path d="M4 19.5A2.5 2.5 0 016.5 17H20"/>
      <path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/>
    </svg>
  );
}

export function PlusIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <line x1="12" y1="5" x2="12" y2="19"/>
      <line x1="5" y1="12" x2="19" y2="12"/>
    </svg>
  );
}

export function ArrowLeftIcon({ size = 24, color = 'currentColor', strokeWidth = 1.8 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <path d="M19 12H5M12 5l-7 7 7 7"/>
    </svg>
  );
}

export function SearchIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <circle cx="11" cy="11" r="7"/>
      <path d="M16.5 16.5L21 21"/>
    </svg>
  );
}

export function CheckIcon({ size = 24, color = 'currentColor', strokeWidth = 2 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <polyline points="20 6 9 17 4 12"/>
    </svg>
  );
}

export function XIcon({ size = 24, color = 'currentColor', strokeWidth = 2 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <line x1="18" y1="6" x2="6" y2="18"/>
      <line x1="6" y1="6" x2="18" y2="18"/>
    </svg>
  );
}

export function ScanIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <path d="M3 7V5a2 2 0 012-2h2M17 3h2a2 2 0 012 2v2M21 17v2a2 2 0 01-2 2h-2M7 21H5a2 2 0 01-2-2v-2"/>
      <line x1="3" y1="12" x2="21" y2="12"/>
    </svg>
  );
}

export function UsersIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
      <circle cx="9" cy="7" r="4"/>
      <path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/>
    </svg>
  );
}

export function ShareIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <circle cx="18" cy="5" r="3"/>
      <circle cx="6" cy="12" r="3"/>
      <circle cx="18" cy="19" r="3"/>
      <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/>
      <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>
    </svg>
  );
}

export function MoreVertIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <circle cx="12" cy="5" r="1.2" fill={color} stroke="none"/>
      <circle cx="12" cy="12" r="1.2" fill={color} stroke="none"/>
      <circle cx="12" cy="19" r="1.2" fill={color} stroke="none"/>
    </svg>
  );
}

export function ChevronRightIcon({ size = 20, color = 'currentColor', strokeWidth = 1.8 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <polyline points="9 18 15 12 9 6"/>
    </svg>
  );
}

export function MenuIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <line x1="3" y1="6" x2="21" y2="6"/>
      <line x1="3" y1="12" x2="21" y2="12"/>
      <line x1="3" y1="18" x2="21" y2="18"/>
    </svg>
  );
}

export function HomeIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/>
      <path d="M9 21V12h6v9"/>
    </svg>
  );
}

export function CopyIcon({ size = 20, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <rect x="9" y="9" width="13" height="13" rx="2"/>
      <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/>
    </svg>
  );
}

export function AlertIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/>
      <line x1="12" y1="9" x2="12" y2="13"/>
      <line x1="12" y1="17" x2="12.01" y2="17"/>
    </svg>
  );
}

export function BrushIcon({ size = 24, color = 'currentColor', strokeWidth = 1.5 }: IconProps) {
  return (
    <svg {...base(size, color, strokeWidth)} viewBox="0 0 24 24">
      <path d="M18.37 2.63L14 7l-1.59-1.59a2 2 0 00-2.82 0L8 7l9 9 1.59-1.59a2 2 0 000-2.82L17 10l4.37-4.37a2.12 2.12 0 00-3-3z"/>
      <path d="M9 8c-2 3-4 3.5-7 4l8 8c.5-3 1-5 4-7"/>
    </svg>
  );
}
