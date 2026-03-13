# KURO Current-Host Delete Hardened Fixture Addendum 033

Timestamp: 2026-03-13 08:20 (Asia/Kuala_Lumpur)
Owner: Kuro
Base host: `https://xqoc-ewo0-x3u2.s2.xano.io`
Endpoint: `DELETE /api:0o-ZhGP6/item_movement_delete`
Depends on baseline: `KURO_CURRENT_HOST_DELETE_FIXTURE_BUNDLE_032.md`

## Purpose
Freeze target-state (post-hardening) fixture behavior so Hitokiri and Shiro can move from split-oracle tracking into deterministic closure assertions.

## Hardening target policy (authoritative for assertion flip)

1) **Method**
- Only `DELETE` is valid.
- Wrong-verb requests remain non-destructive and out of business-logic coercion assertions.

2) **Request-shape/coercion enforcement**
- Coercion variants on either field below MUST reject as validation-class errors:
  - `inventory_id`
  - `inventory_movement_id`
- Covered coercion families: whitespace/control-char (`space/tab/CR/LF`), decimal/scientific, signed/scientific signed, and mixed numeric-format strings.

3) **Status/code policy**
- Coercion/request-shape/type reject target: `400 ERROR_CODE_INPUT_ERROR`.
- Invalid/nonexistent `inventory_movement_id` precedence must remain: `404 ERROR_CODE_NOT_FOUND`.
- Exact tuple valid delete remains: `200 "success"`.

4) **param stability policy (hardened target)**
- Field-specific `param` is required for coercion/type branches:
  - `param=inventory_id` when inventory_id branch fails.
  - `param=inventory_movement_id` when movement-id branch fails.
- Generic `param=field_value` is considered transitional legacy and should not appear after hardening flip.

5) **request_id policy**
- Envelope `request_id` remains optional for client parsing acceptance.
- Backend logging/trace must still capture request correlation deterministically.
- UI behavior: render `ID Rujukan` only when present.

## Canonical target fixtures

### A) Exact tuple success
Status: `200`
```json
"success"
```

### B) Coercion/type reject (inventory_id branch)
Status: `400`
```json
{
  "code": "ERROR_CODE_INPUT_ERROR",
  "message": "Input error",
  "param": "inventory_id",
  "request_id": "<optional>"
}
```

### C) Coercion/type reject (inventory_movement_id branch)
Status: `400`
```json
{
  "code": "ERROR_CODE_INPUT_ERROR",
  "message": "Input error",
  "param": "inventory_movement_id",
  "request_id": "<optional>"
}
```

### D) Invalid/nonexistent movement id precedence
Status: `404`
```json
{
  "code": "ERROR_CODE_NOT_FOUND",
  "message": "Record not found",
  "request_id": "<optional>"
}
```

## Deterministic closure rubric (hardening mode)
- For each coercion test branch, closure requires:
  1) `probe_status=400`, `probe_code=ERROR_CODE_INPUT_ERROR`, field-specific `param` match,
  2) explicit cleanup outcome captured,
  3) post-state parity `pre_hash == post_hash`.
- Any permissive `200` on coercion branch keeps integrity issue OPEN (even if parity closes residue).
- Any revert uncertainty triggers immediate `[REVERT_NOTICE_TO_KURO]` + Critical until exact restore is proven.

## Immediate execution priority (next wave)
1) `inventory_id="+<id>e0"` -> expected fixture B.
2) `inventory_id="-<id>E0"` -> expected fixture B.
3) `inventory_movement_id="+<id>E0"` -> expected fixture C.
4) `inventory_movement_id=" <id>"` -> expected fixture C.

## Consumer notes
- Hitokiri: shift branch expectations from split-oracle to strict 400+param enforcement for coercion families.
- Shiro: keep parser keyed to `code/param`; treat missing `request_id` as valid optional field.
- Kuro: record branch-by-branch flip status; annotate any divergence from this addendum in discussion + test execution log.
