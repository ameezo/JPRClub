interface Photo {
  src: string;
  caption: string;
  captionAr?: string;
}

interface PhotoGalleryProps {
  photos: Photo[];
}

import { useTranslation } from 'react-i18next';

export default function PhotoGallery({ photos }: PhotoGalleryProps) {
  const { i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  return (
    <div className="photo-gallery">
      {photos.map((photo, idx) => (
        <figure key={idx}>
          <img src={photo.src} alt={(isAr && photo.captionAr) ? photo.captionAr : photo.caption} />
          <figcaption>
            {(isAr && photo.captionAr) ? photo.captionAr : photo.caption}
          </figcaption>
        </figure>
      ))}
    </div>
  );
}
