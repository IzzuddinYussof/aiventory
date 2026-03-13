# HITOKIRI - V2 API Execution Pack (Based on KURO Contract Draft)

Timestamp: 2026-03-12 00:24 (Asia/Kuala_Lumpur)
Owner: Hitokiri (Test Design Specialist)
Baseline Contract: `docs/reports/KURO_V2_API_CONTRACT_DRAFT.md`

## 1) Objective
Sediakan test case executable (contract-level) untuk 3 endpoint v2:
1. `POST /v2/inventory_movement`
2. `POST /v2/inventory_carousell`
3. `GET /v2/system/platform_support`

Pack ini fokus pada acceptance criteria, expected response envelope, negative/security coverage, dan bukti yang perlu dikumpul semasa execution.

## 2) Global Acceptance Criteria (All v2 endpoints)
- Semua response (success/fail) mesti ada `request_id` (non-empty string).
- Error response mesti ikut shape standard:
  - `code` (string)
  - `message` (string)
  - `field_errors` (object, optional tapi konsisten untuk validation)
  - `request_id` (string)
- Unauthorized request mesti return `401` secara konsisten.
- `Content-Type: application/json` untuk response JSON.

---

## 3) Endpoint Test Matrix

## A. POST /v2/inventory_movement

### HKT-V2-MOV-001 - Create movement (happy path)
- Preconditions: token valid, payload valid, `Idempotency-Key` UUID baru.
- Steps: submit payload canonical + checksum betul.
- Expect:
  - `201`
  - `idempotency.replayed = false`
  - `data.movement_id` integer > 0
  - `data.status = "created"`

### HKT-V2-MOV-002 - Replay safe (same key + same payload)
- Preconditions: request HKT-V2-MOV-001 berjaya.
- Steps: resend exact payload + exact `Idempotency-Key`.
- Expect:
  - `200`
  - `idempotency.replayed = true`
  - `movement_id` sama seperti request asal
  - no duplicate movement record created

### HKT-V2-MOV-003 - Idempotency conflict (same key + different payload)
- Steps: reuse key sama, ubah satu field canonical (contoh `quantity`).
- Expect:
  - `409`
  - `code = "idempotency_conflict"`
  - conflict reason boleh diaudit melalui `request_id`

### HKT-V2-MOV-004 - Checksum mismatch
- Steps: submit payload valid tapi checksum sengaja salah.
- Expect:
  - `409`
  - `code = "checksum_mismatch"`

### HKT-V2-MOV-004A - Canonicalization mismatch (field-order/normalization)
- Steps:
  1) Build checksum from non-canonical payload ordering or unnormalized scalar (contoh `tx_type="IN"`, quantity precision drift).
  2) Submit with same payload values but checksum generated from incorrect canonicalization.
- Expect:
  - `409`
  - `code = "checksum_mismatch"`
  - response includes `request_id` for audit trail.

### HKT-V2-MOV-005 - Missing required field
- Steps: omit `inventory_id` atau `tx_type`.
- Expect:
  - `400`
  - `code = "validation_error"`
  - `field_errors` contain missing field key

### HKT-V2-MOV-006 - Invalid idempotency key format
- Steps: `Idempotency-Key: not-a-uuid`.
- Expect:
  - `400`
  - `field_errors.Idempotency-Key` contains format guidance

### HKT-V2-MOV-007 - Invalid tx_type enum
- Steps: `tx_type = "receive"` (not in allowed enum).
- Expect: `400 validation_error` + field error on `tx_type`.

### HKT-V2-MOV-008 - Quantity boundary
- Steps: test `quantity = 0`, `quantity < 0`, `quantity = 0.0001`.
- Expect:
  - 0/negative rejected (`400`)
  - positive minimum accepted if policy allows decimal

### HKT-V2-MOV-009 - Expiry date format validation
- Steps: `expiry_date = "31-12-2026"`.
- Expect: `400 validation_error` for invalid ISO date format.

### HKT-V2-MOV-009A - Quoted-null guard (nullable fields)
- Steps:
  1) Submit payload where optional field intentionally serialized as string literal `"null"`.
  2) Repeat with true JSON `null` / omitted field.
