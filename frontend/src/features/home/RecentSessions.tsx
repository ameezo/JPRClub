import { useTranslation } from 'react-i18next';
import SessionCard from '../../components/SessionCard';

export default function RecentSessions() {
  const { t } = useTranslation();

  // Fictional placeholder data
  const sessions = [
    {
      id: "24",
      date: "Sunday, Oct 8",
      title: "News: Autumn Festivals",
      titleAr: "أخبار: مهرجانات الخريف",
      excerpt: "Reading NHK Easy News articles about traditional autumn matsuri.",
      excerptAr: "قراءة مقالات من أخبار NHK المبسطة حول مهرجانات الخريف التقليدية."
    },
    {
      id: "23",
      date: "Sunday, Oct 1",
      title: "Short Story: The Restaurant of Many Orders",
      titleAr: "قصة قصيرة: مطعم الطلبات الكثيرة",
      excerpt: "Analyzing Kenji Miyazawa's classic tale.",
      excerptAr: "تحليل قصة كينجي ميازاوا الكلاسيكية."
    },
    {
      id: "22",
      date: "Sunday, Sep 24",
      title: "Grammar Deep Dive: N4 Conditionals",
      titleAr: "تعمق في القواعد: الشرط في مستوى N4",
      excerpt: "Practice session focusing on ba, to, tara, and nara.",
      excerptAr: "جلسة تدريب تركز على قواعد الشرط."
    }
  ];

  return (
    <section className="section sessions-section">
      <div className="section-header">
        <h2>{t('home.pastSessions')}</h2>
        <p>{t('home.catchUp')}</p>
      </div>
      
      <div className="session-grid">
        {sessions.map(session => (
          <SessionCard key={session.id} {...session} />
        ))}
      </div>
    </section>
  );
}
