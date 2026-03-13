# To Do List - Improvement Audit (Aiventory)

## Phase 1 - Test, Study, Discuss Architecture (Current Priority)
- [ ] Peta architecture app end-to-end (UI -> API -> DB)
- [ ] Senarai semua API yang digunakan app semasa
- [ ] Klasifikasi flow ikut role:
  - [ ] Staff HQ
  - [ ] Assistant Manager branch
  - [ ] DSA/Staff branch
- [ ] Semak flow order barang (create, receive, movement)
- [ ] Semak flow inventory keluar
- [ ] Semak consistency data inventory listing vs movement
- [ ] Semak error handling + edge cases frontend
- [ ] Semak API validation + response consistency
- [ ] Cadang improvement UX utama (quick wins)
- [ ] Cadang improvement backend tanpa sentuh API live (API baru)
- [ ] Document test data lifecycle + revert proof

## Recurring Task Rule
Setiap kali jumpa idea/risiko baru, tambah item baru di bawah backlog.

## Backlog (Auto-growing)
- [ ] Investigate blank white screen on Flutter web first paint (bootstrap/render blocker).
- [ ] Confirm intended platform support (web-only vs web+windows) and align README/test plan.
- [ ] Investigate why Flutter web runtime fails to mount `flt-glass-pane`/canvas despite successful DDC script load (possible pre-runApp init failure).
- [ ] Add debug-only startup instrumentation (`FlutterError.onError`, `PlatformDispatcher.onError`, guarded `runApp`, init milestone logs) to isolate silent render short-circuit path.
- [ ] Validate persisted-state corruption tolerance (`ff_allInventory`, `ff_inventoryCategoryLists`, `ff_branchLists`) so startup never fails silently before first paint.
- [ ] Document explicit platform support matrix in README + test plan (current repo indicates no Windows desktop target).
- [ ] Audit all API calls for auth enforcement expectation; document which endpoints are public vs protected at Xano layer.
- [ ] Replace/retire hardcoded `expiry_date` in Carousell create flow via new versioned endpoint contract.
- [ ] Introduce idempotent movement-create API (`v2`) with mandatory checksum/idempotency key and duplicate replay-safe response.
- [ ] Document and rationalize dual Xano namespace usage (`s4bMNy03` vs `0o-ZhGP6`).
- [ ] Execute HKT-V2-MOV contract tests on mock/staging once `/v2/inventory_movement` spec is published.
- [ ] Execute HKT-V2-CAR expiry_date validation suite once `/v2/inventory_carousell` spec is published.
- [ ] Execute HKT-V2-PLT platform capability contract tests once `/v2/system/platform_support` is available.
- [ ] Define standardized API error contract (`code`, `message`, `field_errors`, `request_id`) across v2 endpoints.
- [ ] Define idempotency retention window and replay semantics in backend spec.
- [ ] Lock final status-code policy for invalid expiry_date (`400 validation_error` vs `422 invalid_expiry_date`) before HKT v2 execution starts.
- [ ] Publish checksum canonicalization reference (field order + normalization rules) for `/v2/inventory_movement`.
- [ ] Expose mock/staging v2 endpoint URLs + seed/cleanup hooks for contract execution runs.
- [ ] Fix/replace `NotifyAlertGroup.headers` contract to standard header map shape before any v2 client migration.
- [ ] Wire or remove unused `parentFolderId` in `UploadImageInventoryCall` to avoid misleading folder-routing assumptions.
- [ ] Add guardrails against quoted-null payloads (`"null"` string) in JSON request builders before v2 rollout.
- [ ] Define per-endpoint content-type contract map (JSON vs multipart) and enforce in v2 specs.
- [ ] Publish endpoint-level auth policy matrix (required/optional/public) to remove client-side ambiguity.
- [ ] Resolve `ApiManager._accessToken` reachability gap (no setter/mutator path found) before assuming centralized bearer injection in v2 clients.
- [ ] Publish proposed `GET /v2/system/auth_probe` contract + auth-source semantics to make bearer-path validation deterministic in staging.
- [ ] Isolate debug-only web blank-screen root cause (DDC/hot-reload/bootstrap timing) since profile mode renders login successfully (SHR-BOOT-005).
- [ ] Define temporary test execution policy: use Flutter web profile mode for frontend functional validation until debug-mode blank-screen is fixed.
- [ ] Execute profile-mode role-flow matrix (HQ/AM/DSA) from `HITOKIRI_PROFILE_MODE_ROLEFLOW_TEST_PLAN.md` once mock/staging credentials and seed/cleanup hooks are published.
- [ ] Fix post-login routing to be role-aware; current login flow routes all authenticated users to `DashboardHQWidget` regardless `UserStruct.role/access`.
- [ ] Add client-side login form validation gate (required/email format/password required) before API submit to reduce avoidable backend calls and generic error dialogs.
- [ ] Remove dual `autofocus: true` on login email+password fields to prevent focus-jump and keyboard accessibility friction.
- [ ] Execute HKT login parity assertion pack (`HKT-LOGIN-ROLE/FOCUS/VAL/ERR`) once role credential matrix and route-key policy are locked.
- [ ] Enforce explicit auth policy on legacy mutation endpoints (`POST /inventory_movement`, `DELETE /item_movement_delete`) and verify unauthenticated write is blocked according to policy matrix.
- [ ] Document cross-namespace mutation dependency (`create` in `api:s4bMNy03` vs `delete` in `api:0o-ZhGP6`) and decide whether to consolidate for auditability.
- [ ] Add reproducible live-test script template (pre-snapshot -> mutate -> verify -> revert -> parity-check) for Kuro/Hitokiri staging executions.
- [ ] Convert HKT-LIVE-013 auth-parity evidence into automated regression script (with hash-based pre/post parity assertion) for recurring live safety checks.
- [ ] Enforce and verify explicit auth rejection on legacy delete endpoint `DELETE /api:0o-ZhGP6/item_movement_delete` (currently succeeds without bearer in live tests).
- [ ] Implement explicit login route resolver (role/access -> routeName) and remove direct HQ hardcode in `LoginModel.authMe`.
- [ ] Add deterministic login form gate (`FormState.validate`) so invalid email/password never triggers `AuthGroup.loginCall.call`.
- [ ] Enforce single autofocus policy on login screen (email first, password via next action) for keyboard accessibility consistency.

