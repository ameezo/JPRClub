import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { CLUB_SOCIAL_LINKS } from '../lib/links';
import { WhatsAppIcon, InstagramIcon, YouTubeIcon, SpotifyIcon } from './SocialIcons';

export default function Footer() {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  const marqueeText = '✦ 読書クラブ • JAPANESE READING CLUB ✦ WEEKLY READING SESSIONS ✦ NOVELS • MANGA • ESSAYS ✦ CURATED BY LEARNERS FOR LEARNERS ✦ つづく (TO BE CONTINUED) ';

  return (
    <div className="site-footer-wrapper">
      {/* Scrolling Editorial Marquee */}
      <div className="editorial-marquee" aria-hidden="true">
        <div className="editorial-marquee-track">
          <span>{marqueeText}</span>
          <span>{marqueeText}</span>
          <span>{marqueeText}</span>
          <span>{marqueeText}</span>
        </div>
      </div>

      {/* High-Contrast Ink Footer */}
      <footer className="site-footer">
        <div className="footer-container">
          {/* Top Conversational Callout */}
          <div className="footer-callout-row">
            <div className="footer-callout-text">
              <span className="footer-callout-badge">JPR CLUB</span>
              <h3 className="footer-callout-title">
                {isAr
                  ? 'مستعد للقراءة معنا؟ انضم إلينا في جلستنا القادمة.'
                  : 'Ready to read together? Pull up a chair at our next session.'}
              </h3>
            </div>
            <Link to="/sessions" className="tactile-btn tactile-btn-primary footer-callout-btn">
              {isAr ? 'عرض الجلسات القادمة ←' : 'Explore Upcoming Sessions →'}
            </Link>
          </div>

          <div className="footer-divider" />

          {/* Bottom Row: Links, Social Icons, Copyright */}
          <div className="footer-bottom-row">
            <div className="footer-links">
              <Link to="/sessions">{t('nav.sessions')}</Link>
              <Link to="/studio">{t('nav.studio')}</Link>
              <Link to="/gallery">{t('nav.gallery')}</Link>
              <Link to="/resources">{t('nav.resources')}</Link>
              <Link to="/journal">{t('nav.journal')}</Link>
              <Link to="/about">{t('nav.about')}</Link>
              <Link to="/reports">{t('nav.reports')}</Link>
            </div>

            <div className="footer-social-row" aria-label="Social links">
              <a
                href={CLUB_SOCIAL_LINKS.whatsapp}
                target="_blank"
                rel="noopener noreferrer"
                className="footer-social-pill"
                aria-label={t('footer.social.whatsapp') || 'WhatsApp'}
                title={t('footer.social.whatsapp') || 'WhatsApp'}
              >
                <WhatsAppIcon size={17} />
              </a>
              <a
                href={CLUB_SOCIAL_LINKS.instagram}
                target="_blank"
                rel="noopener noreferrer"
                className="footer-social-pill"
                aria-label={t('footer.social.instagram') || 'Instagram'}
                title={t('footer.social.instagram') || 'Instagram'}
              >
                <InstagramIcon size={17} />
              </a>
              <a
                href={CLUB_SOCIAL_LINKS.youtube}
                target="_blank"
                rel="noopener noreferrer"
                className="footer-social-pill"
                aria-label={t('footer.social.youtube') || 'YouTube'}
                title={t('footer.social.youtube') || 'YouTube'}
              >
                <YouTubeIcon size={17} />
              </a>
              <a
                href={CLUB_SOCIAL_LINKS.spotify}
                target="_blank"
                rel="noopener noreferrer"
                className="footer-social-pill"
                aria-label={t('footer.social.spotify') || 'Spotify'}
                title={t('footer.social.spotify') || 'Spotify'}
              >
                <SpotifyIcon size={17} />
              </a>
            </div>
          </div>

          <div className="footer-copy-row">
            <span>{t('footer.rights') || '© 2026 Japanese Reading Club • Curated with washi & ink'}</span>
            <span className="footer-kanji-stamp">つづく</span>
          </div>
        </div>
      </footer>
    </div>
  );
}
