# Aiventory Comprehensive Audit - Master Report

Last updated: 2026-03-12 (MYT, B2 completed)
Audit mode: CODE-FIRST (source and contract reasoning only)

## Executive baseline (Phase 1 complete)

Phase 1 scope completed:
- Full page/route inventory established
- API surface inventory established
- Shared/global state dependency map established
- Initial risk baseline established
- Deep-audit queue prepared for iterative cron runs

## Evidence base used in Phase 1

Core architecture and contracts reviewed from:
- `lib/flutter_flow/nav/nav.dart`
- `lib/index.dart`
- `lib/main.dart`
- `lib/backend/api_requests/api_calls.dart`
- `lib/app_state.dart`
- key workflow files under `lib/*/*_widget.dart` and `lib/*/*_model.dart`

## Baseline findings (pre-deep-dive)

### High severity candidates
1) Hardcoded payload field likely to break business correctness
- `CarousellPostCall` hardcodes `"expiry_date": "2025-05-05"`.
- Risk: production data inconsistency, expiry logic corruption.
- Ref: `lib/backend/api_requests/api_calls.dart` (CarousellPostCall)

2) Potential split-brain success in stock receiving flow
- Stock movement and order status update are executed concurrently (`Future.wait`).
- Risk: movement succeeds while order status fails (or vice versa), causing operational mismatch.
- Ref: `lib/stock_in/stock_in_widget.dart` (button submit sequence)

### Medium severity candidates
3) Branch list mutation pattern may duplicate synthetic option
- Branch list bootstrap appends `All Dentabay` after list assignment.
- Risk: repeated bootstrap may duplicate synthetic entry if bootstrap reruns in-session.
- Ref: `lib/login/login_model.dart`

4) Inventory cache update can duplicate entries
- Edit inventory success path appends updated inventory to `allInventory`.
- Risk: stale duplicates; downstream dropdown/search mismatch.
- Ref: `lib/edit_inventory/edit_inventory_widget.dart`, `lib/app_state.dart`

5) Heavy reliance on nullable cross-route params
- Many pages consume nullable params for write-path actions.
- Risk: null/invalid transition payload causing silent failures or partial writes.
- Ref: `lib/flutter_flow/nav/nav.dart`, multiple page widgets

## Audit coverage status

- Phase 1: COMPLETE
- Phase 2+: IN PROGRESS (A1-A4, B1-B2 completed)

## Deep audit run log

### Run: A1 - Login submit contract and token extraction correctness (2026-03-12 MYT)

#### Finding A1-F1 (High): forced null-crash risk on token extraction
- Code force-unwraps token from login response:
  - `FFAppState().token = AuthGroup.loginCall.token(... )!`
- If backend success body shape changes or returns success without `authToken`, app throws before recovery path.
- Evidence:
  - `lib/login/login_widget.dart:507`
  - `lib/backend/api_requests/api_calls.dart:188` (`$.authToken` extractor)
- Production impact: immediate crash on sign-in for affected responses.
- Recommended fix (priority P1):
  - Guard token null/empty before assignment.
  - If invalid, show controlled auth error and do not call `authMe`.

#### Finding A1-F2 (Medium): no client-side required validation before login submit
- Email/password validators are declared but not implemented in model; submit always calls API with raw text.
- Evidence:
  - `lib/login/login_model.dart:20,25` (validator fields only)
  - `lib/login/login_widget.dart:496-502` (direct API call)
- Production impact: avoidable bad requests, noisier auth failures, weaker UX feedback.
- Recommended fix (P2):
  - Add explicit required checks (trimmed non-empty) and email format guard before API call.

#### Finding A1-F3 (Medium): login request uses multipart for credentials
- `AuthGroup.loginCall` sends email/password with `BodyType.MULTIPART`.
- Evidence:
  - `lib/backend/api_requests/api_calls.dart:176`
- Risk: backend contract drift risk if auth endpoint expects JSON/form-url-encoded only; harder debugging/interoperability.
- Recommendation (P2): confirm backend contract and align body type intentionally (documented JSON/form-data choice).

#### Finding A1-F4 (Low/Observation): loading-state guard prevents duplicate submit races
- `_runWithLoading` prevents re-entrancy while API is in flight.
- Evidence:
  - `lib/login/login_widget.dart:26-40,494`
- Positive impact: avoids accidental double login submits.

### Run: A2 - `authMe` bootstrap sequencing and failure handling (2026-03-12 MYT)

