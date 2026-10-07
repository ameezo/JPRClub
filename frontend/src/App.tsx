import { useEffect } from 'react';
import { Routes, Route } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import PublicLayout from './layouts/PublicLayout';
import HomePage from './features/home/HomePage';

import SessionsPage from './features/sessions/SessionsPage';
import SessionDetailPage from './features/sessions/SessionDetailPage';

import AdminLayout from './layouts/AdminLayout';
import LoginPage from './features/admin/LoginPage';
import AdminDashboard from './features/admin/AdminDashboard';
import SessionForm from './features/admin/SessionForm';

import StudioPage from './features/studio/StudioPage';
import StudioDetailPage from './features/studio/StudioDetailPage';

// Placeholder Pages
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
        <Route path="sessions/:id" element={<SessionDetailPage />} />
        <Route path="studio" element={<StudioPage />} />
        <Route path="studio/:id" element={<StudioDetailPage />} />
        <Route path="resources" element={<ResourcesPage />} />
        <Route path="journal" element={<JournalPage />} />
        <Route path="about" element={<AboutPage />} />
      </Route>
      
      <Route path="/admin/login" element={<LoginPage />} />
      <Route path="/admin" element={<AdminLayout />}>
        <Route index element={<AdminDashboard />} />
        <Route path="sessions" element={<AdminDashboard />} />
        <Route path="sessions/new" element={<SessionForm />} />
        <Route path="sessions/:id/edit" element={<SessionForm />} />
      </Route>
    </Routes>
  );
}

export default App;
