import { useState, useEffect, useRef } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import { apiClient } from '@/lib/api';
import ArticleComposer, { type ArticleComposerData } from '@/components/editor/ArticleComposer';
import { Loader2 } from 'lucide-react';

interface JournalData {
  id: string;
  title: string;
  title_ar?: string;
  content: string;
  content_ar?: string;
  cover_image_url?: string | null;
  content_format?: string;
  content_language?: 'en' | 'ar';
  status: 'draft' | 'pending' | 'approved' | 'rejected';
  version: number;
  author_name?: string;
}

export default function JournalComposerPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const location = useLocation();

  const userStr = localStorage.getItem('user');
  const user = userStr ? JSON.parse(userStr) : null;
  const isAdmin = user?.role === 'admin' || user?.role === 'organizer';
  const isAdminRoute = location.pathname.startsWith('/admin');

  const backUrl = isAdminRoute ? '/admin/journal' : '/dashboard';

  const [entry, setEntry] = useState<JournalData | null>(null);
  const [loading, setLoading] = useState(!!id);
  const [error, setError] = useState<string | null>(null);
  const currentIdRef = useRef<string | undefined>(id);
  const currentVersionRef = useRef<number>(1);

  useEffect(() => {
    if (id) {
      const fetchEntry = async () => {
        try {
          const res = await apiClient.get<JournalData>(`/journal/${id}`);
          setEntry(res.data);
          currentIdRef.current = res.data.id;
          currentVersionRef.current = res.data.version;
        } catch (err: any) {
          setError(err?.response?.data?.detail || 'Failed to load journal entry.');
        } finally {
          setLoading(false);
        }
      };
      fetchEntry();
    }
  }, [id]);

  if (loading) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '60vh', gap: '16px' }}>
        <Loader2 size={32} className="animate-spin" style={{ color: '#e88599' }} />
        <p style={{ color: '#6b7280', fontSize: '14px' }}>Loading article composer...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div style={{ textAlign: 'center', padding: '64px 20px' }}>
        <h2 style={{ fontSize: '1.25rem', color: '#dc2626', marginBottom: '8px' }}>Error Loading Journal Entry</h2>
        <p style={{ color: '#6b7280', marginBottom: '24px' }}>{error}</p>
        <button
          type="button"
          onClick={() => navigate(backUrl)}
          className="btn-composer-secondary"
        >
          Go Back
        </button>
      </div>
    );
  }

  // Handle Save Draft (Auto-save and manual Save Draft)
  const handleSaveDraft = async (data: ArticleComposerData) => {
    const payload = {
      title: data.title || 'Untitled Journal Entry',
      content: data.content,
      cover_image_url: data.coverImageUrl || null,
      content_format: 'blocknote',
      content_language: data.contentLanguage,
      status: 'draft',
    };

    if (currentIdRef.current) {
      // Update existing entry
      const res = await apiClient.patch<JournalData>(`/journal/${currentIdRef.current}`, {
        ...payload,
        version: currentVersionRef.current,
      });
      setEntry(res.data);
      currentVersionRef.current = res.data.version;
    } else {
      // Create new draft entry
      const res = await apiClient.post<JournalData>('/journal', payload);
      setEntry(res.data);
      currentIdRef.current = res.data.id;
      currentVersionRef.current = res.data.version;
      // Update browser URL silently without reloading
      const newPath = isAdminRoute
        ? `/admin/journal/${res.data.id}/edit`
        : `/dashboard/journal/${res.data.id}/edit`;
      window.history.replaceState(null, '', newPath);
    }
  };

  // Handle Admin Direct Publish
  const handlePublishArticle = async (data: ArticleComposerData) => {
    if (!isAdmin) return;

    // 1. Ensure article exists & is up to date
    await handleSaveDraft(data);
    const entryId = currentIdRef.current;
    if (!entryId) return;

    // 2. Approve/publish article
    const approveRes = await apiClient.post<JournalData>(`/journal/${entryId}/approve`);
    setEntry(approveRes.data);
    currentVersionRef.current = approveRes.data.version;

    const viewPublic = confirm(
      'Article published to Journal! 🎉\n\nWould you like to view the public journal article now?'
    );
    if (viewPublic) {
      navigate(`/journal/${entryId}`);
    } else {
      navigate(backUrl);
    }
  };

  // Handle Member Submit For Review
  const handleSubmitForReview = async (data: ArticleComposerData) => {
    const payload = {
      title: data.title || 'Untitled Journal Entry',
      content: data.content,
      cover_image_url: data.coverImageUrl || null,
      content_format: 'blocknote',
      content_language: data.contentLanguage,
      status: 'pending',
    };

    if (currentIdRef.current) {
      const res = await apiClient.patch<JournalData>(`/journal/${currentIdRef.current}`, {
        ...payload,
        version: currentVersionRef.current,
      });
      setEntry(res.data);
      currentVersionRef.current = res.data.version;
    } else {
      const res = await apiClient.post<JournalData>('/journal', payload);
      setEntry(res.data);
      currentIdRef.current = res.data.id;
      currentVersionRef.current = res.data.version;
    }

    alert('Your journal article has been submitted for review! 🎉\n\nAn organizer or admin will review and publish it.');
    navigate(backUrl);
  };

  const getStatusBadge = () => {
    if (!entry) return undefined;
    switch (entry.status) {
      case 'approved':
        return 'Published';
      case 'pending':
        return 'Pending Review';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Draft';
    }
  };

  // Handle Manual Save Draft (Save and return)
  const handleManualSaveDraft = async (data: ArticleComposerData) => {
    await handleSaveDraft(data);
    if (!isAdminRoute) {
      navigate('/dashboard');
    } else {
      navigate('/admin/journal');
    }
  };

  return (
    <ArticleComposer
      initialTitle={entry?.title || ''}
      initialContent={entry?.content || null}
      initialCoverImage={entry?.cover_image_url || null}
      initialLanguage={entry?.content_language || (entry?.title_ar ? 'ar' : 'en')}
      onSaveDraft={handleSaveDraft}
      onManualSaveDraft={handleManualSaveDraft}
      onPublish={isAdmin ? handlePublishArticle : undefined}
      onSubmitReview={!isAdmin ? handleSubmitForReview : undefined}
      mode="journal"
      statusBadge={getStatusBadge()}
      backUrl={backUrl}
      titlePlaceholder="Write an engaging title..."
      canPublishDirectly={isAdmin}
      authorName={entry?.author_name}
    />
  );
}