#### Finding A2-F1 (High): stale-token loop risk due missing token invalidation on `authMe` failure
- Startup auto-runs `authMe` whenever persisted token is non-empty.
- On `authMe` failure path, code only shows dialog and does not clear token or force relogin state reset.
- This can produce repeated failing bootstrap attempts on every login-page load/app relaunch with the same invalid token.
- Evidence:
  - `lib/login/login_widget.dart:53-55` (auto-bootstrap condition)
  - `lib/login/login_model.dart:183-202` (failure path dialog-only)
- Recommended fix (P1): clear `FFAppState().token` (and relevant auth-scoped state) when `authMe` fails with unauthorized/invalid-session semantics.

#### Finding A2-F2 (High): bootstrap allows dashboard navigation before all preload dependencies are confirmed
- `authMe` launches three preload calls in `Future.wait`, but navigation is triggered inside the branch-list future before inventory/category completion status is resolved.
- If inventory/category fails, user can land on dashboard with partial/uninitialized caches and late error dialogs.
- Evidence:
  - `lib/login/login_model.dart:56-182` (`Future.wait` with three concurrent branches)
  - `lib/login/login_model.dart:125` (`context.goNamed(...)` inside branch preload block)
- Recommended fix (P1): remove in-branch navigation side effect; navigate once after all required preloads succeed (or enforce explicit degraded-mode policy).

#### Finding A2-F3 (Medium): nullable-success defaulting (`?? true`) weakens failure gating semantics
- Critical API success checks use `(response?.succeeded ?? true)` across auth/bootstrap calls.
- If call result ever becomes null (unexpected path), condition treats it as success and continues state mutation flow.
- Evidence:
  - `lib/login/login_model.dart:54,60,92,151`
  - `lib/login/login_widget.dart:504`
- Recommended fix (P2): default null to failure (`?? false`) and add explicit null/exception guardrail handling.

#### Finding A2-F4 (Low/Observation): no explicit exception guard around parallel bootstrap calls
- `Future.wait` body has per-call failure dialogs for non-success responses, but thrown exceptions are not wrapped in top-level try/catch in `authMe`.
- Impact depends on `ApiManager` behavior; unhandled exceptions could break loading-state flow without controlled user feedback.
- Evidence:
  - `lib/login/login_model.dart:44-203`
- Recommendation (P3): wrap `authMe` action block in structured try/catch and map transport exceptions to controlled recovery path.

### Run: A3 - Branch list bootstrap and duplicate/default-branch consistency (2026-03-12 MYT)

#### Finding A3-F1 (High): fallback-to-zero branch selection can silently widen scope to synthetic "All Dentabay"
- Branch resolution is string-label based and defaults to `0` if `user.branch` is absent or mismatched.
- Bootstrap also appends synthetic branch `{id:0, label:'All Dentabay'}`.
- Combined behavior can silently convert unknown/mistyped user branch into global branch id `0` scope.
- Evidence:
  - `lib/login/login_model.dart:100-103` (synthetic branch insertion)
  - `lib/login/login_model.dart:105-122` (label match + `valueOrDefault(..., 0)` for `branchId`/`branchIdUser`)
- Impact: branch-scoped requests may execute under broader/default context instead of failing closed.
- Recommended fix (P1): treat unmatched `user.branch` as explicit auth/bootstrap failure (force reselect/relogin) rather than fallback id `0`.

#### Finding A3-F2 (Medium): branch identity matching relies on mutable display label, not stable id
- Current mapping searches `branchLists` by `label == user.branch` and extracts first match.
- Evidence:
  - `lib/login/login_model.dart:107-120`
- Risk: renamed/duplicated labels or whitespace/casing drift resolves to wrong branch or `0` fallback.
- Recommended fix (P2): persist and map branch by backend branch id (or immutable code), using label only for display.

#### Finding A3-F3 (Medium): branch cache persistence can keep synthetic/default branch across sessions without validity recheck
- `branch`, `branchId`, and `branchLists` are persisted in SharedPreferences and restored on startup.
- Evidence:
  - `lib/app_state.dart:41-45` (`ff_branch`, `ff_branchId` restore)
  - `lib/app_state.dart:63-70` + `275-287` (`ff_branchLists` restore and mutation persist)
- Risk: stale cached branch metadata survives until next successful bootstrap; downstream pages can consume outdated branch context.
- Recommended fix (P2): invalidate persisted branch context on auth bootstrap start and repopulate only after verified branch mapping.

#### Finding A3-F4 (Low/Observation): current bootstrap path is mostly idempotent for synthetic option insertion
- Branch list is replaced from API before synthetic insertion, limiting duplicate accumulation within the same successful pass.
- Evidence:
  - `lib/login/login_model.dart:93-100` (overwrite from API)
  - `lib/login/login_model.dart:100-103` (single append after overwrite)