- Expect:
  - string literal `"null"` rejected as type violation (`400 validation_error` + field-level error),
  - true `null`/omitted follows contract-specific behavior.

### HKT-V2-MOV-010 - Unauthorized access
- Steps: no Authorization header.
- Expect: `401 unauthorized`.

### HKT-V2-MOV-010A - Content-Type contract enforcement
- Steps: send request with wrong `Content-Type` (e.g. `multipart/form-data` or `text/plain`) for JSON endpoint.
- Expect:
  - deterministic reject (`400`/`415` as per backend policy),
  - error envelope remains standard (`code/message/request_id`).

### HKT-V2-MOV-011 - Idempotency retention expiry behavior
- Steps: replay request after retention window (>24h) in controlled env.
- Expect:
  - treated as NEW request (no replay guarantee)
  - if domain state allows create => `201 created`
  - if domain state conflicts => domain/business error (non-idempotency conflict)
  - `idempotency.replayed` must be `false`

### HKT-V2-MOV-012 - Concurrency race safety
- Steps: fire 10 parallel requests with same key+payload.
- Expect:
  - exactly one created
  - others replay `200` (not duplicates)

---

## B. POST /v2/inventory_carousell

### HKT-V2-CAR-001 - Create listing (happy path)
- Expect: `201`, `data.inventory_carousell_id` valid, `status=created`.

### HKT-V2-CAR-002 - Expiry required by item type/category rule
- Preconditions: item flagged expiry-controlled.
- Steps: omit `expiry_date`.
- Expect: `400/422` with explicit field error.

### HKT-V2-CAR-003 - Invalid expiry format
- Steps: `expiry_date = "2026/12/31"`.
- Expect: `422 invalid_expiry_date` (locked policy).

### HKT-V2-CAR-004 - Reject stale hardcoded date literal
- Steps: force known stale value (`2025-05-05`) pada item baharu yang patut dynamic.
- Expect: rejected with validation/business rule error.

### HKT-V2-CAR-005 - Quantity consistency
- Case A: `available_quantity > initial_quantity` => reject.
- Case B: `sold_quantity + available_quantity > initial_quantity` => reject.
- Case C: valid boundary (`sold + available == initial`) => accept.

### HKT-V2-CAR-006 - Invalid type enum
- Steps: `type = "stock"`.
- Expect: `400 validation_error` with field-level guidance.

### HKT-V2-CAR-007 - Unauthorized access
- Steps: no token.
- Expect: `401 unauthorized`.

### HKT-V2-CAR-008 - Quoted-null guard on optional fields
- Steps: submit optional text/date fields as string literal `"null"`.
- Expect: rejected as invalid type (`400 validation_error`) with field-level hint.

### HKT-V2-CAR-009 - Content-Type mismatch handling
- Steps: submit non-JSON content type to endpoint that expects JSON body.
- Expect: deterministic reject (`400`/`415`) with standard error envelope and `request_id`.

---

## C. GET /v2/system/platform_support

### HKT-V2-PLT-001 - Happy path platform matrix
- Expect:
  - `200`
  - `data.platforms` object exists
  - boolean values for known keys (`web/android/ios/windows/macos/linux`)

### HKT-V2-PLT-002 - Version/channel query compatibility
- Steps: send `app_version` and `channel`.
- Expect:
  - response stable
  - unknown channel handled with explicit validation rule (if enforced)

### HKT-V2-PLT-003 - Unsupported platform messaging quality
- Expect:
  - if `windows=false`, message includes clear operator-facing explanation
  - wording stable enough for frontend UX copy mapping

### HKT-V2-PLT-004 - Unauthorized policy check
- Steps: hit endpoint tanpa token.
- Expect: deterministic `401 unauthorized` (locked for internal app path).

---

## D. GET /v2/system/auth_probe (Proposed NEW API for deterministic auth-source checks)

> Endpoint ini cadangan baharu (belum live). Tujuan: elak ambiguity auth propagation semasa migration v2.

