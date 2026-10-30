import os
import uuid
import zipfile
import xml.etree.ElementTree as ET
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.resource import Resource

def _parse_xlsx(file_path: str):
    """Parse shared strings and sheets from xlsx without external dependencies."""
    if not os.path.exists(file_path):
        return None, None

    with zipfile.ZipFile(file_path) as z:
        shared_strings = []
        if 'xl/sharedStrings.xml' in z.namelist():
            tree = ET.fromstring(z.read('xl/sharedStrings.xml'))
            for si in tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}si'):
                t = si.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}t')
                shared_strings.append(t.text if t is not None else ''.join(si.itertext()))

        # Sheet 1: All podcasts
        sheet1_rows = []
        if 'xl/worksheets/sheet1.xml' in z.namelist():
            tree = ET.fromstring(z.read('xl/worksheets/sheet1.xml'))
            rows = tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}sheetData/{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row')
            for r in rows:
                row_vals = []
                for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                    v = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}v')
                    val = v.text if v is not None else ''
                    if c.attrib.get('t') == 's' and val:
                        val = shared_strings[int(val)]
                    row_vals.append(val)
                sheet1_rows.append(row_vals)

        # Sheet 7: Mais Recommended
        sheet7_rows = []
        if 'xl/worksheets/sheet7.xml' in z.namelist():
            tree = ET.fromstring(z.read('xl/worksheets/sheet7.xml'))
            rows = tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}sheetData/{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row')
            for r in rows:
                row_vals = []
                for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                    v = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}v')
                    val = v.text if v is not None else ''
                    if c.attrib.get('t') == 's' and val:
                        val = shared_strings[int(val)]
                    row_vals.append(val)
                sheet7_rows.append(row_vals)

        return sheet1_rows, sheet7_rows

def normalize_level(est_level: str):
    """Extract standard level and jlpt sublevel from string like 'N5', 'Pre-N5–N5', 'N5–N4', 'N3'."""
    lvl = (est_level or '').strip()
    sublevel = None
    if 'N5' in lvl:
        sublevel = 'N5'
    elif 'N4' in lvl:
        sublevel = 'N4'
    elif 'N3' in lvl:
        sublevel = 'N3'
    elif 'N2' in lvl:
        sublevel = 'N2'
    elif 'N1' in lvl:
        sublevel = 'N1'

    # level category
    if sublevel == 'N5' or 'beginner' in lvl.lower() or 'starter' in lvl.lower():
        primary_level = 'starter'
    elif sublevel:
        primary_level = 'jlpt'
    else:
        primary_level = 'all_levels'

    return primary_level, sublevel or lvl

