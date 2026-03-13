# Revert Guide (Repair Workstream)

## Branch Strategy
- Base branch: current state before repair
- Repair branch: `fix/aiventory-repair-20260313`

## Per-Fix Revert Method
Untuk setiap fix (F01, F02, ...):
1. Simpan patch: `docs/revert_patches/Fxx.patch`
2. Simpan changed file list
3. Simpan DB/API migration notes (kalau backend)

## Quick Revert
- Revert full repair: checkout base branch
- Revert specific fix: apply reverse patch untuk Fxx

## Notes
- Untuk Xano endpoint baru, simpan naming + route + payload schema supaya boleh disable/remove semula jika perlu.

## F01 Revert Detail
- Patch file: `docs/revert_patches/F01.patch`
- Changed files (frontend):
  - `lib/carousell/carousell_widget.dart`
  - `lib/upload_carousell/upload_carousell_widget.dart`
  - `test/widget_test.dart`
- Backend/Xano changes: none
- Revert command (specific fix):
  - `git apply -R docs/revert_patches/F01.patch`
- Verification note:
  - Runtime verification blocked in this environment (`WHERE`/git PATH issue), so revert validation for F01 is patch-based this run.

## F02 Revert Detail
- Patch file: `docs/revert_patches/F02.patch`
- Changed files (backend API layer):
  - `lib/backend/api_requests/api_calls.dart`
- Backend/Xano endpoint contract added (app integration layer):
  - `DELETE /inventory_carousell_delete`
  - `POST /inventory_carousell_undo_delete`
- Rollback note:
  - Remove these endpoint integrations by applying reverse patch:
    - `git apply -R docs/revert_patches/F02.patch`
  - Or reset file to HEAD state if needed:
    - `git checkout -- lib/backend/api_requests/api_calls.dart`
- Verification note:
  - Frontend trigger path was not safely completed/verified in this run; status for F02 is `blocked-final`.

## F03 Revert Detail
- Patch file: `docs/revert_patches/F03.patch`
- Changed files:
  - `lib/backend/api_requests/api_calls.dart`
  - `lib/carousell_update/carousell_update_model.dart`
- Backend/Xano endpoint contract added (app integration layer):
  - `DELETE /inventory_carousell_movement_delete`
  - `POST /inventory_carousell_movement_undo_delete`
- Frontend wiring:
  - Carousell cancel flow now routes through movement delete call (revert-safe contract) in `updateCarousellMovement`.
- Rollback note:
  - Apply reverse patch:
    - `git apply -R docs/revert_patches/F03.patch`
  - Or reset changed files:
    - `git checkout -- lib/backend/api_requests/api_calls.dart lib/carousell_update/carousell_update_model.dart`
- Verification note:
  - Live endpoint execution/rollback proof was not completed in this run; status for F03 is `blocked-final`.

## F04 Revert Detail
- Patch file target: `docs/revert_patches/F04.patch`
- Run outcome this cycle: no accepted code mutation (Shiro phase timeout/fail before usable patch output).
- Rollback note:
  - No rollback action required for this run because no F04 code change was finalized.
- Verification note:
  - Kuro/Hitokiri phases were intentionally skipped due repeated Shiro blocker.
  - Status for F04 is `blocked-final`.

## F05 Revert Detail
- Patch file: `docs/revert_patches/F05.patch`
- Accepted changed files (frontend):
  - `lib/components/edit_status_widget.dart`
  - `lib/order_list/order_list_widget.dart`
  - `lib/stock_in/stock_in_widget.dart`
- Change type:
  - Improve status-transition failure UX message handling (`Status update failed` + clearer invalid-transition guidance).
- Backend/Xano change:
  - No accepted backend mutation in this run.
- Rollback note:
  - Preferred: `git apply -R docs/revert_patches/F05.patch`
  - If strict apply fails due line/whitespace drift, use file-level reset for accepted files:
    - `git checkout -- lib/components/edit_status_widget.dart lib/order_list/order_list_widget.dart lib/stock_in/stock_in_widget.dart`
- Verification note:
  - Hitokiri reported pass criteria not fully met (no conclusive revert-safe live transition matrix proof), so F05 status is `blocked-final` this run.

## F06 Revert Detail
- Patch file: `docs/revert_patches/F06.patch`
- Accepted changed files (frontend):
  - `lib/tracking_order/tracking_order_widget.dart`
  - `test/tracking_order_widget_test.dart`
- Change type:
  - Safer tracking-order image rendering (null/invalid URL fallback icon) + widget coverage for missing/invalid URL.
- Backend/Xano change:
  - None in F06 scope.
- Rollback note:
  - Preferred: `git apply -R docs/revert_patches/F06.patch`
  - If strict reverse apply fails in a dirty tree, use safe file-level restore:
    - `git restore --source=HEAD --worktree --staged lib/tracking_order/tracking_order_widget.dart test/tracking_order_widget_test.dart`
    - If `git restore` is unavailable, fallback:
      - `git checkout -- lib/tracking_order/tracking_order_widget.dart test/tracking_order_widget_test.dart`
      - `git clean -f -- test/tracking_order_widget_test.dart`

## F07 Revert Detail
- Patch file: `docs/revert_patches/F07.patch`
- Accepted changed files (frontend):
  - `lib/carousell/carousell_widget.dart`
- Change type:
  - Standardized Upload Carousell navigation so param path passes consistent context (`inventoryId`, `category`, `search`, `searchCategory`) and blocks missing inventory selection safely.
  - Direct route remains guarded by existing missing `inventoryId` safe screen in upload page.
- Backend/Xano change:
  - None in F07 scope.
- Rollback note:
  - Preferred: `git apply -R docs/revert_patches/F07.patch`
  - Fallback file restore:
    - `git checkout -- lib/carousell/carousell_widget.dart`
- Verification note:
  - Runtime Flutter test execution remains environment-blocked (`WHERE`/git PATH), so verification this run is code-flow/static plus patch readiness.

## F08 Revert Detail
- Patch file target: `docs/revert_patches/F08.patch`
- Run outcome this cycle: no accepted code mutation (Shiro phase was terminated after repeated hang/context drift before usable frontend output).
- Backend/Xano change:
  - None accepted in this run.
- Rollback note:
  - No rollback action required for this run because no F08 code change was finalized.
- Verification note:
  - Kuro and Hitokiri phases were intentionally not started due Shiro blocker and retry guard.
  - Status for F08 is `blocked-final` in this run.

## Final Cycle Revert Snapshot (2026-03-13 03:07 MYT)
- Terminal statuses reached for F01-F08.
- Existing per-fix revert patches remain the source-of-truth for reversible fixes:
  - F01, F02, F03, F05, F06, F07
- Non-mutating blocked fixes with no accepted patch this cycle:
  - F04, F08
- Backend rollback notes are documented in F02/F03 sections.
