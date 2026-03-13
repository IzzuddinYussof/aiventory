from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib.units import cm
from pathlib import Path

src = Path(r"C:\Programming\aiventory\docs\AIVENTORY_FINAL_REPORT_NEWBIE.md")
out = Path(r"C:\Users\User\.openclaw\media\generation\aiventory-userflow-liveapi-final-newbie.pdf")
out.parent.mkdir(parents=True, exist_ok=True)

text = src.read_text(encoding='utf-8').splitlines()

c = canvas.Canvas(str(out), pagesize=A4)
width, height = A4
x = 2*cm
y = height - 2*cm
line_h = 14

c.setFont("Helvetica-Bold", 14)
c.drawString(x, y, "Laporan Final Aiventory (Versi Mesra Newbie)")
y -= 20
c.setFont("Helvetica", 10)

for line in text:
    if y < 2*cm:
        c.showPage()
        c.setFont("Helvetica", 10)
        y = height - 2*cm
    s = line.replace('\t', '    ')
    # simple wrap
    max_chars = 105
    while len(s) > max_chars:
        chunk = s[:max_chars]
        s = s[max_chars:]
        c.drawString(x, y, chunk)
        y -= line_h
        if y < 2*cm:
            c.showPage()
            c.setFont("Helvetica", 10)
            y = height - 2*cm
    c.drawString(x, y, s)
    y -= line_h

c.save()
print(str(out))
