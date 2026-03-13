# HITOKIRI - Bootstrap Render A/B Test Pack

Tarikh: 2026-03-11
Owner: Hitokiri (Test Design)
Status: Execution-ready (debug-only, non-live)

## Context
Shiro run `SHR-BOOT-004` confirms blank gray page persists with Flutter view never mounting (`flt-glass-pane=false`, `canvas=false`) while `manifest.json` warning appears non-blocking. Next highest-value step is controlled A/B render-path isolation before touching backend/API.

## Objective
Bezakan dengan jelas sama ada punca blank screen datang dari:
1) pre-`runApp` init path,
2) router/theme/app bootstrap chain,
3) Flutter web engine mount pipeline.

## Guardrails
- No live API mutation.
- Debug-only code instrumentation/flags sahaja.
- Any temporary patch mesti direvert and logged.

## Execution Matrix

### HKT-BOOT-AB-001 - Pre-runApp milestone trace
**Purpose**: detect silent stop sebelum `runApp`.
- Inject ordered markers:
  - `BOOT_M1 main_enter`
  - `BOOT_M2 bindings_ready`
  - `BOOT_M3 app_state_init_start`
  - `BOOT_M4 app_state_init_done`
  - `BOOT_M5 runApp_enter`
  - `BOOT_M6 runApp_returned`
- Assert: marker sequence complete without gap.
- Fail signal: missing marker before `M5` => pre-render init blocker.

### HKT-BOOT-AB-002 - Global error capture completeness
**Purpose**: ensure silent exceptions are surfaced.
- Enable `FlutterError.onError`, `PlatformDispatcher.instance.onError`, guarded zone wrapper.
- Assert: every captured exception includes stacktrace + phase tag.
- Fail signal: process stalls with no marker and no captured error.

### HKT-BOOT-AB-003 - Fallback root-widget render A/B
**Purpose**: isolate router/theme path from engine mount.
- Variant A: original `runApp(MyApp())`.
- Variant B: `runApp(MaterialApp(home: Scaffold(body: Center(child: Text('BOOT_OK')))))`.
- Assert:
  - If B renders, engine mount works and failure is in app/router/theme/init chain.
  - If B also fails, issue likely engine/web bootstrap layer.

### HKT-BOOT-AB-004 - Deferred persisted-state init probe
**Purpose**: validate whether awaited persisted-state init blocks first paint.
- Variant A: current awaited init before `runApp`.
- Variant B: minimal first paint first, persisted init deferred post-frame (debug probe only).
- Assert: first-state visibility appears in B without functional crash.
- Fail signal: both variants still blank => persisted-state wait not sole blocker.

### HKT-BOOT-AB-005 - Router bypass smoke probe
**Purpose**: isolate `MaterialApp.router` chain.
- Temporarily bypass router with static `MaterialApp(home: BootProbeScreen)`.
- Assert: static screen appears.
- Fail signal: static home still blank => issue below router level.

### HKT-BOOT-AB-006 - Evidence protocol
Per run collect:
1) full console dump,
2) milestone log sequence,
3) DOM mount state (`flt-glass-pane`, `canvas`, body child count),
4) screenshot,
5) explicit revert proof for temporary probes.

## Decision Table
- **Case A**: Bypass/fallback renders -> prioritize app init/router/theme fixes.
- **Case B**: Fallback fails too -> escalate to web engine/bootstrap transport diagnosis.
- **Case C**: Only deferred-init variant renders -> redesign startup flow with non-blocking persisted-state recovery.

## Handoff Requirements
### [HANDOFF_TO_SHIRO]
- Execute `HKT-BOOT-AB-003/004/005` and capture UX-visible first-state outcomes + screenshots.
- Validate whether any variant introduces redirect loop or unusable interaction shell.

### [HANDOFF_TO_KURO]
- Apply instrumentation hooks for `HKT-BOOT-AB-001/002` in debug-only path.
- Provide clean revert commit/patch notes for every temporary startup probe.

## Exit Criteria
Pack considered complete when one branch in Decision Table is proven with evidence and root-cause zone narrowed to a single subsystem.
