import { useEffect } from 'react';
import { Routes, Route } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import PublicLayout from './layouts/PublicLayout';
import HomePage from './features/home/HomePage';

// Placeholder Pages
const SessionsPage = () => <div style={{ padding: '150px 5%' }}><h1>Sessions</h1><p>Placeholder</p></div>;
const StudioPage = () => <div style={{ padding: '150px 5%' }}><h1>Reading Studio</h1><p>Placeholder</p></div>;
const ResourcesPage = () => <div style={{ padding: '150px 5%' }}><h1>Resources</h1><p>Placeholder</p></div>;
const JournalPage = () => <div style={{ padding: '150px 5%' }}><h1>Journal</h1><p>Placeholder</p></div>;
const AboutPage = () => <div style={{ padding: '150px 5%' }}><h1>About</h1><p>Placeholder</p></div>;

function App() {
  const { i18n } = useTranslation();

  useEffect(() => {
    // Update HTML dir and lang attributes based on current language
    document.documentElement.dir = i18n.language === 'ar' ? 'rtl' : 'ltr';
    document.documentElement.lang = i18n.language;
  }, [i18n.language]);

  return (
    <Routes>
      <Route path="/" element={<PublicLayout />}>
        <Route index element={<HomePage />} />
        <Route path="sessions" element={<SessionsPage />} />
        <Route path="studio" element={<StudioPage />} />
        <Route path="resources" element={<ResourcesPage />} />
        <Route path="journal" element={<JournalPage />} />
        <Route path="about" element={<AboutPage />} />
      </Route>
    </Routes>
  );
}

export default App;
