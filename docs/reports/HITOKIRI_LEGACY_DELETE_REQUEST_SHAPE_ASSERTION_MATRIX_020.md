# Hitokiri Legacy Delete Request-Shape Assertion Matrix (020)

## Context
This pack translates latest live evidence into deterministic, executable assertions for:
- `DELETE /api:0o-ZhGP6/item_movement_delete`
- valid-id path request-shape/type/mismatch behavior
- post-probe cleanup + parity decision rules

Latest oracle included:
- `KRO-LIVE-010B`: wrong-type `expiry_date=12345` currently returns `200 success` on valid movement id.

## Objective
1. Freeze current-behavior oracle (legacy permissive branches).
2. Define target-hardened oracle (validation-class 4xx) for future rollout.
3. Prevent false positives in live safety runs by pinning parity/revert decisions.

## Case Matrix

### A. Baseline deterministic branches (already strict)

- **HKT-DEL-TYPE-001**: wrong-type `inventory_movement_id` (`"abc"`)
  - Legacy expected now: `400 ERROR_CODE_INPUT_ERROR`
  - Evidence baseline: `HKT-LIVE-019A`
  - Target hardened expected: same (`400`)

- **HKT-DEL-TYPE-002**: wrong-type `inventory_id` (`"abc"`)
  - Legacy expected now: `400 ERROR_CODE_INPUT_ERROR`
  - Evidence baseline: `KRO-LIVE-010A`
  - Target hardened expected: same (`400`)

- **HKT-DEL-NF-003**: invalid/nonexistent `inventory_movement_id`
  - Legacy expected now: `404 ERROR_CODE_NOT_FOUND`
  - Evidence baseline: `KRO-LIVE-008C`, `HKT-LIVE-016A`
  - Target hardened expected: same (`404`), precedence preserved

### B. Baseline permissive branches (must harden)

- **HKT-DEL-TYPE-004**: wrong-type `branch=12345`
  - Legacy expected now: `200 success` (undesired permissive)
  - Evidence baseline: `HKT-LIVE-019B`
  - Target hardened expected: `400 ERROR_CODE_INPUT_ERROR`

- **HKT-DEL-TYPE-005**: wrong-type `expiry_date=12345`
  - Legacy expected now: `200 success` (undesired permissive)
  - Evidence baseline: `KRO-LIVE-010B`
  - Target hardened expected: `400 ERROR_CODE_INPUT_ERROR` (or policy-locked validation 4xx)

- **HKT-DEL-MISS-006**: missing `branch`
  - Legacy expected now: `200 success` (undesired permissive)
  - Evidence baseline: `KRO-LIVE-009A`
  - Target hardened expected: validation 4xx

- **HKT-DEL-MISS-007**: missing `expiry_date`
  - Legacy expected now: `200 success` (undesired permissive)
  - Evidence baseline: `HKT-LIVE-018A`
  - Target hardened expected: validation 4xx

- **HKT-DEL-MISS-008**: missing `inventory_id`
  - Legacy expected now: `200 success` (undesired permissive)
  - Evidence baseline: `HKT-LIVE-018B`
  - Target hardened expected: validation 4xx

### C. Cleanup + parity decision rule

- **HKT-DEL-REV-009**: cleanup outcome classification after negative probe
  - If post-probe cleanup returns `404` and `pre_hash == post_hash`:
    - classify **Residue CLOSED**
    - classify **Branch-order ambiguity OPEN** (policy lock needed)
  - If `pre_hash != post_hash`:
    - raise `[REVERT_NOTICE_TO_KURO]` severity **Critical** immediately.

## Evidence Protocol (mandatory)
1. Pre-state snapshot (`count`, deterministic hash).
2. Mutation create (capture `id`).
3. Negative probe call (capture status + code/body).
4. Cleanup delete in same cycle.
5. Post-state parity (`pre_hash == post_hash`).

## Dependencies to lock with Kuro
1. Final validation-class policy for wrong-type `expiry_date` on valid-id path (`400` preferred).
2. Canonical error envelope for delete responses:
   - `code`, `message`, `request_id`, optional `param`, optional `field_errors`.
3. Final precedence order:
   - invalid-id `404` > request-shape validation 4xx > exact tuple `200`.

## Notes for Shiro UX mapping
- Map delete failures by code class, not message-only fallback.
- Reserve `request_id` slot in all non-2xx delete outcomes.
- Keep type/missing-field branches separate from `ERROR_CODE_NOT_FOUND`.
