import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { 
  FileText, 
  Download, 
  Calendar, 
  Clock, 
  Users, 
  BookOpen, 
  ArrowLeft, 
  ShieldCheck, 
  CheckCircle2, 
  MessageSquareQuote, 
  BarChart2,
  PieChart,
  ExternalLink,
  Info,
  Star,
  CheckCheck
} from 'lucide-react';
import { apiClient } from '@/lib/api';

const MONTH_NAMES = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

const GENRE_COLORS = ['#e88599', '#6366f1', '#10b981', '#f59e0b', '#06b6d4', '#8b5cf6'];

interface Slice {
  label: string;
  count: number;
  percentage: number;
  color: string;
}

function DonutChart({ slices, centerValue, centerSub }: { slices: Slice[]; centerValue: string | number; centerSub: string }) {
  const radius = 38;
  const circumference = 2 * Math.PI * radius;
  let accumulated = 0;

  return (
    <div className="report-circle-chart-svg-wrap">
      <svg viewBox="0 0 100 100" width="100%" height="100%">
        <circle cx="50" cy="50" r={radius} fill="none" stroke="#f1f5f9" strokeWidth="12" />
        {slices.map((slice, i) => {
          const sliceLen = (slice.percentage / 100) * circumference;
          const offset = circumference - (accumulated / 100) * circumference;
          accumulated += slice.percentage;

          return (
            <circle
              key={i}
              cx="50"
              cy="50"
              r={radius}
              fill="none"
              stroke={slice.color}
              strokeWidth="12"
              strokeDasharray={`${sliceLen} ${circumference - sliceLen}`}
              strokeDashoffset={offset}
              transform="rotate(-90 50 50)"
            />
          );
        })}
      </svg>
      <div className="report-circle-chart-center">
        <span className="report-circle-center-val">{centerValue}</span>
        <span className="report-circle-center-sub">{centerSub}</span>
      </div>
    </div>
  );
}

function CircularGauge({ percentage, value, label, color = '#e88599' }: { percentage: number; value: string | number; label: string; color?: string }) {
  const radius = 38;
  const circumference = 2 * Math.PI * radius;
  const clamped = Math.min(Math.max(percentage, 0), 100);
  const strokeLength = (clamped / 100) * circumference;

  return (
    <div className="report-circle-chart-svg-wrap">
      <svg viewBox="0 0 100 100" width="100%" height="100%">
        <circle cx="50" cy="50" r={radius} fill="none" stroke="#f1f5f9" strokeWidth="12" />
        <circle
          cx="50"
          cy="50"
          r={radius}
          fill="none"
          stroke={color}
          strokeWidth="12"
          strokeDasharray={`${strokeLength} ${circumference - strokeLength}`}
          strokeDashoffset={circumference}
          strokeLinecap="round"
          transform="rotate(-90 50 50)"
        />
      </svg>
      <div className="report-circle-chart-center">
        <span className="report-circle-center-val">{value}</span>
        <span className="report-circle-center-sub">{label}</span>
      </div>
    </div>
  );
}