- [ ] Harden legacy delete contract: reject mismatched coordinate tuple on DELETE /api:0o-ZhGP6/item_movement_delete (current live evidence HKT-LIVE-014B shows wrong inventory_id can still return success when movement id is valid).
- [ ] Harden legacy delete tuple enforcement: wrong branch currently still deletes successfully (KRO-LIVE-007); lock deterministic 4xx mismatch policy + backend resolver audit log fields.
- [ ] Extend live delete integrity suite to dual-field mismatch permutations after policy lock (inventory_id+branch, branch+expiry_date, inventory_id+expiry_date) to confirm hardening is complete beyond single-field probes.
- [ ] Investigate Flutter web semantics/accessibility tree exposure in profile mode (UI renders, but automation snapshot shows minimal generic nodes), then lock a deterministic a11y/testability strategy.
- [ ] Confirm dual-field mismatch hardening on legacy delete endpoint: current live evidence HKT-LIVE-015C shows (inventory_id+branch+expiry mismatch) can still return success when movement id is valid.
- [ ] Lock legacy delete error taxonomy explicitly: preserve 404 ERROR_CODE_NOT_FOUND for invalid/nonexistent inventory_movement_id, while enforcing strict 4xx for valid-id tuple mismatch branches.
- [ ] Add recurring live regression case for invalid movement_id delete reject (KRO-LIVE-008C baseline) to ensure hardening does not break not-found determinism.
- [ ] Preserve invalid-id precedence behavior after tuple-hardening rollout: invalid/nonexistent `inventory_movement_id` must stay `404 ERROR_CODE_NOT_FOUND` even when other delete tuple fields are mismatched (HKT-LIVE-016A baseline).
- [ ] Define deterministic Flutter web semantics-ready acceptance signature for profile mode (expected snapshot roles/labels for Email, Password, Sign In) so automation/a11y assertions are reproducible across runs.
- [ ] Harden delete endpoint request-shape validation so malformed JSON/empty-string payload branches return deterministic validation-class 4xx (not `500 ERROR_FATAL`) before tuple-hardening rollout.
- [ ] Publish delete request-shape error matrix (missing field, empty string, wrong type, malformed JSON) with canonical status/code/body schema and precedence against invalid-id (`404`) branch.
- [ ] Add recurring regression case for cleanup-path robustness: if primary delete transport fails, emergency fallback must still restore parity in same cycle with logged proof.
- [ ] Harden legacy delete request-shape enforcement for missing required tuple fields (live evidence KRO-LIVE-009A: missing `branch` still returns 200 success when movement id valid); lock deterministic validation-class 4xx policy.
- [ ] Harden legacy delete request-shape enforcement for missing expiry_date (live evidence HKT-LIVE-018A: missing field still returns 200 success when movement id is valid); lock deterministic validation-class 4xx behavior.
- [ ] Implement branch-aware delete failure UX in `item_movement_history_widget.dart` (not-found vs validation/request-shape vs unknown/internal) instead of single generic dialog.
- [ ] Surface backend `request_id` on delete-failure dialog + operator-facing recovery CTA (`Refresh senarai` / `Semak semula`) once error envelope is standardized.

- [ ] Harden legacy delete request-shape enforcement for missing inventory_id (live evidence HKT-LIVE-018B: missing field still returns 200 success when movement id is valid); lock deterministic validation-class 4xx behavior.
- [ ] Lock delete cleanup semantics after validation failure: if negative probe returns 400 ERROR_CODE_INPUT_ERROR, define deterministic expectation for immediate cleanup call (200 vs 404) to remove branch-order ambiguity in live automation.
- [ ] Preserve deterministic wrong-type guard on delete endpoint: non-integer inventory_id must return 400 ERROR_CODE_INPUT_ERROR with field pointer payload (param=inventory_id) across future hardening changes.
- [ ] Preserve deterministic wrong-type guard on delete endpoint for `inventory_movement_id`: non-integer movement id must return `400 ERROR_CODE_INPUT_ERROR` across hardening changes (HKT-LIVE-019A baseline).
- [ ] Implement delete-error parser in frontend (item_movement_history_widget.dart) that branches by backend code (+ param when present) instead of message-only fallback.
- [ ] Surface 
equest_id on delete-failure UI and tie CTA to error class (Refresh senarai for not-found, Semak input for validation/type errors).

- [ ] Harden legacy delete type enforcement for `branch`: wrong-type payload (e.g., numeric `branch=12345`) currently still returns `200 success` when movement id is valid (HKT-LIVE-019B); lock deterministic validation-class 4xx behavior.

- [ ] Harden legacy delete type enforcement for expiry_date: wrong-type payload (e.g., numeric expiry_date=12345) currently still returns 200 success when movement id is valid (KRO-LIVE-010B); lock deterministic validation-class 4xx behavior.
- [ ] Execute `HKT-DEL-TYPE-005` from `HITOKIRI_LEGACY_DELETE_REQUEST_SHAPE_ASSERTION_MATRIX_020.md` immediately after Kuro policy lock to confirm legacy `200` flips to deterministic validation-class 4xx with stable error envelope (`code/message/request_id/param`).
- [ ] Refactor `item_movement_history_widget.dart` delete error parser: replace `_responseMessage` message-only extraction with structured parser priority (`code` -> `param/field_errors` -> `message`) and optional `request_id` rendering for support trace.
- [ ] Harden legacy delete request-shape enforcement for missing `inventory_movement_id` (HKT-LIVE-019C showed validation reject path but matrix/error-envelope lock is still required for deterministic automation and UX parsing).
- [ ] Standardize live revert observability logging: every mutation cycle must capture cleanup status/body explicitly; if transport response is unavailable, require parity-hash + count proof plus fallback verification query.
- [ ] Harden legacy delete numeric coercion guard: reject decimal-string `inventory_id` payload (e.g. `"20.5"`) on valid-id path with deterministic validation-class 4xx; current live evidence KRO-LIVE-011B returned `200 success`.
- [ ] Harden legacy delete numeric-coercion guard for inventory_movement_id: reject decimal-string payload (e.g. "30587.5") on valid-id path with deterministic validation-class 4xx; current live evidence HKT-LIVE-019D returned `200 success`.
- [ ] Harden legacy delete numeric-coercion guard for inventory_movement_id scientific notation: reject payload like "30590e0" with deterministic validation-class 4xx; current live evidence KRO-LIVE-011C returned `200 success`.
- [ ] Harden legacy delete numeric-coercion guard for uppercase scientific notation on inventory_movement_id: reject payload like "30593E0" with deterministic validation-class 4xx; current live evidence HKT-LIVE-019G returned `200 success`.
- [ ] Add widget/integration regression test for delete-failure dialog branch mapping so known backend classes (`ERROR_CODE_NOT_FOUND`, `ERROR_CODE_INPUT_ERROR`) cannot regress to generic message-only fallback.
- [ ] Harden legacy delete numeric-coercion guard for inventory_id scientific notation: reject payload like ""22e0"" with deterministic validation-class 4xx (HKT-LIVE-019E currently returned 200 success).
- [ ] Implement branch-aware delete UX copy for numeric-coercion errors (decimal/scientific `inventory_id` and `inventory_movement_id`, including `e/E`) once Kuro locks canonical `ERROR_CODE_INPUT_ERROR` envelope with `param` + `request_id`.
- [ ] Harden legacy delete numeric-coercion guard for inventory_id uppercase scientific notation: reject payload like "26E0" with deterministic validation-class 4xx (HKT-LIVE-019H currently returned 200 success).
- [ ] Harden legacy delete whitespace-coercion guard for inventory_movement_id: reject payload with leading/trailing whitespace (e.g. "30597\t", " 30597") using deterministic validation-class 4xx; current live evidence KRO-LIVE-011D returned 200 success.
- [ ] Harden legacy delete whitespace-coercion guard for inventory_movement_id trailing-space variant: reject payload like "<id> " with deterministic validation-class 4xx; current live evidence HKT-LIVE-019I returned 200 success.
- [ ] Implement branch-aware delete-failure UX copy for whitespace-coercion movement-id variants (`"<id>\t"`, `"<id> "`) under validation class, including param-aware guidance and `request_id` slot.

