import { useState } from 'react';
import { 
  type Resource, 
  getMediaUrl 
} from '@/lib/api';
import { 
  ExternalLink, 
  Edit2, 
  Trash2, 
  Star 
} from 'lucide-react';
import { useTranslation } from 'react-i18next';
import BookCoverFallback from '@/components/BookCoverFallback';

interface ResourceCardProps {
  resource: Resource;
  isAdmin?: boolean;
  onEdit?: (resource: Resource) => void;
  onDelete?: (id: string) => void;
}

export const ResourceCard: React.FC<ResourceCardProps> = ({
  resource,
  isAdmin = false,
  onEdit,
  onDelete,
}) => {
  const { i18n } = useTranslation();
  const isAr = i18n.language === 'ar';
  const [imgError, setImgError] = useState(false);

  const getCategoryConfig = (category: string) => {
    switch (category) {
      case 'podcast':
        return {
          label: isAr ? 'بودكاست' : 'Podcast',
          stampClass: 'stamp-podcast',
          bg: '#FEF3C7',
          color: '#92400E',
        };
      case 'reading':
        return {
          label: isAr ? 'قراءة' : 'Reading',
          stampClass: 'stamp-reading',
          bg: '#D1FAE5',
          color: '#065F46',
        };
      case 'youtube':
        return {
          label: isAr ? 'يوتيوب' : 'YouTube',
          stampClass: 'stamp-youtube',
          bg: '#FEE2E2',
          color: '#991B1B',
        };
      case 'websites':
        return {
          label: isAr ? 'مواقع' : 'Websites',
          stampClass: 'stamp-websites',
          bg: '#DBEAFE',
          color: '#1E40AF',
        };
      case 'grammar':
        return {
          label: isAr ? 'قواعد' : 'Grammar',
          stampClass: 'stamp-grammar',
          bg: '#EDE9FE',
          color: '#5B21B6',
        };
      case 'hiragana_katakana':
        return {
          label: isAr ? 'هيراغانا وكاتاكانا' : 'Kana',
          stampClass: 'stamp-kana',
          bg: '#FFEDD5',
          color: '#9A3412',
        };
      default:
        return {
          label: category,
          stampClass: 'stamp-default',
          bg: '#F3ECE0',
          color: '#1C1917',
        };
    }
  };

  const getLevelLabel = (level: string, sublevel?: string | null) => {
    if (sublevel) {
      if (level === 'starter' && sublevel === 'N5') {
        return isAr ? 'مبتدئ (N5)' : 'Starter (N5)';
      }
      return sublevel.toUpperCase();
    }
    switch (level) {
      case 'starter':
        return isAr ? 'مبتدئ' : 'Starter';
      case 'jlpt':
        return 'JLPT';
      case 'arabic_learner':
        return isAr ? 'للناطقين بالعربية' : 'Arabic Learner';
      case 'all_levels':
        return isAr ? 'جميع المستويات' : 'All Levels';
      default:
        return level;
    }
  };

  const config = getCategoryConfig(resource.category);
  const displayTitle = isAr && resource.title_ar ? resource.title_ar : resource.title;
  const secondaryTitle = isAr ? (resource.title_ar ? resource.title : null) : resource.title_ar;
  const displayDesc = isAr && resource.description_ar ? resource.description_ar : resource.description;

  const coverUrl = resource.cover_image_url ? getMediaUrl(resource.cover_image_url) : null;
  const showCover = Boolean(coverUrl && !imgError);

  return (
    <div className="tactile-card resource-card">
      {/* Banner / Header Image or Obi Book Cover Fallback */}
      <div className="resource-card-banner">
        {showCover ? (
          <img 
            src={coverUrl!} 
            alt={resource.title} 
            onError={() => setImgError(true)} 
            className="resource-banner-img"
          />
        ) : (
          <BookCoverFallback 
            category={resource.category} 
            title={resource.title} 
            aspectRatio="16 / 9" 
          />
        )}

        {/* Top Badges */}
        <div className="banner-badges-top">
          <span 
            className="tactile-stamp" 
            style={{ 
              backgroundColor: config.bg, 
              color: config.color,
              fontSize: '11px',
              padding: '2px 8px',
            }}
          >
            {config.label}
          </span>
          <span 
            className="tactile-stamp"
            style={{
              backgroundColor: '#FFFDF9',
              color: '#1C1917',
              fontSize: '11px',
              padding: '2px 8px',
            }}
          >
            {getLevelLabel(resource.level, resource.jlpt_sublevel)}
          </span>
        </div>

        {/* ★ Misa Pick Gold Stamp */}
        {resource.is_recommended && (
          <div className="badge-misa-pick" title="Misa Recommended Pick">
            <Star style={{ width: '12px', height: '12px', fill: 'currentColor' }} />
            <span>★ Misa Pick</span>
          </div>
        )}
      </div>

      {/* Card Body */}
      <div className="resource-card-body">
        <h3 className="resource-card-title">{displayTitle}</h3>

        {/* Dedicated Bilingual Arabic Subtitle row */}
        {secondaryTitle && (
          <div className="resource-card-bilingual-row" dir={isAr ? 'ltr' : 'rtl'}>
            <span className="bilingual-badge">{isAr ? 'EN' : 'AR'}</span>
            <span className="bilingual-text">{secondaryTitle}</span>
          </div>
        )}

        <p className="resource-card-desc">
          {displayDesc || (isAr ? 'لا يوجد وصف متاح.' : 'Curated Japanese learning material.')}
        </p>

        {/* Footer Actions */}
        <div className="resource-card-footer">
          <a
            href={resource.url}
            target="_blank"
            rel="noopener noreferrer"
            className="tactile-btn tactile-btn-primary btn-visit-resource"
          >
            <span>{isAr ? 'فتح المصدر' : 'Open Resource'}</span>
            <ExternalLink style={{ width: '14px', height: '14px' }} />
          </a>

          {isAdmin && (
            <div className="resource-admin-card-actions">
              <button
                type="button"
                className="tactile-btn btn-card-icon"
                title="Edit Resource"
                onClick={() => onEdit?.(resource)}
                style={{ padding: '6px' }}
              >
                <Edit2 style={{ width: '14px', height: '14px' }} />
              </button>
              <button
                type="button"
                className="tactile-btn btn-card-icon delete"
                title="Delete Resource"
                onClick={() => onDelete?.(resource.id)}
                style={{ padding: '6px', backgroundColor: '#FEE2E2', color: '#DC2626' }}
              >
                <Trash2 style={{ width: '14px', height: '14px' }} />
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