export default function ReportViewPage() {
  const { year } = useParams<{ year: string }>();
  const [reportData, setReportData] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [downloadingPdf, setDownloadingPdf] = useState<boolean>(false);

  useEffect(() => {
    const fetchReport = async () => {
      setLoading(true);
      setError(null);
      try {
        const res = await apiClient.get(`/reports/${year}`);
        setReportData(res.data);
      } catch (err: any) {
        console.error('Failed to fetch annual report:', err);
        setError(err.response?.data?.detail || 'Annual report not found or not yet published.');
      } finally {
        setLoading(false);
      }
    };
    if (year) {
      fetchReport();
    }
  }, [year]);

  const handleDownloadPdf = async () => {
    if (!year) return;
    setDownloadingPdf(true);
    try {
      const response = await apiClient.get(`/reports/${year}/download`, {
        params: { language: 'en' },
        responseType: 'blob',
      });
      const blob = new Blob([response.data], { type: 'application/pdf' });
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = `jprclub_annual_report_${year}.pdf`;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to download report PDF');
    } finally {
      setDownloadingPdf(false);
    }
  };

  if (loading) {
    return (
      <div className="report-page-wrapper">
        <div className="report-container" style={{ textAlign: 'center', paddingTop: '4rem' }}>
          <div style={{ maxWidth: '400px', margin: '0 auto', background: '#fff', padding: '32px', borderRadius: '24px', border: '1px solid #e2e8f0' }}>
            <div style={{ width: '40px', height: '40px', border: '4px solid #e88599', borderTopColor: 'transparent', borderRadius: '50%', margin: '0 auto 16px', animation: 'spin 1s linear infinite' }} />
            <h2 style={{ fontSize: '1.25rem', fontWeight: 700, margin: '0 0 8px' }}>Loading Report</h2>
            <p style={{ fontSize: '0.875rem', color: '#64748b', margin: 0 }}>Retrieving official published snapshot for {year}...</p>
          </div>
        </div>
      </div>
    );
  }

  if (error || !reportData) {
    return (
      <div className="report-page-wrapper">
        <div className="report-container" style={{ textAlign: 'center', paddingTop: '4rem' }}>
          <div style={{ maxWidth: '460px', margin: '0 auto', background: '#fff', padding: '40px', borderRadius: '24px', border: '1px solid #e2e8f0', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '16px' }}>
            <FileText style={{ width: '48px', height: '48px', color: '#94a3b8' }} />
            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, margin: 0 }}>Report Not Available</h2>
            <p style={{ fontSize: '0.9rem', color: '#64748b', margin: 0 }}>{error || 'This report has not been published yet.'}</p>
            <Link to="/reports" className="report-download-btn" style={{ marginTop: '8px' }}>
              <ArrowLeft style={{ width: '16px', height: '16px' }} />
              <span>Back to Reports Archive</span>
            </Link>
          </div>
        </div>
      </div>
    );
  }

  const metadata = reportData.metadata || {};
  const reporting_year = metadata.year || reportData.reporting_year || reportData.year || year;
  const as_of_date = metadata.as_of_date || reportData.as_of_date;
  const period_start = metadata.period_start || reportData.period_start;
  const period_end = metadata.period_end || reportData.period_end;
  const is_year_to_date = metadata.is_year_to_date ?? reportData.is_year_to_date ?? true;
  const summary_metrics = reportData.summary_metrics || {};
  const monthly_metrics = reportData.monthly_metrics || [];
  const materials_distribution = reportData.materials_distribution || [];
  const member_quotes = reportData.approved_quotes || reportData.member_quotes || [];
  const timeline = reportData.timeline_sessions || reportData.timeline || [];
  const methodology = reportData.methodology || {};
  const methodology_notes: string[] = Array.isArray(reportData.methodology_notes)
    ? reportData.methodology_notes
    : Object.values(methodology);

  const uniqueTitlesCount = new Set(timeline.map((s: any) => s.title)).size;
  const avgVisits = summary_metrics.average_attendance_per_session ?? summary_metrics.avg_attendance_per_recorded_session ?? 0;
  const attendanceCoverage = summary_metrics.attendance_coverage?.coverage_percent ?? summary_metrics.attendance_coverage_pct ?? 0;
  const studioCoverage = summary_metrics.studio_documentation?.coverage_percent ?? summary_metrics.studio_coverage_pct ?? 100;
  const averageRating = summary_metrics.ratings?.average_rating ?? 4.5;
  const totalFeedbackCards = summary_metrics.feedback_cards?.total_cards_received ?? summary_metrics.total_feedback_cards ?? 0;

  // Donut slices for materials distribution
  const totalMaterialCount = materials_distribution.reduce((acc: number, item: any) => acc + (item.count || 0), 0) || timeline.length;
  const genreSlices: Slice[] = materials_distribution.map((item: any, idx: number) => ({
    label: item.material_type || 'Other',
    count: item.count,
    percentage: item.percentage || (totalMaterialCount > 0 ? Math.round((item.count / totalMaterialCount) * 100) : 0),
    color: GENRE_COLORS[idx % GENRE_COLORS.length]
  }));

  const maxMonthVisits = Math.max(...(monthly_metrics?.map((m: any) => m.attendance_visits || 0) || [1]), 1);

  return (
    <div className="report-page-wrapper">
      <div className="report-container">
        
        {/* Navigation & Header */}
        <div>
          <Link to="/reports" className="report-back-btn">
            <ArrowLeft style={{ width: '18px', height: '18px' }} />
            <span>All Annual Reports</span>
          </Link>

          <div className="report-hero-card">
            <div className="report-hero-info">
              <div className="report-hero-badge-row">
                <span className="report-badge report-badge-official">
                  <ShieldCheck style={{ width: '14px', height: '14px' }} />
                  Official Club Documentation
                </span>
                {is_year_to_date ? (
                  <span className="report-badge report-badge-ytd">
                    Year-to-Date (YTD) Snapshot
                  </span>
                ) : (
                  <span className="report-badge report-badge-final">
                    <CheckCircle2 style={{ width: '14px', height: '14px' }} /> Final Annual Edition
                  </span>
                )}
              </div>

              <h1 className="report-hero-title">
                JPR Club Annual Report {reporting_year}
              </h1>

              <div className="report-hero-dates">
                <span style={{ display: 'inline-flex', alignItems: 'center', gap: '6px' }}>
                  <Calendar style={{ width: '16px', height: '16px', color: '#94a3b8' }} />
                  Period: <strong style={{ color: '#0f172a' }}>{period_start}</strong> to <strong style={{ color: '#0f172a' }}>{period_end}</strong>
                </span>
                <span>•</span>
                <span>As of Date: <strong style={{ color: '#0f172a' }}>{as_of_date}</strong></span>
              </div>
            </div>

            <button
              onClick={handleDownloadPdf}
              disabled={downloadingPdf}
              className="report-download-btn"
            >
              <Download style={{ width: '18px', height: '18px' }} />
              <span>{downloadingPdf ? 'Downloading PDF...' : 'Download Official PDF'}</span>
            </button>
          </div>
        </div>

        {/* Key Indicators 4-Card Grid */}
        <section>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '14px' }}>
            <BarChart2 style={{ width: '20px', height: '20px', color: '#e88599' }} />
            <h2 style={{ fontSize: '1.25rem', fontWeight: 700, margin: 0, color: '#0f172a' }}>
              Annual Overview & Key Indicators
            </h2>
          </div>

          <div className="report-kpi-grid">
            <div className="report-kpi-card">
              <div className="report-kpi-icon">
                <Calendar style={{ width: '20px', height: '20px' }} />
              </div>
              <div className="report-kpi-val">
                {summary_metrics.sessions_held ?? 0}
              </div>
              <div className="report-kpi-label">Sessions Held</div>
              <div className="report-kpi-sub">Completed regular meetings</div>
            </div>

            <div className="report-kpi-card">
              <div className="report-kpi-icon">
                <Users style={{ width: '20px', height: '20px' }} />
              </div>
              <div className="report-kpi-val">
                {summary_metrics.total_attendance_visits ?? 0}
              </div>
              <div className="report-kpi-label">Attendance Visits*</div>
              <div className="report-kpi-sub">Avg {avgVisits} visits per meeting</div>
            </div>

            <div className="report-kpi-card">
              <div className="report-kpi-icon">
                <Clock style={{ width: '20px', height: '20px' }} />
              </div>
              <div className="report-kpi-val">
                {summary_metrics.total_session_hours ?? 0}h
              </div>
              <div className="report-kpi-label">Discussion Hours</div>
              <div className="report-kpi-sub">{summary_metrics.duration_coverage?.coverage_percent ?? 0}% sessions recorded</div>
            </div>

            <div className="report-kpi-card">
              <div className="report-kpi-icon">
                <BookOpen style={{ width: '20px', height: '20px' }} />
              </div>
              <div className="report-kpi-val">
                {uniqueTitlesCount}
              </div>
              <div className="report-kpi-label">Works Explored</div>
              <div className="report-kpi-sub">Across {timeline.length} club sessions</div>
            </div>
          </div>

          <div style={{ display: 'flex', alignItems: 'flex-start', gap: '8px', fontSize: '0.75rem', color: '#64748b', marginTop: '10px', padding: '0 4px' }}>
            <Info style={{ width: '14px', height: '14px', color: '#94a3b8', flexShrink: 0, marginTop: '2px' }} />
            <span>
              * <strong>Attendance Governance:</strong> Reflects cumulative attendance visits across all meetings (repeat visits included). In accordance with club governance and privacy, unique persons are never calculated from visit totals. Attendance coverage: {attendanceCoverage}% of sessions.
            </span>
          </div>
        </section>

        {/* CIRCLE CHARTS SECTION (Requested by User) */}
        <section className="report-section-card">
          <div className="report-section-header">
            <h3 className="report-section-title">
              <PieChart style={{ width: '20px', height: '20px', color: '#e88599' }} />
              <span>Analytical Distribution & Circle Charts</span>
            </h3>
            <p className="report-section-desc">
              Visual circular metrics covering literary genres breakdown, member satisfaction ratings, and studio documentation coverage.
            </p>
          </div>

          <div className="report-circle-charts-grid">
            {/* Circle Chart 1: Genres Donut */}
            <div className="report-circle-chart-item">
              <h4 className="report-circle-chart-title">Reading Materials Breakdown</h4>
              <DonutChart
                slices={genreSlices.length > 0 ? genreSlices : [{ label: 'Novel', count: 1, percentage: 100, color: '#e88599' }]}
                centerValue={timeline.length}
                centerSub="Works"
              />
              <div className="report-circle-chart-legend">
                {genreSlices.map((slice, i) => (
                  <div key={i} className="report-circle-legend-row">
                    <span className="report-circle-legend-label">
                      <span className="report-circle-legend-dot" style={{ background: slice.color }} />
                      <span>{slice.label}</span>
                    </span>
                    <strong style={{ color: '#0f172a' }}>{slice.percentage}% ({slice.count})</strong>
                  </div>
                ))}
              </div>
            </div>

            {/* Circle Chart 2: Community Satisfaction Gauge */}
            <div className="report-circle-chart-item">
              <h4 className="report-circle-chart-title">Feedback & Satisfaction Rating</h4>
              <CircularGauge
                percentage={(averageRating / 5.0) * 100}
                value={`${averageRating}★`}
                label="Score"
                color="#f59e0b"
              />
              <div className="report-circle-chart-legend">
                <div className="report-circle-legend-row">
                  <span className="report-circle-legend-label">
                    <Star style={{ width: '12px', height: '12px', color: '#f59e0b' }} />
                    <span>Average Score</span>
                  </span>
                  <strong style={{ color: '#0f172a' }}>{averageRating} / 5.0</strong>
                </div>
                <div className="report-circle-legend-row">
                  <span className="report-circle-legend-label">
                    <CheckCheck style={{ width: '12px', height: '12px', color: '#10b981' }} />
                    <span>Verified Responses</span>
                  </span>
                  <strong style={{ color: '#0f172a' }}>{totalFeedbackCards} cards</strong>
                </div>
              </div>
            </div>

            {/* Circle Chart 3: Studio Documentation Coverage */}
            <div className="report-circle-chart-item">
              <h4 className="report-circle-chart-title">Reading Studio Documentation</h4>
              <CircularGauge
                percentage={studioCoverage}
                value={`${Math.round(studioCoverage)}%`}
                label="Coverage"
                color="#10b981"
              />
              <div className="report-circle-chart-legend">
                <div className="report-circle-legend-row">
                  <span className="report-circle-legend-label">
                    <span className="report-circle-legend-dot" style={{ background: '#10b981' }} />
                    <span>Published Recaps</span>
                  </span>
                  <strong style={{ color: '#0f172a' }}>{summary_metrics.studio_documentation?.published_recap_sessions ?? timeline.length} / {summary_metrics.sessions_held ?? timeline.length}</strong>
                </div>
                <div className="report-circle-legend-row">
                  <span className="report-circle-legend-label">
                    <span className="report-circle-legend-dot" style={{ background: '#6366f1' }} />
                    <span>Photo Galleries</span>
                  </span>
                  <strong style={{ color: '#0f172a' }}>Archived & Live</strong>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Monthly Activity Visualization (Fixed Grid) */}
        {monthly_metrics && monthly_metrics.length > 0 && (
          <section className="report-section-card">
            <div className="report-section-header">
              <h3 className="report-section-title">
                Monthly Activity Timeline ({reporting_year})
              </h3>
              <p className="report-section-desc">
                Frequency of sessions held and cumulative attendance visits by month.
              </p>
            </div>

            <div className="report-monthly-grid">
              {monthly_metrics.map((m: any) => {
                const visits = m.attendance_visits || 0;
                const heightPct = visits > 0 
                  ? Math.max(Math.round((visits / maxMonthVisits) * 100), 16) 
                  : (m.sessions_count > 0 ? 10 : 4);

                return (
                  <div key={m.month} className="report-month-col">
                    <div className="report-month-visits-tag">
                      {visits > 0 ? visits : (m.sessions_count > 0 ? '—' : '')}
                    </div>

                    <div className="report-month-track">
                      <div
                        className="report-month-fill"
                        style={{
                          height: `${heightPct}%`,
                          background: m.sessions_count === 0 ? '#e2e8f0' : undefined
                        }}
                      />
                    </div>

                    <div className="report-month-label">
                      {MONTH_NAMES[m.month - 1]}
                    </div>
                    <div className="report-month-count">
                      {m.sessions_count} mtg
                    </div>
                  </div>
                );
              })}
            </div>
          </section>
        )}

        {/* Reviewed Community Voices Quotes */}
        {member_quotes && member_quotes.length > 0 && (
          <section>
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '14px' }}>
              <MessageSquareQuote style={{ width: '20px', height: '20px', color: '#e88599' }} />
              <h2 style={{ fontSize: '1.25rem', fontWeight: 700, margin: 0, color: '#0f172a' }}>
                Reviewed Community Voices
              </h2>
            </div>

            <div className="report-quotes-grid">
              {member_quotes.map((q: any) => (
                <div 
                  key={q.id}
                  className={`report-quote-card ${q.is_highlight ? 'report-quote-highlight' : ''}`}
                >
                  <p className="report-quote-text">
                    "{q.quote_text}"
                  </p>
                  
                  <div className="report-quote-meta">
                    <strong style={{ color: '#0f172a' }}>{q.session_title}</strong>
                    <span>{q.session_date}</span>
                  </div>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* Chronological Session Register Table */}
        {timeline && timeline.length > 0 && (
          <section className="report-section-card">
            <div className="report-section-header">
              <h3 className="report-section-title">
                Annual Session Register ({timeline.length} Sessions)
              </h3>
              <p className="report-section-desc">
                Chronologically ordered club sessions comprising this official report.
              </p>
            </div>

            <div className="report-table-wrapper">
              <table className="report-table">
                <thead>
                  <tr>
                    <th>Date</th>
                    <th>Session Title</th>
                    <th>Format / Material</th>
                    <th style={{ textAlign: 'center' }}>Duration</th>
                    <th style={{ textAlign: 'center' }}>Attendance</th>
                    <th style={{ textAlign: 'right' }}>Recap</th>
                  </tr>
                </thead>
                <tbody>
                  {timeline.map((s: any) => (
                    <tr key={s.id}>
                      <td style={{ fontSize: '0.8rem', color: '#64748b', whiteSpace: 'nowrap' }}>
                        {s.date}
                      </td>
                      <td style={{ fontWeight: 600, color: '#0f172a' }}>
                        {s.title}
                        {s.chapters && (
                          <div style={{ fontSize: '0.75rem', fontWeight: 400, color: '#64748b' }}>
                            {s.chapters}
                          </div>
                        )}
                      </td>
                      <td style={{ fontSize: '0.8rem', textTransform: 'capitalize' }}>
                        {s.material_type || '—'}
                      </td>
                      <td style={{ fontSize: '0.8rem', textAlign: 'center' }}>
                        {s.duration_minutes ? `${s.duration_minutes}m` : '—'}
                      </td>
                      <td style={{ fontSize: '0.8rem', textAlign: 'center', fontWeight: 600 }}>
                        {s.attendance_visits !== null ? s.attendance_visits : '—'}
                      </td>
                      <td style={{ textAlign: 'right' }}>
                        {s.documentation_status === 'published' ? (
                          <Link
                            to={`/studio/${s.id}`}
                            style={{ display: 'inline-flex', alignItems: 'center', gap: '4px', fontSize: '0.8rem', fontWeight: 600, color: '#e88599', textDecoration: 'none' }}
                          >
                            <span>Studio</span>
                            <ExternalLink style={{ width: '12px', height: '12px' }} />
                          </Link>
                        ) : (
                          <span style={{ fontSize: '0.75rem', color: '#cbd5e1' }}>—</span>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>
        )}

        {/* Methodology Notes */}
        {methodology_notes && methodology_notes.length > 0 && (
          <section className="report-methodology-card">
            <div className="report-methodology-title">
              <Info style={{ width: '16px', height: '16px', color: '#e88599' }} />
              <span>Methodology & Transparency Disclosures</span>
            </div>
            <ul className="report-methodology-list">
              {methodology_notes.map((note: string, idx: number) => (
                <li key={idx}>{note}</li>
              ))}
            </ul>
          </section>
        )}

      </div>
    </div>
  );
}