- [ ] Harden legacy delete whitespace-coercion guard for inventory_movement_id leading-space variant: reject payload like " <id>" with deterministic validation-class 4xx; current live evidence HKT-LIVE-019J returned 200 success.
- [ ] Harden legacy delete whitespace-coercion guard for inventory_id trailing-tab variant: reject payload like "33\t" with deterministic validation-class 4xx; current live evidence KRO-LIVE-011E returned 200 success.
- [ ] Extend inventory_id whitespace-coercion matrix to leading/trailing space variants after policy lock, with mandatory same-cycle parity proof per branch.
- [ ] Harden legacy delete whitespace-coercion guard for inventory_id leading-space variant: reject payload like " <id>" with deterministic validation-class 4xx; current live evidence HKT-LIVE-019K returned 200 success.
- [ ] Extend inventory_id whitespace-coercion matrix to trailing-space variant ("<id> ") after policy lock, with mandatory same-cycle parity proof.
- [ ] Implement branch-aware delete-failure UX copy for inventory_id whitespace-coercion variants (`"<id>\t"`, `" <id>"`, `"<id> "`) under validation class, including param-aware guidance and `request_id` slot.
- [ ] Eliminate non-interactive delete probe observability gap: ensure live test harness records deterministic probe status/body (avoid `NO_RESPONSE` prompt path in PowerShell NonInteractive mode) before asserting branch outcomes.
- [ ] Harden legacy delete whitespace-coercion guard for inventory_movement_id leading-tab variant: reject payload like '\t<id>' with deterministic validation-class 4xx; current live evidence KRO-LIVE-011F returned 200 success.
- [ ] Re-baseline legacy delete live-test matrix on current configured host (xqoc-ewo0-x3u2): latest HKT-LIVE-019M returned 400 ERROR_CODE_INPUT_ERROR with payload.param=field_value for both probe and cleanup, indicating contract/request-shape drift from prior permissive-oracle runs.
- [ ] Publish canonical delete request schema for current host (including meaning of payload.param=field_value) before continuing whitespace/numeric coercion branch assertions.
- [ ] Freeze current-host delete request typing contract (`item_movement_delete` on xqoc-ewo0-x3u2) and update client builder away from fully string-quoted tuple payload if backend schema now enforces typed fields (`param=field_value` signal).
- [ ] Implement branch-aware delete-failure parser for current-host validation branch (`ERROR_CODE_INPUT_ERROR` + `param=field_value`) in `item_movement_history_widget.dart`, including `request_id` surface and actionable CTA.
- [ ] Pause new live delete coercion-variant probes on current host until Kuro publishes canonical `item_movement_delete` request schema + envelope samples (to avoid false-oracle noise after `param=field_value` drift signal).
- [ ] Align `ItemMovementDeleteCall` payload typing with current-host schema once published (avoid fully string-quoted tuple if backend now enforces typed fields).

- [ ] Freeze current-host delete oracle split with live baseline: exact tuple payload remains `200 success` while coercion/invalid-shape payloads return `400 ERROR_CODE_INPUT_ERROR (param=field_value)`; use this split for Hitokiri assertions and Shiro parser mapping.
- [ ] Harden current-host delete coercion guard for inventory_id trailing-tab variant ("<id>\t") with deterministic validation-class 4xx; latest live evidence HKT-LIVE-022A returned 200 success on valid-id path.
- [ ] Validate new frontend delete parser (`SHR-UX-019`) against live current-host envelopes to confirm `request_id` rendering and `param=field_value` copy branch are triggered as expected (not fallback-only).
- [ ] Harmonize delete failure copy language (currently English in `SHR-UX-019`) with final product language policy once Kuro locks canonical envelope and branch matrix.
- [ ] Harden current-host (`xqoc-ewo0-x3u2`) inventory_id whitespace-coercion branches to deterministic validation-class 4xx; latest live evidence still permissive for `"42\t"` (HKT-LIVE-022A) and `" 43"` (HKT-LIVE-022B).
- [ ] Execute UI assertion verification pass on `SHR-UX-019` against live envelope variants (with/without `request_id`, `ERROR_CODE_NOT_FOUND`, `ERROR_CODE_INPUT_ERROR`) and record pass/fail evidence before freezing parser acceptance.
- [ ] Publish per-field current-host delete coercion matrix finalization: `inventory_id` whitespace family now fully evidenced (`"<id>\t"`, `" <id>"`, `"<id> "`) but still permissive; lock deterministic validation-class 4xx policy before tuple-resolution.
- [ ] Run UI assertion verification against `SHR-UX-019` using mixed current-host outcomes (validation reject vs permissive delete) to ensure dialog copy/CTA/request_id behavior remains branch-correct.
- [ ] Harden current-host delete coercion guard for inventory_id decimal-string payloads (e.g. "45.0") with deterministic validation-class 4xx; latest live evidence HKT-LIVE-022C returned 200 success.
- [ ] Publish and lock current-host delete error-envelope examples (with/without request_id + param variants) so SHR-UX-019/020 UI assertions can be frozen deterministically.

- [ ] Harden current-host delete coercion guard for inventory_id scientific-notation payloads (e.g. "46e0" / "46E0") with deterministic validation-class 4xx; latest live evidence KRO-LIVE-012E returned 200 success.
- [ ] Harden current-host delete coercion guard for inventory_id uppercase scientific-notation payloads (e.g. "48E0") with deterministic validation-class 4xx; latest live evidence HKT-LIVE-022D returned 200 success.
- [ ] Publish frozen current-host delete fixture bundle (JSON samples) for parser regression: not_found + input_error (inventory_id / inventory_movement_id / field_value), each with and without `request_id`.
- [ ] Harden current-host delete coercion guard for inventory_movement_id trailing-space payloads (e.g. "<id> ") with deterministic validation-class 4xx; latest live evidence HKT-LIVE-022E returned 200 success.
- [ ] Publish per-field current-host movement-id whitespace precedence matrix (\t<id>,  <id>, <id> , <id>\t) to remove split-oracle ambiguity between permissive and validation branches.
- [ ] Harden current-host delete coercion guard for inventory_movement_id trailing-tab payloads (e.g. "<id>\t") with deterministic validation-class 4xx; latest live evidence KRO-LIVE-012F returned 200 success.
- [ ] Standardize current-host live test transport harness for Windows PowerShell NonInteractive mode (avoid unsupported flags like -SkipHttpErrorCheck) and require deterministic probe/cleanup status capture before asserting oracle branches.
- [x] Harmonize delete-flow operator copy in item_movement_history_widget.dart with locked language policy (BM vs bilingual), including branch titles/CTA and Request ID label consistency after Kuro fixture/policy lock. (Completed by Shiro in SHR-UX-023, 2026-03-12 03:26)
- [ ] Resolve current-host `HTTP 500` transport ambiguity on leading-space `inventory_movement_id` probe (`HKT-LIVE-022F-R1`): lock deterministic capture path before asserting branch outcome.
- [ ] Publish/standardize Windows NonInteractive delete probe harness (raw status/body/request_id capture) to eliminate false 500/no-response artifacts in live mutation cycles.

