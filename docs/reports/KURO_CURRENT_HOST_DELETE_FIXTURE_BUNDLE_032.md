# KURO Current-Host Delete Fixture Bundle 032

Timestamp: 2026-03-13 05:22 (Asia/Kuala_Lumpur)
Owner: Kuro
Host: `https://xqoc-ewo0-x3u2.s2.xano.io`
Endpoint: `DELETE /api:0o-ZhGP6/item_movement_delete`

## Purpose
Freeze interim fixture bundle for frontend/parser/assertion teams while hardening is still in split-oracle state.

## Canonical request shape (current host, observed working)
```json
{
  "inventory_movement_id": "<stringified id>",
  "inventory_id": "<stringified id>",
  "branch": "<branch name>",
  "expiry_date": "YYYY-MM-DD"
}
```
Method must be `DELETE`. Wrong verb (`POST`) can return `404` and does not perform deletion.

## Observed response fixtures (current-state oracle)

### 1) Success branch (exact tuple, or permissive-coercion branch)
Status: `200`
Body:
```json
"success"
```

### 2) Not-found branch
Status: `404`
Body (sample):
```json
{
  "code": "ERROR_CODE_NOT_FOUND",
  "message": "Record not found"
}
```
`request_id`: not consistently observed in current logs; treat as optional/absent for now.

### 3) Input/validation branch
Status: `400`
Body (sample):
```json
{
  "code": "ERROR_CODE_INPUT_ERROR",
  "message": "Input error",
  "param": "field_value"
}
```
Observed `param` can be generic (`field_value`) or field-specific in other branches (`inventory_id`, `inventory_movement_id`). Parser must support both.

## Current per-field split-oracle summary
- `inventory_id` coercion variants (space/tab/CR/LF/decimal/scientific/signed): mostly still permissive `200` when movement id resolves.
- `inventory_movement_id` coercion variants: mixed; many permissive `200`, some branches observed `400` or `404` depending on variant.
- Signed split confirmed:
  - `inventory_movement_id="+<id>"` -> permissive `200` (observed)
  - `inventory_movement_id="-<id>"` -> `404 ERROR_CODE_NOT_FOUND` (observed)

## Deterministic closure rubric (active)
For controlled write tests:
- `probe=200`, `cleanup=404`, `pre_hash==post_hash` => residue `CLOSED`, integrity issue remains `OPEN`.
- Any revert uncertainty => immediate `[REVERT_NOTICE_TO_KURO]` Critical until parity restore is proven.

## Handoff consumption notes
- Shiro: keep parser branching on `code`, fallback on `param` generic values, and render `ID Rujukan` only when present.
- Hitokiri: continue split-oracle assertions using this fixture pack; do not collapse permissive branches into validation until policy lock flips.
- Kuro follow-up: publish hardened target-state fixture pack once backend enforcement is applied (expected coercion rejects as deterministic validation 4xx).