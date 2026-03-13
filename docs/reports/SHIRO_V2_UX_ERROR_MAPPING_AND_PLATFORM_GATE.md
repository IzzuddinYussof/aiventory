# SHIRO - V2 UX Error Mapping + Platform Gate Draft

Timestamp: 2026-03-11 23:52 (Asia/Kuala_Lumpur)
Scope: Frontend/UX mapping based on proposed v2 backend contract (`code`, `message`, `field_errors`, `request_id`).

## 1) UX Error Mapping Matrix (Form + Toast + Support)

### Global rules
- Always show human-readable summary at top (toast/banner).
- Inline field-level messages from `field_errors` if key matches form field.
- Always surface `request_id` in expandable "Need help?" section for support trace.
- Keep user action-oriented copy (what happened + what to do next).

### Recommended mapping

| `code` | UX severity | UI behavior | Suggested copy |
|---|---|---|---|
| `validation_error` | Warning | Keep form state, highlight invalid fields, focus first invalid field | "Maklumat belum lengkap. Sila semak medan bertanda merah." |
| `invalid_expiry_date` | Warning | Highlight expiry date field; show date format helper (`YYYY-MM-DD`) | "Tarikh luput tidak sah. Guna format YYYY-MM-DD." |
| `unauthorized` | Critical | Block submit, redirect/login modal | "Sesi anda tamat. Sila log masuk semula." |
| `checksum_mismatch` | High | Block retry with same payload; force refresh latest data snapshot | "Data berubah semasa dihantar. Sila muat semula dan cuba lagi." |
| `idempotency_conflict` | High | Disable blind retry, show conflict guidance | "Permintaan ini pernah dihantar dengan data berbeza. Semak semula sebelum hantar." |
| `internal_error` | Critical | Non-blocking fallback where possible; show support path | "Ralat sistem berlaku. Cuba lagi sebentar lagi. Jika berterusan, hubungi sokongan." |

## 2) `field_errors` to Widget Binding

Recommended frontend helper:
- `Map<String, List<String>> fieldErrors = response.field_errors ?? {};`
- Bind first message to each field:
  - `expiry_date` -> expiry date picker helper text
  - `quantity` -> quantity input error text
  - `checksum` -> hidden/system error panel (not regular form field)
  - `Idempotency-Key` (header issue) -> global banner only

Fallback policy:
- If unknown field key appears, show under "Maklumat lain" section to avoid silent drop.

## 3) Platform Support Gate UX (`GET /v2/system/platform_support`)

### Decision rule
- On app bootstrap, resolve current platform key (`web/android/ios/windows/macos/linux`).
- If unsupported (`false`), show blocking gate page instead of entering login/dashboard routes.

### Unsupported page copy (BM-first)
- Title: "Platform ini belum disokong"
- Body: "Aiventory belum menyokong Windows desktop buat masa ini. Sila guna web atau peranti mudah alih yang disokong."
- Secondary body (dynamic): `data.message` from API when available.
- Primary CTA: "Buka versi web"
- Secondary CTA: "Hubungi admin"
- Footer: "Rujukan sokongan: {request_id}"

### UX safety notes
- Do not loop user back to login when unsupported; keep message persistent.
- Cache latest support response for short TTL (e.g., 15 min) to reduce gate flicker.

## 4) Thin Client Validation Checklist (once mock endpoint is live)

1. `validation_error` with field errors -> inline highlight appears, form values preserved.
2. `invalid_expiry_date` -> date widget helper message appears exactly once.
3. `idempotency.replayed=true` success -> show neutral info toast ("Permintaan sebelum ini telah digunakan semula").
4. `idempotency_conflict` -> prevent repeated submit until user edits payload.
5. `request_id` displayed in support panel for every non-2xx response.
6. Unsupported platform response -> gate page shown before route entry.

## 5) Frontend integration proposal (non-breaking)

- Add centralized error mapper: `lib/core/network/v2_error_mapper.dart`
- Add platform gate widget: `lib/pages/platform_gate/platform_gate_widget.dart`
- Route-level guard insertion before auth-routing decision.

No live API change required for this UX layer; waits for v2 mock/staging availability.
