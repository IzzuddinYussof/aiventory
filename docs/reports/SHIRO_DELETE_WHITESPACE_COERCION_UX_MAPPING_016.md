# SHIRO_DELETE_WHITESPACE_COERCION_UX_MAPPING_016

Tarikh: 2026-03-12
Owner: Shiro (Frontend UX + Execution)
Scope: Delete-failure UX mapping untuk branch coercion format `inventory_movement_id` (whitespace/tab/space) dan numeric-coercion yang sudah ada oracle live.

## Context
Live oracle terkini kekal konsisten:
- `KRO-LIVE-011D`: `inventory_movement_id="<id>\t"` -> `200 success` (permissive legacy)
- `HKT-LIVE-019I`: `inventory_movement_id="<id> "` -> `200 success` (permissive legacy)

Pada frontend semasa, parser delete-error masih message-only dan belum branch-aware.

## Line-level Evidence (current frontend)
File: `lib/item_movement_history/item_movement_history_widget.dart`
- `171`: `_responseMessage` hanya baca `$.message`
- `266`: call delete endpoint (`itemMovementDeleteCall.call`)
- `285`: title dialog statik `Delete failed`
- `287-289`: fallback message generik `Unable to delete this movement.`

Implikasi: branch known (`ERROR_CODE_NOT_FOUND`, `ERROR_CODE_INPUT_ERROR`, future strict mismatch/request-shape 4xx) collapse ke surface yang sama.

## UX Mapping Proposal (freeze candidate selepas envelope lock dari Kuro)

### 1) Validation / Type / Coercion branch (`ERROR_CODE_INPUT_ERROR`)
Termasuk:
- decimal/scientific `inventory_id` / `inventory_movement_id`
- whitespace suffix/prefix movement id (tab/space)
- wrong-type field lain (`branch`, `expiry_date`)

Copy cadangan:
- Title: `Input tidak sah`
- Body utama ikut `param`:
  - `inventory_movement_id`: `ID pergerakan mesti nombor bulat tanpa ruang atau simbol tambahan.`
  - `inventory_id`: `ID item mesti nombor bulat biasa (bukan perpuluhan/scientific).`
  - `expiry_date`: `Format tarikh luput tidak sah.`
  - fallback: `Sila semak format input dan cuba lagi.`
- CTA utama: `Semak input`
- CTA kedua: `Tutup`
- Footer kecil (jika ada): `Rujukan: {request_id}`

### 2) Not-found branch (`ERROR_CODE_NOT_FOUND`)
Copy cadangan:
- Title: `Rekod tidak ditemui`
- Body: `Rekod mungkin sudah dipadam atau senarai belum dikemas kini.`
- CTA utama: `Refresh senarai`
- CTA kedua: `Tutup`
- Footer: `Rujukan: {request_id}` (jika tersedia)

### 3) Unknown/Internal fallback
- Title: `Delete failed`
- Body: guna `message` jika ada, jika tiada guna fallback semasa.
- CTA: `Cuba lagi`
- Footer: `Rujukan: {request_id}` jika ada.

## Parser Priority (frontend target)
Gantikan message-only dengan prioriti ini:
1. `code`
2. `param` / `field_errors`
3. `message`
4. fallback default

## Acceptance Criteria (untuk Hitokiri assertion layer)
1. Known branch tidak boleh collapse ke dialog generik tunggal.
2. Jika `param=inventory_movement_id` + `ERROR_CODE_INPUT_ERROR`, copy mesti spesifik format ID pergerakan.
3. `request_id` dipaparkan bila field tersedia.
4. CTA berbeza ikut branch (`Refresh senarai` vs `Semak input`).
5. Generic fallback hanya untuk unknown/internal branch.

## Status
- Frontend implementation: BELUM
- UX mapping draft: SIAP (dokumen ini)
- Dependency blocker: Kuro final envelope lock (`code/message/request_id/param`) + precedence matrix final untuk valid-id coercion branches.