async def seed_resources_from_excel_file(db: AsyncSession, user_id: Optional[uuid.UUID] = None) -> int:
    """Read Japanese_Podcasts_N5_to_N1.xlsx and seed podcasts + curated resources into resources table."""
    # Find file path
    candidates = [
        "/app/app/data/Japanese_Podcasts_N5_to_N1.xlsx",
        "/app/Japanese_Podcasts_N5_to_N1.xlsx",
        "backend/app/data/Japanese_Podcasts_N5_to_N1.xlsx",
        "Japanese_Podcasts_N5_to_N1.xlsx",
        os.path.join(os.path.dirname(__file__), "../data/Japanese_Podcasts_N5_to_N1.xlsx")
    ]
    file_path = next((p for p in candidates if os.path.exists(p)), None)

    sheet1_rows, sheet7_rows = (None, None)
    if file_path:
        sheet1_rows, sheet7_rows = _parse_xlsx(file_path)

    # Build recommendations lookup from Sheet 7
    rec_lookup = {}
    if sheet7_rows and len(sheet7_rows) > 1:
        for row in sheet7_rows[1:]:
            if len(row) >= 2 and row[0]:
                title = row[0].strip()
                suggested_use = row[2].strip() if len(row) > 2 and row[2] else ""
                rec_lookup[title.lower()] = suggested_use

    # Fetch existing resource titles to avoid duplicate insertions
    existing_res = await db.execute(select(Resource.title))
    existing_titles = {t.lower() for t in existing_res.scalars().all()}

    inserted_count = 0

    # 1. Podcasts from Excel
    if sheet1_rows and len(sheet1_rows) > 1:
        for idx, row in enumerate(sheet1_rows[1:], start=1):
            if len(row) < 4 or not row[1]:
                continue
            title = row[1].strip()
            if title.lower() in existing_titles:
                continue

            est_level = row[2].strip() if len(row) > 2 else ""
            link = row[3].strip() if len(row) > 3 else ""
            notes = row[5].strip() if len(row) > 5 else ""

            primary_level, jlpt_sub = normalize_level(est_level)
            
            is_rec = False
            rec_note = ""
            for r_title, r_use in rec_lookup.items():
                if r_title in title.lower() or title.lower() in r_title:
                    is_rec = True
                    rec_note = f"Mais Recommended • Suggested Use: {r_use}" if r_use else "Mais Recommended"
                    break

            description = f"Japanese podcast leveled at {est_level}."
            if rec_note:
                description = f"{rec_note}. {description}"
            if notes:
                description += f" {notes}"

            res_item = Resource(
                title=title,
                category="podcast",
                level=primary_level,
                jlpt_sublevel=jlpt_sub or est_level,
                url=link or "https://podcasts.apple.com/",
                description=description,
                notes=rec_note or notes,
                is_recommended=is_rec,
                order_index=idx,
                created_by=user_id,
                status="published"
            )
            db.add(res_item)
            existing_titles.add(title.lower())
            inserted_count += 1

    # 2. Add any Sheet 7 recommendations not in Sheet 1
    if sheet7_rows and len(sheet7_rows) > 1:
        for row in sheet7_rows[1:]:
            if len(row) >= 2 and row[0]:
                title = row[0].strip()
                if title.lower() not in existing_titles:
                    lvl = row[1].strip() if len(row) > 1 else ""
                    use = row[2].strip() if len(row) > 2 else ""
                    primary_lvl, sublevel = normalize_level(lvl)
                    res_item = Resource(
                        title=title,
                        category="podcast",
                        level=primary_lvl,
                        jlpt_sublevel=sublevel or lvl,
                        url="https://podcasts.apple.com/",
                        description=f"Mais Recommended • Suggested Use: {use}. Estimated level: {lvl}.",
                        notes=f"Mais Recommended ({use})",
                        is_recommended=True,
                        order_index=inserted_count + 1,
                        created_by=user_id,
                        status="published"
                    )
                    db.add(res_item)
                    existing_titles.add(title.lower())
                    inserted_count += 1

    # 3. Curated foundational resources for other categories
    curated = [
        # Hiragana & Katakana
        {
            "title": "Tofugu Learn Hiragana Guide",
            "title_ar": "دليل توفوجو لتعلم حروف الهيراغانا",
            "category": "hiragana_katakana",
            "level": "starter",
            "jlpt_sublevel": "N5",
            "url": "https://www.tofugu.com/japanese/learn-hiragana/",
            "description": "Visual mnemonic guide to master all 46 Hiragana characters quickly with practice sheets and audio.",
            "description_ar": "الدليل المصور الشامل لإتقان قراءة وكتابة حروف الهيراغانا الـ 46 بطريقة الذاكرة البصرية التفاعلية.",
            "is_recommended": True,
            "order_index": 1
        },
        {
            "title": "Tofugu Learn Katakana Guide",
            "title_ar": "دليل توفوجو لتعلم حروف الكاتاكانا",
            "category": "hiragana_katakana",
            "level": "starter",
            "jlpt_sublevel": "N5",
            "url": "https://www.tofugu.com/japanese/learn-katakana/",
            "description": "Visual mnemonics and printable stroke-order practice worksheets to master Katakana easily.",
            "description_ar": "دليل مصور وتمارين تفاعلية متدرجة لإتقان قراءة وكتابة حروف الكاتاكانا المستخدمة في الكلمات الدخيلة.",
            "is_recommended": True,
            "order_index": 2
        },
        {
            "title": "Real Kana - Quick Kana Drills",
            "title_ar": "منصة ريل كانا للتمارين السريعة",
            "category": "hiragana_katakana",
            "level": "starter",
            "jlpt_sublevel": "N5",
            "url": "https://realkana.com/",
            "description": "Minimalist interactive drills and flashcards for drilling instant Kana character recognition.",
            "description_ar": "تمارين بطاقات سريعة لاختبار سرعة قراءة وتمييز حروف الهيراغانا والكاتاكانا.",
            "is_recommended": False,
            "order_index": 3
        },

        # Grammar
        {
            "title": "Tae Kim's Guide to Japanese Grammar",
            "title_ar": "دليل تاي كيم لقواعد اللغة اليابانية",
            "category": "grammar",
            "level": "starter",
            "jlpt_sublevel": "N5",
            "url": "https://guidetojapanese.org/learn/",
            "description": "A structured, logical approach to Japanese grammar from the perspective of how Japanese actually works.",
            "description_ar": "المرجع الأشهر لشرح قواعد وبنية الجملة اليابانية بأسلوب منطقي مبسط وعميق.",
            "is_recommended": True,
            "order_index": 1
        },
        {
            "title": "Bunpro - SRS Grammar Study",
            "title_ar": "منصة بونبرو لدراسة القواعد بالتكرار المتباعد",
            "category": "grammar",
            "level": "jlpt",
            "jlpt_sublevel": "N5–N1",
            "url": "https://bunpro.jp/",
            "description": "Comprehensive SRS study platform covering grammar points for all JLPT levels with audio examples.",
            "description_ar": "نظام تفاعلي متقدم لمراجعة وحفظ القواعد عبر التكرار المتباعد لجميع مستويات JLPT.",
            "is_recommended": True,
            "order_index": 2
        },
        {
            "title": "Imabi Grammar Reference",
            "title_ar": "مرجع إيمابي الموسع لقواعد اليابانية",
            "category": "grammar",
            "level": "jlpt",
            "jlpt_sublevel": "N3–N1",
            "url": "https://imabi.org/",
            "description": "Exhaustive grammatical reference exploring modern colloquial nuances as well as classical Japanese.",
            "description_ar": "موسوعة مرجعية معمقة للباحثين والمتقدمين تشرح أدق الفروق بين تراكيب الجمل.",
            "is_recommended": False,
            "order_index": 3
        },

        # Reading
        {
            "title": "NHK NEWS WEB EASY",
            "title_ar": "أخبار إن إتش كيه باليابانية المبسطة",
            "category": "reading",
            "level": "jlpt",
            "jlpt_sublevel": "N4–N3",
            "url": "https://www3.nhk.or.jp/news/easy/",
            "description": "Daily Japanese news articles written in clear, simple Japanese with furigana and native voice narration.",
            "description_ar": "نشرات إخبارية يومية حقيقية مكتوبة بلغة يابانية مبسطة مدعومة بالفوريغانا والتسجيل الصوتي.",
            "is_recommended": True,
            "order_index": 1
        },
        {
            "title": "Tadoku Graded Readers (Free Books)",
            "title_ar": "قصص القراءة المكثفة المتدرجة (تادوكو)",
            "category": "reading",
            "level": "starter",
            "jlpt_sublevel": "N5",
            "url": "https://tadoku.org/japanese/en/free-books/",
            "description": "Free illustrated graded readers starting from zero vocabulary, designed for extensive natural reading.",
            "description_ar": "مكتبة قصص مصورة مجانية متدرجة تبدأ من الصفر لدعم القراءة الطبيعية السلسة دون قاموس.",
            "is_recommended": True,
            "order_index": 2
        },
        {
            "title": "Satori Reader",
            "title_ar": "منصة ساتوري ريدر للقراءة التفاعلية",
            "category": "reading",
            "level": "jlpt",
            "jlpt_sublevel": "N3",
            "url": "https://www.satorireader.com/",
            "description": "Engaging episodic stories curated for intermediate learners with word-by-word breakdowns and rich narration.",
            "description_ar": "قصص روائية مشوقة مصحوبة بتحليلات نحوية لكل كلمة وتسجيل صوتي احترافي فائق الجودة.",
            "is_recommended": False,
            "order_index": 3
        },

        # YouTube
        {
            "title": "Japanese Ammo with Misa",
            "title_ar": "قناة جابانيز آمو مع ميسا",
            "category": "youtube",
            "level": "starter",
            "jlpt_sublevel": "N5–N4",
            "url": "https://www.youtube.com/@JapaneseAmmowithMisa",
            "description": "Detailed video lessons teaching everyday Japanese conversations, nuances, and grammar with warmth.",
            "description_ar": "دروس مرئية واضحة وممتعة لشرح قواعد الحوار والتعبيرات الطبيعية الدقيقة.",
            "is_recommended": True,
            "order_index": 1
        },
        {
            "title": "Dogen",
            "title_ar": "قناة دوغن لتعليم النبرات والصوتيات",
            "category": "youtube",
            "level": "all_levels",
            "jlpt_sublevel": "All",
            "url": "https://www.youtube.com/@Dogen",
            "description": "Expert lessons focusing on Japanese phonetics, pitch accent patterns, and cultural observations.",
            "description_ar": "دروس مميزة في النطق الطبيعي والنبرات الصوتية (Pitch Accent) وأسلوب التحدث الياباني الأصيل.",
            "is_recommended": True,
            "order_index": 2
        },
        {
            "title": "دروس اليابانية بالعربية - Arab Sensei",
            "title_ar": "قناة شروحات اليابانية للناطقين بالعربية",
            "category": "youtube",
            "level": "arabic_learner",
            "jlpt_sublevel": "N5",
            "url": "https://www.youtube.com/results?search_query=دروس+اللغة+اليابانية+بالعربية",
            "description": "Video lessons breaking down Japanese phonetics and grammar using Arabic analogies and clear explanations.",
            "description_ar": "سلاسل دروس فيديو تقدم شروحات لقواعد اللغة اليابانية ومقارنتها بقواعد النحو العربي.",
            "is_recommended": True,
            "order_index": 3
        },

        # Websites
        {
            "title": "Jisho.org",
            "title_ar": "معجم جيشو الإلكتروني",
            "category": "websites",
            "level": "all_levels",
            "jlpt_sublevel": "All",
            "url": "https://jisho.org/",
            "description": "The ultimate online Japanese-English dictionary with radical search, pitch accent, and stroke orders.",
            "description_ar": "القاموس الإلكتروني الرائد للبحث السريع عن الكلمات، رسم حروف الكانجي، وجمل الأمثلة التوضيحية.",
            "is_recommended": True,
            "order_index": 1
        },
        {
            "title": "WaniKani",
            "title_ar": "منصة وانيكاني لحفظ الكانجي",
            "category": "websites",
            "level": "starter",
            "jlpt_sublevel": "N5–N1",
            "url": "https://www.wanikani.com/",
            "description": "Spaced repetition (SRS) web app to learn 2,000 kanji and over 6,000 vocabulary words effectively.",
            "description_ar": "نظام تعلم الكانجي والمفردات بالتكرار المتباعد مع القصص الصورية التخيلية.",
            "is_recommended": True,
            "order_index": 2
        },
        {
            "title": "Kanshudo",
            "title_ar": "موقع كانشودو لتعلم اليابانية",
            "category": "websites",
            "level": "all_levels",
            "jlpt_sublevel": "All",
            "url": "https://www.kanshudo.com/",
            "description": "Master Japanese through kanji mastery, grammar libraries, reading exercises, and adaptive flashcards.",
            "description_ar": "منصة تعليمية متكاملة تقدم اختبارات تحديد المستوى ومكتبة واسعة لممارسة القراءة وحفظ الحروف.",
            "is_recommended": False,
            "order_index": 3
        },

        # Arabic Learner
        {
            "title": "دليل المتعلم العربي لبنية الجملة اليابانية",
            "title_ar": "دليل المتعلم العربي لبنية الجملة اليابانية",
            "category": "websites",
            "level": "arabic_learner",
            "jlpt_sublevel": "Starter",
            "url": "https://jprclub.org",
            "description": "Comparative study guide mapping Japanese particles (wa, ga, o, ni) to Arabic case markers and structure.",
            "description_ar": "دليل مقارن يشرح أدوات الربط اليابانية وتناظرها مع الحركات والإعراب في اللغة العربية لتسهيل الفهم.",
            "is_recommended": True,
            "order_index": 1
        },
        {
            "title": "المعجم الياباني العربي للكلمات الأساسية",
            "title_ar": "المعجم الياباني العربي للكلمات الأساسية",
            "category": "websites",
            "level": "arabic_learner",
            "jlpt_sublevel": "N5–N4",
            "url": "https://www.arab-japan.com",
            "description": "Curated Arabic-Japanese glossary designed for Arab students studying for JLPT N5 and N4.",
            "description_ar": "مسرد مفردات وتعبيرات يومية يابانية مترجمة بدقة للعربية مع أمثلة وسياق الاستخدام.",
            "is_recommended": True,
            "order_index": 2
        }
    ]

    for item in curated:
        title = item["title"]
        if title.lower() not in existing_titles:
            res_item = Resource(
                title=title,
                title_ar=item.get("title_ar"),
                category=item["category"],
                level=item["level"],
                jlpt_sublevel=item.get("jlpt_sublevel"),
                url=item["url"],
                description=item.get("description"),
                description_ar=item.get("description_ar"),
                is_recommended=item.get("is_recommended", False),
                order_index=item.get("order_index", 0),
                created_by=user_id,
                status="published"
            )
            db.add(res_item)
            existing_titles.add(title.lower())
            inserted_count += 1

    await db.commit()
    return inserted_count
