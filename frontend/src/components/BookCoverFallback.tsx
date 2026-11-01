import React from 'react';

export interface BookCoverFallbackProps {
  category?: string | null;
  title?: string | null;
  className?: string;
  style?: React.CSSProperties;
  aspectRatio?: string;
}

interface CategoryTheme {
  bg: string;
  kanji: string;
  stamp: string;
  tagColor: string;
}

function getCategoryTheme(category?: string | null): CategoryTheme {
  const norm = (category || '').trim().toLowerCase();

  if (norm.includes('novel') || norm.includes('رواية') || norm.includes('literature') || norm.includes('book')) {
    return {
      bg: '#FDE2E4',
      kanji: '小説',
      stamp: '文学 • LITERATURE',
      tagColor: '#9F1239',
    };
  }
  if (norm.includes('manga') || norm.includes('مانجا') || norm.includes('comic')) {
    return {
      bg: '#D8F3DC',
      kanji: '漫画',
      stamp: '漫 • MANGA',
      tagColor: '#065F46',
    };
  }
  if (norm.includes('essay') || norm.includes('مقال') || norm.includes('zuihitsu') || norm.includes('podcast')) {
    return {
      bg: '#FEF3C7',
      kanji: '随筆',
      stamp: '随筆 • ESSAY',
      tagColor: '#92400E',
    };
  }

  // ARTICLE / Default reading
  return {
    bg: '#E0E7FF',
    kanji: '記事',
    stamp: '読物 • READING',
    tagColor: '#3730A3',
  };
}

export default function BookCoverFallback({
  category,
  title,
  className = '',
  style = {},
  aspectRatio = '16 / 9',
}: BookCoverFallbackProps) {
  const theme = getCategoryTheme(category);
  const displayTitle = title ? title.trim() : 'JPR Club Library';

  return (
    <div
      className={`book-cover-fallback ${className}`}
      style={{
        position: 'relative',
        width: '100%',
        aspectRatio: aspectRatio,
        backgroundColor: theme.bg,
        borderBottom: '1.5px solid #1C1917',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between',
        userSelect: 'none',
        boxSizing: 'border-box',
        ...style,
      }}
    >
      {/* Decorative Book Spine Texture Accent on Left */}
      <div
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          bottom: 0,
          width: '7px',
          background: 'linear-gradient(to right, rgba(28,25,23,0.28), rgba(28,25,23,0.02))',
          zIndex: 2,
          pointerEvents: 'none',
        }}
      />

      {/* Top Header: Stamped Hanko Badge */}
      <div
        style={{
          position: 'relative',
          zIndex: 3,
          display: 'flex',
          justifyContent: 'flex-end',
          padding: '10px 14px',
        }}
      >
        <span
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '4px',
            fontSize: '10px',
            fontWeight: 800,
            letterSpacing: '0.08em',
            textTransform: 'uppercase',
            color: '#1C1917',
            backgroundColor: 'rgba(255, 253, 249, 0.92)',
            border: '1.5px solid #1C1917',
            padding: '2px 8px',
            borderRadius: '4px',
            boxShadow: '1.5px 1.5px 0px #1C1917',
            fontFamily: "system-ui, -apple-system, sans-serif",
          }}
        >
          {theme.stamp}
        </span>
      </div>

      {/* Large Decorative Kanji Watermark */}
      <div
        aria-hidden="true"
        style={{
          position: 'absolute',
          right: '8px',
          bottom: '24px',
          fontSize: '4.75rem',
          fontWeight: 900,
          lineHeight: 1,
          fontFamily: "'Noto Serif JP', serif",
          color: '#1C1917',
          opacity: 0.14,
          pointerEvents: 'none',
          zIndex: 1,
        }}
      >
        {theme.kanji}
      </div>

      {/* Lower Obi (Belly-Band) Strip */}
      <div
        style={{
          position: 'relative',
          zIndex: 3,
          backgroundColor: '#FFFDF9',
          borderTop: '1.5px solid #1C1917',
          padding: '8px 14px',
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
        }}
      >
        <span
          style={{
            display: 'inline-block',
            width: '6px',
            height: '6px',
            backgroundColor: '#D9385A',
            borderRadius: '50%',
            flexShrink: 0,
          }}
        />
        <span
          style={{
            fontFamily: "'Fraunces', 'Noto Serif JP', Georgia, serif",
            fontWeight: 700,
            fontSize: '13px',
            color: '#1C1917',
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            letterSpacing: '-0.01em',
          }}
        >
          {displayTitle}
        </span>
      </div>
    </div>
  );
}

