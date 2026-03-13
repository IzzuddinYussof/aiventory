# SHIRO_DELETE_NUMERIC_COERCION_UX_MAPPING_015

## Context
Run fokus pada UX mapping untuk branch delete-failure berkaitan numeric coercion yang kini ada bukti live:
- `inventory_id` decimal/scientific string (`"20.5"`, `"22e0"`) permissive pada legacy.
- `inventory_movement_id` decimal/scientific string (`"30587.5"`, `"30590e0"`, `"30593E0"`) permissive pada legacy.

Target frontend: bila backend hardening aktif (validation-class 4xx), UI mesti branch-aware dan tidak collapse ke dialog generik.

## Current Frontend Gap (confirmed)
File: `lib/item_movement_history/item_movement_history_widget.dart`
- `_responseMessage` hanya parse `$.message`.
- `_deleteMovement` failure dialog masih generic: title `Delete failed`, content fallback umum, CTA `Ok` sahaja.
- Tiada parser `code`, `param`, `request_id`.

## UX Mapping Proposal (numeric coercion branches)

### 1) Validation/type branch (target hardened)
Trigger contoh:
- `ERROR_CODE_INPUT_ERROR` + `param=inventory_id`
- `ERROR_CODE_INPUT_ERROR` + `param=inventory_movement_id`

Surface:
- Title: `Input tidak sah`
- Body by param:
  - `inventory_id`: `ID inventori mesti nombor bulat biasa (bukan perpuluhan atau format saintifik).`
  - `inventory_movement_id`: `ID pergerakan mesti nombor bulat biasa (bukan perpuluhan atau format saintifik).`
- CTA primer: `Semak input`
- CTA sekunder: `Tutup`
- Trace: papar `request_id` jika wujud.

### 2) Not-found branch
Trigger:
- `ERROR_CODE_NOT_FOUND`

Surface:
- Title: `Rekod tidak dijumpai`
- Body: `Pergerakan ini mungkin sudah dipadam. Sila segar semula senarai.`
- CTA primer: `Segar semula`
- CTA sekunder: `Tutup`
- Trace: papar `request_id` jika wujud.

### 3) Unknown/internal fallback
Trigger:
- Tiada `code` diketahui atau envelope tidak lengkap.

Surface:
- Kekalkan fallback semasa tetapi tambah trace slot `request_id` jika ada.
- CTA primer: `Cuba lagi`

## Parser Priority (implementation-ready)
Cadangan urutan parse pada response error:
1. `code`
2. `param` / `field_errors`
3. `message`
4. fallback text statik

## Acceptance Criteria
1. Known code branch (`ERROR_CODE_INPUT_ERROR`, `ERROR_CODE_NOT_FOUND`) tidak lagi guna dialog generik sama.
2. Numeric-coercion guidance spesifik dipaparkan untuk `inventory_id` dan `inventory_movement_id`.
3. `request_id` dipaparkan bila hadir pada payload.
4. Unknown branch sahaja guna fallback generik.

## Dependency to Kuro
Perlu sample envelope konsisten untuk freeze parser:
- validation/type (`code/message/request_id/param`)
- not-found (`code/message/request_id`)
- mismatch/hardening validation branch (target 4xx)
