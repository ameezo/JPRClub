import os
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
    KeepTogether,
    HRFlowable,
)
from reportlab.pdfgen import canvas
from typing import Dict, Any

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_number(num_pages)
            super().showPage()
        super().save()

    def draw_page_number(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 9)
        self.setFillColor(colors.HexColor("#64748b"))
        
        # Header (pages > 1)
        if self._pageNumber > 1:
            self.drawString(54, 800, "JPR Club — Annual Report")
            self.setStrokeColor(colors.HexColor("#e2e8f0"))
            self.setLineWidth(0.5)
            self.line(54, 792, 541, 792)

        # Footer
        page_text = f"Page {self._pageNumber} of {page_count}"
        self.drawRightString(541, 36, page_text)
        self.drawString(54, 36, "Japanese Reading Club • Official Documentation")
        self.setStrokeColor(colors.HexColor("#e2e8f0"))
        self.setLineWidth(0.5)
        self.line(54, 48, 541, 48)
        self.restoreState()


class ReportPdfGenerator:
    @staticmethod
    def generate_pdf(snapshot: Dict[str, Any], output_path: str) -> str:
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        doc = SimpleDocTemplate(
            output_path,
            pagesize=A4,
            leftMargin=54,
            rightMargin=54,
            topMargin=54,
            bottomMargin=54,
        )

        styles = getSampleStyleSheet()

        # Custom styles
        brand_color = colors.HexColor("#1e293b")
        accent_color = colors.HexColor("#e88599")
        secondary_color = colors.HexColor("#0284c7")

        title_style = ParagraphStyle(
            "ReportTitle",
            parent=styles["Heading1"],
            fontName="Helvetica-Bold",
            fontSize=24,
            leading=28,
            textColor=brand_color,
            spaceAfter=4,
        )

        subtitle_style = ParagraphStyle(
            "ReportSubtitle",
            parent=styles["Normal"],
            fontName="Helvetica",
            fontSize=11,
            leading=15,
            textColor=colors.HexColor("#64748b"),
            spaceAfter=14,
        )

        h2_style = ParagraphStyle(
            "SectionH2",
            parent=styles["Heading2"],
            fontName="Helvetica-Bold",
            fontSize=14,
            leading=18,
            textColor=brand_color,
            spaceBefore=14,
            spaceAfter=8,
            keepWithNext=True,
        )

        body_style = ParagraphStyle(
            "ReportBody",
            parent=styles["Normal"],
            fontName="Helvetica",
            fontSize=9.5,
            leading=13.5,
            textColor=colors.HexColor("#334155"),
            spaceAfter=6,
        )

        meta_label = ParagraphStyle(
            "MetaLabel",
            parent=styles["Normal"],
            fontName="Helvetica-Bold",
            fontSize=8.5,
            leading=11,
            textColor=colors.HexColor("#475569"),
        )

        meta_value = ParagraphStyle(
            "MetaValue",
            parent=styles["Normal"],
            fontName="Helvetica-Bold",
            fontSize=15,
            leading=18,
            textColor=brand_color,
        )

        meta_sub = ParagraphStyle(
            "MetaSub",
            parent=styles["Normal"],
            fontName="Helvetica",
            fontSize=8,
            leading=10,
            textColor=colors.HexColor("#64748b"),
        )

        quote_style = ParagraphStyle(
            "QuoteText",
            parent=styles["Normal"],
            fontName="Helvetica-Oblique",
            fontSize=9,
            leading=13,
            textColor=colors.HexColor("#1e293b"),
        )

        quote_sub = ParagraphStyle(
            "QuoteSub",
            parent=styles["Normal"],
            fontName="Helvetica",
            fontSize=8,
            leading=11,
            textColor=colors.HexColor("#64748b"),
        )

        story = []

        meta = snapshot.get("metadata", {})
        metrics = snapshot.get("summary_metrics", {})
        year = meta.get("year", "")
        status_label = meta.get("status_label", "Annual Report")
        as_of_date = meta.get("as_of_date", "")

        # 1. Document Header & Title
        story.append(Paragraph(f"Japanese Reading Club (JPR Club)", subtitle_style))
        story.append(Paragraph(f"Annual Report {year}", title_style))
        story.append(Paragraph(f"Status: {status_label} • As of: {as_of_date} • Timezone: {meta.get('reporting_timezone')}", subtitle_style))
        story.append(HRFlowable(width="100%", thickness=1.5, color=accent_color, spaceBefore=2, spaceAfter=14))

        # 2. Executive Metric Cards Table
        sessions_held = metrics.get("sessions_held", 0)
        attendance_visits = metrics.get("total_attendance_visits", 0)
        att_cov = metrics.get("attendance_coverage", {})
        avg_att = metrics.get("average_attendance_per_session")
        hours = metrics.get("total_session_hours", 0)
        dur_cov = metrics.get("duration_coverage", {})
        ratings = metrics.get("ratings", {})
        avg_rating = ratings.get("average_rating")
        rated_resps = ratings.get("total_rated_responses", 0)

        card1 = [
            Paragraph("SESSIONS HELD", meta_label),
            Paragraph(f"{sessions_held}", meta_value),
            Paragraph(f"{metrics.get('studio_documentation', {}).get('published_recap_sessions', 0)} recaps published", meta_sub),
        ]

        card2 = [
            Paragraph("ATTENDANCE VISITS", meta_label),
            Paragraph(f"{attendance_visits}", meta_value),
            Paragraph(f"{att_cov.get('recorded_sessions', 0)} of {sessions_held} recorded ({att_cov.get('coverage_percent', 0)}%)", meta_sub),
        ]

        card3 = [
            Paragraph("AVG. VISITS / SESSION", meta_label),
            Paragraph(f"{avg_att if avg_att is not None else 'N/A'}", meta_value),
            Paragraph(f"Based on recorded sessions", meta_sub),
        ]

        card4 = [
            Paragraph("HOURS HELD", meta_label),
            Paragraph(f"{hours}h", meta_value),
            Paragraph(f"{dur_cov.get('recorded_sessions', 0)} of {sessions_held} recorded", meta_sub),
        ]

        summary_table_data = [[card1, card2, card3, card4]]
        summary_table = Table(summary_table_data, colWidths=[121, 122, 122, 122])
        summary_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#f8fafc")),
            ('BOX', (0, 0), (-1, -1), 0.5, colors.HexColor("#e2e8f0")),
            ('INNERGRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#e2e8f0")),
            ('TOPPADDING', (0, 0), (-1, -1), 8),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
            ('LEFTPADDING', (0, 0), (-1, -1), 10),
            ('RIGHTPADDING', (0, 0), (-1, -1), 10),
        ]))
        story.append(summary_table)
        story.append(Spacer(1, 14))

        # 3. Reading Materials Breakdown
        materials = snapshot.get("materials_distribution", [])
        if materials:
            story.append(Paragraph("Reading Materials & Formats", h2_style))
            mat_rows = [[Paragraph("Material Type", meta_label), Paragraph("Sessions", meta_label), Paragraph("Share", meta_label)]]
            for m in materials:
                mat_rows.append([
                    Paragraph(m.get("material_type", ""), body_style),
                    Paragraph(str(m.get("count", 0)), body_style),
                    Paragraph(f"{m.get('percentage', 0)}%", body_style),
                ])
            mat_table = Table(mat_rows, colWidths=[240, 120, 127])
            mat_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#f1f5f9")),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
                ('TOPPADDING', (0, 0), (-1, -1), 4),
                ('LINEBELOW', (0, 0), (-1, -1), 0.5, colors.HexColor("#e2e8f0")),
            ]))
            story.append(mat_table)
            story.append(Spacer(1, 12))

        # 4. Monthly Session Activity Table
        monthly = snapshot.get("monthly_metrics", [])
        if monthly:
            story.append(Paragraph("Monthly Activity Breakdown", h2_style))
            month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            header_row = [Paragraph("Month", meta_label), Paragraph("Sessions Held", meta_label), Paragraph("Attendance Visits", meta_label), Paragraph("Coverage", meta_label)]
            month_rows = [header_row]
            for m in monthly:
                m_num = m.get("month", 1)
                m_name = month_names[m_num - 1]
                sess_cnt = m.get("sessions_count", 0)
                visits_val = m.get("attendance_visits")
                visits_str = str(visits_val) if visits_val is not None else "Unrecorded"
                cov_str = f"{m.get('recorded_attendance_sessions', 0)}/{sess_cnt} sessions" if sess_cnt > 0 else "—"
                month_rows.append([
                    Paragraph(m_name, body_style),
                    Paragraph(str(sess_cnt), body_style),
                    Paragraph(visits_str, body_style),
                    Paragraph(cov_str, body_style),
                ])
            month_table = Table(month_rows, colWidths=[100, 120, 140, 127])
            month_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#f1f5f9")),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 3),
                ('TOPPADDING', (0, 0), (-1, -1), 3),
                ('LINEBELOW', (0, 0), (-1, -1), 0.5, colors.HexColor("#e2e8f0")),
            ]))
            story.append(month_table)
            story.append(Spacer(1, 14))

        # 5. Session Timeline
        timeline = snapshot.get("timeline_sessions", [])
        if timeline:
            story.append(Paragraph(f"Session Timeline ({len(timeline)} Sessions)", h2_style))
            for s in timeline:
                t_title = s.get("title", "")
                t_date = s.get("date", "")
                t_mat = s.get("material_type", "")
                t_visits = s.get("attendance_visits")
                visits_text = f"{t_visits} visits" if t_visits is not None else "Visits unrecorded"
                t_recap = s.get("recap_preview") or "Session completed."

                session_block = [
                    Paragraph(f"<b>{t_title}</b> — {t_date} ({t_mat}, {visits_text})", body_style),
                    Paragraph(f"{t_recap}", quote_sub),
                    Spacer(1, 4),
                ]
                story.append(KeepTogether(session_block))
            story.append(Spacer(1, 10))

        # 6. Reviewed Feedback Quotes
        quotes = snapshot.get("approved_quotes", [])
        if quotes:
            story.append(Paragraph(f"Community Voices & Feedback ({len(quotes)})", h2_style))
            for q in quotes:
                q_text = q.get("quote_text", "")
                q_meta = f"{q.get('session_title', '')} • {q.get('source_type', '').replace('_', ' ').title()}"
                quote_block = [
                    Paragraph(f'"{q_text}"', quote_style),
                    Paragraph(q_meta, quote_sub),
                    Spacer(1, 6),
                ]
                story.append(KeepTogether(quote_block))
            story.append(Spacer(1, 10))

        # 7. Methodology Disclosures
        story.append(KeepTogether([
            Paragraph("Methodology & Data Integrity Disclosures", h2_style),
            Paragraph(f"• <b>Reporting Timezone:</b> {meta.get('reporting_timezone')}", body_style),
            Paragraph("• <b>Attendance Policy:</b> Attendance counts represent repeat attendance visits. Unique attendees across multiple sessions are not inferred without unique identity records.", body_style),
            Paragraph("• <b>Missing Data Policy:</b> Unknown attendance visits and actual durations are reported with explicit denominators and coverage percentages rather than treated as zero.", body_style),
            Paragraph("• <b>Privacy Guarantee:</b> Only anonymous quotations with explicit publication permissions and administrative review are published.", body_style),
            Paragraph(f"• <b>Integrity Content Hash (SHA-256):</b> {snapshot.get('content_hash', '')[:24]}...", meta_sub),
        ]))

        doc.build(story, canvasmaker=NumberedCanvas)
        return output_path