### HKT-V2-AUTH-001 - Auth probe without bearer
- Steps: call endpoint tanpa `Authorization`.
- Expect:
  - `401 unauthorized` (atau `200 authenticated=false` jika policy pilih soft probe; policy mesti lock satu)
  - response include `request_id`
  - `auth_source` mesti jelas (`none`/`absent_header`)

### HKT-V2-AUTH-002 - Auth probe with explicit bearer header
- Steps: call endpoint dengan token valid pada header request.
- Expect:
  - success (`200`) with `authenticated=true`
  - `subject_id` non-empty
  - `auth_source="authorization_header"`

### HKT-V2-AUTH-003 - Invalid/expired token behavior
- Steps: call with malformed or expired bearer token.
- Expect:
  - deterministic reject (`401`) dengan `code="unauthorized"`
  - `request_id` present
  - no ambiguous `200 authenticated=false` unless explicitly locked in spec.

### HKT-V2-AUTH-004 - Header-path parity guard (future middleware migration)
- Preconditions: test env supports both strategies during transition.
- Steps: compare request via explicit header path vs centralized middleware path.
- Expect:
  - identical auth interpretation (`authenticated`, `subject_id`, policy code)
  - no endpoint behavior drift between auth-source strategies.

## 4) Evidence Checklist (Per Test Execution)
- Raw request/response (sanitized token).
- HTTP status + response body snapshot.
- `request_id` captured for every attempt.
- Database/assertion proof for duplicate prevention tests (if env allows).
- Cleanup/revert log for any seeded records.

## 5) Data Lifecycle & Revert Rules
- Test data naming prefix: `HKT_V2_*`.
- Every created record must have:
  - creation timestamp,
  - owner test case ID,
  - cleanup action + status.
- If cleanup fails: log `[REVERT_NOTICE_TO_KURO]` with pending artifact IDs.

## 6) Spec Clarifications Status (Locked by KURO-SPEC-003)
1. Invalid expiry policy locked: semantic invalid date => `422 invalid_expiry_date`; structural/missing => `400 validation_error`.
2. Post-retention (>24h) idempotency locked: same key treated as NEW request.
3. `GET /v2/system/platform_support` auth locked: internal app path requires token (`401` when absent/invalid).
4. Checksum canonicalization locked with fixed key order + scalar normalization rules (see KURO spec-lock doc).

## 7) UX Assertion Overlay (Integrated from SHIRO mapping)
Gunakan assertion layer ini sekali semasa execution contract tests supaya API correctness dan UX behavior sync:

1. `request_id` wajib visible pada error surface yang operator boleh akses:
   - Inline/form error: request_id boleh dipaparkan di help text atau expandable detail.
   - Global banner/toast: mesti ada tindakan "Salin ID rujukan" atau teks setara.
2. `field_errors` mesti map 1:1 ke field UI:
   - `inventory_id`, `tx_type`, `quantity`, `expiry_date`, `Idempotency-Key` tidak boleh collapse kepada generic error sahaja.
3. `idempotency.replayed=true` mesti tidak dianggap fail oleh UX:
   - UI state dijangka tunjuk info "permintaan ini telah diproses" (info/non-error).
4. `idempotency_conflict` dan `checksum_mismatch` mesti dipetakan kepada blocker state (aksi pembetulan pengguna diperlukan).
5. Platform gate assertions (`GET /v2/system/platform_support`):
   - Unsupported platform tidak redirect loop ke login.
   - Blocking page/section ada CTA jelas (contoh: guna Web/Android/iOS) dan mesej konsisten.
6. Bahasa BM error copy mesti kekal jelas dan bukan mesej teknikal mentah (kecuali request_id).

## 8) Execution Readiness Status
- Design readiness: **READY**
- Environment readiness: **WAITING** (mock/staging endpoint availability)
- Blocking dependency: published mock/spec + seed/cleanup hooks from backend stream.
- Additional lock needed before live execution:
  1) definitive status policy for content-type mismatch (`400` vs `415`),
  2) strict nullable-field contract (true `null` vs omitted) per endpoint,
  3) auth-probe policy mode lock (`401 hard reject` vs `200 authenticated=false` for missing bearer).