- [ ] Harden current-host delete coercion guard for inventory_movement_id leading-space payload (" <id>"): latest live evidence KRO-LIVE-012G returned HTTP 200 success; enforce deterministic validation-class 4xx and freeze canonical envelope fixture.
- [ ] Re-enable blocked branch execution lane for Hitokiri movement-id leading-space case (HKT-LIVE-022F) now that transport-safe capture path is validated by KRO-LIVE-012G.

- [ ] Add transport harness guardrail to assert HTTP method (DELETE) for item_movement_delete probes before execution, preventing false 404/residual-risk cycles from wrong-verb calls.
- [ ] Harden current-host delete coercion guard for inventory_movement_id leading-tab payload (e.g. "\t<id>") with deterministic validation-class 4xx; latest live evidence HKT-LIVE-022G returned 200 success.
- [x] Add transport harness guardrail to assert HTTP method (DELETE) for item_movement_delete probes before execution, preventing false 404/residual-risk cycles from wrong-verb calls. (Validated live by KRO-LIVE-013A-R1, 2026-03-12 03:36, wrong-verb POST=404 + mid-state row persisted + DELETE cleanup=200 + parity=true)
- [ ] Publish reusable Windows NonInteractive delete harness snippet/script (method assert + deterministic status/body capture + parity helper) in docs/reports for Kuro/Hitokiri shared use.
- [ ] Fix/standardize PowerShell inline JSON payload escaping for live create/delete probes (`tmp_hkt022h` showed create path can fail with `500 ERROR_FATAL` before mutation); prefer file-backed payload transport to avoid false branch signals.
- [x] Harmonize remaining Item Movement History screen copy to BM (header/help text/load-error fallback/empty-state/pagination/swipe action) to close mixed-language UX debt after SHR-UX-023. (Completed by Shiro in SHR-UX-026, 2026-03-13 04:06)
- [ ] Harden current-host delete coercion guard for inventory_movement_id decimal-string payloads (e.g. "<id>.0"): latest live evidence HKT-LIVE-022H-R1 returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Harden current-host delete coercion guard for inventory_id leading-tab payloads (e.g. "\t<id>") with deterministic validation-class 4xx; latest live evidence KRO-LIVE-013B returned 200 success.
- [ ] Harden current-host delete coercion guard for inventory_movement_id lowercase scientific-notation payloads (e.g. "<id>e0"); latest live evidence HKT-LIVE-022I returned 200 success on valid-id path; lock deterministic validation-class 4xx + canonical error envelope.
- [ ] Extend current-host movement-id scientific-coercion matrix to uppercase variant ("<id>E0") after policy lock, with mandatory same-cycle parity proof.
- [x] Harmonize remaining Item Movement History English labels to BM (`Item Movement History`, `Branch/Expiry/All`, helper text, `Retry`, empty-state, pagination `Previous/Next`, swipe `Delete`, load-error fallback) to close SHR-UX-025 mixed-language discrepancy. (Completed by Shiro in SHR-UX-026, 2026-03-13 04:06)
- [x] Add deterministic UI assertion for language consistency on Item Movement History (header/help/error/empty/pagination/swipe labels) and block closure until zero English residue after policy lock. (Hitokiri `HKT-DESIGN-023`, static assertion pass + profile-lane sanity, 2026-03-12 04:10)
- [ ] Harden current-host delete coercion guard for inventory_movement_id uppercase scientific-notation payloads (e.g. "<id>E0"): latest live evidence HKT-LIVE-022J returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Mark movement-id scientific coercion evidence set as matrix-complete on current host (`"<id>e0"` + `"<id>E0"`) and freeze split-oracle closure rules (`probe 200 + cleanup 404 + parity=true`) until backend hardening flips behavior.
- [ ] Harden current-host delete coercion guard for inventory_id leading-carriage-return payloads (e.g. "\r<id>"): latest live evidence KRO-LIVE-013C returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Mark inventory_id control-character coercion matrix as explicitly tracked (`space/tab/CR`) with split-oracle closure rule (`probe 200 + cleanup 404 + parity=true`) until backend hardening flips behavior.
- [ ] Harden current-host delete coercion guard for inventory_movement_id leading-carriage-return payloads (e.g. "\r<id>"): latest live evidence HKT-LIVE-022K returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Harden current-host delete coercion guard for inventory_movement_id trailing-carriage-return payloads (e.g. "<id>\r"): latest live evidence KRO-LIVE-013D returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Mark movement-id control-character coercion matrix as explicitly tracked (space/tab/CR + decimal/scientific families) with split-oracle closure rule (`probe 200 + cleanup 404 + parity=true`) until backend hardening flips behavior.
- [ ] Add automated widget/string-regression test (CI-safe) for Item Movement History BM copy keys to prevent future EN label drift after SHR-UX-026/HKT-DESIGN-023 baseline.
- [x] Consolidate current-host coercion live evidence into single Hitokiri matrix sync artifact for deterministic split-oracle tracking (`docs/reports/HITOKIRI_CURRENT_HOST_COERCION_MATRIX_SYNC_024.md`, 2026-03-13 04:15).
- [ ] Publish frozen per-field current-host coercion policy + canonical reject fixture bundle (`ERROR_CODE_INPUT_ERROR`, stable `param`, request_id optionality) to unblock deterministic resume of Hitokiri live assertion wave.
- [ ] Resume live coercion assertions only after Kuro fixture lock; enforce split-oracle closure rubric in every case (`probe 200 + cleanup 404 + parity true => residue CLOSED, integrity OPEN`).
- [ ] Add Shiro UI assertion case for LF control-character movement-id coercion branches (`"\n<id>"`, `"<id>\n"`) to ensure permissive `200` evidence is logged as integrity risk (not validation-error UX branch) until Kuro fixture lock flips behavior.
- [x] Harmonize remaining Item Movement History pagination label to BM (Page x / y -> Halaman x / y) to fully align module copy consistency. (Completed by Shiro in SHR-UX-027, 2026-03-13 04:24)

- [ ] Harden current-host delete coercion guard for inventory_id trailing-carriage-return payloads (e.g. '<id>\r'): latest live evidence HKT-LIVE-022L returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Harden current-host delete coercion guard for inventory_movement_id leading-linefeed payloads (e.g. "\n<id>"): latest live evidence KRO-LIVE-013E returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Harden current-host delete coercion guard for inventory_movement_id trailing-linefeed payloads (e.g. "<id>\n"): latest live evidence HKT-LIVE-022M returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.

