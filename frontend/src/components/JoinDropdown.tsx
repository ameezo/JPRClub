import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { 
  ChevronDown, 
  MessageCircle, 
  HandHeart, 
  Users, 
  Lightbulb, 
  ExternalLink 
} from 'lucide-react';
import { WHATSAPP_GROUP_URL, type Session } from '@/lib/api';

interface JoinDropdownProps {
  nextSession?: Session | null;
  className?: string;
  align?: 'center' | 'end' | 'start';
  buttonLabel?: string;
}

export default function JoinDropdown({ 
  nextSession, 
  className = '', 
  align = 'center',
  buttonLabel 
}: JoinDropdownProps) {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [isOpen, setIsOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }

    function handleKeyDown(event: KeyboardEvent) {
      if (event.key === 'Escape') {
        setIsOpen(false);
      }
    }

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
      document.addEventListener('keydown', handleKeyDown);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      document.removeEventListener('keydown', handleKeyDown);
    };
  }, [isOpen]);

  const handleAttendanceClick = () => {
    setIsOpen(false);
    window.open(WHATSAPP_GROUP_URL, '_blank', 'noopener,noreferrer');
  };

  const handleFormOptionClick = (type: 'volunteer' | 'team' | 'instructor') => {
    setIsOpen(false);
    const searchParams = new URLSearchParams();
    if (nextSession?.id) {
      searchParams.set('sessionId', nextSession.id);
    }
    const query = searchParams.toString() ? `?${searchParams.toString()}` : '';
    navigate(`/join/${type}${query}`);
  };

  return (
    <div className={`join-dropdown-wrapper ${className}`} ref={containerRef}>
      <button
        type="button"
        id="join-dropdown-btn"
        className="btn-primary join-trigger-btn"
        onClick={() => setIsOpen(!isOpen)}
        aria-expanded={isOpen}
        aria-haspopup="true"
      >
        <span>{buttonLabel || t('home.joinNext') || 'Join Next Session'}</span>
        <ChevronDown 
          className={`join-chevron ${isOpen ? 'rotated' : ''}`} 
          style={{ width: '18px', height: '18px', transition: 'transform 0.2s ease' }} 
        />
      </button>

      {isOpen && (
        <div 
          className={`join-dropdown-popover popover-align-${align}`} 
          role="dialog" 
          aria-label={t('join.chooseOption') || 'Choose how you want to join'}
        >
          <div className="join-dropdown-header">
            <h4>{t('join.chooseOption') || 'Choose How You Want to Join'}</h4>
          </div>

          <div className="join-dropdown-options">
            {/* 1. Attendance */}
            <button
              type="button"
              className="join-option-item attendance-option"
              onClick={handleAttendanceClick}
            >
              <div className="join-option-icon attendance-icon">
                <MessageCircle style={{ width: '20px', height: '20px' }} />
              </div>
              <div className="join-option-content">
                <div className="join-option-title-row">
                  <span className="join-option-title">{t('join.attendance')}</span>
                  <span className="join-badge-whatsapp">
                    WhatsApp <ExternalLink style={{ width: '12px', height: '12px', display: 'inline', marginInlineStart: '3px' }} />
                  </span>
                </div>
                <p className="join-option-desc">{t('join.attendanceDesc')}</p>
              </div>
            </button>

            {/* 2. Volunteer */}
            <button
              type="button"
              className="join-option-item"
              onClick={() => handleFormOptionClick('volunteer')}
            >
              <div className="join-option-icon volunteer-icon">
                <HandHeart style={{ width: '20px', height: '20px' }} />
              </div>
              <div className="join-option-content">
                <div className="join-option-title-row">
                  <span className="join-option-title">{t('join.volunteer')}</span>
                </div>
                <p className="join-option-desc">{t('join.volunteerDesc')}</p>
              </div>
            </button>

            {/* 3. Join Our Team */}
            <button
              type="button"
              className="join-option-item"
              onClick={() => handleFormOptionClick('team')}
            >
              <div className="join-option-icon team-icon">
                <Users style={{ width: '20px', height: '20px' }} />
              </div>
              <div className="join-option-content">
                <div className="join-option-title-row">
                  <span className="join-option-title">{t('join.team')}</span>
                </div>
                <p className="join-option-desc">{t('join.teamDesc')}</p>
              </div>
            </button>

            {/* 4. Instructor */}
            <button
              type="button"
              className="join-option-item"
              onClick={() => handleFormOptionClick('instructor')}
            >
              <div className="join-option-icon instructor-icon">
                <Lightbulb style={{ width: '20px', height: '20px' }} />
              </div>
              <div className="join-option-content">
                <div className="join-option-title-row">
                  <span className="join-option-title">{t('join.instructor')}</span>
                </div>
                <p className="join-option-desc">{t('join.instructorDesc')}</p>
              </div>
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
