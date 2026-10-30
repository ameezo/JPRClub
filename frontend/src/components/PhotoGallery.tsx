import { useState, useRef, useEffect, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { ChevronLeft, ChevronRight } from 'lucide-react';

export interface Photo {
  src: string;
  caption: string;
  captionAr?: string;
  sessionId?: string;
}

interface PhotoGalleryProps {
  photos: Photo[];
}

export default function PhotoGallery({ photos }: PhotoGalleryProps) {
  const { i18n } = useTranslation();
  const isAr = i18n.language === 'ar';
  const [failedIndices, setFailedIndices] = useState<Set<number>>(new Set());
  const scrollRef = useRef<HTMLDivElement>(null);
  const [canScrollLeft, setCanScrollLeft] = useState(false);
  const [canScrollRight, setCanScrollRight] = useState(false);

  const validPhotos = photos.filter((_, idx) => !failedIndices.has(idx));

  const checkScroll = useCallback(() => {
    if (scrollRef.current) {
      const { scrollLeft, scrollWidth, clientWidth } = scrollRef.current;
      const maxScroll = scrollWidth - clientWidth;
      const absScroll = Math.abs(scrollLeft);
      setCanScrollLeft(absScroll > 8);
      setCanScrollRight(maxScroll > 8 && absScroll < maxScroll - 8);
    }
  }, []);

  useEffect(() => {
    checkScroll();
    window.addEventListener('resize', checkScroll);
    return () => window.removeEventListener('resize', checkScroll);
  }, [validPhotos, checkScroll]);

  const scroll = (direction: 'left' | 'right') => {
    if (scrollRef.current) {
      const distance = 360;
      const sign = direction === 'left' ? -1 : 1;
      const delta = isAr ? -sign * distance : sign * distance;
      scrollRef.current.scrollBy({ left: delta, behavior: 'smooth' });
      setTimeout(checkScroll, 320);
    }
  };

  if (validPhotos.length === 0) return null;

  return (
    <div className="photo-gallery-container">
      {canScrollLeft && (
        <button
          type="button"
          onClick={() => scroll('left')}
          className="photo-gallery-nav-btn prev"
          aria-label={isAr ? 'الصور السابقة' : 'Previous photos'}
        >
          <ChevronLeft size={20} />
        </button>
      )}

      <div
        ref={scrollRef}
        onScroll={checkScroll}
        className="photo-gallery"
      >
        {photos.map((photo, idx) => {
          if (failedIndices.has(idx)) return null;
          const title = (isAr && photo.captionAr) ? photo.captionAr : photo.caption;
          
          const card = (
            <figure className="photo-gallery-card">
              <img 
                src={photo.src} 
                alt={title}
                loading="lazy"
                onError={() => {
                  setFailedIndices(prev => new Set(prev).add(idx));
                }}
              />
              <figcaption>
                {title}
              </figcaption>
            </figure>
          );

          if (photo.sessionId) {
            return (
              <Link 
                key={idx} 
                to={`/studio/${photo.sessionId}`}
                className="photo-gallery-item"
                title={`View session: ${title}`}
              >
                {card}
              </Link>
            );
          }

          return <div key={idx} className="photo-gallery-item">{card}</div>;
        })}
      </div>

      {canScrollRight && (
        <button
          type="button"
          onClick={() => scroll('right')}
          className="photo-gallery-nav-btn next"
          aria-label={isAr ? 'الصور التالية' : 'Next photos'}
        >
          <ChevronRight size={20} />
        </button>
      )}
    </div>
  );
}
