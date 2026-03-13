# Repair Orchestration SOP (Shiro -> Kuro -> Hitokiri)

## Objective
Baiki semua issue dalam report dengan flow agent berurutan, satu agent aktif pada satu masa.

## Agent Roles
- Orchestrator (main): pilih fix, kawal flow, update log/report, keputusan go/no-go.
- Shiro (frontend): implement UI/route/state handling.
- Kuro (backend): implement endpoint/rules di Xano + data safety.
- Hitokiri (QA): test code-flow + live API (ikut kontrak app), verify revert.

## Reality in current environment
- Subagent ID yang tersedia sekarang hanya `main`.
- Jadi execution praktikal: spawn sub-sesi berlabel `shiro`, `kuro`, `hitokiri` tapi guna agentId `main`.
- Tetap jaga disiplin role walaupun model sama.

## Run Flow (per fix)
1. Orchestrator pilih next fix `pending` dari `REPAIR_MASTER_TODO.md`.
2. Spawn sesi `shiro` (frontend task) -> siap -> ringkasan + changed files.
3. Spawn sesi `kuro` (backend/Xano task) -> siap -> endpoint contract + test response.
4. Spawn semula `shiro` jika frontend perlu adjust ikut backend baru.
5. Spawn `hitokiri` untuk verification:
   - validate route/data flow
   - call live API ikut app format
   - verify revert/cleanup
6. Jika fail:
   - route balik ke shiro/kuro ikut punca
   - max 1 retry cycle per fix (token-aware)
   - kalau masih fail, mark blocked-final dan move on
7. Jika pass:
   - mark done
   - update developer log + progress report
   - proceed next fix

## Hard Guards
- No loop berulang tanpa nilai.
- Jika blocker sama berulang: stop, mark jelas, next fix.
- Report mesti bahasa simple.
- Jika subagent timeout/fail berulang sebelum hasil usable (contoh context drift), kill sesi stale, kira sebagai retry consumed, dan jangan paksa sambung ke phase seterusnya.
- Jika ada risiko pendedahan credential/secrets dalam execution log, hentikan phase segera, sanitize report, dan retry sekali dalam mode read-only selamat.

## Run Notes
- 2026-03-13 01:58 MYT: SOP unchanged; used standard single-active sequence with one retry cycle allowance.
- 2026-03-13 02:31 MYT: Added execution guard for this environment: if labeled subagent drifts to wrong workspace/context repeatedly, orchestrator may terminate stale session and complete role validation directly in target repo (`C:\Programming\aiventory`) to avoid low-value loops. This still counts toward retry/token guard.
- 2026-03-13 03:07 MYT: Runbook closed for this repair cycle because all queued fixes reached terminal status (`done` or `blocked-final`). Cron scheduler disabled for this orchestrator job.
