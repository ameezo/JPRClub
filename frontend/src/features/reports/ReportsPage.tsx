import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { 
  FileText, 
  Download, 
  Calendar, 
  ArrowRight, 
  CheckCircle2, 
  Archive, 
  ShieldCheck,
  RefreshCw,
  Info
} from 'lucide-react';
import { apiClient, type PublicReportListItem } from '@/lib/api';

export default function ReportsPage() {
  const [reports, setReports] = useState<PublicReportListItem[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchReports = async () => {
      try {
        const res = await apiClient.get<PublicReportListItem[]>('/reports');
        setReports(res.data);
      } catch (err: any) {
        console.error('Failed to fetch public reports:', err);
        setError('Unable to load annual reports at this time.');
      } finally {
        setLoading(false);
      }
    };
    fetchReports();
  }, []);

  return (
    <div className="report-page-wrapper">
      <div className="report-container">
        
        {/* Hero Header */}
        <div style={{ textAlign: 'center', maxWidth: '720px', margin: '0 auto 1.5rem' }}>
          <div style={{ display: 'inline-flex', alignItems: 'center', gap: '8px', padding: '6px 14px', borderRadius: '9999px', background: 'rgba(247, 168, 184, 0.15)', color: '#d95d77', fontSize: '0.75rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '16px' }}>
            <ShieldCheck style={{ width: '16px', height: '16px' }} />
            Official Club Documentation
          </div>
          <h1 style={{ fontSize: '2.5rem', fontWeight: 800, color: '#0f172a', margin: '0 0 16px', lineHeight: 1.2 }}>
            Annual Reports & Archive
          </h1>
          <p style={{ fontSize: '1.1rem', color: '#475569', lineHeight: 1.6, margin: 0 }}>
            Review our yearly community milestones, session analytics, reading lists, and verified club documentation.
          </p>
        </div>

        {/* Content Section */}
        {loading ? (
          <div style={{ textAlign: 'center', padding: '60px 0', color: '#64748b' }}>
            <RefreshCw style={{ width: '32px', height: '32px', animation: 'spin 1s linear infinite', margin: '0 auto 12px', color: '#e88599' }} />
            <p style={{ fontSize: '0.9rem', margin: 0 }}>Retrieving published reports and archives...</p>
          </div>
        ) : error ? (
          <div style={{ maxWidth: '480px', margin: '0 auto', padding: '24px', background: '#fef2f2', color: '#b91c1c', borderRadius: '16px', textAlign: 'center', fontSize: '0.9rem', border: '1px solid #fecaca' }}>
            {error}
          </div>
        ) : reports.length === 0 ? (
          <div style={{ maxWidth: '520px', margin: '0 auto', textAlign: 'center', padding: '48px 32px', background: '#ffffff', borderRadius: '24px', border: '1px solid #e2e8f0' }}>
            <FileText style={{ width: '48px', height: '48px', color: '#cbd5e1', margin: '0 auto 16px' }} />
            <h3 style={{ fontSize: '1.25rem', fontWeight: 700, color: '#0f172a', margin: '0 0 8px' }}>No Reports Published Yet</h3>
            <p style={{ color: '#64748b', fontSize: '0.875rem', margin: 0 }}>
              Our annual reports will appear here once finalized by the club administration.
            </p>
          </div>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
            {reports.map((report) => (
              <div 
                key={`${report.year}-${report.language}`} 
                style={{
                  background: '#ffffff',
                  borderRadius: '24px',
                  padding: '32px',
                  border: '1px solid #e2e8f0',
                  boxShadow: '0 4px 16px -2px rgba(0, 0, 0, 0.04)',
                  display: 'flex',
                  flexDirection: 'row',
                  alignItems: 'center',
                  gap: '24px',
                  justifyContent: 'space-between',
                  boxSizing: 'border-box',
                  flexWrap: 'wrap'
                }}
              >
                {/* Information */}
                <div style={{ display: 'flex', alignItems: 'center', gap: '20px', flex: '1 1 300px' }}>
                  <div style={{
                    width: '64px',
                    height: '64px',
                    borderRadius: '18px',
                    background: report.is_legacy ? '#f1f5f9' : 'rgba(247, 168, 184, 0.15)',
                    color: report.is_legacy ? '#475569' : '#d95d77',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    flexShrink: 0
                  }}>
                    {report.is_legacy ? (
                      <Archive style={{ width: '32px', height: '32px' }} />
                    ) : (
                      <FileText style={{ width: '32px', height: '32px' }} />
                    )}
                  </div>

                  <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flexWrap: 'wrap' }}>
                      <span style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '0.8rem', fontWeight: 700, color: '#64748b' }}>
                        <Calendar style={{ width: '14px', height: '14px' }} />
                        {report.year}
                      </span>
                      {report.is_legacy ? (
                        <span style={{ fontSize: '0.7rem', fontWeight: 700, padding: '2px 10px', borderRadius: '9999px', background: '#f1f5f9', color: '#475569' }}>
                          Historical Archive
                        </span>
                      ) : report.is_year_to_date ? (
                        <span style={{ fontSize: '0.7rem', fontWeight: 700, padding: '2px 10px', borderRadius: '9999px', background: '#eff6ff', color: '#1d4ed8' }}>
                          Year-to-Date (YTD)
                        </span>
                      ) : (
                        <span style={{ fontSize: '0.7rem', fontWeight: 700, padding: '2px 10px', borderRadius: '9999px', background: '#ecfdf5', color: '#047857', display: 'flex', alignItems: 'center', gap: '4px' }}>
                          <CheckCircle2 style={{ width: '12px', height: '12px' }} /> Official Edition
                        </span>
                      )}
                    </div>

                    <h3 style={{ fontSize: '1.4rem', fontWeight: 700, color: '#0f172a', margin: 0 }}>
                      {report.title}
                    </h3>

                    <p style={{ fontSize: '0.875rem', color: '#475569', margin: 0, lineHeight: 1.5 }}>
                      {report.description}
                    </p>
                  </div>
                </div>
                
                {/* Actions */}
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px', flexShrink: 0 }}>
                  {report.has_web_report && (
                    <Link 
                      to={`/reports/${report.year}`}
                      style={{
                        display: 'inline-flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: '6px',
                        padding: '12px 22px',
                        background: '#e88599',
                        color: '#ffffff',
                        borderRadius: '12px',
                        fontWeight: 600,
                        fontSize: '0.9rem',
                        textDecoration: 'none',
                        boxShadow: '0 2px 8px rgba(232, 133, 153, 0.35)',
                        transition: 'all 0.2s ease'
                      }}
                    >
                      <span>View Online</span>
                      <ArrowRight style={{ width: '16px', height: '16px' }} />
                    </Link>
                  )}

                  {report.has_pdf_download && (
                    <a 
                      href={report.download_url}
                      download
                      style={{
                        display: 'inline-flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: '6px',
                        padding: '12px 22px',
                        background: report.has_web_report ? '#f1f5f9' : '#e88599',
                        color: report.has_web_report ? '#334155' : '#ffffff',
                        borderRadius: '12px',
                        fontWeight: 600,
                        fontSize: '0.9rem',
                        textDecoration: 'none',
                        transition: 'all 0.2s ease'
                      }}
                    >
                      <Download style={{ width: '16px', height: '16px' }} />
                      <span>Download PDF</span>
                    </a>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Governance & Transparency Disclosure Footer */}
        <div style={{ padding: '24px', borderRadius: '20px', background: '#f8fafc', border: '1px solid #e2e8f0', textAlign: 'center', fontSize: '0.8rem', color: '#64748b', display: 'flex', flexDirection: 'column', gap: '8px' }}>
          <strong style={{ color: '#1e293b', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '6px' }}>
            <Info style={{ width: '14px', height: '14px', color: '#e88599' }} />
            Club Governance & Methodology Disclosure
          </strong>
          <p style={{ margin: 0, lineHeight: 1.5 }}>
            All annual reporting statistics are compiled deterministically according to official session documentation. Attendance metrics calculate cumulative attendance visits across completed meetings (repeat participation included) and do not infer unique personal identities. Reports are finalized and published exclusively through authorized club administrator review.
          </p>
        </div>

      </div>
    </div>
  );
}