- [ ] Harden current-host delete coercion guard for inventory_id leading-linefeed payloads (e.g. "\n<id>"): latest live evidence HKT-LIVE-022N returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Harden current-host delete coercion guard for inventory_id trailing-linefeed payloads (e.g. '<id>\n'): latest live evidence KRO-LIVE-013F returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Add CI-safe copy regression checker that validates user-visible Item Movement History labels while excluding code identifiers (e.g., `canGoNext`) to avoid false-positive language drift alerts.
- [x] Freeze and publish current-host delete fixture bundle for parser acceptance close-out (`SHR-UX-029` dependency): `ERROR_CODE_NOT_FOUND` + `ERROR_CODE_INPUT_ERROR` (`param=inventory_id|inventory_movement_id|field_value`) with explicit `request_id` optionality samples. (Published in `docs/reports/KURO_CURRENT_HOST_DELETE_FIXTURE_BUNDLE_032.md`, 2026-03-13 05:22; current-host `request_id` treated optional/absent until backend hardening lock.)
- [x] Publish Hitokiri CI-safe copy regression checker design artifact with false-positive guardrails (identifier exclusion for `canGoNext`/`_nextPage`/`next_page`) and execution proof baseline. (Completed in `HKT-DESIGN-026`, 2026-03-13 04:39)
- [x] Implement and wire CI-safe copy regression checker script in pipeline per `docs/reports/HITOKIRI_COPY_REGRESSION_CHECKER_DESIGN_026.md` (Shiro owner). *(Completed by SHR-UX-034, 2026-03-12 05:30: script `scripts/check_item_movement_copy.ps1` + workflow `.github/workflows/item-movement-copy-check.yml`.)*
- [ ] Harden current-host delete coercion guard for inventory_id signed numeric-string payloads (e.g. '+<id>'): latest live evidence KRO-LIVE-013G returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.

- [ ] Harden current-host delete coercion guard for inventory_movement_id signed numeric-string payloads (e.g. "+<id>"): latest live evidence HKT-LIVE-022O returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Publish canonical signed-coercion reject fixtures on current host for both delete fields (`inventory_id="+<id>"`, `inventory_movement_id="+<id>"`) including stable `param` mapping + `request_id` optionality, then rerun Hitokiri hardening assertions from split-oracle to deterministic 4xx reject mode.
- [ ] Freeze signed-number precedence for `inventory_movement_id` on current host: `"+<id>"` branch vs `"-<id>"` branch (latest `-<id>` live evidence returned `404 ERROR_CODE_NOT_FOUND`, KRO-LIVE-013H); publish canonical fixtures + hardening target decision.
- [x] Add current-host live assertion branch for signed-negative movement-id (`"-<id>"`) and keep deterministic closure rubric (`probe 404 + cleanup 200 + parity=true => residue CLOSED`). (Hitokiri `HKT-LIVE-022P`, 2026-03-12 04:55)
- [x] Verify frontend delete-failure UX mapping routes signed-negative movement-id to not-found branch (not input-error), with conditional `ID Rujukan` rendering when envelope includes request_id. (Verified by Shiro in `SHR-UX-031`, 2026-03-12 04:57, source-level parser branch check + profile-mode sanity run.)
- [ ] Harden current-host delete coercion guard for inventory_id signed-negative numeric-string payloads (e.g. "-<id>"): latest live evidence HKT-LIVE-022Q returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Freeze signed-number precedence for inventory_id on current host ("+<id>" vs "-<id>"), publish canonical fixtures (ERROR_CODE_INPUT_ERROR + stable param + request_id optionality), then rerun Hitokiri hardening assertions in deterministic reject mode.
- [ ] Rerun signed-number live hardening assertions for both delete fields (`inventory_id`, `inventory_movement_id`; `+/-`) immediately after Kuro publishes hardened reject fixture pack, and close split-oracle tracking only on deterministic validation-class 4xx outcomes.
- [x] Wire `scripts/check_item_movement_copy.ps1` into repository CI entrypoint so BM copy regression gate runs automatically on PR/merge. (Completed by Shiro in SHR-UX-034, 2026-03-12 05:30; workflow added: `.github/workflows/item-movement-copy-check.yml` on pull_request/push/workflow_dispatch.)

- [ ] Harden current-host delete coercion guard for inventory_movement_id signed-decimal payloads (e.g. '+<id>.0'): latest live evidence HKT-LIVE-022R returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Harden current-host delete coercion guard for inventory_id signed-decimal payloads (e.g. '+<id>.0'): latest live evidence KRO-LIVE-013I returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Freeze signed-decimal precedence matrix on current host for movement-id (`+<id>.0` permissive vs `-<id>.0` not-found from HKT-LIVE-022S) and publish canonical fixture policy before hardening flip.
- [ ] Execute fixture-032 driven UI assertion pass for signed-decimal precedence branches (`inventory_movement_id=+<id>.0` -> success/permissive risk, `inventory_movement_id=-<id>.0` -> not-found) and capture deterministic dialog/CTA/request_id behavior evidence before freeze.
- [ ] Freeze signed-decimal precedence for current-host inventory_id family (`+<id>.0`, `-<id>.0`) as matrix-complete permissive baseline (HKT-LIVE-022T + KRO-LIVE-013I), then publish deterministic hardening target fixture (`400 ERROR_CODE_INPUT_ERROR`, `param=inventory_id`, request_id optionality) before next assertion flip.
- [ ] Harden current-host delete coercion guard for inventory_movement_id signed-scientific payloads (e.g. "+<id>e0"): latest live evidence KRO-LIVE-013J returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Extend signed-coercion precedence matrix for inventory_movement_id to include signed-scientific branch (`+<id>e0`) and freeze split-oracle closure rule until backend hardening flips behavior.
- [x] Extend signed-coercion precedence matrix for `inventory_movement_id` to include signed-scientific exponent variants (`+<id>e0`, `+<id>E0`) and freeze split-oracle closure rule until backend hardening flips behavior. (Completed by KRO-LIVE-013J + HKT-LIVE-022U, 2026-03-12/13, parity-verified.)
- [ ] Harden current-host delete coercion guard for `inventory_movement_id` signed-uppercase-scientific payloads (e.g. `+<id>E0`): latest live evidence HKT-LIVE-022U returned `200 success`; lock deterministic validation-class `4xx` + canonical reject fixture (`ERROR_CODE_INPUT_ERROR`, stable `param=inventory_movement_id`).
- [ ] Harden current-host delete coercion guard for inventory_id signed-scientific payloads (e.g. '+<id>e0'): latest live evidence HKT-LIVE-022V returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Harden current-host delete coercion guard for inventory_id signed-uppercase-scientific payloads (e.g. '+<id>E0'): latest live evidence HKT-LIVE-022W returned 200 success; lock deterministic validation-class 4xx + canonical error envelope fixture.
- [ ] Publish Kuro hardened fixture addendum for signed-decimal/scientific coercion rejects on current host (ERROR_CODE_INPUT_ERROR + stable per-field param mapping) and freeze 
equest_id guarantee policy (required vs optional) so Shiro parser/UI assertions can be closed deterministically. (Raised by SHR-UX-035, 2026-03-13 05:40)
- [ ] Freeze signed-scientific precedence for current-host `inventory_movement_id` (`+<id>e0/+<id>E0` permissive vs `-<id>e0` not-found from KRO-LIVE-013K) and publish canonical hardened reject target fixture before next assertion flip.
- [ ] Harden current-host delete coercion guard for inventory_id signed-negative-scientific payloads (e.g. "-<id>e0"): latest live evidence HKT-LIVE-022X returned `200 success`; lock deterministic validation-class `4xx` + canonical reject fixture (`ERROR_CODE_INPUT_ERROR`, stable `param=inventory_id`).
- [x] Add current-host live assertion branch for signed-negative-uppercase-scientific movement-id (`inventory_movement_id="-<id>E0"`) and freeze split-oracle closure proof (`probe 404 + cleanup 200 + parity=true`). (Completed by Hitokiri `HKT-LIVE-022Y`, 2026-03-13 05:51)
- [ ] Freeze signed-scientific movement-id precedence as case-insensitive for negative sign (`-<id>e0` and `-<id>E0` => `404 not_found`) in Kuro canonical fixture addendum, then use as deterministic baseline for UI/assertion packs.
- [ ] Harden current-host delete coercion guard for inventory_id signed-negative-uppercase-scientific payloads (e.g. "-<id>E0"): latest live evidence KRO-LIVE-013L returned `200 success`; lock deterministic validation-class `4xx` + canonical reject fixture (`ERROR_CODE_INPUT_ERROR`, stable `param=inventory_id`).
- [ ] Add widget-level regression test for delete error UI model branch mapping (ERROR_CODE_NOT_FOUND vs ERROR_CODE_INPUT_ERROR) including conditional ID Rujukan rendering when request_id is absent/present.

