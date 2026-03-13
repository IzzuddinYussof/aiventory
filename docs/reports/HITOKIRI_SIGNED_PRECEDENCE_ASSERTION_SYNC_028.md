# HITOKIRI_SIGNED_PRECEDENCE_ASSERTION_SYNC_028

Timestamp: 2026-03-13 05:34 (Asia/Kuala_Lumpur)
Owner: Hitokiri
Scope: Assertion-sync (non-mutation) after fixture lock `KURO_CURRENT_HOST_DELETE_FIXTURE_BUNDLE_032.md`

## Objective
Freeze deterministic Hitokiri assertion behavior for signed-number delete branches so future live cycles avoid duplicate/noisy probes and follow one closure rubric.

## Inputs Reviewed
- `docs/reports/KURO_CURRENT_HOST_DELETE_FIXTURE_BUNDLE_032.md`
- `docs/discussion_lisa_hitokiri.md` latest handoff blocks
- `docs/todo_list_improvement.md` signed-coercion open items

## Signed-number oracle (current-host, interim split)

### inventory_movement_id
- `+<id>` branch: permissive risk branch (historical: probe `200`, cleanup `404`, parity `true`).
- `-<id>` branch: deterministic not-found branch (historical: probe `404 ERROR_CODE_NOT_FOUND`, cleanup `200`, parity `true`).

### inventory_id
- `+<id>` branch: permissive risk branch (historical: probe `200`, cleanup `404`, parity `true`).
- `-<id>` branch: permissive risk branch (historical: probe `200`, cleanup `404`, parity `true`).

## Frozen closure rubric (active until hardened fixture pack published)
- Permissive branch close condition: `probe 200 + cleanup 404 + parity=true` => residue CLOSED, integrity OPEN.
- Not-found branch close condition: `probe 404 + cleanup 200 + parity=true` => residue CLOSED, precedence signal OPEN/LOCKED as documented.
- Any revert uncertainty => immediate `[REVERT_NOTICE_TO_KURO]` Critical, remains open until parity proof is captured.

## Next executable queue (Hitokiri)
1) Do not re-run already-complete signed branches unless Kuro publishes hardened reject fixtures.
2) Prioritize uncovered coercion families only.
3) Reuse fixture-032 envelope expectations for all parser-facing evidence capture.

## Dependency lock
Final signed-branch deterministic freeze still depends on Kuro hardened target fixture bundle (expected validation-class reject for both fields where policy requires). Until then, keep split-oracle tracking explicit in every run.
