# HITOKIRI COPY REGRESSION CHECKER DESIGN 026

## Context
Current Item Movement History BM harmonization is stable in source-level spot checks, but closure is still fragile without a deterministic CI-safe checker that avoids false positives from code identifiers (example: `canGoNext`, `_nextPage`).

## Cycle Goal
Design and execute a non-mutation verification pass for copy regression readiness while keeping the primary local app lane healthy.

## Execution Summary (2026-03-13 04:39 Asia/Kuala_Lumpur)
1. Local lane sanity run:
   - `flutter run -d chrome --web-port 8446 --profile --no-resident`
   - Result: `Built build\\web`, `Application finished`.
2. Source-level targeted scan on:
   - `lib/item_movement_history/item_movement_history_widget.dart`
3. Detection approach used:
   - PowerShell `Select-String` with known legacy EN labels as pattern list.

## Observed Result
- No targeted user-facing EN legacy labels were found in current source.
- Matches that appeared were identifier-only (`_nextPage`, `canGoNext`, `next_page`, `nextPage`) and **not UI copy**.
- This confirms BM harmonization remains intact for the tracked discrepancy set.

## CI-safe Checker Design (Proposed)
### Checker objective
Fail CI only when user-visible EN labels reappear in Item Movement History screen copy.

### Guardrails to avoid false positives
1. Scope to user-visible string literals only (quoted text in widget tree/build methods), not variable names.
2. Exclude identifier/token matches:
   - `nextPage`, `_nextPage`, `canGoNext`, `next_page`.
3. Maintain explicit denylist of legacy EN labels, for example:
   - `"Item Movement History"`
   - `"Swipe left on a movement row to delete."`
   - `"Retry"`
   - `"No movement history found."`
   - `"Previous"`
   - `"Next"`
   - `"Delete failed"`
   - `"Movement not found"`
   - `"Invalid delete request"`
   - `"Request ID"`
   - `"Delete movement?"`
4. Output deterministic fail report with:
   - line number,
   - matched literal,
   - context snippet.

### Suggested implementation path
- Add a lightweight script under `scripts/` (PowerShell or Dart) that:
  1) parses/filters string literals,
  2) checks denylist,
  3) exits non-zero on literal regressions only.
- Wire script into CI as a dedicated quality gate for Item Movement History module.

## Risk Note
Until this checker is integrated in CI, copy-regression closure still depends on manual/static re-audit cycles.

## Handoff Targets
- Kuro: lock policy whether checker should enforce BM-only or allow bilingual exceptions by module.
- Shiro: implement checker script + CI hook and include one negative fixture test proving identifier-only tokens do not fail the gate.