- [x] Re-run non-mutation frontend continuity gate (copy checker + parser anchors + profile lane) after fixture-032 baseline to confirm no regression before backend hardening addendum. (Completed by Shiro in SHR-UX-037, 2026-03-12 05:58; checker PASS + profile lane PASS on port 8896.)
- [x] Re-run Hitokiri non-mutation continuity gate (copy checker + parser anchors + profile lane) under split-oracle freeze while awaiting Kuro hardened reject fixtures. (Completed by Hitokiri in HKT-VERIFY-026, 2026-03-13 06:28; checker PASS + profile lane PASS on port 8924.)

- [ ] KRO-LIVE-013M: Validate hardened-fixture-033 flip on two priority branches
  - inventory_id signed-scientific (`+<id>e0` or `-<id>E0`) => expect `400 ERROR_CODE_INPUT_ERROR`, `param=inventory_id`
  - inventory_movement_id whitespace coercion (`" <id>"` or `"<id>\t"`) => expect `400 ERROR_CODE_INPUT_ERROR`, `param=inventory_movement_id`
  - Mandatory protocol: pre snapshot -> probe -> cleanup -> post parity, with immediate `[REVERT_NOTICE_TO_KURO]` if revert uncertainty occurs.

- [ ] HKT-ASSERT-FLIP-033: Convert signed/scientific + whitespace coercion assertion matrix to hardened-mode expectations (replace split-oracle expected 200/404 where fixture-033 now mandates 400).

- [x] SHR-UX-FIXTURE-033: Freeze parser acceptance set to field-specific `param` values (`inventory_id` / `inventory_movement_id`) and keep `request_id` optional rendering checks. (Completed by Shiro in SHR-UX-038, 2026-03-13 08:42; local profile lane + parser anchor re-audit PASS.)

- [ ] Re-run fixture-033 hardening verification with isolated single-branch cycles (separate create rows) to avoid probe-order deletion side effects masking branch outcome (HKT-LIVE-033A showed signed-scientific probe can pre-delete row before movement-id assertion).
- [ ] Verify signed-scientific inventory_id hardening on current host (+<id>e0/+<id>E0) flips from permissive 200 success to deterministic 400 ERROR_CODE_INPUT_ERROR with param=inventory_id; latest Hitokiri evidence HKT-LIVE-033A still permissive.
- [ ] Validate fixture-033 rollout status for isolated movement-id leading-space coercion on current host: latest `HKT-LIVE-033B` still returns `200 success` (expected hardened target `400 ERROR_CODE_INPUT_ERROR`, `param=inventory_movement_id`).
- [ ] Complete KRO-LIVE-013M priority pair: movement-id whitespace isolated verification still pending after KRO-LIVE-013M-R1 confirmed signed-scientific `inventory_id` branch remains permissive (`200 success` vs expected hardened `400`).
- [ ] Reconfirm fixture-033 hardening flip for isolated signed-negative-uppercase-scientific `inventory_id` branch (`-<id>E0`) after backend rollout; latest Hitokiri evidence `HKT-LIVE-033C` still returns `200 success` (expected `400 ERROR_CODE_INPUT_ERROR`, `param=inventory_id`).
- [ ] Publish backend rollout status/ETA for fixture-033 coercion hardening on priority branches (inventory_id signed-scientific, inventory_movement_id leading-space) because latest isolated live runs still return permissive 200 success (HKT-LIVE-033B, KRO-LIVE-013M-R1, HKT-LIVE-033C, KRO-LIVE-013M-R3).
- [ ] Enforce no-duplicate rerun gate for already-isolated fixture-033 branches until Kuro publishes rollout fingerprint/ETA; execute non-mutation continuity/design only during hold window (policy: HITOKIRI_FIXTURE033_ISOLATION_GAP_RETEST_POLICY_034).
- [ ] Verify fixture-033 rollout activation for isolated movement-id leading-space branch on current host (`inventory_movement_id=" <id>"`): latest HKT-LIVE-033D still returns `200 success` (expected hardened `400 ERROR_CODE_INPUT_ERROR`, `param=inventory_movement_id`).
- [ ] Verify fixture-033 rollout activation for isolated movement-id trailing-tab branch on current host (`inventory_movement_id="<id>\t"`): latest `KRO-LIVE-013M-R2` still returns `200 success` (expected hardened `400 ERROR_CODE_INPUT_ERROR`, `param=inventory_movement_id`).
- [ ] Verify fixture-033 rollout activation for isolated movement-id trailing-space branch on current host (`inventory_movement_id="<id> "`): latest `HKT-LIVE-033E` still returns `200 success` (expected hardened `400 ERROR_CODE_INPUT_ERROR`, `param=inventory_movement_id`).
- [x] Re-run Shiro non-mutation frontend continuity gate under fixture-033 baseline (`SHR-UX-040`): profile lane + parser anchors + BM copy anchors remain stable. (Completed 2026-03-13 06:29, port 9106)
- [ ] Verify fixture-033 rollout activation for isolated signed-uppercase-scientific inventory_id branch on current host (`inventory_id="+<id>E0"`): latest `HKT-LIVE-033F` still returns `200 success` (expected hardened `400 ERROR_CODE_INPUT_ERROR`, `param=inventory_id`).
- [x] Re-run Shiro non-mutation frontend continuity gate during fixture-033 hold window (copy checker + parser anchors + profile lane) to confirm no regression before next backend rollout signal. (Completed by Shiro in SHR-UX-041, 2026-03-13 08:58; checker PASS + profile lane PASS on port 9140.)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-027`): copy checker + parser anchors + profile lane remained stable (Completed 2026-03-13 09:06, port 9162).
- [ ] Publish fixture-033 rollout fingerprint/ETA checkpoint (backend deployment marker + expected activation window) before any new duplicate isolated live retest is allowed.
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-028`): copy checker PASS, parser anchors stable, and profile lane PASS on port 9188 (Completed 2026-03-13 09:18).
- [x] Re-run Shiro non-mutation frontend continuity gate during fixture-033 hold window (SHR-UX-042): copy checker PASS + parser anchors stable + profile lane PASS on port 9206. (Completed 2026-03-12 06:45)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-029`): copy checker PASS + parser anchors stable + profile lane PASS on port 9224. (Completed 2026-03-12 06:48)
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-035): verified rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint execution pair ready. (Completed 2026-03-12 06:51)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-030`): copy checker PASS + parser anchors stable + profile lane PASS on port 9246. (Completed 2026-03-12 06:56)
- [x] Re-run Shiro non-mutation frontend continuity gate during fixture-033 hold window (`SHR-UX-043`): copy checker PASS + parser anchors stable + profile lane PASS on port 9272. (Completed 2026-03-13 06:55)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (HKT-VERIFY-031): copy checker PASS + parser anchors stable + profile lane PASS on port 9296. (Completed 2026-03-12 06:58)
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-036): verified rollout fingerprint/ETA still unpublished in active docs, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-12 07:03)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-032`): copy checker PASS + parser anchors stable + profile lane PASS on port 9318. (Completed 2026-03-12 07:08)
- [x] Re-run Shiro non-mutation frontend continuity gate during fixture-033 hold window (`SHR-UX-044`): copy checker PASS + parser anchors stable + profile lane PASS on port 9342. (Completed 2026-03-12 07:12)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (HKT-VERIFY-033): copy checker PASS + parser anchors stable + profile lane PASS on port 9364. (Completed 2026-03-13 07:16)
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-037): reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-13 07:12)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-034`): copy checker PASS + parser anchors stable + profile lane PASS on port 9386. (Completed 2026-03-13 07:14)

