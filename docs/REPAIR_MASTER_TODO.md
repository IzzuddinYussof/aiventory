# Aiventory Repair Master TODO (Code + API)

Mode: implement fixes directly in source (frontend + backend) with safe revert path.
Owner: Izz

## Global Rules
- Satu run fokus satu fix utama sahaja.
- Token-aware: kalau blocker sama berulang, mark blocked-final dan terus next fix.
- Setiap fix mesti ada:
  - code change summary
  - test result
  - revert path (git + patch)
- Bahasa report: simple, minimum jargon.

## Revert Strategy (wajib)
- Semua kerja dibuat pada branch repair.
- Simpan patch per fix di `docs/revert_patches/`.
- Update `docs/REVERT_GUIDE_REPAIR.md` setiap fix.

## Fix Queue

### F01 (High)
Upload Carousell route param safety
- Frontend: pastikan navigation ke `/uploadCarousell` sentiasa hantar param wajib (`inventoryId`, dll jika perlu).
- Frontend: tambah guard jika param missing (jangan crash).
- Test: direct path + param path.

### F02 (High)
Backend endpoint untuk revert-safe delete `inventory_carousell`
- Backend (Xano): tambah endpoint delete/undo dalam API group aiventory.
- Frontend: guna endpoint ni untuk cleanup test/live-safe flow jika perlu.
- Test: create -> verify -> delete -> verify clean.

### F03 (High)
Backend endpoint untuk revert-safe delete `inventory_carousell_movement`
- Backend (Xano): tambah endpoint delete/undo untuk movement.
- Frontend: pastikan flow boleh trigger cleanup.
- Test: create movement -> verify -> delete -> verify clean.

### F04 (High)
Carousell Update buyer-side exact revert
- Backend + frontend: betulkan update path supaya metadata buyer-side boleh kembali exact pre-state bila reverse.
- Test: toggle done true/false + compare before/after exact.

### F05 (Medium)
Order status transition state machine
- Backend: lock transition rules (reject sequence tak valid).
- Frontend: handle reject message dengan clear UX message.
- Test: valid transitions pass, invalid transition fail expected.

### F06 (Medium)
Tracking Order null safety (`url`)
- Frontend: remove force unwrap risk, add fallback UI.
- Test: missing/invalid url tak crash.

### F07 (Medium)
Carousell direct vs param behavior consistency
- Frontend: standardize expected behavior; jika param memang penting, enforce; kalau tak penting, simplify route contract.
- Test: compare output direct vs param dan classify expected.

### F08 (Medium)
Purchase Order API integration
- Backend: tambah/semak endpoint create/read/update ikut keperluan page.
- Frontend: wire API + validation + success/error handling.
- Test: CRUD minimal + safe cleanup/revert.

## Progress Legend
- pending
- in_progress
- done
- blocked-final

## Current Status
- F01: blocked-final (retry exhausted; verification blocked by local env git PATH issue: "WHERE not recognized", cannot complete runtime test proof this run)
- F02: blocked-final (retry exhausted; backend API-layer endpoint wiring added, but frontend trigger path for safe inventory_carousell delete could not be completed/verified this run)
- F03: blocked-final (retry exhausted; API-layer movement delete/undo + frontend cancel trigger wired, but live Xano endpoint verification not completed this run)
- F04: blocked-final (orchestration retry exhausted in this run: shiro subagent repeatedly failed/timeout before producing usable F04 frontend patch in target repo, so Kuro/Hitokiri chain not safely started)
- F05: blocked-final (Shiro frontend UX improvement completed, but Kuro/Hitokiri could not produce conclusive revert-safe live proof for transition matrix; verification failed and retry cycle exhausted this run)
- F06: done (frontend null-safe URL fallback implemented; backend not required; verification pass after 1 retry cycle)
- F07: done (frontend route behavior standardized: upload path now forwards inventory/search/category params and blocks missing inventoryId safely; backend not required for this fix)
- F08: blocked-final (Shiro phase failed twice due repeated subagent hang/context drift before producing usable frontend patch; per retry guard this run stopped without unsafe backend mutation)

## Finalization (2026-03-13 03:07 MYT)
- Queue completion reached: all fixes are now in terminal state (`done` or `blocked-final`).
- Final summary report prepared and exported to:
  - `C:\Users\User\.openclaw\media\generation\aiventory-repair-final.pdf`
- Cron job `85c61485-512f-4a85-8b75-db8d6a575716` disabled.
