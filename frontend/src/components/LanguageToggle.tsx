import { useTranslation } from 'react-i18next';

export default function LanguageToggle() {
  const { i18n } = useTranslation();

  const toggleLanguage = () => {
    const nextLang = i18n.language === 'en' ? 'ar' : 'en';
    i18n.changeLanguage(nextLang);
  };

  return (
    <button 
      className="lang-toggle" 
      onClick={toggleLanguage}
      aria-label="Toggle Language"
    >
      {i18n.language === 'en' ? 'عربي' : 'EN'}
    </button>
  );
}
