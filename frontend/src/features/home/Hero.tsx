import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

export default function Hero() {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  // Fictional placeholder for the next session
  const nextSession = {
    id: "1",
    date: "Sunday, Oct 15 • 18:00 JST",
    title: "Yotsuba&! Vol. 1, Ch 1-3",
    titleAr: "يوتسوبا! المجلد 1، الفصول 1-3",
    excerpt: "Everyday Japanese life and lighthearted comedy.",
    excerptAr: "الحياة اليومية اليابانية والكوميديا الخفيفة."
  };

  return (
    <header className="hero">
      <div className="video-background">
        <video 
          autoPlay 
          muted 
          loop 
          playsInline 
          poster="/logo.jpeg"
        >
          {/* Note: In production this would come from a media server or public folder */}
          <source src="/JPRClub_test_video.mp4" type="video/mp4" />
        </video>
        <div className="hero-overlay"></div>
      </div>
      
      <div className="hero-content">
        <div className="session-panel">
          <div className="panel-badge">{t('home.nextSession')}</div>
          <h1>{isAr ? nextSession.titleAr : nextSession.title}</h1>
          <p className="session-meta">{nextSession.date}</p>
          <p className="session-excerpt">
            {isAr ? nextSession.excerptAr : nextSession.excerpt}
          </p>
          <Link to={`/sessions/${nextSession.id}`} className="button-primary">
            {t('home.joinNext')}
          </Link>
        </div>
      </div>
    </header>
  );
}
