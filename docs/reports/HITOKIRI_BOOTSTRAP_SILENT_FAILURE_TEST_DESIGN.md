# HITOKIRI Test Design - Bootstrap Silent Failure Isolation

Timestamp: 2026-03-11 23:28 (Asia/Kuala_Lumpur)
Author: Lisa (Hitokiri)

## Why this run exists
UI functional rerun akan duplicate finding lama (blank screen sudah disahkan beberapa kali). Run ini fokus design test baru untuk isolate silent-failure path sebelum UI mount.

## New finding basis (static)
- `main.dart` menunggu `await appState.initializePersistedState();` sebelum `runApp(...)`.
- `app_state.dart` gunakan `_safeInit(...)` yang swallow exception (`catch (_) {}`), jadi decode/state failure boleh senyap tanpa signal kuat.
- Kombinasi ini konsisten dengan simptom: app start, tapi mount UI gagal tanpa console error jelas.

## Test Objectives
1) Bezakan failure sumber dari persisted state vs router/splash asset.
2) Paksa error observability supaya root cause boleh ditangkap sekali run.
3) Bagi Shiro/Kuro executable checklist yang non-destructive dan no live API mutation.

## Targeted test matrix

### A. Persisted-state corruption / decode-path tests
- HKT-BOOT-SIL-001: LocalStorage clean state (tiada `ff_*`) -> expected login/splash visible.
- HKT-BOOT-SIL-002: Inject malformed JSON pada `ff_allInventory` -> expected app still render + fallback kosong + error log marker.
- HKT-BOOT-SIL-003: Inject malformed JSON pada `ff_inventoryCategoryLists` -> expected no white screen, controlled fallback.
- HKT-BOOT-SIL-004: Inject malformed JSON pada `ff_branchLists` -> expected no render short-circuit.
- HKT-BOOT-SIL-005: Valid large persisted list (stress) -> expected mount <= agreed threshold (set p95 target by team).

### B. Pre-runApp observability tests (debug-only instrumentation)
- HKT-BOOT-SIL-006: Add marker logs before/after `FlutterFlowTheme.initialize()`.
- HKT-BOOT-SIL-007: Add marker logs before/after `initializePersistedState()`.
- HKT-BOOT-SIL-008: Wrap `runApp` in guarded zone and assert stacktrace capture if any throw.
- HKT-BOOT-SIL-009: Hook `FlutterError.onError` + `PlatformDispatcher.instance.onError` and verify emitted logs when forced exception is triggered.

### C. Router/splash attach tests
- HKT-BOOT-SIL-010: Force `showSplashImage=false` at startup in debug build -> expected direct LoginWidget render.
- HKT-BOOT-SIL-011: Validate splash asset load success (`assets/images/Untitled_design_(1).png`) and fallback behavior if asset fails load.
- HKT-BOOT-SIL-012: Navigate direct `/login` with same instrumented build -> expected identical lifecycle markers + visible login mount.

## Acceptance criteria to unblock functional testing
- At least one visible first-state (splash or login) appears consistently.
- If startup failure berlaku, log mesti pinpoint segment (theme init / persisted state / router build / widget render) dengan stacktrace.
- Tiada data mutation API berlaku semasa bootstrap diagnostics.

## Evidence checklist for execution team
- Console/log capture with milestone markers (timestamped).
- Screenshot first visible state.
- LocalStorage snapshot before/after corruption tests.
- Explicit revert note: remove instrumentation patch and clear injected localStorage test keys.

## Handoffs
[HANDOFF_TO_KURO]
1) Implement debug-only instrumentation for HKT-BOOT-SIL-006..009.
2) Share exact failing segment + stacktrace from first failing case.
3) If persisted-state corruption reproduces blocker, propose NEW API-backed state bootstrap contract (do not alter live APIs).

[HANDOFF_TO_SHIRO]
1) Execute HKT-BOOT-SIL-010..012 on instrumented build and validate first visible UX state.
2) Draft UX fallback copy for startup degraded mode (state reset prompt / retry) once failing segment confirmed.

[REVERT_NOTICE_TO_KURO]
- This run design-only. No code patch, no data touched.
- Revert not required for this cycle.
