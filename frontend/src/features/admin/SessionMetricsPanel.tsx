import React, { useState, useEffect } from 'react';
import { apiClient, type Session, type SessionMetrics, type FeedbackQuote } from '@/lib/api';
import { 
  Users, 
  MessageSquare, 
  CheckCircle2, 
  AlertCircle, 
  Lock, 
  Save, 
  Plus, 
  Trash2, 
  RefreshCw, 
  ShieldCheck, 
  ShieldAlert,
  Check
} from 'lucide-react';

interface SessionMetricsPanelProps {
  session: Session;
  onSessionUpdated?: (updatedSession: Session) => void;
}

export default function SessionMetricsPanel({ session, onSessionUpdated }: SessionMetricsPanelProps) {
  const [, setMetrics] = useState<SessionMetrics | null>(null);
  const [quotes, setQuotes] = useState<FeedbackQuote[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMsg, setSuccessMsg] = useState<string | null>(null);

  // Exclude from reports flag (on Session)
  const [excludeFromReports, setExcludeFromReports] = useState(session.exclude_from_reports || false);

  // Metrics Form Fields
  const [actualDate, setActualDate] = useState<string>('');
  const [actualDuration, setActualDuration] = useState<string>('');
  const [attendanceVisits, setAttendanceVisits] = useState<string>('');
  const [isAttendanceUnknown, setIsAttendanceUnknown] = useState<boolean>(true);
  const [attendanceInPerson, setAttendanceInPerson] = useState<string>('');
  const [attendanceOnline, setAttendanceOnline] = useState<string>('');
  const [countingMethod, setCountingMethod] = useState<string>('headcount');
  const [staffIncluded, setStaffIncluded] = useState<boolean>(false);

  // Feedback Card Fields
  const [cardsReceived, setCardsReceived] = useState<string>('');
  const [isCardsUnknown, setIsCardsUnknown] = useState<boolean>(true);
  const [rating5, setRating5] = useState<number>(0);
  const [rating4, setRating4] = useState<number>(0);
  const [rating3, setRating3] = useState<number>(0);
  const [rating2, setRating2] = useState<number>(0);
  const [rating1, setRating1] = useState<number>(0);
  const [unrated, setUnrated] = useState<number>(0);
  const [tallyCompleted, setTallyCompleted] = useState<boolean>(false);
  const [internalNotes, setInternalNotes] = useState<string>('');
  const [version, setVersion] = useState<number>(1);

  // New Quote Form
  const [newQuoteText, setNewQuoteText] = useState('');
  const [newQuoteLang, setNewQuoteLang] = useState('en');
  const [newQuoteType, setNewQuoteType] = useState('in_person_card');
  const [newQuoteReviewed, setNewQuoteReviewed] = useState(false);
  const [newQuotePermission, setNewQuotePermission] = useState(false);
  const [newQuoteHighlight, setNewQuoteHighlight] = useState(false);
  const [addingQuote, setAddingQuote] = useState(false);

  const fetchMetricsAndQuotes = async () => {
    setLoading(true);
    setError(null);
    try {
      const [metricsRes, quotesRes] = await Promise.all([
        apiClient.get<SessionMetrics>(`/sessions/${session.id}/metrics`),
        apiClient.get<FeedbackQuote[]>(`/sessions/${session.id}/quotes`),
      ]);

      const m = metricsRes.data;
      setMetrics(m);
      setVersion(m.version);
      setActualDate(m.actual_date || '');
      setActualDuration(m.actual_duration_minutes !== null && m.actual_duration_minutes !== undefined ? String(m.actual_duration_minutes) : '');
      
      if (m.attendance_visits === null || m.attendance_visits === undefined) {
        setIsAttendanceUnknown(true);
        setAttendanceVisits('');
      } else {
        setIsAttendanceUnknown(false);
        setAttendanceVisits(String(m.attendance_visits));
      }

      setAttendanceInPerson(m.attendance_in_person !== null && m.attendance_in_person !== undefined ? String(m.attendance_in_person) : '');
      setAttendanceOnline(m.attendance_online !== null && m.attendance_online !== undefined ? String(m.attendance_online) : '');
      setCountingMethod(m.attendance_counting_method || 'headcount');
      setStaffIncluded(m.staff_included || false);

      if (m.feedback_cards_received === null || m.feedback_cards_received === undefined) {
        setIsCardsUnknown(true);
        setCardsReceived('');
      } else {
        setIsCardsUnknown(false);
        setCardsReceived(String(m.feedback_cards_received));
      }

      setRating5(m.rating_5_count || 0);
      setRating4(m.rating_4_count || 0);
      setRating3(m.rating_3_count || 0);
      setRating2(m.rating_2_count || 0);
      setRating1(m.rating_1_count || 0);
      setUnrated(m.unrated_count || 0);
      setTallyCompleted(m.tally_completed || false);
      setInternalNotes(m.internal_notes || '');

      setQuotes(quotesRes.data);
    } catch (err: any) {
      console.error('Failed to load metrics:', err);
      setError(err?.response?.data?.detail || 'Failed to load session metrics');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchMetricsAndQuotes();
  }, [session.id]);

  // Derived Calculations
  const ratingsSum = Number(rating5 || 0) + Number(rating4 || 0) + Number(rating3 || 0) + Number(rating2 || 0) + Number(rating1 || 0) + Number(unrated || 0);
  const parsedCards = isCardsUnknown || cardsReceived === '' ? null : Number(cardsReceived);
  const isTallyReconciled = parsedCards === null || ratingsSum === parsedCards;
  const tallyDiff = parsedCards !== null ? parsedCards - ratingsSum : 0;

  const handleSaveMetrics = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setError(null);
    setSuccessMsg(null);

    // Client-side validations
    const finalVisits = isAttendanceUnknown || attendanceVisits === '' ? null : Number(attendanceVisits);
    const finalInPerson = attendanceInPerson === '' ? null : Number(attendanceInPerson);
    const finalOnline = attendanceOnline === '' ? null : Number(attendanceOnline);
    const finalDuration = actualDuration === '' ? null : Number(actualDuration);
    const finalCards = isCardsUnknown || cardsReceived === '' ? null : Number(cardsReceived);

    if (tallyCompleted) {
      if (finalCards === null) {
        setError('Cannot mark feedback tally complete without specifying total feedback cards received.');
        setSaving(false);
        return;
      }
      if (ratingsSum !== finalCards) {
        setError(`Completed tally mismatch: sum of ratings (${ratingsSum}) does not match cards received (${finalCards}). Difference: ${tallyDiff}.`);
        setSaving(false);
        return;
      }
      if (finalInPerson !== null && finalOnline !== null && finalVisits !== null) {
        if (finalInPerson + finalOnline !== finalVisits) {
          setError(`Attendance mismatch: In-person (${finalInPerson}) + Online (${finalOnline}) must equal total visits (${finalVisits}).`);
          setSaving(false);
          return;
        }
      }
    }

    try {
      // 1. Update session's exclude_from_reports if changed
      if (excludeFromReports !== (session.exclude_from_reports || false)) {
        const sessRes = await apiClient.patch<Session>(`/sessions/${session.id}`, {
          exclude_from_reports: excludeFromReports,
          version: session.version,
        });
        if (onSessionUpdated) onSessionUpdated(sessRes.data);
      }

      // 2. Update metrics
      const payload = {
        actual_date: actualDate || null,
        actual_duration_minutes: finalDuration,
        attendance_visits: finalVisits,
        attendance_in_person: finalInPerson,
        attendance_online: finalOnline,
        attendance_counting_method: countingMethod || null,
        staff_included: staffIncluded,
        feedback_cards_received: finalCards,
        rating_1_count: Number(rating1 || 0),
        rating_2_count: Number(rating2 || 0),
        rating_3_count: Number(rating3 || 0),
        rating_4_count: Number(rating4 || 0),
        rating_5_count: Number(rating5 || 0),
        unrated_count: Number(unrated || 0),
        tally_completed: tallyCompleted,
        internal_notes: internalNotes || null,
        version: version,
      };

      const res = await apiClient.put<SessionMetrics>(`/sessions/${session.id}/metrics`, payload);
      setMetrics(res.data);
      setVersion(res.data.version);
      setSuccessMsg('Session metrics saved successfully!');
      setTimeout(() => setSuccessMsg(null), 4000);
    } catch (err: any) {
      console.error('Failed to save metrics:', err);
      if (err?.response?.status === 409) {
        setError('Conflict: These metrics were modified by another window or user. Please reload below.');
      } else {
        const detail = err?.response?.data?.detail;
        setError(typeof detail === 'string' ? detail : 'Failed to save session metrics.');
      }
    } finally {
      setSaving(false);
    }
  };

  const handleAddQuote = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newQuoteText.trim()) return;

    if (newQuotePermission && !newQuoteReviewed) {
      alert('A quote must be marked as reviewed before granting permission to publish.');
      return;
    }

    setAddingQuote(true);
    try {
      const payload = {
        quote_text: newQuoteText.trim(),
        source_language: newQuoteLang,
        source_type: newQuoteType,
        is_reviewed: newQuoteReviewed,
        permission_to_publish: newQuotePermission,
        is_highlight: newQuoteHighlight,
      };
      const res = await apiClient.post<FeedbackQuote>(`/sessions/${session.id}/quotes`, payload);
      setQuotes([res.data, ...quotes]);
      setNewQuoteText('');
      setNewQuoteReviewed(false);
      setNewQuotePermission(false);
      setNewQuoteHighlight(false);
    } catch (err: any) {
      alert(err?.response?.data?.detail || 'Failed to add quote');
    } finally {
      setAddingQuote(false);
    }
  };

  const handleToggleQuoteReview = async (q: FeedbackQuote) => {
    try {
      const nextReviewed = !q.is_reviewed;
      const res = await apiClient.patch<FeedbackQuote>(`/sessions/${session.id}/quotes/${q.id}`, {
        is_reviewed: nextReviewed,
        // if unreviewing, permission is automatically revoked
        permission_to_publish: nextReviewed ? q.permission_to_publish : false,
      });
      setQuotes(quotes.map(item => item.id === q.id ? res.data : item));
    } catch (err: any) {
      alert(err?.response?.data?.detail || 'Failed to update review status');
    }
  };

  const handleToggleQuotePermission = async (q: FeedbackQuote) => {
    if (!q.is_reviewed && !q.permission_to_publish) {
      alert('Review this quote first before granting public publication permission.');
      return;
    }
    try {
      const res = await apiClient.patch<FeedbackQuote>(`/sessions/${session.id}/quotes/${q.id}`, {
        permission_to_publish: !q.permission_to_publish,
      });
      setQuotes(quotes.map(item => item.id === q.id ? res.data : item));
    } catch (err: any) {
      alert(err?.response?.data?.detail || 'Failed to update permission');
    }
  };

  const handleDeleteQuote = async (quoteId: string) => {
    if (!confirm('Are you sure you want to delete this quote record?')) return;
    try {
      await apiClient.delete(`/sessions/${session.id}/quotes/${quoteId}`);
      setQuotes(quotes.filter(q => q.id !== quoteId));
    } catch (err) {
      alert('Failed to delete quote');
    }
  };

  if (loading) {
    return (
      <div style={{ textAlign: 'center', padding: '48px 16px', color: '#6b7280' }}>
        <RefreshCw className="animate-spin" style={{ margin: '0 auto 12px auto', width: '28px', height: '28px' }} />
        <p>Loading session attendance & feedback metrics...</p>
      </div>
    );
  }

  return (
    <div style={{ maxWidth: '960px', margin: '0 auto', padding: '24px 16px' }}>
      
      {/* Header & Status Alert */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
        <div>
          <h2 style={{ fontSize: '1.5rem', fontWeight: 700, color: '#111827', margin: 0 }}>
            Attendance & Feedback Metrics
          </h2>
          <p style={{ color: '#6b7280', fontSize: '0.875rem', marginTop: '4px' }}>
            Structured reporting data for session: <strong>{session.title}</strong>
          </p>
        </div>
        <button
          type="button"
          onClick={fetchMetricsAndQuotes}
          className="btn-composer-secondary"
          style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '13px' }}
        >
          <RefreshCw size={14} /> Reload
        </button>
      </div>

      {error && (
        <div style={{ 
          backgroundColor: '#fef2f2', 
          border: '1px solid #f87171', 
          color: '#b91c1c', 
          padding: '12px 16px', 
          borderRadius: '8px', 
          marginBottom: '20px',
          display: 'flex',
          alignItems: 'center',
          gap: '8px'
        }}>
          <AlertCircle size={18} />
          <span>{error}</span>
        </div>
      )}

      {successMsg && (
        <div style={{ 
          backgroundColor: '#f0fdf4', 
          border: '1px solid #86efac', 
          color: '#15803d', 
          padding: '12px 16px', 
          borderRadius: '8px', 
          marginBottom: '20px',
          display: 'flex',
          alignItems: 'center',
          gap: '8px'
        }}>
          <CheckCircle2 size={18} />
          <span>{successMsg}</span>
        </div>
      )}

      {/* Report Eligibility Exclusion Banner */}
      <div style={{ 
        backgroundColor: excludeFromReports ? '#fffbeb' : '#f9fafb', 
        border: `1px solid ${excludeFromReports ? '#fcd34d' : '#e5e7eb'}`, 
        padding: '14px 18px', 
        borderRadius: '12px', 
        marginBottom: '24px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between'
      }}>
        <div>
          <label style={{ display: 'flex', alignItems: 'center', gap: '10px', cursor: 'pointer', fontWeight: 600, color: '#1f2937' }}>
            <input 
              type="checkbox" 
              checked={excludeFromReports}
              onChange={(e) => setExcludeFromReports(e.target.checked)}
              style={{ width: '18px', height: '18px', accentColor: '#d97706' }}
            />
            <span>Exclude from Annual Reports (Test / Demo / Unconfirmed Session)</span>
          </label>
          <p style={{ margin: '4px 0 0 28px', fontSize: '0.8125rem', color: '#6b7280' }}>
            When checked, this session will be completely omitted from annual report metrics, charts, and public timeline snapshots.
          </p>
        </div>
        {excludeFromReports && (
          <span style={{ fontSize: '0.75rem', fontWeight: 700, color: '#b45309', backgroundColor: '#fef3c7', padding: '4px 10px', borderRadius: '12px' }}>
            EXCLUDED FROM REPORTS
          </span>
        )}
      </div>

      <form onSubmit={handleSaveMetrics}>
        {/* Section 1: Session Attendance */}
        <div style={{ 
          backgroundColor: '#ffffff', 
          border: '1px solid #e5e7eb', 
          borderRadius: '12px', 
          padding: '24px', 
          marginBottom: '24px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.05)'
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '16px' }}>
            <Users style={{ color: '#0284c7', width: '22px', height: '22px' }} />
            <h3 style={{ fontSize: '1.125rem', fontWeight: 600, color: '#111827', margin: 0 }}>
              1. Attendance Visits & Details
            </h3>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: '20px' }}>
            
            {/* Total Visits with Unknown / Zero options */}
            <div>
              <label style={{ display: 'block', fontWeight: 600, fontSize: '0.875rem', color: '#374151', marginBottom: '6px' }}>
                Total Attendance Visits
              </label>
              <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
                <input 
                  type="number"
                  min="0"
                  disabled={isAttendanceUnknown}
                  placeholder={isAttendanceUnknown ? 'Unknown / Not recorded' : '0'}
                  value={attendanceVisits}
                  onChange={(e) => setAttendanceVisits(e.target.value)}
                  style={{
                    flex: 1,
                    padding: '8px 12px',
                    border: '1px solid #d1d5db',
                    borderRadius: '8px',
                    backgroundColor: isAttendanceUnknown ? '#f3f4f6' : '#ffffff',
                    color: isAttendanceUnknown ? '#9ca3af' : '#111827',
                  }}
                />
              </div>
              <div style={{ marginTop: '6px', display: 'flex', gap: '12px', fontSize: '0.75rem' }}>
                <label style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '4px', color: '#4b5563' }}>
                  <input 
                    type="checkbox"
                    checked={isAttendanceUnknown}
                    onChange={(e) => {
                      setIsAttendanceUnknown(e.target.checked);
                      if (e.target.checked) setAttendanceVisits('');
                    }}
                  />
                  <span>Unknown / Unrecorded</span>
                </label>
                <button
                  type="button"
                  onClick={() => {
                    setIsAttendanceUnknown(false);
                    setAttendanceVisits('0');
                  }}
                  style={{ background: 'none', border: 'none', color: '#0284c7', cursor: 'pointer', padding: 0, textDecoration: 'underline' }}
                >
                  Set confirmed zero (0)
                </button>
              </div>
              <p style={{ fontSize: '0.75rem', color: '#6b7280', margin: '4px 0 0 0' }}>
                Each participant is counted once per session. Repeat sessions count as repeat visits.
              </p>
            </div>

            {/* In-Person vs Online split (Optional) */}
            <div>
              <label style={{ display: 'block', fontWeight: 600, fontSize: '0.875rem', color: '#374151', marginBottom: '6px' }}>
                Modality Breakdown (Optional)
              </label>
              <div style={{ display: 'flex', gap: '10px' }}>
                <div style={{ flex: 1 }}>
                  <span style={{ fontSize: '0.75rem', color: '#6b7280' }}>In-Person</span>
                  <input 
                    type="number"
                    min="0"
                    placeholder="—"
                    value={attendanceInPerson}
                    onChange={(e) => setAttendanceInPerson(e.target.value)}
                    style={{ width: '100%', padding: '8px 12px', border: '1px solid #d1d5db', borderRadius: '8px' }}
                  />
                </div>
                <div style={{ flex: 1 }}>
                  <span style={{ fontSize: '0.75rem', color: '#6b7280' }}>Online</span>
                  <input 
                    type="number"
                    min="0"
                    placeholder="—"
                    value={attendanceOnline}
                    onChange={(e) => setAttendanceOnline(e.target.value)}
                    style={{ width: '100%', padding: '8px 12px', border: '1px solid #d1d5db', borderRadius: '8px' }}
                  />
                </div>
              </div>
            </div>

            {/* Counting Method */}
            <div>
              <label style={{ display: 'block', fontWeight: 600, fontSize: '0.875rem', color: '#374151', marginBottom: '6px' }}>
                Counting Method
              </label>
              <select
                value={countingMethod}
                onChange={(e) => setCountingMethod(e.target.value)}
                style={{ width: '100%', padding: '8px 12px', border: '1px solid #d1d5db', borderRadius: '8px', backgroundColor: '#ffffff' }}
              >
                <option value="headcount">Headcount Tally</option>
                <option value="signin_sheet">Sign-in Sheet</option>
                <option value="online_roster">Online Meeting Roster</option>
                <option value="approximate">Approximate Estimate</option>
                <option value="other">Other / Mixed</option>
              </select>
              <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.75rem', color: '#4b5563', marginTop: '6px', cursor: 'pointer' }}>
                <input 
                  type="checkbox" 
                  checked={staffIncluded} 
                  onChange={(e) => setStaffIncluded(e.target.checked)} 
                />
                <span>Staff/organizers are included in tally</span>
              </label>
            </div>

            {/* Actual Date & Duration */}
            <div>
              <label style={{ display: 'block', fontWeight: 600, fontSize: '0.875rem', color: '#374151', marginBottom: '6px' }}>
                Actual Date & Duration (If Rescheduled)
              </label>
              <div style={{ display: 'flex', gap: '10px' }}>
                <div style={{ flex: 1 }}>
                  <span style={{ fontSize: '0.75rem', color: '#6b7280' }}>Actual Date</span>
                  <input 
                    type="date"
                    value={actualDate}
                    onChange={(e) => setActualDate(e.target.value)}
                    style={{ width: '100%', padding: '7px 10px', border: '1px solid #d1d5db', borderRadius: '8px' }}
                  />
                </div>
                <div style={{ flex: 1 }}>
                  <span style={{ fontSize: '0.75rem', color: '#6b7280' }}>Actual Mins</span>
                  <input 
                    type="number"
                    min="0"
                    placeholder="Mins"
                    value={actualDuration}
                    onChange={(e) => setActualDuration(e.target.value)}
                    style={{ width: '100%', padding: '7px 10px', border: '1px solid #d1d5db', borderRadius: '8px' }}
                  />
                </div>
              </div>
            </div>

          </div>
        </div>

        {/* Section 2: Feedback Cards & Rating Distribution */}
        <div style={{ 
          backgroundColor: '#ffffff', 
          border: '1px solid #e5e7eb', 
          borderRadius: '12px', 
          padding: '24px', 
          marginBottom: '24px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.05)'
        }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '16px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
              <MessageSquare style={{ color: '#8b5cf6', width: '22px', height: '22px' }} />
              <h3 style={{ fontSize: '1.125rem', fontWeight: 600, color: '#111827', margin: 0 }}>
                2. Feedback Cards & Rating Tallies
              </h3>
            </div>
            
            {/* Live Tally Reconciliation Status */}
            <div style={{ 
              display: 'flex', 
              alignItems: 'center', 
              gap: '6px', 
              fontSize: '0.8125rem', 
              fontWeight: 600,
              padding: '4px 12px',
              borderRadius: '20px',
              backgroundColor: isTallyReconciled ? '#f0fdf4' : '#fffbeb',
              color: isTallyReconciled ? '#16a34a' : '#d97706',
              border: `1px solid ${isTallyReconciled ? '#bbf7d0' : '#fde68a'}`
            }}>
              {isTallyReconciled ? (
                <>
                  <Check size={14} />
                  <span>Ratings match cards received ({ratingsSum} total)</span>
                </>
              ) : (
                <>
                  <AlertCircle size={14} />
                  <span>Tally gap: {ratingsSum} accounted for / {parsedCards} received ({tallyDiff > 0 ? `${tallyDiff} remaining` : `${Math.abs(tallyDiff)} excess`})</span>
                </>
              )}
            </div>
          </div>

          <div style={{ marginBottom: '20px' }}>
            <label style={{ display: 'block', fontWeight: 600, fontSize: '0.875rem', color: '#374151', marginBottom: '6px' }}>
              Total Feedback Cards Received
            </label>
            <div style={{ display: 'flex', gap: '12px', alignItems: 'center', maxWidth: '320px' }}>
              <input 
                type="number"
                min="0"
                disabled={isCardsUnknown}
                placeholder={isCardsUnknown ? 'Unknown / None collected' : '0'}
                value={cardsReceived}
                onChange={(e) => setCardsReceived(e.target.value)}
                style={{
                  flex: 1,
                  padding: '8px 12px',
                  border: '1px solid #d1d5db',
                  borderRadius: '8px',
                  backgroundColor: isCardsUnknown ? '#f3f4f6' : '#ffffff',
                }}
              />
              <label style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '4px', fontSize: '0.75rem', color: '#4b5563' }}>
                <input 
                  type="checkbox"
                  checked={isCardsUnknown}
                  onChange={(e) => {
                    setIsCardsUnknown(e.target.checked);
                    if (e.target.checked) setCardsReceived('');
                  }}
                />
                <span>Unknown</span>
              </label>
            </div>
          </div>

          {/* 1-5 Rating inputs */}
          <p style={{ fontWeight: 600, fontSize: '0.875rem', color: '#374151', marginBottom: '10px' }}>
            Card Rating Counts (1 = Very Poor, 5 = Very Good):
          </p>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(130px, 1fr))', gap: '12px', marginBottom: '20px' }}>
            <div style={{ backgroundColor: '#f9fafb', padding: '10px', borderRadius: '8px', border: '1px solid #e5e7eb' }}>
              <span style={{ fontSize: '0.75rem', color: '#16a34a', fontWeight: 600 }}>5 — Very Good</span>
              <input 
                type="number" 
                min="0" 
                value={rating5} 
                onChange={(e) => setRating5(Math.max(0, parseInt(e.target.value) || 0))}
                style={{ width: '100%', marginTop: '4px', padding: '6px', border: '1px solid #d1d5db', borderRadius: '6px' }}
              />
            </div>
            <div style={{ backgroundColor: '#f9fafb', padding: '10px', borderRadius: '8px', border: '1px solid #e5e7eb' }}>
              <span style={{ fontSize: '0.75rem', color: '#65a30d', fontWeight: 600 }}>4 — Good</span>
              <input 
                type="number" 
                min="0" 
                value={rating4} 
                onChange={(e) => setRating4(Math.max(0, parseInt(e.target.value) || 0))}
                style={{ width: '100%', marginTop: '4px', padding: '6px', border: '1px solid #d1d5db', borderRadius: '6px' }}
              />
            </div>
            <div style={{ backgroundColor: '#f9fafb', padding: '10px', borderRadius: '8px', border: '1px solid #e5e7eb' }}>
              <span style={{ fontSize: '0.75rem', color: '#d97706', fontWeight: 600 }}>3 — Neutral</span>
              <input 
                type="number" 
                min="0" 
                value={rating3} 
                onChange={(e) => setRating3(Math.max(0, parseInt(e.target.value) || 0))}
                style={{ width: '100%', marginTop: '4px', padding: '6px', border: '1px solid #d1d5db', borderRadius: '6px' }}
              />
            </div>
            <div style={{ backgroundColor: '#f9fafb', padding: '10px', borderRadius: '8px', border: '1px solid #e5e7eb' }}>
              <span style={{ fontSize: '0.75rem', color: '#ea580c', fontWeight: 600 }}>2 — Poor</span>
              <input 
                type="number" 
                min="0" 
                value={rating2} 
                onChange={(e) => setRating2(Math.max(0, parseInt(e.target.value) || 0))}
                style={{ width: '100%', marginTop: '4px', padding: '6px', border: '1px solid #d1d5db', borderRadius: '6px' }}
              />
            </div>
            <div style={{ backgroundColor: '#f9fafb', padding: '10px', borderRadius: '8px', border: '1px solid #e5e7eb' }}>
              <span style={{ fontSize: '0.75rem', color: '#dc2626', fontWeight: 600 }}>1 — Very Poor</span>
              <input 
                type="number" 
                min="0" 
                value={rating1} 
                onChange={(e) => setRating1(Math.max(0, parseInt(e.target.value) || 0))}
                style={{ width: '100%', marginTop: '4px', padding: '6px', border: '1px solid #d1d5db', borderRadius: '6px' }}
              />
            </div>
            <div style={{ backgroundColor: '#f9fafb', padding: '10px', borderRadius: '8px', border: '1px solid #e5e7eb' }}>
              <span style={{ fontSize: '0.75rem', color: '#6b7280', fontWeight: 600 }}>Unrated / Blank</span>
              <input 
                type="number" 
                min="0" 
                value={unrated} 
                onChange={(e) => setUnrated(Math.max(0, parseInt(e.target.value) || 0))}
                style={{ width: '100%', marginTop: '4px', padding: '6px', border: '1px solid #d1d5db', borderRadius: '6px' }}
              />
            </div>
          </div>

          {/* Tally completed reconciliation checkbox */}
          <div style={{ 
            backgroundColor: '#f8fafc', 
            padding: '12px 16px', 
            borderRadius: '8px', 
            border: '1px solid #e2e8f0',
            display: 'flex',
            alignItems: 'center',
            gap: '12px'
          }}>
            <input 
              type="checkbox"
              id="tallyCompleted"
              checked={tallyCompleted}
              onChange={(e) => setTallyCompleted(e.target.checked)}
              style={{ width: '18px', height: '18px', accentColor: '#2563eb' }}
            />
            <label htmlFor="tallyCompleted" style={{ fontSize: '0.875rem', fontWeight: 600, color: '#1e293b', cursor: 'pointer' }}>
              Finalize & Mark Feedback Tally as Completed
            </label>
            <span style={{ fontSize: '0.75rem', color: '#64748b' }}>
              (Enforces strict reconciliation between cards received and rating sum)
            </span>
          </div>
        </div>

        {/* Section 3: Private Moderator Notes */}
        <div style={{ 
          backgroundColor: '#ffffff', 
          border: '1px solid #e5e7eb', 
          borderRadius: '12px', 
          padding: '24px', 
          marginBottom: '24px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.05)'
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '8px' }}>
            <Lock size={18} style={{ color: '#d97706' }} />
            <h3 style={{ fontSize: '1.125rem', fontWeight: 600, color: '#111827', margin: 0 }}>
              3. Private Moderator Notes
            </h3>
            <span style={{ fontSize: '0.75rem', color: '#92400e', backgroundColor: '#fef3c7', padding: '2px 8px', borderRadius: '10px', fontWeight: 600 }}>
              Internal Only
            </span>
          </div>
          <p style={{ fontSize: '0.8125rem', color: '#6b7280', margin: '0 0 12px 0' }}>
            Private collection observations, box location, and unverified notes. Strictly excluded from public APIs and annual report snapshots.
          </p>
          <textarea
            rows={3}
            value={internalNotes}
            onChange={(e) => setInternalNotes(e.target.value)}
            placeholder="e.g. Session had high engagement during Manga vocabulary section. 2 cards left blank."
            style={{ width: '100%', padding: '10px', border: '1px solid #d1d5db', borderRadius: '8px', fontSize: '0.875rem' }}
          />
        </div>

        {/* Save Metrics Button */}
        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '12px', marginBottom: '36px' }}>
          <button
            type="submit"
            disabled={saving}
            className="btn-composer-primary"
            style={{ display: 'flex', alignItems: 'center', gap: '8px', padding: '10px 24px', fontSize: '15px' }}
          >
            <Save size={16} />
            <span>{saving ? 'Saving Metrics...' : 'Save Metrics & Tallies'}</span>
          </button>
        </div>
      </form>

      {/* Section 4: Reviewed Feedback Quotes */}
      <div style={{ 
        backgroundColor: '#ffffff', 
        border: '1px solid #e5e7eb', 
        borderRadius: '12px', 
        padding: '24px', 
        boxShadow: '0 1px 3px rgba(0,0,0,0.05)'
      }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '16px' }}>
          <div>
            <h3 style={{ fontSize: '1.125rem', fontWeight: 600, color: '#111827', margin: 0 }}>
              4. Reviewed Feedback Quotes ({quotes.length})
            </h3>
            <p style={{ fontSize: '0.8125rem', color: '#6b7280', margin: '4px 0 0 0' }}>
              Individual quotes with recorded review and publication consent. Publication permission defaults strictly to <strong>No</strong>.
            </p>
          </div>
        </div>

        {/* New Quote Form */}
        <form onSubmit={handleAddQuote} style={{ backgroundColor: '#f8fafc', padding: '16px', borderRadius: '10px', border: '1px solid #e2e8f0', marginBottom: '24px' }}>
          <h4 style={{ margin: '0 0 10px 0', fontSize: '0.875rem', fontWeight: 600, color: '#1e293b' }}>
            Add Reviewed Feedback Quote
          </h4>
          <textarea
            required
            rows={2}
            value={newQuoteText}
            onChange={(e) => setNewQuoteText(e.target.value)}
            placeholder="Type or transcribe attendee quote..."
            style={{ width: '100%', padding: '8px 12px', border: '1px solid #d1d5db', borderRadius: '8px', marginBottom: '10px' }}
          />
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '16px', alignItems: 'center', justifyContent: 'space-between' }}>
            <div style={{ display: 'flex', gap: '12px' }}>
              <div>
                <span style={{ fontSize: '0.75rem', color: '#64748b' }}>Language: </span>
                <select 
                  value={newQuoteLang} 
                  onChange={(e) => setNewQuoteLang(e.target.value)}
                  style={{ padding: '4px 8px', borderRadius: '6px', border: '1px solid #cbd5e1' }}
                >
                  <option value="en">English (en)</option>
                  <option value="ar">Arabic (ar)</option>
                  <option value="ja">Japanese (ja)</option>
                  <option value="mixed">Mixed</option>
                </select>
              </div>
              <div>
                <span style={{ fontSize: '0.75rem', color: '#64748b' }}>Source: </span>
                <select 
                  value={newQuoteType} 
                  onChange={(e) => setNewQuoteType(e.target.value)}
                  style={{ padding: '4px 8px', borderRadius: '6px', border: '1px solid #cbd5e1' }}
                >
                  <option value="in_person_card">In-Person Paper Card</option>
                  <option value="online_poll">Online Meeting Poll</option>
                  <option value="direct_message">Direct Message</option>
                </select>
              </div>
            </div>

            <div style={{ display: 'flex', gap: '16px', alignItems: 'center' }}>
              <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.8125rem', cursor: 'pointer', color: '#1e293b' }}>
                <input 
                  type="checkbox" 
                  checked={newQuoteReviewed} 
                  onChange={(e) => {
                    setNewQuoteReviewed(e.target.checked);
                    if (!e.target.checked) setNewQuotePermission(false);
                  }} 
                />
                <span>Recorded as Reviewed</span>
              </label>

              <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.8125rem', cursor: 'pointer', color: newQuoteReviewed ? '#15803d' : '#9ca3af' }}>
                <input 
                  type="checkbox" 
                  disabled={!newQuoteReviewed}
                  checked={newQuotePermission} 
                  onChange={(e) => setNewQuotePermission(e.target.checked)} 
                />
                <span style={{ fontWeight: 600 }}>Permission to Publish (Opt-in)</span>
              </label>

              <button
                type="submit"
                disabled={addingQuote}
                style={{ 
                  backgroundColor: '#7c3aed', 
                  color: '#ffffff', 
                  border: 'none', 
                  padding: '6px 14px', 
                  borderRadius: '6px', 
                  fontSize: '0.8125rem', 
                  fontWeight: 600,
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '4px'
                }}
              >
                <Plus size={14} /> Add Quote
              </button>
            </div>
          </div>
        </form>

        {/* Existing Quotes List */}
        {quotes.length === 0 ? (
          <p style={{ textAlign: 'center', color: '#9ca3af', padding: '24px 0', fontSize: '0.875rem' }}>
            No feedback quotes recorded for this session yet.
          </p>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
            {quotes.map((q) => (
              <div 
                key={q.id}
                style={{ 
                  padding: '14px 18px', 
                  borderRadius: '10px', 
                  border: '1px solid #e5e7eb',
                  backgroundColor: q.permission_to_publish ? '#f0fdf4' : '#fafafa',
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '8px'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                  <p style={{ margin: 0, fontSize: '0.9375rem', color: '#1f2937', fontStyle: 'italic' }}>
                    "{q.quote_text}"
                  </p>
                  <button
                    type="button"
                    onClick={() => handleDeleteQuote(q.id)}
                    style={{ background: 'none', border: 'none', color: '#9ca3af', cursor: 'pointer', padding: '4px' }}
                    title="Delete quote"
                  >
                    <Trash2 size={16} />
                  </button>
                </div>

                <div style={{ display: 'flex', flexWrap: 'wrap', alignItems: 'center', justifyContent: 'space-between', fontSize: '0.75rem', color: '#6b7280' }}>
                  <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
                    <span style={{ backgroundColor: '#e5e7eb', padding: '2px 6px', borderRadius: '4px' }}>{q.source_language.toUpperCase()}</span>
                    <span>{q.source_type}</span>
                    {q.reviewed_at && (
                      <span>• Reviewed: {new Date(q.reviewed_at).toLocaleDateString()}</span>
                    )}
                  </div>

                  <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
                    <button
                      type="button"
                      onClick={() => handleToggleQuoteReview(q)}
                      style={{ 
                        background: 'none', 
                        border: '1px solid #cbd5e1', 
                        padding: '3px 8px', 
                        borderRadius: '6px', 
                        cursor: 'pointer',
                        fontSize: '0.75rem',
                        color: q.is_reviewed ? '#15803d' : '#4b5563',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '4px'
                      }}
                    >
                      {q.is_reviewed ? <ShieldCheck size={12} color="#16a34a" /> : <ShieldAlert size={12} />}
                      {q.is_reviewed ? 'Reviewed' : 'Mark Reviewed'}
                    </button>

                    <button
                      type="button"
                      onClick={() => handleToggleQuotePermission(q)}
                      style={{ 
                        background: q.permission_to_publish ? '#dcfce7' : '#fee2e2', 
                        border: `1px solid ${q.permission_to_publish ? '#86efac' : '#fca5a5'}`, 
                        padding: '3px 8px', 
                        borderRadius: '6px', 
                        cursor: 'pointer',
                        fontSize: '0.75rem',
                        fontWeight: 600,
                        color: q.permission_to_publish ? '#166534' : '#991b1b',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '4px'
                      }}
                    >
                      {q.permission_to_publish ? 'Published Permission: YES' : 'Published Permission: NO'}
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

      </div>

    </div>
  );
}
