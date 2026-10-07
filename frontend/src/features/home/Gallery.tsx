import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import PhotoGallery from '../../components/PhotoGallery';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';

export default function Gallery() {
  const { t } = useTranslation();
  const [photos, setPhotos] = useState<{ src: string; caption: string; captionAr?: string }[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchGallery = async () => {
      try {
        const response = await apiClient.get('/sessions?status=completed&limit=5');
        const sessions: Session[] = response.data.items;
        
        const extractedPhotos: { src: string; caption: string; captionAr?: string }[] = [];
        sessions.forEach(session => {
          if (session.gallery_images && session.gallery_images.length > 0) {
            session.gallery_images.forEach(img => {
              extractedPhotos.push({
                src: getMediaUrl(img),
                caption: session.title,
                captionAr: session.title_ar
              });
            });
          }
        });
        
        // Take up to 6 photos for the home gallery
        setPhotos(extractedPhotos.slice(0, 6));
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
