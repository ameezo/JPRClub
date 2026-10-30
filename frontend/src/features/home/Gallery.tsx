import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import PhotoGallery, { type Photo } from '../../components/PhotoGallery';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import { extractSessionPhotos } from '@/lib/content-utils';

export default function Gallery() {
  const { t } = useTranslation();
  const [photos, setPhotos] = useState<Photo[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchGallery = async () => {
      try {
        const response = await apiClient.get('/sessions?status=completed&limit=50');
        const sessions: Session[] = response.data.items || [];
        
        const extractedPhotos: Photo[] = [];
        sessions.forEach(session => {
          if (session.status === 'completed' && (session.documentation_status === 'published' || !session.documentation_status)) {
            const items = extractSessionPhotos(session);
            items.forEach(item => {
              extractedPhotos.push({
                src: getMediaUrl(item.url),
                caption: item.sessionTitle,
                captionAr: item.sessionTitleAr,
                sessionId: item.sessionId,
              });
            });
          }
        });
        
        // Take up to 24 recent photos for the home gallery single line
        setPhotos(extractedPhotos.slice(0, 24));
      } catch (err) {
        console.error('Failed to fetch gallery', err);
      } finally {
        setLoading(false);
      }
    };
    fetchGallery();
  }, []);

  if (loading || photos.length === 0) return null;

  return (
    <section className="section gallery-section">
      <div className="section-header">
        <h2>{t('home.communityGallery')}</h2>
        <p>{t('home.glimpses')}</p>
      </div>
      
      <PhotoGallery photos={photos} />
    </section>
  );
}
