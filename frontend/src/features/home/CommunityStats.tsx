import { useTranslation } from 'react-i18next';

export default function CommunityStats() {
  const { i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  const stats = [
    {
      value: '25+',
      title: isAr ? 'جلسة قراءة مكتملة' : 'Sessions Held',
      desc: isAr ? 'أكواب شاي وفصول أُنجزت' : 'Cups of tea & chapters read',
      icon: '🍵',
    },
    {
      value: '102',
      title: isAr ? 'مصدر رقمي مختار' : 'Curated Resources',
      desc: isAr ? 'أدلة وقنوات وبودكاست' : 'Handpicked tools & guides',
      icon: '📚',
    },
    {
      value: '4',
      title: isAr ? 'أنماط قراءة متنوعة' : 'Reading Formats',
      desc: isAr ? 'روايات، مانجا، مقالات ومقتطفات' : 'Novels, Manga, Essays & Articles',
      icon: '🔖',
    },
    {
      value: 'N5–N1',
      title: isAr ? 'نرحب بجميع المستويات' : 'All Levels Welcome',
      desc: isAr ? 'من الحروف الأولى حتى الأدب' : 'From first Kana to literature',
      icon: '⛩️',
    },
  ];

  return (
    <section className="community-stat-section">
      <div className="container-custom">
        <div className="stat-strip-container">
          {stats.map((item, idx) => (
            <div key={idx} className="stat-strip-card">
              <div className="stat-strip-icon-row">
                <span className="stat-strip-icon">{item.icon}</span>
                <span className="stat-strip-value">{item.value}</span>
              </div>
              <h4 className="stat-strip-title">{item.title}</h4>
              <p className="stat-strip-desc">{item.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

