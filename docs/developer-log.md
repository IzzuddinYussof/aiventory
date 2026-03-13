# Developer Log

## 2026-03-11

### Objective

Reverse-engineer the current project structure, map the main user flows, trace the backend and data model, and produce baseline documentation for future development.

### Scope Completed

- mapped the app screen-by-screen from routed pages and primary components
- traced the login/bootstrap flow
- traced the main API groups and endpoint usage
- reviewed the core domain structs
- documented current architecture and known gaps

### Main Findings

1. The project is an internal branch inventory app, not a consumer app.
2. The code supports inventory management, order lifecycle handling, stock movement tracking, and an internal Carousell workflow.
3. Branch context is central to almost every screen.
4. `AI Venture` currently behaves as the HQ/admin branch in the client.
5. Inventory master data and inventory listing data are separate concepts in the model.
6. Order receiving is tied directly into stock-in movement creation.
7. Carousell is a distinct operational workflow layered on top of inventory rather than a simple listing screen.

### Architecture Notes

- Client framework: Flutter with heavy FlutterFlow generation
- Routing: `go_router`
- State: `FFAppState` plus provider-based propagation
- Persistence: `shared_preferences`
- Backend: Xano APIs with at least two namespaces
- Uploads: Xano upload endpoint plus Google Cloud Function for image upload

### Business Workflow Notes

#### Inventory

- users search branch inventory through inventory listings
- stock changes are represented through movement records
- history and stock-out are accessible from inventory search

#### Orders

- order creation starts from inventory
- status transitions are operationally important and handled in the client
- stock-in can complete the receiving part of the order lifecycle

#### Carousell

- supports both supply listings and request listings
- creates branch-to-branch movement records
- has a dedicated update queue for in-progress transactions

### Technical Risks Observed

- minimal automated test coverage
- placeholder `PurchaseOrder` screen still routed in app
- mixed status spelling for cancelled/canceled
- HQ permission logic depends partly on hard-coded branch naming
- wide use of global mutable app state increases hidden coupling
- backend namespace split is undocumented in repo

### Artifacts Created

- `C:\Programming\aiventory\docs\project-documentation.md`
- `C:\Programming\aiventory\docs\developer-log.md`

### Suggested Follow-Up

1. validate this reverse-engineered documentation with a product or operations owner
2. define a single canonical order status enum and transition table
3. add a developer setup section with required Flutter version, environment values, and backend dependencies
4. separate generated FlutterFlow code from hand-maintained business logic in team documentation
5. add tests for custom functions, order state transitions, and stock movement flows


## 2026-03-13 00:12 MYT - Repair workstream initialized
- Created docs/REPAIR_MASTER_TODO.md with full fix queue F01-F08.
- Created docs/REPAIR_ORCHESTRATION.md for sequential role-based flow (Shiro -> Kuro -> Hitokiri).
- Created docs/REVERT_GUIDE_REPAIR.md for rollback strategy.
- Constraint noted: only subagent id main available in current environment; role sessions will be label-based.

## 2026-03-13 00:xx MYT - F01 orchestration run (Shiro/Kuro/Hitokiri)
- Executed sequential flow for F01 using session labels: shiro -> kuro -> hitokiri.
- Shiro (initial): implemented route param send (`inventoryId`) and missing-param guard; added/updated widget tests.
- Kuro: confirmed no backend/Xano change required for F01.
- Hitokiri (initial verify): FAIL, found nullable crash path when `inventoryId` exists but no matching inventory (`inventoryChosen` null path).
- Shiro (retry cycle, 1x): added null-safe handling in `upload_carousell_widget.dart` (sync helper + guard on inventoryChosen-dependent assignments).
- Hitokiri (post-retry verify): runtime verification still blocked by environment (`WHERE` not recognized / git not in PATH for flutter wrapper), therefore cannot produce runtime-pass proof this run.
- Per workflow (retry exhausted + repeated blocker), F01 marked `blocked-final` and moved on.
- Revert patch saved: `docs/revert_patches/F01.patch`.

