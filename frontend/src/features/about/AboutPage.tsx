import { useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { CLUB_SOCIAL_LINKS } from '../../lib/links';
import { WhatsAppIcon, InstagramIcon, YouTubeIcon, SpotifyIcon } from '../../components/SocialIcons';

export default function AboutPage() {
  const { t } = useTranslation();
  const location = useLocation();

  useEffect(() => {
    if (location.hash === '#connect') {
      const el = document.getElementById('connect');
      if (el) {
        // Small timeout ensures component layout has settled on initial load / route transition
        setTimeout(() => {
          el.scrollIntoView({ behavior: 'smooth' });
        }, 50);
      }
    } else {
      window.scrollTo({ top: 0, behavior: 'instant' });
    }
  }, [location.pathname, location.hash]);

  return (
    <div className="about-page-wrapper">
      <div className="container-custom">
        
        {/* 1. Compact Page Introduction */}
        <header className="about-hero">
          <h1 className="about-title">{t('about.pageTitle')}</h1>
          <p className="about-descriptor">{t('about.shortDescriptor')}</p>
          <p className="about-intro-text">{t('about.introP1')}</p>
          <p className="about-intro-text">{t('about.introP2')}</p>
        </header>

        {/* 2. What happens here / ماذا نفعل؟ */}
        <section className="about-section" aria-labelledby="about-what-we-do">
          <h2 id="about-what-we-do" className="about-section-heading">{t('about.whatWeDo.title')}</h2>
          <div className="public-grid">
            <div className="about-activity-card">
              <h3 className="activity-card-title">{t('about.whatWeDo.card1Title')}</h3>
              <p className="activity-card-desc">{t('about.whatWeDo.card1Desc')}</p>
            </div>
            
            <div className="about-activity-card">
              <h3 className="activity-card-title">{t('about.whatWeDo.card2Title')}</h3>
              <p className="activity-card-desc">{t('about.whatWeDo.card2Desc')}</p>
            </div>
            
            <div className="about-activity-card">
              <h3 className="activity-card-title">{t('about.whatWeDo.card3Title')}</h3>
              <p className="activity-card-desc">{t('about.whatWeDo.card3Desc')}</p>
            </div>
          </div>
        </section>

        {/* 3. What guides us / ما الذي نؤمن به؟ */}
        <section className="about-section" aria-labelledby="about-principles">
          <h2 id="about-principles" className="about-section-heading">{t('about.principles.title')}</h2>
          <div className="about-principles-card">
            <ul className="principles-list">
              <li className="principles-item">
                <span className="principles-bullet" aria-hidden="true">✓</span>
                <span>{t('about.principles.item1')}</span>
              </li>
              <li className="principles-item">
                <span className="principles-bullet" aria-hidden="true">✓</span>
                <span>{t('about.principles.item2')}</span>
              </li>
              <li className="principles-item">
                <span className="principles-bullet" aria-hidden="true">✓</span>
                <span>{t('about.principles.item3')}</span>
              </li>
            </ul>
          </div>
        </section>

        {/* 4. Explore the club / اكتشف النادي */}
        <section className="about-section" aria-labelledby="about-explore">
          <h2 id="about-explore" className="about-section-heading">{t('about.explore.title')}</h2>
          <div className="about-explore-grid">
            <Link to="/sessions" className="about-explore-card">
              <div>
                <h3 className="explore-card-title">
                  <span>{t('about.explore.sessionsTitle')}</span>
                  <span className="explore-card-arrow" aria-hidden="true">→</span>
                </h3>
                <p className="explore-card-desc">{t('about.explore.sessionsDesc')}</p>
              </div>
            </Link>

            <Link to="/studio" className="about-explore-card">
              <div>
                <h3 className="explore-card-title">
                  <span>{t('about.explore.studioTitle')}</span>
                  <span className="explore-card-arrow" aria-hidden="true">→</span>
                </h3>
                <p className="explore-card-desc">{t('about.explore.studioDesc')}</p>
              </div>
            </Link>

            <Link to="/reports" className="about-explore-card">
              <div>
                <h3 className="explore-card-title">
                  <span>{t('about.explore.reportsTitle')}</span>
                  <span className="explore-card-arrow" aria-hidden="true">→</span>
                </h3>
                <p className="explore-card-desc">{t('about.explore.reportsDesc')}</p>
              </div>
            </Link>
          </div>
        </section>

        {/* 5. Connect / تواصل وتابعنا (Anchor #connect) */}
        <section id="connect" className="about-section" aria-labelledby="about-connect-heading">
          <div className="about-connect-section">
            <h2 id="about-connect-heading" className="about-section-heading" style={{ marginBottom: '1rem' }}>
              {t('about.connect.title')}
            </h2>
            <p className="about-connect-lead">{t('about.connect.lead')}</p>
            
            <div className="about-connect-grid">
              <a 
                href={CLUB_SOCIAL_LINKS.whatsapp} 
                target="_blank" 
                rel="noopener noreferrer" 
                className="connect-action-btn connect-btn-whatsapp"
              >
                <WhatsAppIcon size={22} />
                <span>{t('about.connect.whatsapp')}</span>
              </a>

              <a 
                href={CLUB_SOCIAL_LINKS.instagram} 
                target="_blank" 
                rel="noopener noreferrer" 
                className="connect-action-btn connect-btn-instagram"
              >
                <InstagramIcon size={22} />
                <span>{t('about.connect.instagram')}</span>
              </a>

              <a 
                href={CLUB_SOCIAL_LINKS.youtube} 
                target="_blank" 
                rel="noopener noreferrer" 
                className="connect-action-btn connect-btn-youtube"
              >
                <YouTubeIcon size={22} />
                <span>{t('about.connect.youtube')}</span>
              </a>

              <a 
                href={CLUB_SOCIAL_LINKS.spotify} 
                target="_blank" 
                rel="noopener noreferrer" 
                className="connect-action-btn connect-btn-spotify"
              >
                <SpotifyIcon size={22} />
                <span>{t('about.connect.spotify')}</span>
              </a>
            </div>
          </div>
        </section>

      </div>
    </div>
  );
}
