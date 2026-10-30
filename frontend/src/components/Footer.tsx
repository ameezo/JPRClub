import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { CLUB_SOCIAL_LINKS } from '../lib/links';
import { WhatsAppIcon, InstagramIcon, YouTubeIcon, SpotifyIcon } from './SocialIcons';

export default function Footer() {
  const { t } = useTranslation();

  return (
    <footer className="site-footer">
      <div className="footer-links">
        <Link to="/about">{t('nav.about')}</Link>
        <Link to="/reports">{t('nav.reports')}</Link>
        <Link to="/about#connect">{t('nav.contact')}</Link>
      </div>

      <div className="footer-social-row" aria-label="Social links">
        <a 
          href={CLUB_SOCIAL_LINKS.whatsapp} 
          target="_blank" 
          rel="noopener noreferrer" 
          className="footer-social-link"
          aria-label={t('footer.social.whatsapp') || 'WhatsApp'}
          title={t('footer.social.whatsapp') || 'WhatsApp'}
        >
          <WhatsAppIcon size={18} />
        </a>
        <a 
          href={CLUB_SOCIAL_LINKS.instagram} 
          target="_blank" 
          rel="noopener noreferrer" 
          className="footer-social-link"
          aria-label={t('footer.social.instagram') || 'Instagram'}
          title={t('footer.social.instagram') || 'Instagram'}
        >
          <InstagramIcon size={18} />
        </a>
        <a 
          href={CLUB_SOCIAL_LINKS.youtube} 
          target="_blank" 
          rel="noopener noreferrer" 
          className="footer-social-link"
          aria-label={t('footer.social.youtube') || 'YouTube'}
          title={t('footer.social.youtube') || 'YouTube'}
        >
          <YouTubeIcon size={18} />
        </a>
        <a 
          href={CLUB_SOCIAL_LINKS.spotify} 
          target="_blank" 
          rel="noopener noreferrer" 
          className="footer-social-link"
          aria-label={t('footer.social.spotify') || 'Spotify'}
          title={t('footer.social.spotify') || 'Spotify'}
        >
          <SpotifyIcon size={18} />
        </a>
      </div>

      <div className="footer-copy">
        {t('footer.rights') || '© 2026 Japanese Reading Club'}
      </div>
    </footer>
  );
}