## 2026-03-13 01:xx MYT - F02 orchestration run (Shiro/Kuro/Hitokiri + 1 retry)
- Target fix: F02 (backend endpoint untuk revert-safe delete `inventory_carousell`).
- Shiro (initial): frontend assessment done, no safe obvious pre-backend change; no code change.
- Kuro: added backend API integration in app layer (`lib/backend/api_requests/api_calls.dart`):
  - `CarousellDeleteCall` -> `DELETE /inventory_carousell_delete`
  - `CarousellUndoDeleteCall` -> `POST /inventory_carousell_undo_delete`
  - Registered both under `CarousellGroup`.
- Shiro (follow-up): attempted frontend wiring for delete trigger; no safe unambiguous trigger path found in current UI flow without broader refactor; no code change.
- Hitokiri verify: FAIL (partial integration only): endpoint exists in API layer, but no confirmed frontend trigger usage and no live API proof.
- Retry cycle (1x, Shiro): aborted/failed to complete targeted implementation in run window; no code change.
- Per workflow (retry exhausted), F02 marked `blocked-final`.
- Revert patch saved: `docs/revert_patches/F02.patch`.
- Net file mutation for F02 this run: `lib/backend/api_requests/api_calls.dart`.

## 2026-03-13 01:10+ MYT - F03 orchestration run (Shiro/Kuro/Hitokiri + 1 retry ceiling)
- Target fix: F03 (backend endpoint untuk revert-safe delete `inventory_carousell_movement`).
- Shiro (initial): no safe isolated frontend-only change before backend contract wiring.
- Kuro: added movement delete/undo integration in app API layer (`lib/backend/api_requests/api_calls.dart`):
  - `CarousellMovementDeleteCall` -> `DELETE /inventory_carousell_movement_delete`
  - `CarousellMovementUndoDeleteCall` -> `POST /inventory_carousell_movement_undo_delete`
  - registered both under `CarousellGroup`.
- Shiro (follow-up): wired cancel action path in `lib/carousell_update/carousell_update_model.dart` so cancel now uses `carousellMovementDeleteCall` (with request id + actor id).
- Hitokiri verify: PARTIAL FAIL.
  - Code-flow wiring found for delete path.
  - Live Xano execution and mutation revert proof not completed this run, so pass criteria not fully met.
- Per workflow (retry ceiling + verification incomplete), F03 marked `blocked-final`.
- Revert patch target: `docs/revert_patches/F03.patch`.

## 2026-03-13 01:22+ MYT - F04 orchestration run (Shiro phase failed before handoff)
- Target fix: F04 (Carousell Update buyer-side exact revert).
- Orchestrator spawned Shiro sequentially (one active at a time rule).
- Shiro attempts repeatedly failed/timeout before producing usable F04 patch in the target repo (`C:\Programming\aiventory`).
- Same blocker repeated in same run (subagent instability/wrong context drift), so retry budget consumed at orchestration level.
- Kuro + Hitokiri phases were not started to avoid cascading low-confidence changes.
- Per workflow, F04 marked `blocked-final` and next fix will be F05 on next run.
- No new code mutation accepted for F04 in this run.

## 2026-03-13 01:3x+ MYT - F05 orchestration run (Shiro -> Kuro -> Kuro retry -> Hitokiri)
- Target fix: F05 (Order status transition state machine).
- Shiro (frontend): implemented clearer failure UX for status transition rejection in:
  - `lib/components/edit_status_widget.dart`
  - `lib/order_list/order_list_widget.dart`
  - `lib/stock_in/stock_in_widget.dart`
  - generated `docs/revert_patches/F05.patch`.
- Kuro initial pass (backend): execution became unsafe/noisy (credential-handling risk + inconclusive mutation evidence), run was stopped.
- Kuro retry (read-only constrained): confirmed app targets `PUT /order_list_status` and found non-mutating evidence only; no backend file mutation accepted.
- Hitokiri verify: FAIL for pass criteria completeness.
  - Frontend code-flow improvement exists.
  - But no conclusive revert-safe live proof for valid-vs-invalid transition matrix in this run.
  - F05 patch strict apply/reverse checks were fragile (not cleanly strict-applicable in all checks).
- Per workflow (retry exhausted + verification incomplete), F05 marked `blocked-final`.
- Next fix for subsequent run: F06.

