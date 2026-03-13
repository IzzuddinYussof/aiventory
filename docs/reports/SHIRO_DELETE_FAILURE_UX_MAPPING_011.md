# SHIRO_DELETE_FAILURE_UX_MAPPING_011

Timestamp: 2026-03-12 04:50 (Asia/Kuala_Lumpur)
Owner: Shiro (Frontend UX + Execution)
Scope: Legacy delete flow UX hardening prep (`item_movement_history_widget.dart`) berdasarkan live integrity findings terkini.

## Why this run (non-duplicate)
Run ini tidak ulang mutation API. Fokus pada front-end UX debt yang belum ditutup: bagaimana app paparkan kegagalan delete mengikut branch error sebenar (not-found, malformed payload, tuple mismatch hardening akan datang).

## Execution performed
1) Local app lane sanity run:
   - `flutter run -d chrome --web-port 7436 --profile --no-resident`
   - Result: build + launch success.
2) Static UX contract audit pada:
   - `lib/item_movement_history/item_movement_history_widget.dart`
   - delete confirmation + success/fail feedback path.

## Current implementation evidence
- Delete action call:
  - `InventoryMovementGroup.itemMovementDeleteCall.call(...)`
- Success UX:
  - Snackbar generik: `Movement deleted successfully.`
- Failure UX:
  - Dialog title: `Delete failed`
  - Message fallback: `Unable to delete this movement.`
  - Mengguna `_responseMessage(jsonBody, fallback)` tetapi tiada branch-specific copy map.
- Tiada explicit `request_id` display dalam error surface.

## UX discrepancy (frontend)
1) **Error class collapse**
   - Semua kegagalan delete dipaparkan hampir sama (dialog generik), padahal backend findings sekarang ada branch berbeza:
     - invalid/nonexistent movement id (deterministik 404)
     - malformed/empty-string payload (pernah muncul 500 ERROR_FATAL)
     - tuple mismatch/missing-field (target hardening future: 4xx)

2) **No support trace visibility**
   - `request_id` tidak dipaparkan kepada operator, jadi escalation sukar bila isu intermittent.

3) **Success semantics too optimistic for transition period**
   - Dengan legacy permissive behavior pada valid movement id mismatch, mesej success semata-mata boleh menyorok contract integrity risk.

## Proposed UX mapping (transitional -> hardened)
### A) Invalid/nonexistent movement (404 / ERROR_CODE_NOT_FOUND)
- Title: `Pergerakan tidak ditemui`
- Body: `Rekod mungkin sudah dipadam atau senarai belum dikemas kini. Sila refresh dan cuba semula.`
- Action: `Refresh senarai`

### B) Validation/request-shape fault (400/422 target, termasuk malformed payload)
- Title: `Maklumat padam tidak lengkap`
- Body: `Data padam tidak lengkap atau tidak sah. Semak semula dan cuba lagi.`
- Action: `Semak semula`

### C) Tuple mismatch hardening branch (future strict 4xx)
- Title: `Padam ditolak kerana data tidak sepadan`
- Body: `Maklumat item telah berubah. Refresh dahulu sebelum padam semula.`
- Action: `Refresh senarai`

### D) Unknown/internal
- Title: `Gagal padam pergerakan`
- Body: `Sistem sedang bermasalah. Cuba lagi sebentar lagi.`

## Request ID surfacing rule (acceptance candidate)
- Jika response ada `request_id`, paparkan pada dialog bawah mesej:
  - `Rujukan sokongan: <request_id>`
- Kekalkan juga dalam log debug client untuk handoff Kuro/Hitokiri.

## UI acceptance criteria (frontend)
1) Delete failure copy mesti branch-aware minimum untuk:
   - not-found,
   - validation/request-shape,
   - unknown/internal.
2) `request_id` dipaparkan bila tersedia.
3) Dialog action CTA jelas (`Refresh` atau `Semak semula`), bukan hanya `Ok` generik.
4) Success toast kekal, tetapi jangan override failure-specific detail bila backend return reject.

## [HANDOFF_TO_KURO]
1) Publish final error envelope untuk delete endpoint hardening (`code`, `message`, `request_id`, optional `field_errors`) supaya branch-map frontend boleh difreeze.
2) Lock status/code matrix bagi:
   - invalid id (404),
   - missing field,
   - malformed payload,
   - valid-id tuple mismatch.

## [HANDOFF_TO_HITOKIRI]
1) Tambah assertion UX layer untuk delete-failure branch mapping + `request_id` visibility.
2) Untuk execution run seterusnya, verify UI branch tidak collapse ke dialog generik bagi semua error class.

## Revert note
- Tiada code patch.
- Tiada API mutation.
- Revert: not required.
