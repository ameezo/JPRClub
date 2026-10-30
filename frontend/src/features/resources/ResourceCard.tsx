import { useState } from 'react';
import { 
  type Resource, 
  getMediaUrl 
} from '@/lib/api';
import { 
  Headphones, 
  BookOpen, 
  Globe, 
  Languages, 
  ExternalLink, 
  Edit2, 
  Trash2, 
  Star 
} from 'lucide-react';
import { useTranslation } from 'react-i18next';

const YoutubeIcon = ({ className, style }: { className?: string; style?: React.CSSProperties }) => (
  <svg viewBox="0 0 24 24" fill="currentColor" className={className} style={{ width: '48px', height: '48px', ...style }}>
    <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
  </svg>
);

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
          bgClass: 'banner-bg-podcast',
          icon: <Headphones className="banner-fallback-icon text-rose-500" style={{ color: '#e11d48' }} />,
          themeColor: '#e11d48',
        };
      case 'reading':
        return {
          label: isAr ? 'قراءة' : 'Reading',
          bgClass: 'banner-bg-reading',
          icon: <BookOpen className="banner-fallback-icon text-emerald-600" style={{ color: '#059669' }} />,
          themeColor: '#059669',
        };
      case 'youtube':
        return {
          label: isAr ? 'يوتيوب' : 'YouTube',
          bgClass: 'banner-bg-youtube',
          icon: <YoutubeIcon className="banner-fallback-icon" style={{ color: '#dc2626' }} />,
          themeColor: '#dc2626',
        };
      case 'websites':
        return {
          label: isAr ? 'مواقع' : 'Websites',
          bgClass: 'banner-bg-websites',
          icon: <Globe className="banner-fallback-icon text-blue-600" style={{ color: '#2563eb' }} />,
          themeColor: '#2563eb',
        };
      case 'grammar':
        return {
          label: isAr ? 'قواعد' : 'Grammar',
          bgClass: 'banner-bg-grammar',
          icon: <Languages className="banner-fallback-icon text-purple-600" style={{ color: '#7c3aed' }} />,
          themeColor: '#7c3aed',
        };
      case 'hiragana_katakana':
        return {
          label: isAr ? 'هيراغانا وكاتاكانا' : 'Kana',
          bgClass: 'banner-bg-hiragana_katakana',
          icon: (
            <div style={{ fontSize: '36px', fontWeight: 900, color: '#ea580c', fontFamily: 'serif' }}>
              あ
            </div>
          ),
          themeColor: '#ea580c',
        };
      default:
        return {
          label: category,
          bgClass: 'banner-bg-websites',
          icon: <Globe className="banner-fallback-icon text-blue-600" style={{ color: '#2563eb' }} />,
          themeColor: '#4b5563',
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
  const showCover = coverUrl && !imgError;

  return (
    <div className="resource-card">
      {/* Banner / Header Image */}
      <div className={`resource-card-banner ${showCover ? '' : config.bgClass}`}>
        {showCover ? (
          <img 
            src={coverUrl} 
            alt={resource.title} 
            onError={() => setImgError(true)} 
          />
        ) : (
          config.icon
        )}

        {/* Top Badges */}
        <div className="banner-badges-top">
          <span className="badge-category">{config.label}</span>
          <span className={`badge-level ${resource.level}`}>
            {getLevelLabel(resource.level, resource.jlpt_sublevel)}
          </span>
        </div>

        {/* Mais Recommended Star Badge */}
        {resource.is_recommended && (
          <div className="badge-recommended" title="Mais Recommended Pick">
            <Star style={{ width: '12px', height: '12px', fill: 'currentColor' }} />
            <span>{isAr ? 'توصية ميس' : 'Mais Pick'}</span>
          </div>
        )}
      </div>

      {/* Card Body */}
      <div className="resource-card-body">
        <h3 className="resource-card-title">{displayTitle}</h3>
        {secondaryTitle && (
          <div className="resource-card-title-ar">{secondaryTitle}</div>
        )}

        <p className="resource-card-desc">
          {displayDesc || (isAr ? 'لا يوجد وصف متاح.' : 'No description provided.')}
        </p>

        {/* Footer Actions */}
        <div className="resource-card-footer">
          <a
            href={resource.url}
            target="_blank"
            rel="noopener noreferrer"
            className="btn-visit-resource"
          >
            <span>{isAr ? 'زيارة المصدر' : 'Open Resource'}</span>
            <ExternalLink style={{ width: '14px', height: '14px' }} />
          </a>

          {isAdmin && (
            <div className="resource-admin-card-actions">
              <button
                type="button"
                className="btn-card-icon"
                title="Edit Resource"
                onClick={() => onEdit?.(resource)}
              >
                <Edit2 style={{ width: '15px', height: '15px' }} />
              </button>
              <button
                type="button"
                className="btn-card-icon delete"
                title="Delete Resource"
                onClick={() => onDelete?.(resource.id)}
              >
                <Trash2 style={{ width: '15px', height: '15px' }} />
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