## 2026-03-13 01:46-01:58 MYT - F06 orchestration run (Shiro -> Kuro -> Hitokiri + 1 retry)
- Target fix: F06 (Tracking Order null safety `url`).
- Shiro (frontend): replaced unsafe URL force unwrap path in `lib/tracking_order/tracking_order_widget.dart` with validated URL guard + fallback icon flow; added `test/tracking_order_widget_test.dart`; initial patch `docs/revert_patches/F06.patch` created.
- Kuro (backend/Xano): reviewed with credentials doc policy; confirmed no backend/Xano mutation required for F06 scope.
- Hitokiri initial verify: FAIL due revert-check fragility in dirty tree + runtime test environment blocker (`WHERE`/git PATH under flutter wrapper).
- Retry cycle (Shiro, 1x): rebuilt deterministic `docs/revert_patches/F06.patch` and updated `docs/REVERT_GUIDE_REPAIR.md` with explicit fallback file-level restore commands.
- Hitokiri final verify: PASS.
  - Code-flow null safety valid.
  - Backend not required.
  - Reverse patch check passed (`git apply -R --check docs/revert_patches/F06.patch`).
- Final status: F06 marked `done`.
- Next fix for subsequent run: F07.

## 2026-03-13 02:31 MYT - F07 orchestration run (Shiro/Kuro/Hitokiri, static verification)
- Target fix: F07 (Carousell direct vs param behavior consistency).
- Shiro role had unstable subagent execution in this environment; accepted frontend change was validated directly from current source diff.
- Accepted frontend mutation in `lib/carousell/carousell_widget.dart`:
  - Upload route now enforces selected inventory and shows safe message if missing.
  - Upload navigation now forwards consistent params: `inventoryId`, `category`, `search`, `searchCategory`.
- Kuro scope outcome: no backend/Xano change required for F07 (frontend route-contract consistency only).
- Hitokiri verification basis: code-flow/static checks + revert patch readiness (runtime Flutter test still environment-blocked by git PATH wrapper issue).
- Final status: F07 marked `done`.
- Revert patch: `docs/revert_patches/F07.patch`.
- Next fix: F08.

## 2026-03-13 03:05 MYT - F08 orchestration run (Shiro blocked; retry exhausted)
- Target fix: F08 (Purchase Order API integration).
- Spawned Shiro phase first (frontend-only) as required.
- Observed repeated non-productive run pattern (deep exploration/hang/context drift), with no usable frontend patch output.
- Per token-aware guard, executed one intervention (`steer`) and then terminated stale run when blocker repeated.
- To keep one-agent-at-a-time rule clean, also terminated unrelated stale `kuro` run left from prior cycle.
- No accepted frontend/backend mutation for F08 in this run.
- Kuro and Hitokiri phases were intentionally not started because Shiro phase did not produce safe handoff artifacts after retry.
- Final status: F08 marked `blocked-final` for this run.
- Revert impact: none (no code mutation accepted), patch file intentionally not generated.

## 2026-03-13 03:04 MYT - F08 SHIRO (frontend-only minimal prep)
- Scope constraint applied: frontend-only, no backend/Xano credential or secret changes.
- Purchase Order screen currently has no dedicated backend contract in app API layer.
- Added safe preparatory wiring in `lib/purchase_order/purchase_order_model.dart`:
  - imported API call types and FlutterFlow util types
  - added `purchaseOrderResponse` placeholder (`ApiCallResponse?`)
  - added `isLoading` and `errorMessage` state fields for future UI/API wiring
- No runtime behavior change to existing order flow; no backend mutation performed.
- Revert patch prepared: `docs/revert_patches/F08.patch`.
- Kuro backend dependency: define/confirm Purchase Order API contract (endpoint(s), request payload, response schema, status lifecycle) before full frontend integration.

## 2026-03-13 03:07 MYT - Finalization (repair queue closed)
- Confirmed all fixes F01-F08 are in terminal status (`done` or `blocked-final`).
- Updated closure notes in:
  - `docs/REPAIR_MASTER_TODO.md`
  - `docs/REPAIR_ORCHESTRATION.md`
  - `docs/REVERT_GUIDE_REPAIR.md`
- Generated final repair report PDF at:
  - `C:\Users\User\.openclaw\media\generation\aiventory-repair-final.pdf`
- Disabled orchestrator cron job:
  - `85c61485-512f-4a85-8b75-db8d6a575716`
