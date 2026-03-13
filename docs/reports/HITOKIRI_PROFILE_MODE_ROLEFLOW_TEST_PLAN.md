# HITOKIRI PROFILE-MODE ROLEFLOW TEST PLAN

## Context
- Debug web mode masih ada blank-screen blocker (rujuk SHR-BOOT-005).
- Flutter web **profile mode** sudah buktikan first-state/login boleh render.
- Jadi functional validation boleh diteruskan secara terkawal menggunakan profile mode sementara root-cause debug mode diasingkan.

## Objective
Sediakan test design execution-ready untuk role-flow utama menggunakan `flutter run -d chrome --profile`, dengan guardrail supaya dapatan tidak tercemar oleh debug-only defect.

## Test Environment Policy (Temporary)
1. Primary frontend functional run: `flutter run -d chrome --profile --web-port <port>`.
2. Jangan classify isu yang hanya muncul di debug mode sebagai blocker functional, kecuali reproducible juga di profile mode.
3. Setiap defect mesti label salah satu:
   - `PROFILE_BLOCKER` (valid blocker untuk release path)
   - `DEBUG_ONLY_DEFECT` (track berasingan)
4. Tiada live API mutation; jika perlu backend behavior baru, guna v2 proposal/mock sahaja.

## Role-Flow Functional Matrix (Profile Mode)

### HQ Flow
- **HKT-PROF-HQ-001** Login success + landing state stabil
- **HKT-PROF-HQ-002** Semak list inventory load + empty-state handling
- **HKT-PROF-HQ-003** Filter/search inventory dan verify state reset
- **HKT-PROF-HQ-004** Create movement draft (non-live/mock expected)
- **HKT-PROF-HQ-005** Validation UX untuk field wajib + numeric boundary

### Assistant Manager Branch Flow
- **HKT-PROF-AM-001** Login + branch-context attach
- **HKT-PROF-AM-002** Receive stock flow (UI state transitions)
- **HKT-PROF-AM-003** Approve/reject movement action state + confirmation behavior
- **HKT-PROF-AM-004** Error mapping for backend contract errors (`field_errors`, `request_id`)

### DSA / Staff Branch Flow
- **HKT-PROF-DSA-001** Login + default dashboard state
- **HKT-PROF-DSA-002** Inventory outflow entry form validation
- **HKT-PROF-DSA-003** Offline/slow-network UX fallback (loading/retry)
- **HKT-PROF-DSA-004** Session expiry handling + relogin continuity

## Cross-Cutting Assertions
1. Request lifecycle states jelas: loading -> success/error (tanpa frozen UI).
2. Error text BM konsisten dan actionable.
3. `request_id` dipaparkan untuk error kelas backend (jika ada pada response).
4. Tiada redirect loop selepas login atau semasa auth-expired branch.
5. Platform gate behavior selari dengan `/v2/system/platform_support` policy (bila endpoint tersedia).

## Evidence Checklist
- Screenshot setiap major state (login, list, form error, submit success/fail).
- Console log ringkas (error/warn sahaja) untuk setiap case FAIL/BLOCKED.
- Catatan expectation vs actual per case ID.
- Rekod data touched + revert proof (jika execution melibatkan mock data mutation).

## Exit Criteria
- Minimum 1 pass-run lengkap bagi setiap role cluster (HQ/AM/DSA) dalam profile mode.
- Semua defect dilabel jelas `PROFILE_BLOCKER` vs `DEBUG_ONLY_DEFECT`.
- Handoff kepada Kuro/Shiro mengandungi defect packet yang boleh terus diambil tindakan.

## Dependencies / Blockers
- Perlu kredensial role test (HQ, AM, DSA) atau seed account setara.
- Perlu pengesahan endpoint environment (mock/staging) untuk flow yang trigger write actions.
- Jika kredensial/env belum tersedia, run ini kekal design-only dan menunggu publish hook.
