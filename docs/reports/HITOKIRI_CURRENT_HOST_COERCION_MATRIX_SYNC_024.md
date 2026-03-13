# HITOKIRI CURRENT-HOST COERCION MATRIX SYNC 024

Timestamp: 2026-03-13 04:15 (Asia/Kuala_Lumpur)
Owner: Hitokiri
Scope: Sync current-host live oracle coverage into one actionable matrix and keep execution lane healthy without duplicate mutation.

## Local execution lane
- Command: `flutter run -d chrome --web-port 8284 --profile --no-resident`
- Result: PASS (`Built build\\web`, `Application finished`)

## Current-host split-oracle summary (xqoc-ewo0-x3u2)

### A) Exact tuple baseline
- Exact tuple delete remains valid success path (`200 success`) on clean payload.

### B) inventory_id coercion family (current behavior)
- Proven permissive (`200 success` then cleanup `404 already removed`, parity true):
  - whitespace: leading/trailing space, leading/trailing tab
  - control char: leading CR (`\r<id>`)
  - numeric coercion: decimal string (`<id>.0`), scientific lower/upper (`<id>e0`, `<id>E0`)

### C) inventory_movement_id coercion family (current behavior)
- Proven permissive for multiple branches (`200 success` then cleanup `404 already removed`, parity true):
  - whitespace: leading/trailing space, leading/trailing tab
  - control char: leading/trailing CR
  - numeric coercion: decimal string (`<id>.0`), scientific lower/upper (`<id>e0`, `<id>E0`)

## Deterministic closure rubric (active)
- For permissive-risk branches:
  - probe `200 success`
  - cleanup exact delete `404 ERROR_CODE_NOT_FOUND`
  - post-state parity `pre_hash == post_hash`
  => residue CLOSED, integrity finding remains OPEN (Critical).

## Dependencies to close split-oracle
1) Kuro publishes frozen per-field coercion policy (target reject before tuple resolution).
2) Kuro publishes canonical reject envelope fixtures:
   - `ERROR_CODE_INPUT_ERROR`
   - stable `param` contract (`inventory_id` / `inventory_movement_id` / `field_value`)
   - `request_id` optionality rule.
3) Shiro validates parser UI against fixture pack (present/absent `request_id`, param-aware branches).

## Revert protocol
- This cycle did not perform live mutation.
- Revert not required.
