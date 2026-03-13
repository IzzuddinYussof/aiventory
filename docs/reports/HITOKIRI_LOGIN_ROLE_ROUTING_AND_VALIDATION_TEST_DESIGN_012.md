# HITOKIRI LOGIN ROLE-ROUTING + VALIDATION TEST DESIGN (012)

## Context
Input handoff dari `SHIRO_LOGIN_UX_STATIC_AUDIT_006.md` menunjukkan 3 risk baru pada login flow:
1) post-login route hardcoded ke `DashboardHQWidget` untuk semua role,
2) dual autofocus (email + password) berisiko ganggu focus order,
3) tiada pre-submit client-side validation gate.

Run ini kekal design-only (non-live), patuh dedup, dan fokus pada execution pack tambahan yang boleh terus dipakai bila env/credential tersedia.

## Objective
Sediakan assertion matrix khusus login flow supaya role parity dan UX basic quality boleh diuji secara deterministik dalam profile-mode test track.

## Proposed Case Pack

### A) Role Routing Parity
- **HKT-LOGIN-ROLE-001 (HQ route parity)**  
  Preconditions: user role=HQ, login success.  
  Assert: route final = HQ home, tiada intermediate redirect loop.

- **HKT-LOGIN-ROLE-002 (AM route parity)**  
  Preconditions: user role=AM, login success.  
  Assert: route final = AM home (bukan HQ dashboard), session state branch context valid.

- **HKT-LOGIN-ROLE-003 (DSA route parity)**  
  Preconditions: user role=DSA, login success.  
  Assert: route final = DSA home (bukan HQ dashboard), no unauthorized widget exposure.

- **HKT-LOGIN-ROLE-004 (unknown role fallback)**  
  Preconditions: auth payload role tidak dikenali/empty.  
  Assert: fallback safe page + support trace/request_id bila ada; tidak crash dan tidak loop.

### B) Focus + Accessibility Behavior
- **HKT-LOGIN-FOCUS-001 (single initial focus)**  
  Preconditions: halaman login dibuka fresh.  
  Assert: hanya satu field pegang initial focus (email preferred); tiada focus-jump spontan.

- **HKT-LOGIN-FOCUS-002 (tab traversal order)**  
  Steps: Tab dari email -> password -> Sign In.  
  Assert: order stabil dan keyboard-only path usable.

### C) Pre-submit Validation Gate
- **HKT-LOGIN-VAL-001 (empty form gate)**  
  Steps: klik Sign In dengan email/password kosong.  
  Assert: API login tidak dipanggil; inline validation muncul pada dua field.

- **HKT-LOGIN-VAL-002 (invalid email format gate)**  
  Steps: isi email invalid + password valid dummy, klik Sign In.  
  Assert: block submit client-side, mesej error jelas.

- **HKT-LOGIN-VAL-003 (password required gate)**  
  Steps: email valid + password kosong, klik Sign In.  
  Assert: block submit client-side, fokus pindah ke field error pertama.

### D) Error-Surface Contract Bridge
- **HKT-LOGIN-ERR-001 (backend auth error mapping)**  
  Preconditions: backend return unauthorized/invalid credential.  
  Assert: mesej UX tidak generik semata-mata; action guidance minimum dipaparkan.

- **HKT-LOGIN-ERR-002 (request_id visibility parity)**  
  Preconditions: backend return error envelope dengan `request_id`.  
  Assert: request_id surfaced konsisten ikut UX policy (inline/banner/dialog).

## Evidence Requirements
- Screenshot setiap case FAIL/PASS kritikal (role-route landing, validation states).
- Route trace ringkas (before login -> after login).
- Console warning/error hanya untuk case FAIL/BLOCKED.
- Jika test data disentuh pada env mock/staging: log data touched + cleanup proof wajib.

## Dependency Locks
1) Kuro perlu lock role enum/value map dari auth payload (`HQ/AM/DSA/...`) untuk assertion deterministic.
2) Shiro perlu lock target route key bagi AM/DSA + fallback page behavior untuk unknown role.
3) Credential seed matrix per role diperlukan sebelum execution run.

## Non-live Compliance
- Tiada API live disentuh.
- Tiada code mutation.
- Tiada test data mutation.
