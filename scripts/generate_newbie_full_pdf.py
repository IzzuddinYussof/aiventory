from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib.units import cm
from pathlib import Path

src = Path(r"C:\Programming\aiventory\docs\AIVENTORY_FINAL_REPORT_NEWBIE_FULL.md")
out = Path(r"C:\Users\User\.openclaw\media\generation\aiventory-userflow-liveapi-final-newbie-full.pdf")
out.parent.mkdir(parents=True, exist_ok=True)

lines = src.read_text(encoding='utf-8').splitlines()

c = canvas.Canvas(str(out), pagesize=A4)
W, H = A4
x = 1.8 * cm
y = H - 1.8 * cm
line_h = 13
max_chars = 108

c.setFont("Helvetica", 10)

for raw in lines:
    s = raw.replace('\t', '    ')
    if not s:
        y -= line_h
        if y < 2 * cm:
            c.showPage(); c.setFont("Helvetica", 10); y = H - 1.8 * cm
        continue

    while len(s) > max_chars:
        chunk = s[:max_chars]
        s = s[max_chars:]
        c.drawString(x, y, chunk)
        y -= line_h
        if y < 2 * cm:
            c.showPage(); c.setFont("Helvetica", 10); y = H - 1.8 * cm

    c.drawString(x, y, s)
    y -= line_h
    if y < 2 * cm:
        c.showPage(); c.setFont("Helvetica", 10); y = H - 1.8 * cm

c.save()
print(out)
