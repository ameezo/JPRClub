import { useState, useEffect, type FormEvent } from 'react';
import { useParams, useSearchParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { 
  ArrowLeft, 
  ArrowRight, 
  CheckCircle2, 
  HandHeart, 
  Users, 
  Lightbulb, 
  MessageCircle, 
  Calendar,
  Sparkles,
  AlertCircle
} from 'lucide-react';
import Container from '@/components/ui/Container';
import { apiClient, WHATSAPP_GROUP_URL, type Session } from '@/lib/api';

type JoinType = 'volunteer' | 'team' | 'instructor';

export default function JoinFormPage() {
  const { type } = useParams<{ type: string }>();
  const [searchParams] = useSearchParams();
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  const validTypes: JoinType[] = ['volunteer', 'team', 'instructor'];
  const activeType: JoinType = validTypes.includes(type as JoinType) 
    ? (type as JoinType) 
    : 'volunteer';

  const sessionId = searchParams.get('sessionId');
  const [session, setSession] = useState<Session | null>(null);

  // Form states
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [message, setMessage] = useState('');
  
  const [loading, setLoading] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  // Pre-fill user details if logged in
  useEffect(() => {
    try {
      const stored = localStorage.getItem('user');
      if (stored) {
        const u = JSON.parse(stored);
        if (u.name) setFullName(u.name);
        if (u.email) setEmail(u.email);
        if (u.phone) setPhone(u.phone);
      }
    } catch {
      // ignore
    }
  }, []);

  // Fetch session details if sessionId was provided
  useEffect(() => {
    if (!sessionId) return;
    async function fetchSession() {
      try {
        const res = await apiClient.get(`/sessions/${sessionId}`);
        setSession(res.data);
      } catch (err) {
        console.error('Failed to load session info:', err);
      }
    }
    fetchSession();
  }, [sessionId]);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setErrorMsg(null);

    if (!fullName.trim() || !email.trim() || !phone.trim()) {
      setErrorMsg(isAr ? 'يرجى ملء جميع الحقول المطلوبة' : 'Please fill in all required fields');
      return;
    }

    setLoading(true);
    try {
      await apiClient.post('/session-interests', {
        type: activeType,
        full_name: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        message: message.trim(),
        session_id: sessionId || null,
      });
      setSubmitted(true);
    } catch (err: any) {
      console.error('Failed to submit interest:', err);
      const detail = err.response?.data?.detail;
      setErrorMsg(
        typeof detail === 'string' 
          ? detail 
          : (isAr ? 'حدث خطأ أثناء الإرسال. يرجى المحاولة مرة أخرى.' : 'Failed to submit. Please try again.')
      );
    } finally {
      setLoading(false);
    }
  };

  const getIcon = () => {
    switch (activeType) {
      case 'volunteer':
        return <HandHeart style={{ width: '28px', height: '28px', color: '#e88599' }} />;
      case 'team':
        return <Users style={{ width: '28px', height: '28px', color: '#a855f7' }} />;
      case 'instructor':
        return <Lightbulb style={{ width: '28px', height: '28px', color: '#f59e0b' }} />;
    }
  };

  const sessionTitle = session 
    ? (isAr && session.title_ar ? session.title_ar : session.title)
    : null;

  return (
    <div className="public-page-wrapper bg-gray join-page-wrapper">
      <Container>
        <div className="join-nav-back">
          <Link to="/" className="btn-back-link">
            {isAr ? <ArrowRight style={{ width: '16px', height: '16px' }} /> : <ArrowLeft style={{ width: '16px', height: '16px' }} />}
            <span>{t('join.backHome') || 'Back to Home'}</span>
          </Link>
        </div>

        <div className="join-form-card">
          {submitted ? (
            <div className="join-success-view">
              <div className="join-success-icon-wrapper">
                <CheckCircle2 style={{ width: '56px', height: '56px', color: '#10b981' }} />
              </div>
              <h2 className="join-success-title">
                {t('join.successTitle') || 'Thank You!'}
              </h2>
              <p className="join-success-text">
                {t('join.successMessage') || 'Your application has been received. Our team will review your submission and contact you soon.'}
              </p>

              {/* Extra WhatsApp invitation */}
              <div className="join-success-whatsapp-box">
                <div className="whatsapp-box-header">
                  <MessageCircle style={{ width: '24px', height: '24px', color: '#25D366' }} />
                  <h4>{isAr ? 'انضم إلى مجتمعنا على الواتساب' : 'Join Our WhatsApp Community'}</h4>
                </div>
                <p>
                  {isAr 
                    ? 'تابع مستجدات وتفاصيل الجلسات والفعاليات أولاً بأول' 
                    : 'Stay connected and receive real-time announcements for our sessions and events.'}
                </p>
                <a
                  href={WHATSAPP_GROUP_URL}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="btn-whatsapp-action"
                >
                  <MessageCircle style={{ width: '18px', height: '18px' }} />
                  <span>{t('join.joinWhatsappNow') || 'Join WhatsApp Group'}</span>
                </a>
              </div>

              <div className="join-success-actions">
                <Link to="/sessions" className="btn-secondary-link">
                  {t('join.backSessions') || 'View All Sessions'}
                </Link>
                <Link to="/" className="btn-primary-link">
                  {t('join.backHome') || 'Return to Homepage'}
                </Link>
              </div>
            </div>
          ) : (
            <>
              <div className="join-header-section">
                <div className="join-type-badge">
                  {getIcon()}
                  <span>{t(`join.formTitle.${activeType}`)}</span>
                </div>
                <h1 className="join-main-heading">
                  {t(`join.formTitle.${activeType}`)}
                </h1>
                <p className="join-main-desc">
                  {t(`join.formDesc.${activeType}`)}
                </p>

                {sessionTitle && (
                  <div className="join-session-banner">
                    <Calendar style={{ width: '18px', height: '18px', color: '#e88599', flexShrink: 0 }} />
                    <div className="join-session-banner-text">
                      <span className="banner-label">{t('join.applyingForSession') || 'Target Session'}:</span>
                      <strong className="banner-title">{sessionTitle}</strong>
                    </div>
                  </div>
                )}
              </div>

              {errorMsg && (
                <div className="join-error-banner" role="alert">
                  <AlertCircle style={{ width: '18px', height: '18px', flexShrink: 0 }} />
                  <span>{errorMsg}</span>
                </div>
              )}

              <form onSubmit={handleSubmit} className="join-application-form">
                {/* 1. Full Name */}
                <div className="form-group-custom">
                  <label htmlFor="full_name" className="form-label-custom">
                    {t('join.fullName')} <span className="required-star">*</span>
                  </label>
                  <input
                    type="text"
                    id="full_name"
                    value={fullName}
                    onChange={(e) => setFullName(e.target.value)}
                    placeholder={t('join.fullNamePlaceholder')}
                    required
                    className="form-input-custom"
                  />
                </div>

                {/* 2. Email */}
                <div className="form-group-custom">
                  <label htmlFor="email" className="form-label-custom">
                    {t('join.email')} <span className="required-star">*</span>
                  </label>
                  <input
                    type="email"
                    id="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder={t('join.emailPlaceholder')}
                    required
                    className="form-input-custom"
                  />
                </div>

                {/* 3. Phone */}
                <div className="form-group-custom">
                  <label htmlFor="phone" className="form-label-custom">
                    {t('join.phone')} <span className="required-star">*</span>
                  </label>
                  <input
                    type="tel"
                    id="phone"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    placeholder={t('join.phonePlaceholder')}
                    required
                    className="form-input-custom"
                  />
                </div>

                {/* 4. Idea / Brief / Note */}
                <div className="form-group-custom">
                  <label htmlFor="message" className="form-label-custom">
                    {t(`join.messageLabel.${activeType}`)}
                  </label>
                  <textarea
                    id="message"
                    rows={4}
                    value={message}
                    onChange={(e) => setMessage(e.target.value)}
                    placeholder={t(`join.messagePlaceholder.${activeType}`)}
                    className="form-textarea-custom"
                  />
                </div>

                <div className="form-submit-row">
                  <button
                    type="submit"
                    disabled={loading}
                    className="btn-primary join-submit-btn"
                  >
                    {loading ? (
                      <span>{t('join.submitting') || 'Submitting...'}</span>
                    ) : (
                      <>
                        <Sparkles style={{ width: '18px', height: '18px' }} />
                        <span>{t('join.submit') || 'Submit Application'}</span>
                      </>
                    )}
                  </button>
                </div>
              </form>
            </>
          )}
        </div>
      </Container>
    </div>
  );
}
