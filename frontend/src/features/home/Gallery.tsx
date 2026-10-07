import { useTranslation } from 'react-i18next';
import PhotoGallery from '../../components/PhotoGallery';

export default function Gallery() {
  const { t } = useTranslation();

  // Fictional placeholder data for photos
  const photos = [
    { src: 'https://picsum.photos/400/300?random=1', caption: 'Session 22 Discussion', captionAr: 'نقاش الجلسة ٢٢' },
    { src: 'https://picsum.photos/400/300?random=2', caption: 'Reading Group A', captionAr: 'مجموعة القراءة أ' },
    { src: 'https://picsum.photos/400/300?random=3', caption: 'Vocabulary Practice', captionAr: 'التدرب على المفردات' },
    { src: 'https://picsum.photos/400/300?random=4', caption: 'Coffee Break', captionAr: 'استراحة القهوة' }
  ];

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
