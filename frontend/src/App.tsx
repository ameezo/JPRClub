import { useEffect } from 'react';
import { Routes, Route } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import PublicLayout from './layouts/PublicLayout';
import HomePage from './features/home/HomePage';

import SessionsPage from './features/sessions/SessionsPage';
import SessionDetailPage from './features/sessions/SessionDetailPage';
import JoinFormPage from './features/sessions/JoinFormPage';

import AdminLayout from './layouts/AdminLayout';
import LoginPage from './features/auth/LoginPage';
import RegisterPage from './features/auth/RegisterPage';
import AdminDashboard from './features/admin/AdminDashboard';
import SessionForm from './features/admin/SessionForm';
import SessionDocumentPage from './features/admin/SessionDocumentPage';
import AdminJournal from './features/admin/AdminJournal';
import AdminUsers from './features/admin/AdminUsers';
import AdminAudit from './features/admin/AdminAudit';
import AdminInterests from './features/admin/AdminInterests';
import AdminResources from './features/admin/AdminResources';

import MemberLayout from './layouts/MemberLayout';
import MemberDashboard from './features/member/MemberDashboard';
import JournalComposerPage from './features/journal/JournalComposerPage';

import StudioPage from './features/studio/StudioPage';
import StudioDetailPage from './features/studio/StudioDetailPage';
import GalleryPage from './features/gallery/GalleryPage';

import JournalPage from './features/journal/JournalPage';
import JournalArticlePage from './features/journal/JournalArticlePage';

import ResourcesPage from './features/resources/ResourcesPage';
import AboutPage from './features/about/AboutPage';
import ReportsPage from './features/reports/ReportsPage';
import ReportViewPage from './features/reports/ReportViewPage';
import AdminReportsPage from './features/admin/AdminReportsPage';

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
        <Route path="gallery" element={<GalleryPage />} />
        <Route path="resources" element={<ResourcesPage />} />
        <Route path="journal" element={<JournalPage />} />
        <Route path="journal/:id" element={<JournalArticlePage />} />
        <Route path="about" element={<AboutPage />} />
        <Route path="reports" element={<ReportsPage />} />
        <Route path="reports/:year" element={<ReportViewPage />} />
        <Route path="join/:type" element={<JoinFormPage />} />
        <Route path="login" element={<LoginPage />} />
        <Route path="register" element={<RegisterPage />} />
      </Route>
      
      <Route path="/admin/login" element={<LoginPage />} />
      
      <Route path="/admin" element={<AdminLayout />}>
        <Route index element={<AdminDashboard />} />
        <Route path="dashboard" element={<AdminDashboard />} />
        <Route path="sessions" element={<AdminDashboard />} />
        <Route path="sessions/new" element={<SessionForm />} />
        <Route path="sessions/:id/edit" element={<SessionForm />} />
        <Route path="sessions/:id/document" element={<SessionDocumentPage />} />
        <Route path="reports" element={<AdminReportsPage />} />
        <Route path="interests" element={<AdminInterests />} />
        <Route path="journal" element={<AdminJournal />} />
        <Route path="journal/new" element={<JournalComposerPage />} />
        <Route path="journal/:id/edit" element={<JournalComposerPage />} />
        <Route path="users" element={<AdminUsers />} />
        <Route path="resources" element={<AdminResources />} />
        <Route path="audit" element={<AdminAudit />} />
      </Route>

      <Route path="/dashboard" element={<MemberLayout />}>
        <Route index element={<MemberDashboard />} />
        <Route path="journal/new" element={<JournalComposerPage />} />
        <Route path="journal/:id/edit" element={<JournalComposerPage />} />
      </Route>
    </Routes>
  );
}

export default App;
