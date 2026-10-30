import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { 
  BarChart3, 
  Calendar, 
  AlertTriangle, 
  CheckCircle2, 
  FileDown, 
  RefreshCw, 
  Globe, 
  ShieldAlert, 
  Check, 
  ArrowRight,
  BookOpen,
  Clock,
  Users,
  MessageSquareQuote
} from 'lucide-react';
import { 
  apiClient, 
  type ReportYearSummary, 
  type MissingDataChecklist, 
  type ReportRevision 
} from '@/lib/api';

export default function AdminReportsPage() {
  const [years, setYears] = useState<ReportYearSummary[]>([]);
  const [selectedYear, setSelectedYear] = useState<number>(new Date().getFullYear());
  const [checklist, setChecklist] = useState<MissingDataChecklist | null>(null);
  const [draftRev, setDraftRev] = useState<ReportRevision | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [generating, setGenerating] = useState<boolean>(false);
  const [publishing, setPublishing] = useState<boolean>(false);
  const [showPublishModal, setShowPublishModal] = useState<boolean>(false);
  const [downloadingPdf, setDownloadingPdf] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  const fetchYears = async () => {
    try {
      const res = await apiClient.get<ReportYearSummary[]>('/admin/reports/years');
      setYears(res.data);
      if (res.data.length > 0 && !res.data.some(y => y.year === selectedYear)) {
        setSelectedYear(res.data[0].year);
      }
    } catch (err: any) {
      console.error('Failed to fetch report years:', err);
    }
  };

  const fetchYearData = async (year: number) => {
    setLoading(true);
    setErrorMessage(null);
    try {
      // 1. Fetch checklist
      const chkRes = await apiClient.get<MissingDataChecklist>(`/admin/reports/${year}/missing-data-checklist`);
      setChecklist(chkRes.data);

      // 2. Fetch active draft if exists
      try {
        const draftRes = await apiClient.get<ReportRevision>(`/admin/reports/${year}/draft`);
        setDraftRev(draftRes.data);
      } catch (e: any) {
        if (e.response?.status === 404) {
          setDraftRev(null);
        } else {
          console.warn('Draft fetch note:', e);
          setDraftRev(null);
        }
      }
    } catch (err: any) {
      console.error('Failed to fetch year data:', err);
      setErrorMessage(err.response?.data?.detail || 'Failed to load report data');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchYears();
  }, []);

  useEffect(() => {
    if (selectedYear) {
      fetchYearData(selectedYear);
    }
  }, [selectedYear]);

  const handleGenerateDraft = async () => {
    setGenerating(true);
    setErrorMessage(null);
    setSuccessMessage(null);
    try {
      const res = await apiClient.post<ReportRevision>(`/admin/reports/${selectedYear}/draft`, {
        language: 'en',
        include_methodology_notes: true,
      });
      setDraftRev(res.data);
      setSuccessMessage(`Draft Revision #${res.data.revision_number} generated successfully with deterministic calculation and vector PDF artifact.`);
      await fetchYears();
    } catch (err: any) {
      setErrorMessage(err.response?.data?.detail || 'Failed to generate draft report');
    } finally {
      setGenerating(false);
    }
  };

  const handlePublish = async () => {
    if (!draftRev) return;
    setPublishing(true);
    setErrorMessage(null);
    try {
      const res = await apiClient.post<ReportRevision>(`/admin/reports/${selectedYear}/publish`, {
        revision_id: draftRev.id,
      });
      setDraftRev(res.data);
      setShowPublishModal(false);
      setSuccessMessage(`Revision #${res.data.revision_number} successfully published! It is now live on the public Annual Reports page.`);
      await fetchYears();
    } catch (err: any) {
      setErrorMessage(err.response?.data?.detail || 'Failed to publish revision');
    } finally {
      setPublishing(false);
    }
  };

  const handleDownloadPdf = async (isDraft: boolean) => {
    setDownloadingPdf(true);
    try {
      const response = await apiClient.get(`/reports/${selectedYear}/download`, {
        params: { draft: isDraft, language: 'en' },
        responseType: 'blob',
      });
      const blob = new Blob([response.data], { type: 'application/pdf' });
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = `jprclub_annual_report_${selectedYear}_${isDraft ? 'draft' : 'official'}.pdf`;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to download PDF artifact');
    } finally {
      setDownloadingPdf(false);
    }
  };

  const currentYearSummary = years.find(y => y.year === selectedYear);

  // Collect problematic sessions from checklist
  const missingAttendanceList = checklist?.missing_attendance_sessions || [];
  const incompleteTalliesList = checklist?.incomplete_tallies_sessions || [];
  const missingDurationList = checklist?.missing_actual_duration_sessions || [];

  // Group problems by session ID
  const problematicSessionMap = new Map<string, { id: string; title: string; date: string; issues: string[] }>();

  missingAttendanceList.forEach(s => {
    const existing = problematicSessionMap.get(s.id) || { id: s.id, title: s.title, date: s.date, issues: [] };
    existing.issues.push('Missing Attendance');
    problematicSessionMap.set(s.id, existing);
  });

  incompleteTalliesList.forEach(s => {
    const existing = problematicSessionMap.get(s.id) || { id: s.id, title: s.title, date: s.date, issues: [] };
    existing.issues.push('Incomplete Tally');
    problematicSessionMap.set(s.id, existing);
  });

  missingDurationList.forEach(s => {
    const existing = problematicSessionMap.get(s.id) || { id: s.id, title: s.title, date: s.date, issues: [] };
    if (!existing.issues.includes('Missing Actual Duration')) {
      existing.issues.push('Missing Actual Duration');
    }
    problematicSessionMap.set(s.id, existing);
  });

  const problematicSessions = Array.from(problematicSessionMap.values());
  const totalCompleted = checklist?.total_completed_sessions ?? 0;
  const missingAttendanceCount = checklist?.missing_attendance_count ?? 0;
  const incompleteTalliesCount = checklist?.incomplete_tallies_count ?? 0;

  return (
    <div className="admin-reports-page">
      {/* Top Header */}
      <div className="admin-reports-header">
        <div className="admin-reports-header-title-wrap">
          <div className="admin-reports-icon-badge">
            <BarChart3 className="w-6 h-6" />
          </div>
          <div>
            <h1 className="admin-reports-title">Annual Reports Management</h1>
            <p className="admin-reports-subtitle">
              Deterministic yearly report engine, missing-data audit checklist, vector PDF generation, and manual publication gating.
            </p>
          </div>
        </div>
        <div>
          <Link
            to={`/reports/${selectedYear}`}
            target="_blank"
            className="admin-reports-btn-view"
          >
            <Globe className="w-4 h-4 text-gray-500" />
            <span>View Public Web Report</span>
          </Link>
        </div>
      </div>

      {/* Messages */}
      {errorMessage && (
        <div className="admin-reports-alert-danger">
          <AlertTriangle className="w-5 h-5 flex-shrink-0" />
          <span>{errorMessage}</span>
        </div>
      )}
      {successMessage && (
        <div className="admin-reports-alert-success">
          <CheckCircle2 className="w-5 h-5 flex-shrink-0" />
          <span>{successMessage}</span>
        </div>
      )}

      {/* Year Selector Toolbar */}
      <div className="admin-reports-year-bar">
        <div className="admin-reports-year-group">
          <div className="admin-reports-year-label">
            <Calendar className="w-4 h-4 text-gray-400" />
            <span>Select Report Year:</span>
          </div>
          <div className="admin-reports-year-pills">
            {[2024, 2025, 2026].map(yr => {
              const summary = years.find(y => y.year === yr);
              const isSelected = selectedYear === yr;
              return (
                <button
                  key={yr}
                  onClick={() => setSelectedYear(yr)}
                  className={`admin-reports-year-btn ${isSelected ? 'active' : ''}`}
                >
                  <span>{yr}</span>
                  {summary?.status === 'published' && (
                    <span className="admin-reports-pill-tag admin-reports-pill-tag-published">
                      Published
                    </span>
                  )}
                  {summary?.status === 'archived' && (
                    <span className="admin-reports-pill-tag">
                      Archive
                    </span>
                  )}
                  {summary?.status === 'draft' && (
                    <span className="admin-reports-pill-tag admin-reports-pill-tag-draft">
                      Draft
                    </span>
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {/* Current status pill */}
        <div className={`admin-reports-status-pill ${
          currentYearSummary?.status === 'published'
            ? 'status-published'
            : currentYearSummary?.status === 'draft'
            ? 'status-draft'
            : 'status-archived'
        }`}>
          <span className="admin-pulse-dot" />
          <span>Year Status: {currentYearSummary?.status ? currentYearSummary.status.toUpperCase() : 'NO DRAFT'}</span>
        </div>
      </div>

      {loading ? (
        <div style={{ textAlign: 'center', padding: '60px 0', color: '#64748b' }}>
          <RefreshCw className="w-8 h-8 animate-spin mx-auto text-primary mb-3" />
          <p style={{ margin: 0, fontSize: '14px', fontWeight: 500 }}>Loading year checklist and draft state...</p>
        </div>
      ) : (
        <>
          {/* Missing-Data Checklist Card */}
          {checklist && (
            <div className="admin-reports-card">
              <div className="admin-reports-card-header">
                <div>
                  <h2 className="admin-reports-card-title">
                    <ShieldAlert className="w-5 h-5 text-primary" />
                    Missing-Data & Tally Quality Audit ({selectedYear})
                  </h2>
                  <p className="admin-reports-card-subtitle">
                    Quality gate checking completed sessions for missing attendance and feedback card tallies.
                  </p>
                </div>
                <div className="admin-reports-badge-counter">
                  <span>Completed Sessions:</span>
                  <strong>{totalCompleted}</strong>
                </div>
              </div>

              {/* Status banner */}
              {missingAttendanceCount === 0 && incompleteTalliesCount === 0 ? (
                <div className="admin-reports-audit-banner-verified">
                  <CheckCircle2 className="w-5 h-5 text-emerald-600 flex-shrink-0" />
                  <div>
                    <strong>Data Quality Verified:</strong> All {totalCompleted} completed sessions in {selectedYear} have recorded attendance metrics and verified feedback tallies.
                  </div>
                </div>
              ) : (
                <div className="admin-reports-audit-banner-warning">
                  <AlertTriangle className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
                  <div style={{ flex: 1 }}>
                    <div style={{ fontWeight: 600, marginBottom: '2px' }}>Review Recommendations before Final Publication:</div>
                    <ul>
                      {missingAttendanceCount > 0 && (
                        <li>{missingAttendanceCount} session(s) lack recorded post-session attendance metrics.</li>
                      )}
                      {incompleteTalliesCount > 0 && (
                        <li>{incompleteTalliesCount} session(s) have unfinalized or mismatched feedback card rating tallies.</li>
                      )}
                    </ul>
                  </div>
                </div>
              )}

              {/* Session list checklist */}
              {problematicSessions.length === 0 ? (
                <p style={{ textAlign: 'center', color: '#64748b', padding: '20px 0', fontSize: '13.5px', margin: 0 }}>
                  All sessions have recorded attendance and tallies!
                </p>
              ) : (
                <div className="admin-reports-session-list">
                  {problematicSessions.map((session) => (
                    <div key={session.id} className="admin-reports-session-row">
                      <div className="admin-reports-session-meta">
                        <span className="admin-reports-session-title">{session.title}</span>
                        <span className="admin-reports-session-date">
                          <Calendar className="w-3.5 h-3.5 text-gray-400" />
                          <span>Date: {session.date}</span>
                        </span>
                      </div>

                      <div className="admin-reports-session-actions">
                        {session.issues.map((issue, idx) => (
                          <span
                            key={idx}
                            className={issue === 'Missing Attendance' ? 'admin-reports-issue-badge-danger' : 'admin-reports-issue-badge-warning'}
                          >
                            <AlertTriangle className="w-3.5 h-3.5" />
                            <span>{issue}</span>
                          </span>
                        ))}

                        <Link
                          to={`/admin/sessions/${session.id}/document?tab=metrics`}
                          className="admin-reports-btn-metrics"
                        >
                          <span>Enter / Edit Metrics</span>
                          <ArrowRight className="w-3.5 h-3.5" />
                        </Link>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Draft Generation & Revision Snapshot Card */}
          <div className="admin-reports-card">
            <div className="admin-reports-card-header">
              <div>
                <h2 className="admin-reports-card-title">
                  <RefreshCw className="w-5 h-5 text-primary" />
                  Deterministic Draft Engine & Vector PDF
                </h2>
                <p className="admin-reports-card-subtitle">
                  Recomputes live summary metrics, literary works, and builds downloadable vector PDF artifact.
                </p>
              </div>

              <button
                onClick={handleGenerateDraft}
                disabled={generating}
                className="admin-reports-btn-primary"
              >
                {generating ? (
                  <>
                    <RefreshCw className="w-4 h-4 animate-spin" />
                    <span>Recalculating & Building PDF...</span>
                  </>
                ) : (
                  <>
                    <RefreshCw className="w-4 h-4" />
                    <span>{draftRev ? 'Rebuild Draft Revision' : 'Generate Initial Draft'}</span>
                  </>
                )}
              </button>
            </div>

            {/* Active Draft Details */}
            {draftRev ? (
              <div>
                {/* Revision Header Banner */}
                <div className="admin-reports-draft-banner">
                  <div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flexWrap: 'wrap' }}>
                      <span style={{ fontSize: '15px', fontWeight: 700, color: '#0f172a' }}>
                        Revision #{draftRev.revision_number}
                      </span>
                      <span className={`admin-reports-pill-tag ${draftRev.generation_status === 'published' ? 'admin-reports-pill-tag-published' : 'admin-reports-pill-tag-draft'}`}>
                        {draftRev.generation_status.toUpperCase()}
                      </span>
                      {draftRev.is_year_to_date && (
                        <span className="admin-reports-pill-tag" style={{ background: '#dbeafe', color: '#1e40af' }}>
                          Year-To-Date (YTD)
                        </span>
                      )}
                    </div>
                    <div style={{ fontSize: '12px', color: '#64748b', marginTop: '6px', display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
                      <span>Period: {draftRev.period_start} to {draftRev.period_end}</span>
                      <span>•</span>
                      <span>Generated: {new Date(draftRev.generated_at).toLocaleString()}</span>
                      <span>•</span>
                      <span>SHA-256: <code>{draftRev.content_hash ? `${draftRev.content_hash.slice(0, 16)}...` : '—'}</code></span>
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px', flexWrap: 'wrap' }}>
                    <button
                      onClick={() => handleDownloadPdf(true)}
                      disabled={downloadingPdf}
                      className="admin-reports-btn-download"
                    >
                      <FileDown className="w-4 h-4 text-gray-500" />
                      <span>{downloadingPdf ? 'Downloading...' : 'Download Draft PDF'}</span>
                    </button>

                    <button
                      onClick={() => setShowPublishModal(true)}
                      disabled={publishing || draftRev.generation_status === 'published'}
                      className="admin-reports-btn-publish"
                    >
                      <Check className="w-4 h-4" />
                      <span>{draftRev.generation_status === 'published' ? 'Published' : 'Publish Revision'}</span>
                    </button>
                  </div>
                </div>

                {/* Key Metrics Snapshot Grid */}
                {draftRev.snapshot_data?.summary_metrics && (
                  <div>
                    <h3 style={{ fontSize: '12px', fontWeight: 700, color: '#475569', textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '12px' }}>
                      Snapshot Key Metrics ({draftRev.snapshot_data.metadata?.year || selectedYear})
                    </h3>
                    <div className="admin-reports-metrics-grid">
                      <div className="admin-reports-metric-card">
                        <Calendar className="w-4 h-4 mx-auto text-primary mb-1" />
                        <div className="admin-reports-metric-val">
                          {draftRev.snapshot_data.summary_metrics.sessions_held ?? 0}
                        </div>
                        <div className="admin-reports-metric-lbl">Sessions Held</div>
                      </div>

                      <div className="admin-reports-metric-card">
                        <Users className="w-4 h-4 mx-auto text-primary mb-1" />
                        <div className="admin-reports-metric-val">
                          {draftRev.snapshot_data.summary_metrics.total_attendance_visits ?? 0}
                        </div>
                        <div className="admin-reports-metric-lbl" title="Repeat participation included. Never unique persons.">
                          Attendance Visits*
                        </div>
                      </div>

                      <div className="admin-reports-metric-card">
                        <Clock className="w-4 h-4 mx-auto text-primary mb-1" />
                        <div className="admin-reports-metric-val">
                          {draftRev.snapshot_data.summary_metrics.total_session_hours ?? 0}h
                        </div>
                        <div className="admin-reports-metric-lbl">Total Hours</div>
                      </div>

                      <div className="admin-reports-metric-card">
                        <Clock className="w-4 h-4 mx-auto text-primary mb-1" />
                        <div className="admin-reports-metric-val">
                          {draftRev.snapshot_data.summary_metrics.average_attendance_per_session ?? '—'}
                        </div>
                        <div className="admin-reports-metric-lbl">Avg Visits / Ssn</div>
                      </div>

                      <div className="admin-reports-metric-card">
                        <BookOpen className="w-4 h-4 mx-auto text-primary mb-1" />
                        <div className="admin-reports-metric-val">
                          {draftRev.snapshot_data.timeline_sessions?.length ?? draftRev.snapshot_data.summary_metrics.sessions_held}
                        </div>
                        <div className="admin-reports-metric-lbl">Works Explored</div>
                      </div>

                      <div className="admin-reports-metric-card">
                        <MessageSquareQuote className="w-4 h-4 mx-auto text-primary mb-1" />
                        <div className="admin-reports-metric-val">
                          {draftRev.snapshot_data.approved_quotes?.length ?? draftRev.snapshot_data.member_quotes?.length ?? 0}
                        </div>
                        <div className="admin-reports-metric-lbl">Approved Quotes</div>
                      </div>
                    </div>

                    <p style={{ fontSize: '11.5px', color: '#94a3b8', marginTop: '12px' }}>
                      * Attendance visits reflect cumulative session participation (repeat visits included). Per club governance principles, unique individuals are never derived from visit totals.
                    </p>
                  </div>
                )}
              </div>
            ) : (
              <div style={{ textAlign: 'center', padding: '48px 16px', border: '2px dashed #e2e8f0', borderRadius: '16px' }}>
                <FileDown className="w-10 h-10 text-gray-400 mx-auto mb-2" />
                <h3 style={{ fontSize: '15px', fontWeight: 600, color: '#1e293b', margin: '0 0 4px' }}>No Draft Revision Generated Yet</h3>
                <p style={{ fontSize: '13px', color: '#64748b', margin: 0 }}>
                  Click the button above to execute the report calculation engine and generate Revision #1 for {selectedYear}.
                </p>
              </div>
            )}
          </div>
        </>
      )}

      {/* Manual Publication Confirmation Modal */}
      {showPublishModal && draftRev && (
        <div className="admin-reports-modal-overlay">
          <div className="admin-reports-modal-dialog">
            <div style={{ display: 'flex', alignItems: 'flex-start', gap: '14px', marginBottom: '16px' }}>
              <div style={{ width: '44px', height: '44px', borderRadius: '12px', background: '#fef3c7', color: '#b45309', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                <ShieldAlert className="w-6 h-6" />
              </div>
              <div>
                <h3 style={{ fontSize: '18px', fontWeight: 700, color: '#0f172a', margin: '0 0 4px' }}>
                  Publish Revision #{draftRev.revision_number}?
                </h3>
                <p style={{ fontSize: '12.5px', color: '#64748b', margin: 0 }}>
                  Manual publication gate for Annual Report {selectedYear}.
                </p>
              </div>
            </div>

            <div style={{ background: '#f8fafc', padding: '14px 16px', borderRadius: '14px', border: '1px solid #e2e8f0', fontSize: '13px', color: '#334155', marginBottom: '20px' }}>
              <p style={{ margin: '0 0 6px', fontWeight: 600 }}>By publishing this revision:</p>
              <ul style={{ margin: '0 0 0 16px', padding: 0, fontSize: '12px', color: '#475569', lineHeight: 1.6 }}>
                <li>This exact snapshot (SHA-256: <code>{draftRev.content_hash ? `${draftRev.content_hash.slice(0, 10)}...` : '—'}</code>) will become publicly visible on <strong>/reports</strong> and <strong>/reports/{selectedYear}</strong>.</li>
                <li>Public downloads will resolve this official signed vector PDF.</li>
                <li>Draft status will be upgraded to <strong>Published</strong>.</li>
              </ul>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: '10px' }}>
              <button
                type="button"
                onClick={() => setShowPublishModal(false)}
                className="admin-reports-modal-cancel"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handlePublish}
                disabled={publishing}
                className="admin-reports-btn-publish"
                style={{ padding: '10px 20px', fontSize: '13.5px' }}
              >
                {publishing ? 'Publishing...' : 'Yes, Publish Official Report'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
