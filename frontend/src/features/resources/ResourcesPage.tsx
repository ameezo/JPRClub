import { useEffect, useState, useMemo } from 'react';
import { useTranslation } from 'react-i18next';
import { 
  type Resource, 
  apiClient 
} from '@/lib/api';
import Container from '@/components/ui/Container';
import { ResourceCard } from './ResourceCard';
import { ResourceModal } from './ResourceModal';
import { 
  Search, 
  X, 
  Plus, 
  ChevronDown, 
  Star, 
  FileSpreadsheet, 
  Sparkles, 
  Headphones, 
  BookOpen, 
  Globe, 
  Languages, 
  Layers,
  RotateCcw,
  LayoutGrid,
  List,
  ExternalLink
} from 'lucide-react';

const YoutubeIcon = ({ className, style }: { className?: string; style?: React.CSSProperties }) => (
  <svg viewBox="0 0 24 24" fill="currentColor" className={className} style={{ width: '14px', height: '14px', ...style }}>
    <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
  </svg>
);

export default function ResourcesPage() {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  const [resources, setResources] = useState<Resource[]>([]);
  const [loading, setLoading] = useState(true);

  // Filters
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [selectedLevel, setSelectedLevel] = useState<string>('all');
  const [selectedJlpt, setSelectedJlpt] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [recommendedOnly, setRecommendedOnly] = useState<boolean>(false);

  // View Mode: Cards Grid vs Compact Index Table ("The B-Sides")
  const [viewMode, setViewMode] = useState<'grid' | 'table'>('grid');

  // Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingResource, setEditingResource] = useState<Resource | null>(null);

  // Current User Check (Admin/Organizer)
  const [isAdmin] = useState<boolean>(() => {
    try {
      const u = localStorage.getItem('user');
      const parsed = u ? JSON.parse(u) : null;
      return parsed?.role === 'admin' || parsed?.role === 'organizer';
    } catch {
      return false;
    }
  });

  const fetchResources = async () => {
    try {
      setLoading(true);
      const res = await apiClient.get<{ items: Resource[]; total: number }>('/resources', {
        params: { limit: 300 }
      });
      setResources(res.data.items || []);
    } catch (err) {
      console.error('Failed to fetch resources:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchResources();
  }, []);

  // Filter calculation
  const filteredResources = useMemo(() => {
    return resources.filter((item) => {
      // Category filter
      if (selectedCategory !== 'all' && item.category !== selectedCategory) {
        return false;
      }

      // Level filter
      if (selectedLevel !== 'all') {
        if (selectedLevel === 'jlpt') {
          const isJlpt = item.level === 'jlpt' || !!item.jlpt_sublevel;
          if (!isJlpt) return false;
        } else if (selectedLevel === 'starter') {
          const isStarter = item.level === 'starter' || (item.jlpt_sublevel && item.jlpt_sublevel.includes('N5'));
          if (!isStarter) return false;
        } else if (item.level !== selectedLevel) {
          return false;
        }
      }

      // JLPT Sub-level filter
      if (selectedJlpt !== 'all') {
        if (!item.jlpt_sublevel || !item.jlpt_sublevel.toLowerCase().includes(selectedJlpt.toLowerCase())) {
          return false;
        }
      }

      // Recommended filter
      if (recommendedOnly && !item.is_recommended) {
        return false;
      }

      // Search Query
      if (searchQuery.trim()) {
        const query = searchQuery.toLowerCase().trim();
        const matchesTitle = item.title.toLowerCase().includes(query);
        const matchesTitleAr = item.title_ar?.toLowerCase().includes(query);
        const matchesDesc = item.description?.toLowerCase().includes(query);
        const matchesDescAr = item.description_ar?.toLowerCase().includes(query);
        const matchesNotes = item.notes?.toLowerCase().includes(query);
        if (!matchesTitle && !matchesTitleAr && !matchesDesc && !matchesDescAr && !matchesNotes) {
          return false;
        }
      }

      return true;
    });
  }, [resources, selectedCategory, selectedLevel, selectedJlpt, searchQuery, recommendedOnly]);

  const hasActiveFilters = 
    selectedCategory !== 'all' || 
    selectedLevel !== 'all' || 
    selectedJlpt !== 'all' || 
    recommendedOnly || 
    searchQuery.trim().length > 0;

  const handleClearFilters = () => {
    setSelectedCategory('all');
    setSelectedLevel('all');
    setSelectedJlpt('all');
    setRecommendedOnly(false);
    setSearchQuery('');
  };

  const handleEdit = (resource: Resource) => {
    setEditingResource(resource);
    setIsModalOpen(true);
  };

  const handleCreate = () => {
    setEditingResource(null);
    setIsModalOpen(true);
  };

  const handleDelete = async (id: string) => {
    if (!window.confirm(isAr ? 'هل أنت متأكد من حذف هذا المصدر؟' : 'Are you sure you want to delete this resource?')) {
      return;
    }
    try {
      await apiClient.delete(`/resources/${id}`);
      fetchResources();
    } catch (err) {
      console.error('Delete resource error:', err);
      alert(isAr ? 'فشل حذف المصدر' : 'Failed to delete resource');
    }
  };

  const handleSyncExcel = async () => {
    if (!window.confirm(isAr ? 'هل تريد استيراد أو تحديث البودكاست من ملف الإكسل؟' : 'Import/update podcasts from Japanese_Podcasts_N5_to_N1.xlsx?')) {
      return;
    }
    try {
      const res = await apiClient.post<{ message: string; count: number }>('/resources/seed-excel');
      alert(res.data.message);
      fetchResources();
    } catch (err) {
      console.error('Sync Excel error:', err);
      alert(isAr ? 'فشل استيراد الملف' : 'Failed to import Excel file');
    }
  };

  const categoryPills = [
    { id: 'all', label: isAr ? 'الكل' : 'All', icon: <Layers className="w-3.5 h-3.5" /> },
    { id: 'podcast', label: isAr ? 'بودكاست' : 'Podcast', icon: <Headphones className="w-3.5 h-3.5" /> },
    { id: 'reading', label: isAr ? 'قراءة' : 'Reading', icon: <BookOpen className="w-3.5 h-3.5" /> },
    { id: 'youtube', label: isAr ? 'يوتيوب' : 'YouTube', icon: <YoutubeIcon className="w-3.5 h-3.5" /> },
    { id: 'websites', label: isAr ? 'مواقع' : 'Websites', icon: <Globe className="w-3.5 h-3.5" /> },
    { id: 'grammar', label: isAr ? 'قواعد' : 'Grammar', icon: <Languages className="w-3.5 h-3.5" /> },
    { id: 'hiragana_katakana', label: isAr ? 'هيراغانا وكاتاكانا' : 'Kana', icon: <span style={{ fontFamily: 'serif', fontWeight: 800 }}>あ</span> },
  ];

  return (
    <div className="public-page-wrapper">
      <Container>
        {/* Header */}
        <div className="resources-header-box">
          <div className="tactile-stamp resources-badge">
            <Sparkles style={{ width: '14px', height: '14px', color: 'var(--accent-sakura)' }} />
            <span>{isAr ? 'المكتبة الرقمية والمصادر المنسقة' : 'Curated Japanese Reading & Audio Hub'}</span>
          </div>
          <h1 className="resources-page-title">
            {t('resources.title') || (isAr ? 'المصادر والأدلة' : 'Resources & Directory')}
          </h1>
          <p className="resources-page-desc">
            {t('resources.subtitle') || (isAr 
              ? 'مجموعة مختارة بعناية من برامج البودكاست، ومصادر القراءة، وقنوات اليوتيوب، وشروحات القواعد لدعم مسيرتك في تعلم اليابانية.' 
              : 'Hand-picked podcasts, reading libraries, YouTube channels, and grammar references to elevate your Japanese learning journey.')}
          </p>
        </div>

        {/* Admin Quick Action Banner */}
        {isAdmin && (
          <div className="tactile-card resources-admin-bar">
            <div className="resources-admin-info">
              <span style={{ fontSize: '18px' }}>⚡</span>
              <span>
                {isAr ? 'لوحة تحكم المشرف: إدارة وتعديل المصادر واستيراد الإكسل' : 'Admin Controls: Manage resources or import Excel dataset'}
              </span>
            </div>
            <div className="resources-admin-actions">
              <button
                type="button"
                className="tactile-btn tactile-btn-primary"
                onClick={handleCreate}
              >
                <Plus style={{ width: '15px', height: '15px' }} />
                <span>{isAr ? 'إضافة مصدر جديد' : 'Add New Resource'}</span>
              </button>
              <button
                type="button"
                className="tactile-btn"
                onClick={handleSyncExcel}
                title="Re-seed podcasts from Japanese_Podcasts_N5_to_N1.xlsx"
              >
                <FileSpreadsheet style={{ width: '15px', height: '15px' }} />
                <span>{isAr ? 'مزامنة إكسل البودكاست' : 'Sync Excel Podcasts'}</span>
              </button>
            </div>
          </div>
        )}

        {/* Tactile Filter Container */}
        <div className="tactile-card resources-filter-container">
          {/* Main Controls Row */}
          <div className="resources-filter-row">
            {/* Search Input */}
            <div className="resources-search-box">
              <Search className="resources-search-icon" />
              <input
                type="text"
                placeholder={t('resources.searchPlaceholder') || (isAr ? 'ابحث عن بودكاست أو مصدر...' : 'Search resources by title or topic...')}
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="resources-search-input"
              />
              {searchQuery && (
                <button
                  type="button"
                  className="resources-search-clear"
                  onClick={() => setSearchQuery('')}
                >
                  <X style={{ width: '16px', height: '16px' }} />
                </button>
              )}
            </div>

            {/* Dropdowns Group */}
            <div className="resources-select-group">
              {/* Category Dropdown */}
              <div className="resources-dropdown-wrapper">
                <select
                  value={selectedCategory}
                  onChange={(e) => setSelectedCategory(e.target.value)}
                  className="resources-select"
                >
                  <option value="all">📂 {isAr ? 'جميع التصنيفات' : 'All Categories'}</option>
                  <option value="podcast">🎙️ {isAr ? 'بودكاست' : 'Podcast'}</option>
                  <option value="reading">📖 {isAr ? 'قراءة' : 'Reading'}</option>
                  <option value="youtube">▶️ {isAr ? 'يوتيوب' : 'YouTube'}</option>
                  <option value="websites">🌐 {isAr ? 'مواقع' : 'Websites'}</option>
                  <option value="grammar">✍️ {isAr ? 'قواعد' : 'Grammar'}</option>
                  <option value="hiragana_katakana">あ {isAr ? 'هيراغانا وكاتاكانا' : 'Hiragana & Katakana'}</option>
                </select>
                <ChevronDown className="resources-select-chevron" />
              </div>

              {/* Level Dropdown */}
              <div className="resources-dropdown-wrapper">
                <select
                  value={selectedLevel}
                  onChange={(e) => setSelectedLevel(e.target.value)}
                  className="resources-select"
                >
                  <option value="all">🎓 {isAr ? 'جميع المستويات' : 'All Levels'}</option>
                  <option value="starter">🌱 {isAr ? 'مبتدئ' : 'Starter'}</option>
                  <option value="jlpt">⛩️ {isAr ? 'اختبار JLPT' : 'JLPT'}</option>
                  <option value="all_levels">✨ {isAr ? 'شامل كل المستويات' : 'General / All Levels'}</option>
                  <option value="arabic_learner">🌍 {isAr ? 'للناطقين بالعربية' : 'Arabic Learner'}</option>
                </select>
                <ChevronDown className="resources-select-chevron" />
              </div>
            </div>
          </div>

          {/* Quick Category Pills Row */}
          <div className="resources-pills-row">
            {categoryPills.map((pill) => (
              <button
                key={pill.id}
                type="button"
                className={`tactile-btn resource-filter-pill ${selectedCategory === pill.id ? 'active' : ''}`}
                onClick={() => setSelectedCategory(pill.id)}
              >
                {pill.icon}
                <span>{pill.label}</span>
              </button>
            ))}
          </div>

          {/* JLPT Sub-levels Row */}
          {(selectedLevel === 'jlpt' || selectedCategory === 'podcast' || selectedJlpt !== 'all') && (
            <div className="jlpt-sublevels-row">
              <span className="jlpt-sublevels-label">{isAr ? 'مستوى JLPT:' : 'JLPT Level:'}</span>
              {['all', 'N5', 'N4', 'N3', 'N2', 'N1'].map((lvl) => (
                <button
                  key={lvl}
                  type="button"
                  className={`tactile-stamp jlpt-sub-pill ${selectedJlpt === lvl ? 'active' : ''}`}
                  onClick={() => setSelectedJlpt(lvl)}
                >
                  {lvl === 'all' ? (isAr ? 'الكل' : 'All') : lvl}
                </button>
              ))}
            </div>
          )}

          {/* Filter Footer / Meta & View Mode Switcher */}
          <div className="resources-filter-meta">
            <div style={{ display: 'flex', alignItems: 'center', gap: '16px', flexWrap: 'wrap' }}>
              <span className="resources-count-label">
                {isAr 
                  ? `عرض ${filteredResources.length} من أصل ${resources.length} مصدر` 
                  : `Showing ${filteredResources.length} of ${resources.length} resources`}
              </span>

              {/* View Mode Switcher */}
              <div className="view-mode-toggle-group" role="group" aria-label="View Mode">
                <button
                  type="button"
                  className={`tactile-btn view-toggle-btn ${viewMode === 'grid' ? 'active' : ''}`}
                  onClick={() => setViewMode('grid')}
                  title="Grid Cards View"
                >
                  <LayoutGrid size={15} />
                  <span>{isAr ? 'شبكة البطاقات' : 'Cards'}</span>
                </button>
                <button
                  type="button"
                  className={`tactile-btn view-toggle-btn ${viewMode === 'table' ? 'active' : ''}`}
                  onClick={() => setViewMode('table')}
                  title="Compact Index Table View (The B-Sides)"
                >
                  <List size={15} />
                  <span>{isAr ? 'الفهرس السريع' : 'Directory Table'}</span>
                </button>
              </div>

              {/* Misa Recommended Pick Filter */}
              <button
                type="button"
                className={`tactile-stamp btn-filter-misa-pick ${recommendedOnly ? 'active' : ''}`}
                onClick={() => setRecommendedOnly(!recommendedOnly)}
              >
                <Star style={{ width: '13px', height: '13px', fill: recommendedOnly ? 'currentColor' : 'none' }} />
                <span>★ Misa Picks Only</span>
              </button>
            </div>

            {hasActiveFilters && (
              <button
                type="button"
                className="tactile-btn btn-clear-filters"
                onClick={handleClearFilters}
              >
                <RotateCcw size={13} />
                <span>{isAr ? 'إعادة ضبط التصفية' : 'Reset filters'}</span>
              </button>
            )}
          </div>
        </div>

        {/* Resources Content: Grid or Index Table */}
        {loading ? (
          <div className="public-empty-state" style={{ padding: '60px 0', textAlign: 'center' }}>
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-primary mx-auto mb-4" style={{ borderColor: 'var(--accent-sakura)' }}></div>
            <p>{isAr ? 'جاري تحميل المصادر...' : 'Loading resources...'}</p>
          </div>
        ) : filteredResources.length === 0 ? (
          <div className="tactile-card public-empty-state" style={{ padding: '60px 20px', textAlign: 'center' }}>
            <Layers style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: 'var(--ink-secondary)' }} />
            <h3 style={{ fontSize: '18px', fontWeight: 700, color: 'var(--ink-primary)', marginBottom: '8px' }}>
              {isAr ? 'لم يتم العثور على مصادر تطابق خيارات البحث' : 'No matching resources found'}
            </h3>
            <p style={{ color: 'var(--ink-secondary)', fontSize: '14px', maxWidth: '420px', margin: '0 auto 16px auto' }}>
              {isAr 
                ? 'جرب تغيير خيارات التصفية أو إزالة شروط البحث للعثور على المصادر المناسبة.' 
                : 'Try adjusting your search query, switching categories, or clearing active filters.'}
            </p>
            {hasActiveFilters && (
              <button
                type="button"
                className="tactile-btn tactile-btn-primary"
                onClick={handleClearFilters}
                style={{ margin: '0 auto' }}
              >
                <RotateCcw style={{ width: '14px', height: '14px' }} />
                <span>{isAr ? 'إلغاء التصفية' : 'Clear Filters'}</span>
              </button>
            )}
          </div>
        ) : viewMode === 'grid' ? (
          <div className="resources-grid">
            {filteredResources.map((resource) => (
              <ResourceCard
                key={resource.id}
                resource={resource}
                isAdmin={isAdmin}
                onEdit={handleEdit}
                onDelete={handleDelete}
              />
            ))}
          </div>
        ) : (
          /* Index Table View ("The B-Sides" / Quick Directory) */
          <div className="tactile-card resource-index-table-wrapper">
            <table className="resource-index-table">
              <thead>
                <tr>
                  <th style={{ width: '60px' }}>#</th>
                  <th>{isAr ? 'العنوان والمصدر' : 'Title & Translation'}</th>
                  <th style={{ width: '130px' }}>{isAr ? 'التصنيف' : 'Category'}</th>
                  <th style={{ width: '120px' }}>{isAr ? 'المستوى' : 'Level'}</th>
                  <th style={{ width: '130px' }}>{isAr ? 'التوصية' : 'Pick'}</th>
                  <th style={{ width: '120px', textAlign: 'center' }}>{isAr ? 'رابط' : 'Link'}</th>
                </tr>
              </thead>
              <tbody>
                {filteredResources.map((resource, idx) => {
                  const displayTitle = isAr && resource.title_ar ? resource.title_ar : resource.title;
                  const secondaryTitle = isAr ? (resource.title_ar ? resource.title : null) : resource.title_ar;
                  const numStr = String(idx + 1).padStart(2, '0');

                  return (
                    <tr key={resource.id} className="resource-table-row">
                      <td className="table-col-num">{numStr}</td>
                      <td className="table-col-title">
                        <div className="table-primary-title">{displayTitle}</div>
                        {secondaryTitle && (
                          <div className="table-secondary-title">{secondaryTitle}</div>
                        )}
                      </td>
                      <td className="table-col-category">
                        <span className="tactile-stamp table-category-stamp">
                          {resource.category}
                        </span>
                      </td>
                      <td className="table-col-level">
                        <span className="tactile-stamp table-level-stamp">
                          {resource.jlpt_sublevel || resource.level}
                        </span>
                      </td>
                      <td className="table-col-pick">
                        {resource.is_recommended && (
                          <span className="badge-misa-pick">
                            ★ Misa Pick
                          </span>
                        )}
                      </td>
                      <td className="table-col-action">
                        <a
                          href={resource.url}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="tactile-btn table-open-link"
                          title="Open resource in new tab"
                        >
                          <span>{isAr ? 'فتح' : 'Open'}</span>
                          <ExternalLink size={13} />
                        </a>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}

        {/* Add / Edit Modal */}
        <ResourceModal
          isOpen={isModalOpen}
          initialResource={editingResource}
          onClose={() => setIsModalOpen(false)}
          onSuccess={fetchResources}
        />
      </Container>
    </div>
  );
}