- [x] Re-run Shiro non-mutation frontend continuity gate during fixture-033 hold window (`SHR-UX-045`): copy checker PASS + parser/copy anchors stable + profile lane PASS on port 9408. (Completed 2026-03-12 07:15)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (HKT-VERIFY-035): copy checker PASS + parser anchors stable + profile lane PASS on port 9426. (Completed 2026-03-12 07:17)

- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-038): reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-13 07:18)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (HKT-VERIFY-036): copy checker PASS + parser anchors stable + profile lane PASS on port 9444. (Completed 2026-03-13 07:20)
- [x] Re-run Shiro non-mutation frontend continuity gate during fixture-033 hold window (SHR-UX-046): copy checker PASS + parser anchors stable + profile lane PASS on port 9468. (Completed 2026-03-13 07:22)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-037`): copy checker PASS + parser anchors stable + profile lane PASS on port 9492. (Completed 2026-03-12 07:23)

- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-039): reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-13 07:25)

- [ ] [Kuro] Publish auditable fixture-033 rollout fingerprint/ETA checkpoint (still missing as of 2026-03-13 07:27; blocks deterministic live hardening flip verification).
- [ ] [Kuro+Hitokiri] After fingerprint publish, execute isolated priority resume pair:
  - signed-scientific inventory_id -> expect 400 ERROR_CODE_INPUT_ERROR (param=inventory_id)
  - whitespace inventory_movement_id -> expect 400 ERROR_CODE_INPUT_ERROR (param=inventory_movement_id)
- [x] [Shiro] Run scheduled non-mutation frontend continuity gate SHR-UX-047 (copy checker + profile lane + parser/copy anchors) - PASS.
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (HKT-VERIFY-038): copy checker PASS + parser anchors stable + profile lane PASS on port 9532. (Completed 2026-03-13 07:29)
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-040): reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-13 07:30)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (HKT-VERIFY-039): copy checker PASS + parser anchors stable + profile lane PASS on port 9554. (Completed 2026-03-13 07:31)

- [x] [Shiro] Run scheduled non-mutation frontend continuity gate SHR-UX-048 (copy checker + profile lane + parser/copy anchors) - PASS. (Completed 2026-03-13 07:33, port 9576)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-040`): copy checker PASS + parser anchors stable + profile lane PASS on port 9598. (Completed 2026-03-13 07:35)

- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-041): reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-13 07:37)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (HKT-VERIFY-041): copy checker PASS + parser anchors stable + profile lane PASS on port 9622. (Completed 2026-03-13 07:38)

## 2026-03-12 07:40 (SHR-UX-049)
- [x] Run BM copy regression checker (`scripts/check_item_movement_copy.ps1`) under hold window.
- [x] Reconfirm local profile-mode lane health (`flutter run -d chrome --web-port 9646 --profile --no-resident`).
- [x] Re-verify parser/BM anchors in `item_movement_history_widget.dart` (lines 202, 208, 224, 428, 634).
- [ ] Wait for Kuro fixture-033 rollout fingerprint/ETA publication before any new isolated live hardening-flip rerun.
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-042`): copy checker PASS + parser anchors stable + profile lane PASS on port 9668. (Completed 2026-03-12 07:43)

- [ ] [Kuro] Publish auditable fixture-033 rollout fingerprint/ETA checkpoint (deployment marker + activation window) to unblock deterministic isolated hardening verification.
- [ ] [Hitokiri] On checkpoint publish, resume isolated signed-scientific inventory_id verification targeting 400 ERROR_CODE_INPUT_ERROR (param=inventory_id).
- [ ] [Hitokiri] On checkpoint publish, resume isolated whitespace inventory_movement_id verification targeting 400 ERROR_CODE_INPUT_ERROR (param=inventory_movement_id).
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-043`): copy checker PASS + parser/copy anchors stable + profile lane PASS on port 9690. (Completed 2026-03-13 07:46)