- Note: idempotency still depends on API never returning a real branch with id/label collision (`0`, `All Dentabay`).

### Run: A4 - Inventory category bootstrap and downstream dropdown dependency integrity (2026-03-12 MYT)

#### Finding A4-F1 (High): dashboard navigation can happen before category bootstrap finalizes
- Category preload runs in parallel during `authMe`, but dashboard navigation is triggered inside the branch preload branch, not after all bootstrap dependencies are confirmed.
- This allows category-dependent pages (Order/Edit/Upload/Carousell chips) to initialize against stale persisted category cache or empty list transiently.
- Evidence:
  - `lib/login/login_model.dart:56-57,125,148-160`
  - category consumers: `lib/order/order_widget.dart:279-282`, `lib/edit_inventory/edit_inventory_widget.dart:239-242`, `lib/upload_carousell/upload_carousell_widget.dart:187-190`, `lib/carousell/carousell_widget.dart:426-429`
- Recommended fix (P1): move navigation side effect to a single post-`Future.wait` success gate and require category preload success (or explicit degraded-mode contract).

#### Finding A4-F2 (Medium): stale category cache can survive bootstrap failures and continue driving dropdown/chip options
- `inventoryCategoryLists` is persisted and restored from preferences on startup.
- On category fetch failure, bootstrap only shows dialog and does not invalidate stale cached categories.
- Evidence:
  - restore path: `lib/app_state.dart:47-60`
  - failure path: `lib/login/login_model.dart:161-170`
- Impact: users can submit/filter with outdated categories that no longer match backend-allowed values.
- Recommended fix (P2): clear or version-check persisted category cache when category bootstrap fails; force refresh before category-dependent write flows.

#### Finding A4-F3 (Medium): category option list is not normalized (blank/duplicate values can propagate)
- Category struct getter returns empty string when API field is null.
- Consumers map categories directly to UI options without filtering/deduplication.
- Carousell GET uses selected category directly as query param.
- Evidence:
  - `lib/backend/schema/structs/inventory_category_struct.dart:35-38`
  - direct option mapping: `lib/order/order_widget.dart:279-282`, `lib/edit_inventory/edit_inventory_widget.dart:239-242`, `lib/upload_carousell/upload_carousell_widget.dart:187-190`, `lib/carousell/carousell_widget.dart:426-429`
  - query usage: `lib/carousell/carousell_widget.dart:438-440`, `lib/backend/api_requests/api_calls.dart:689-701`
- Recommended fix (P2): normalize category source (`trim`, reject empty, distinct by normalized key) before writing to app state and before building dropdown/chip options.

### Run: B1 - Persisted state load safety and corruption handling (2026-03-12 MYT)

#### Finding B1-F1 (High): partial persisted-auth restore can produce unsafe mixed state without fail-closed reset
- Startup restores `token`, `branch`, and `branchId` from SharedPreferences, but `branchIdUser` is not persisted/restored.
- On cold start, app can hold persisted auth/branch identity while user-branch scope (`branchIdUser`) resets to default `0` until fresh bootstrap finishes.
- Evidence:
  - persisted restore keys: `lib/app_state.dart:23,41,44`
  - non-persisted `branchIdUser`: `lib/app_state.dart:507-511`
  - restore invoked before app runs: `lib/main.dart:20-23`
- Impact: transient scope mismatch risk for flows reading `branchIdUser` early; default `0` is a broad-scope sentinel elsewhere in codebase.
- Recommended fix (P1): treat auth/branch context as an atomic persisted bundle (include `branchIdUser` or derive it deterministically post-restore), and block write-path actions until auth scope is fully validated.

#### Finding B1-F2 (Medium): decode corruption handling is tolerant but can silently drop bad entries and continue with partial datasets
- Persisted list decode catches per-entry JSON errors and removes invalid items via `.withoutNulls`, then continues with surviving entries.
- Evidence:
  - inventory decode path: `lib/app_state.dart:26-38`
  - category decode path: `lib/app_state.dart:47-60`
  - branch decode path: `lib/app_state.dart:63-75`
- Impact: app may run with partially truncated cached lists without explicit invalidation signal, producing hard-to-trace stale/partial UI options.
- Recommended fix (P2): add dataset-level integrity checks (e.g., clear whole key when any decode error occurs, or record corruption flag and force refetch before use).

