import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import en from './en.json';
import ar from './ar.json';

const savedLanguage = localStorage.getItem('i18nextLng') || localStorage.getItem('language');
const initialLanguage = savedLanguage === 'en' ? 'en' : 'ar';

i18n
  .use(initReactI18next)
  .init({
    resources: {
      en: { translation: en },
      ar: { translation: ar },
    },
    lng: initialLanguage,
    fallbackLng: 'ar',
    interpolation: {
      escapeValue: false, // React already escapes values
    },
  });

i18n.on('languageChanged', (lng) => {
  localStorage.setItem('i18nextLng', lng);
});

export default i18n;
