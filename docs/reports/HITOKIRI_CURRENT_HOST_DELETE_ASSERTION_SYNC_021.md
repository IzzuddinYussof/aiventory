# HITOKIRI CURRENT-HOST DELETE ASSERTION SYNC 021

Timestamp: 2026-03-12 16:40 (Asia/Kuala_Lumpur)
Owner: Hitokiri
Scope: Freeze deterministic assertion baseline for current-host delete path after `HKT-LIVE-019M` + `SHR-UX-018`.

## Context
Current configured host is `https://xqoc-ewo0-x3u2.s2.xano.io`.
Latest live signal (`HKT-LIVE-019M`) differs from legacy permissive oracle:
- negative probe returned `400 ERROR_CODE_INPUT_ERROR` with `param=field_value`,
- cleanup with exact tuple also returned `400 ERROR_CODE_INPUT_ERROR`,
- post-state parity still restored.

This indicates contract/request-shape drift and makes further coercion-variant live probes noisy until schema is locked.

## This cycle verification (non-live)
1) Local lane sanity confirmed:
   - `flutter run -d chrome --web-port 7796 --profile --no-resident` => build success.
2) Frontend parser state reconfirmed:
   - `item_movement_history_widget.dart` still reads message only (`$.message`),
   - no branch parser for `code/param/request_id`,
   - dialog still generic (`Delete failed` + `Ok`).
3) Client delete builder reconfirmed:
   - `ItemMovementDeleteCall` sends fully string-quoted tuple body.

## Assertion freeze (effective now)
Pause new live coercion permutations until Kuro publishes canonical current-host schema.
Allowed scope before schema lock:
- documentation sync,
- parser UX mapping prep,
- non-mutation local runtime sanity.

## Deterministic assertion set to use after schema lock
- Branch A: validation
  - expected class: `400 ERROR_CODE_INPUT_ERROR`
  - required payload fields: at least `code`, `message`, `param`; include `request_id` if available.
- Branch B: not-found
  - expected class: `404 ERROR_CODE_NOT_FOUND`
- Branch C: exact success
  - expected: success branch with deterministic envelope.

## UI acceptance tie-in
Frontend delete-failure handling must stop collapsing known branches into generic dialog.
Minimum acceptance:
1) Parse priority: `code` -> `param/field_errors` -> `message` fallback.
2) Validation branch (`ERROR_CODE_INPUT_ERROR`, `param=field_value`) shows targeted guidance.
3) Not-found branch shows refresh/re-sync guidance.
4) `request_id` shown when available.
5) Generic fallback only for unknown/internal branch.

## Revert protocol status
- No live mutation in this cycle.
- Revert not required.