#### Finding B1-F3 (Medium): `_safeInit` swallows field-level initialization exceptions without telemetry
- `_safeInit` catches all exceptions and ignores them (`catch (_) {}`), eliminating observability for critical restore failures.
- Evidence:
  - `_safeInit` implementation: `lib/app_state.dart:534-538`
  - used for every persisted restore in `initializePersistedState`: `lib/app_state.dart:22-76`
- Impact: corrupted preference shape or unexpected type mismatch can fail silently, leaving mixed defaults/persisted values with no structured logs.
- Recommended fix (P2): log structured error context per key (or accumulate restore diagnostics) and trigger controlled cache reset for critical keys.

#### Finding B1-F4 (Low/Observation): no persisted schema/version guard for app-state migration
- Persisted keys are loaded directly with no version stamp or migration branch.
- Evidence:
  - direct key loads in `initializePersistedState`: `lib/app_state.dart:20-76`
- Impact: future model/key changes risk silent fallback or partial decode behavior rather than explicit one-time migration.
- Recommended fix (P3): introduce `ff_state_version` and migration/reset strategy.

### Run: B2 - `allInventory` lifecycle integrity (dedup/update policy across edit/search flows) (2026-03-12 MYT)

#### Finding B2-F1 (High): edit success path appends updated inventory instead of replacing by stable id
- Both edit submit branches call `FFAppState().addToAllInventory(...)` after successful `editInventoryCall` response.
- No id-based replacement/removal is performed before append, so repeated edits for the same item produce duplicate rows in cache.
- Evidence:
  - `lib/edit_inventory/edit_inventory_widget.dart:2199-2203`
  - `lib/edit_inventory/edit_inventory_widget.dart:2311-2315`
  - append mutator in `lib/app_state.dart:156-159`
- Impact: duplicated dropdown/search options and divergent item metadata by same `id` across pages consuming shared cache.
- Recommended fix (P1): replace append with deterministic upsert (`id` key): find existing index and `updateAllInventoryAtIndex`, else insert.

#### Finding B2-F2 (High): `allInventory` mutators perform in-place list edits without `notifyListeners`
- `addToAllInventory/remove/update/insert` mutate the underlying list and persist to prefs, but never call `notifyListeners`.
- `FFAppState.update(...)` is the only built-in notifier wrapper, and these mutators do not use it.
- Evidence:
  - notifier wrapper: `lib/app_state.dart:78-81`
  - non-notifying mutators: `lib/app_state.dart:156-186`
- Impact: pages relying on `context.watch<FFAppState>()` can miss cache changes unless local `setState` happens in same widget, causing cross-page stale state.
- Recommended fix (P1): wrap list mutations in `update(() { ... })` or call `notifyListeners()` after each mutation.

#### Finding B2-F3 (Medium): login bootstrap full assignment can overwrite newer local edits with stale server snapshot
- On auth bootstrap success, inventory cache is fully replaced from `/inventory` response (`FFAppState().allInventory = ...`).
- Any optimistic/local cache mutation from edit flows that is not reflected in backend response timing will be discarded wholesale.
- Evidence:
  - assignment path: `lib/login/login_model.dart:58-67`
  - setter path: `lib/app_state.dart:150-153`
- Impact: non-monotonic cache behavior (duplicate after edit, then sudden replacement on relogin/startup), hard to reason about consistency.
- Recommended fix (P2): enforce a single coherence strategy (server-authoritative with immediate refetch after edit, or reliable local upsert plus versioned refresh policy).

#### Finding B2-F4 (Medium): downstream operational pages trust raw `allInventory` list without canonicalization
- Order and Upload Carousell pages seed item dropdown options directly from `FFAppState().allInventory`.
- No deduplication/sorting/canonical id merge occurs before presenting or selecting items.
- Evidence:
  - Order seed: `lib/order/order_widget.dart:48`
  - Upload Carousell seed: `lib/upload_carousell/upload_carousell_widget.dart:54`
- Impact: duplicate cache entries surface directly in user selection controls and can lead to incorrect item selection.
- Recommended fix (P2): canonicalize inventory options at read boundary (`distinctBy(id)`) until write-side upsert is corrected.

## Next target

B3 - Branch context propagation (`branch`, `branchId`, `branchIdUser`) across all payload builders:
- Enumerate every payload builder using branch context fields
- Verify each page uses the correct branch id variant (`branchId` vs `branchIdUser`) for role/scope
- Trace cross-page parameter handoff where branch context is recomputed or overridden
- Validate failure/empty-state handling when branch mapping is unresolved

## Blockers

No code-access blocker.
Operational blocker: cron self-reschedule action (`cron.update`) is not available as a callable tool in this runtime; scheduling instruction must be handled by orchestrator.