## 2026-03-13 07:47 (SHR-UX-050)
- [x] Run BM copy regression checker (`scripts/check_item_movement_copy.ps1`) under hold window.
- [x] Reconfirm local profile-mode lane health (`flutter run -d chrome --web-port 9712 --profile --no-resident`).
- [x] Maintain non-mutation continuity (no API/test-data write).
- [ ] Wait for Kuro fixture-033 rollout fingerprint/ETA publication before any isolated live hardening-flip rerun.
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (HKT-VERIFY-044): copy checker PASS + parser anchors stable + profile lane PASS on port 9734. (Completed 2026-03-13 07:49)
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-043): reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-12 07:50)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-045`): copy checker PASS + profile lane PASS on port 9756; no API/test-data mutation. (Completed 2026-03-13 07:52)
- [x] [Shiro] Run scheduled non-mutation frontend continuity gate SHR-UX-051 (copy checker + profile lane + parser/copy anchors) - PASS. (Completed 2026-03-13 07:53, port 9778)
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-046`): copy checker PASS + parser/copy anchors stable + profile lane PASS on port 9800. (Completed 2026-03-13 07:55)
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-044): re-read latest docs, reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-13 07:57)
- [x] [Shiro] Run scheduled non-mutation frontend continuity gate SHR-UX-052 (copy checker + profile lane + parser/copy anchor stability) - PASS. (Completed 2026-03-13 08:00, port 9822)
- [ ] [Kuro] Publish fixture-033 rollout fingerprint/ETA checkpoint (still missing as of SHR-UX-052; deterministic live hardening-flip verification remains blocked).
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-045): re-read latest docs, reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and reconfirmed continuity checks PASS (copy checker + profile lane on port 9844). (Completed 2026-03-12 08:01 (A59ia/uala_Lu1pur))
- [ ] [Kuro] Publish fixture-033 rollout fingerprint/ETA checkpoint (still missing as of KRO-DESIGN-045; deterministic live hardening-flip verification remains blocked).

## 2026-03-13 08:07 (KRO-DESIGN-047)
- [x] Re-read latest discussion/todo/plan/test_execution_log before cycle action.
- [x] Reconfirm fixture-033 rollout fingerprint/ETA checkpoint still unpublished in active docs.
- [x] Preserve no-duplicate live rerun hold for already-isolated branches.
- [ ] [Kuro] Publish auditable fixture-033 rollout fingerprint/ETA checkpoint (deployment marker + activation window) to unblock deterministic live hardening-flip verification.
- [ ] [Hitokiri] On checkpoint publish, execute isolated whitespace inventory_movement_id verification (expect 400 ERROR_CODE_INPUT_ERROR, param=inventory_movement_id) with mandatory same-cycle parity proof.
- [ ] [Hitokiri] On checkpoint publish, execute isolated signed-scientific inventory_id verification (expect 400 ERROR_CODE_INPUT_ERROR, param=inventory_id) with mandatory same-cycle parity proof.
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-048): re-read latest docs, reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and reconfirmed continuity checks PASS (copy checker + profile lane on port 9866). (Completed 2026-03-13 08:09)
- [ ] [Kuro] Publish auditable fixture-033 rollout fingerprint/ETA checkpoint (still missing as of KRO-DESIGN-048; deterministic live hardening-flip verification remains blocked).
- [ ] [Hitokiri] On checkpoint publish, execute isolated signed/scientific inventory_id verification (expect 400 ERROR_CODE_INPUT_ERROR, param=inventory_id) with mandatory same-cycle parity proof.
- [ ] [Hitokiri] On checkpoint publish, execute isolated whitespace inventory_movement_id verification (expect 400 ERROR_CODE_INPUT_ERROR, param=inventory_movement_id) with mandatory same-cycle parity proof.
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (HKT-VERIFY-047): copy checker PASS + profile lane PASS on port 9890; no API/test-data mutation. (Completed 2026-03-13 08:11)
- [ ] [Kuro] Publish fixture-033 rollout fingerprint/ETA checkpoint (still missing as of HKT-VERIFY-047; deterministic isolated hardening-flip verification remains blocked).
- [x] [Shiro] Run scheduled non-mutation frontend continuity gate SHR-UX-053 (copy checker + profile lane + hold-policy compliance) - PASS. (Completed 2026-03-12 08:12, port 9908)
- [ ] [Kuro] Publish fixture-033 rollout fingerprint/ETA checkpoint (still missing as of SHR-UX-053; deterministic isolated hardening-flip verification remains blocked).
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-048`): copy checker PASS + profile lane PASS on port 9930; no API/test-data mutation. (Completed 2026-03-13 08:14)
- [ ] [Kuro] Publish fixture-033 rollout fingerprint/ETA checkpoint (still missing as of HKT-VERIFY-048; deterministic isolated hardening-flip verification remains blocked).
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-049): re-read latest discussion/todo/plan/test logs, reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-12 08:15)
- [ ] [Kuro] Publish auditable fixture-033 rollout fingerprint/ETA checkpoint (still missing as of KRO-DESIGN-049; deterministic isolated hardening-flip verification remains blocked).
- [x] Re-run Hitokiri non-mutation continuity gate during fixture-033 hold window (`HKT-VERIFY-049`): copy checker PASS + profile lane PASS on port 9952; no API/test-data mutation. (Completed 2026-03-12 08:17)
- [ ] [Kuro] Publish fixture-033 rollout fingerprint/ETA checkpoint (still missing as of HKT-VERIFY-049; deterministic isolated hardening-flip verification remains blocked).

## 2026-03-12 08:18 (SHR-UX-054)
- [x] [Shiro] Run scheduled non-mutation frontend continuity gate under fixture-033 hold (copy checker + profile lane).
- [x] BM copy checker PASS (`scripts/check_item_movement_copy.ps1`).
- [x] Profile lane PASS (`flutter run -d chrome --web-port 9974 --profile --no-resident` -> `Built build\\web`, `Application finished`).
- [x] No API mutation/test-data write in this cycle.
- [ ] [Kuro] Publish auditable fixture-033 rollout fingerprint/ETA checkpoint (still missing as of SHR-UX-054; deterministic isolated hardening-flip verification remains blocked).

## 2026-03-13 08:20 (HKT-VERIFY-050)
- [x] Re-read latest discussion/todo/plan/test logs before cycle action.
- [x] Run BM copy regression checker (`scripts/check_item_movement_copy.ps1`) under fixture-033 hold window.
- [x] Reconfirm local profile-mode lane health (`flutter run -d chrome --web-port 9996 --profile --no-resident`).
- [x] Maintain non-mutation continuity (no API/test-data write) while hold policy is active.
- [ ] [Kuro] Publish auditable fixture-033 rollout fingerprint/ETA checkpoint to unblock deterministic isolated hardening-flip verification.
- [x] Run Kuro non-mutation governance checkpoint during fixture-033 hold window (KRO-DESIGN-050): re-read latest docs, reconfirmed rollout fingerprint/ETA still unpublished, preserved no-duplicate live-rerun hold, and kept deterministic post-fingerprint isolated pair ready. (Completed 2026-03-13 08:21)
- [ ] [Kuro] Publish auditable fixture-033 rollout fingerprint/ETA checkpoint (still missing as of KRO-DESIGN-050; deterministic isolated hardening-flip verification remains blocked).
