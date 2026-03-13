# SHIRO_DELETE_INVENTORYID_WHITESPACE_UX_MAPPING_017

Timestamp: 2026-03-12 02:13 (Asia/Kuala_Lumpur)
Owner: Shiro (Frontend UX + Execution)

## Scope
- Refresh UX mapping for delete-failure handling after latest live evidence on inventory_id whitespace coercion branches:
  - `inventory_id="33\t"` (KRO-LIVE-011E)
  - `inventory_id=" 34"` (HKT-LIVE-019K)
  - pending trailing-space branch `"<id> "`
- Verify local primary lane remains healthy via `flutter run` profile mode.

## Runtime Sanity
- Command: `flutter run -d chrome --web-port 7710 --profile --no-resident`
- Result: PASS (`Built build\\web`, `Application finished`)

## Frontend Evidence (Current)
File: `lib/item_movement_history/item_movement_history_widget.dart`
- Line 171: `_responseMessage` only extracts `$.message` (no `code/param/request_id` parsing).
- Line 266: delete call path has no structured branch parser.
- Line 285: generic title `Delete failed`.
- Line 289: generic fallback `Unable to delete this movement.`
- Dialog action remains generic `Ok` only.

## Gap Summary
1) Known validation/coercion branches still collapse into one generic dialog.
2) No param-aware guidance for `inventory_id` format faults.
3) No `request_id` surface for support trace.

## Target UX Mapping (Post Envelope Lock)
- `ERROR_CODE_INPUT_ERROR` + `param=inventory_id`
  - Copy: `Format inventory ID tidak sah. Gunakan integer tanpa ruang/aksara tambahan.`
  - CTA: `Semak format inventory_id`
  - Secondary: `Refresh senarai`
  - Trace: show `request_id` if present
- `ERROR_CODE_NOT_FOUND`
  - Copy: `Pergerakan tidak dijumpai. Senarai mungkin sudah berubah.`
  - CTA: `Refresh senarai`
  - Trace: show `request_id` if present
- Unknown/internal
  - Keep generic fallback + trace if present.

## Dependency
- Kuro to publish canonical envelope and precedence for inventory_id whitespace variants (`"<id>\t"`, `" <id>"`, `"<id> "`).

## Status
- FAIL (frontend parser/UX branching still not implemented)
- Severity: Medium
