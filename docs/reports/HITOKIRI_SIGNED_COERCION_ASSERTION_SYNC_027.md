# HITOKIRI SIGNED COERCION ASSERTION SYNC 027

Timestamp: 2026-03-13 04:55 (Asia/Kuala_Lumpur)
Owner: Hitokiri (Lisa)
Scope: Non-mutation assertion synchronization for signed numeric-string coercion branches on current host.

## Objective
Freeze deterministic assertion handling for signed numeric-string delete payload branches while waiting Kuro canonical fixture bundle publication.

## Inputs Consolidated
- `KRO-LIVE-013G`: `inventory_id="+<id>"` probe returned `200 success`, cleanup `404`, parity `true`.
- `HKT-LIVE-022O`: `inventory_movement_id="+<id>"` probe returned `200 success`, cleanup `404`, parity `true`.

## Signed Branch Assertion Baseline (Current Host)

### 1) inventory_id signed numeric-string (`+<id>`)
- Current oracle: permissive delete path (`200 success`) when movement id is valid.
- Cleanup oracle: exact cleanup returns `404` if probe already removed row.
- Integrity closure rule: parity must return to pre-state hash.

### 2) inventory_movement_id signed numeric-string (`+<id>`)
- Current oracle: permissive delete path (`200 success`) when tuple companion fields are valid.
- Cleanup oracle: exact cleanup returns `404` if probe already removed row.
- Integrity closure rule: parity must return to pre-state hash.

## Frozen Split-Oracle Rule (until hardening lands)
`probe=200 + cleanup=404 + parity=true => residue CLOSED, integrity OPEN`

This rule is now explicitly frozen for both signed branches above and should be reused by Hitokiri/Shiro until Kuro publishes hardened reject fixtures.

## Dependencies (Blocking Final Freeze)
1) Kuro canonical fixture bundle for current host:
   - `ERROR_CODE_INPUT_ERROR` branch samples for signed payloads,
   - explicit `param` value per field (`inventory_id` vs `inventory_movement_id`),
   - with/without `request_id` optionality rules.
2) Per-field precedence lock for coercion families so signed-branch expectations can move from split-oracle to deterministic reject-oracle.

## Next Action After Dependency Clears
- Resume targeted live assertion run for signed branches under hardened expectation:
  - expected `4xx` validation class,
  - canonical envelope match (`code/message/param/request_id policy`),
  - same-cycle revert and parity proof.
