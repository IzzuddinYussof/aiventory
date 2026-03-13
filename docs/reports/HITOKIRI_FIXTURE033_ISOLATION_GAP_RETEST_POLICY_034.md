# HITOKIRI FIXTURE-033 ISOLATION GAP RETEST POLICY 034

Timestamp: 2026-03-13 06:35 (Asia/Kuala_Lumpur)
Owner: Hitokiri
Scope: Post-isolated-run decision policy for fixture-033 hardening verification on current host (`xqoc-ewo0-x3u2`)

## Context
Isolated verification wave already executed on priority coercion branches after fixture addendum 033, including:
- inventory_id signed-scientific (`+<id>e0`, `+<id>E0`, `-<id>E0`)
- inventory_movement_id whitespace (`" <id>"`, `"<id>\t"`, `"<id> "`)

Observed live behavior remains permissive on these branches (`probe=200 success`, `cleanup=404 already removed`, `parity=true`) instead of hardened target (`400 ERROR_CODE_INPUT_ERROR` + field-specific `param`).

## Verified isolated evidence set
1) HKT-LIVE-033B: movement-id leading-space -> 200 permissive
2) KRO-LIVE-013M-R2: movement-id trailing-tab -> 200 permissive
3) HKT-LIVE-033E: movement-id trailing-space -> 200 permissive
4) KRO-LIVE-013M-R1: inventory_id signed-scientific `+<id>e0` -> 200 permissive
5) HKT-LIVE-033C: inventory_id signed-scientific `-<id>E0` -> 200 permissive
6) HKT-LIVE-033F: inventory_id signed-scientific `+<id>E0` -> 200 permissive
7) KRO-LIVE-013M-R3: movement-id leading-space isolated reconfirm -> 200 permissive

## Decision (Hitokiri execution policy)
Until Kuro publishes rollout fingerprint/ETA and deployment confirmation for fixture-033 hardening activation:
- STOP duplicate live reruns on already-isolated branches above.
- Keep integrity finding OPEN (Critical) with split-oracle closure rubric:
  - `probe 200 + cleanup 404 + parity=true` => residual CLOSED, integrity OPEN.
- Continue only non-mutation continuity/design work to avoid noisy live cycles.

## Resume criteria for live hardening flip checks
Resume live mutation checks only when ALL conditions are met:
1) Kuro provides explicit rollout fingerprint (deploy id/build hash/time window),
2) Branch-level target matrix re-confirmed (`inventory_id` signed-scientific + `inventory_movement_id` whitespace => 400 input error),
3) Deterministic transport harness confirmed (DELETE method assertion + raw status/body capture),
4) Same-cycle parity protocol unchanged.

## Next executable assertion pack after resume
- HKT-LIVE-033G (planned): inventory_id signed-scientific `+<id>e0` hardened-flip check (expect 400 + `param=inventory_id`)
- HKT-LIVE-033H (planned): movement-id leading-space hardened-flip check (expect 400 + `param=inventory_movement_id`)
- Closure allowed only with deterministic hardened result + parity restoration proof.
