import { useTranslation } from 'react-i18next';

export default function LanguageToggle() {
  const { i18n } = useTranslation();

  const toggleLanguage = () => {
    const nextLang = i18n.language === 'en' ? 'ar' : 'en';
    i18n.changeLanguage(nextLang);
  };

  return (
    <button 
      type="button"
      className="tactile-btn lang-toggle-btn" 
      onClick={toggleLanguage}
      aria-label="Toggle Language"
    >
      <span className="lang-globe-icon">🌐</span>
      <span>{i18n.language === 'en' ? 'عربي' : 'EN'}</span>
    </button>
  );
}
