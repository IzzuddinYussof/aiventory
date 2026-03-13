# Aiventory User-Flow Master TODO (Reset)

Last updated: 2026-03-12 (MYT)
Mode: user-flow simulation + live API (ikut behavior app)

## Rules
- Start from `/login` flow first.
- Simulate exactly what app does (endpoint, payload format, sequence).
- For write/mutation API: wajib simpan before/after, then revert.
- Jangan guna arbitrary fuzz. Guna values yang valid ikut source (dropdown/enum/returned lists).

---

## 0) Global setup (once)
- [x] Create run log: `docs/SIM_RUN_LOG.md`
- [x] Create state snapshot file: `docs/SIM_STATE_TRACKER.json`
- [x] Create revert ledger: `docs/SIM_REVERT_LEDGER.json`
- [x] Confirm base URL + endpoint groups from `lib/backend/api_requests/api_calls.dart`
- [x] Map route and params from `lib/flutter_flow/nav/nav.dart`

---

## 1) Auth entry flow (critical)
Page: `/login`
Purpose: user authentication + bootstrap session

- [x] Simulate valid login (`POST /auth/login`, multipart)
- [x] Extract and store `authToken` (secure masked in report)
- [x] Simulate `GET /auth/me` with Bearer token
- [x] Simulate wrong email login and verify error contract
- [x] Simulate wrong password login and verify error contract
- [x] Verify app-side expected variable mapping:
  - [x] `FFAppState().token`
  - [x] `FFAppState().user`

APIs:
- `POST /auth/login`
- `GET /auth/me`

---

## 2) Post-login bootstrap flow
Purpose: preload app state required for downstream pages

- [x] Simulate `GET /inventory`
- [x] Simulate `GET /branch_list_basic`
- [x] Simulate `GET /inventory_category_list`
- [x] Reproduce branch resolution logic from code (`label` -> `branchId`)
- [x] Verify branch fallback behavior when label mismatch
- [x] Save bootstrap artifacts to state tracker

APIs:
- `GET /inventory`
- `GET /branch_list_basic`
- `GET /inventory_category_list`

---

## 3) Dashboard flow
Page: `/dashboardHQ`
Purpose: summary data by access/branch context

- [x] Build payload using current user/access/branch from simulated state
- [x] Simulate `GET /dashboard_inventory_hq`
- [x] Verify branch scope behavior (`branch_id` changes output)
- [x] Verify response fields used by UI cards/charts

APIs:
- `GET /dashboard_inventory_hq`

---

## 4) Find Inventory flow
Page: `/findInventory`
Purpose: listing + filter + route out to edit/history/order/cart

- [x] Simulate initial listing (`inventory_listing`)
- [x] Simulate search by inventory id list
- [x] Simulate expiry/date filter conversion path
- [x] Simulate pagination (`page`, `per_page`)
- [x] Validate returned rows enough for downstream route params

APIs:
- `GET /inventory_listing` (api:0o-ZhGP6)
- `GET /inventory_listing_expiring_count`

---

## 5) Edit Inventory flow
Page: `/editInventory`
Purpose: retrieve one item + update item

- [x] Pick one safe test inventory item
- [x] Simulate `GET /inventory/{id}`
- [x] Simulate valid `PUT /inventory` (multipart) with minimal change
- [x] Simulate invalid/missing required field case (app-like)
- [x] Verify updated value reflected via follow-up get/list
- [x] Revert changed item exactly to pre-state
- [x] Log revert proof in ledger

APIs:
- `GET /inventory/{id}`
- `PUT /inventory` (multipart)

---

## 6) Order create flow
Page: `/order`
Purpose: create/update order list status entry

- [x] Build payload from valid inventory + branch context
- [x] Simulate order submit (`PUT /order_list_status`)
- [x] Verify status/channel derivation logic
- [x] Confirm record appears in order list query
- [x] Revert: return status to original / delete-equivalent flow if available

APIs:
- `PUT /order_list_status`
- `POST /order_lists`

---

## 7) Order List workflow
Page: `/orderList`
Purpose: status transitions and queue operations

- [x] Simulate list retrieval with default status filters
- [x] Simulate each transition path used by app UI:
  - [x] approve
  - [x] ordered
  - [x] received
  - [x] cancel/reverse
- [x] Check transition safety (invalid sequence handling)
- [x] Revert test transitions to original status

APIs:
- `POST /order_lists`
- `PUT /order_list_status`
- `GET /order/{id}`

---

## 8) Stock In flow
Page: `/stockIn`
Purpose: movement posting + optional linked order received update

- [x] Simulate inventory lookup/barcode lookup
- [x] Simulate attachment upload path (`uploadFile_inventory`) if used
- [x] Simulate movement submit (`POST /inventory_movement`)
- [x] Simulate linked order status update (`received`) when orderData exists
- [x] Verify movement appears in history endpoints
- [x] Revert movement effects (delete or compensating reverse movement)

APIs:
- `GET /inventory_barcode`
- `POST /uploadFile_inventory`
- `POST /inventory_movement`
- `PUT /order_list_status`
- `GET /item_history`

---

## 9) Item Movement History flow
Page: `/itemMovementHistory`
Purpose: audit trail + delete operation

- [x] Simulate `GET /item_history` with route params
- [x] Validate filter behavior (`inventory_id`, `expiry_date`, `branch`)
- [x] Simulate safe delete on test-created movement only
- [x] Confirm data consistency after delete
- [x] Blocker resolved (2026-03-12 15:40 MYT): created scoped test movement marker `[SIM9-DELETE-TARGET]`, deleted same record via `DELETE /item_movement_delete`, and verified absence in follow-up `GET /item_history`.

APIs:
- `GET /item_history` (api:0o-ZhGP6)
- `DELETE /item_movement_delete` (api:0o-ZhGP6)

---

## 10) Carousell listing flow
Page: `/carousell`
Purpose: list inventory carousell by search/category/inventory ids

- [x] Simulate default list query
- [x] Simulate search + category filters
- [x] Validate inventory id list serialization behavior

APIs:
- `GET /inventory_carousell`

---

## 11) Upload Carousell flow
Page: `/uploadCarousell`
Purpose: create inventory carousell posting

- [ ] Build payload from valid inventory record
- [ ] Simulate create (`POST /inventory_carousell`)
- [ ] Verify created row appears in list
- [ ] Revert: remove/neutralize created test row via supported app flow
- [ ] BLOCKED (2026-03-12 15:50 MYT): `POST /inventory_carousell` creates new rows (ids 17,18 for `inventory_id=1357`) and app contract exposes no delete/update endpoint for `inventory_carousell`, so exact pre-state revert is not currently possible.
- [ ] BLOCKED (2026-03-12 15:54 MYT): read-only revalidation (`docs/sim_artifacts/20260312-155406-section-11-upload-carousell-flow.json`) confirms blocker persists; source `/carousell` direct navigation omits params while `/uploadCarousell` runtime dereferences `inventoryId!`, and no exact-revert path exists.
- [ ] BLOCKED (2026-03-12 15:59 MYT): read-only revalidation (`docs/sim_artifacts/20260312-155927-section-11-upload-carousell-flow.json`) still shows direct `/carousell -> /uploadCarousell` path omits required params, and mutation remains unsafe due to missing delete/update revert endpoint for `inventory_carousell`.
- [ ] BLOCKED (2026-03-12 16:04 MYT): read-only revalidation (`docs/sim_artifacts/20260312-160413-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.
- [ ] BLOCKED (2026-03-12 16:07 MYT): read-only revalidation (`docs/sim_artifacts/20260312-160730-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.
- [ ] BLOCKED (2026-03-12 16:11 MYT): read-only revalidation (`docs/sim_artifacts/20260312-161107-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.
- [ ] BLOCKED (2026-03-12 16:15 MYT): read-only revalidation (`docs/sim_artifacts/20260312-161547-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.
- [ ] BLOCKED (2026-03-12 16:25 MYT): read-only revalidation (`docs/sim_artifacts/20260312-162431-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.
- [ ] BLOCKED (2026-03-12 16:29 MYT): read-only revalidation (`docs/sim_artifacts/20260312-162928-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.

- [ ] BLOCKED (2026-03-12 16:41 MYT): read-only revalidation (`docs/sim_artifacts/20260312-164124-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.
- [ ] BLOCKED (2026-03-12 16:44 MYT): read-only revalidation (`docs/sim_artifacts/20260312-164459-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.

APIs:
- `POST /inventory_carousell`
- `GET /inventory_carousell`

- [ ] BLOCKED-DEFERRED (2026-03-12 17:05 MYT): anti-stall applied after repeated Section 11 blocks; deferred with blocker evidence in `docs/sim_artifacts/20260312-170001-section-11-upload-carousell-flow.json` and advanced to Section 12.

---

- [ ] BLOCKED (2026-03-12 16:34 MYT): read-only revalidation (`docs/sim_artifacts/20260312-163417-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.
- [ ] BLOCKED (2026-03-12 16:37 MYT): read-only revalidation (`docs/sim_artifacts/20260312-163709-section-11-upload-carousell-flow.json`) confirms blocker persists; direct `/carousell -> /uploadCarousell` still omits required params while target force-unwraps `inventoryId`, and mutation remains unsafe because no delete/update revert path exists for `inventory_carousell`.

- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:04 MYT): deferred retry confirms blocker persists; direct /carousell -> /uploadCarousell still omits runtime-required inventoryId and mutation remains unrevertable due to missing delete/update endpoint for inventory_carousell. Evidence: `docs/sim_artifacts/20260312-190400-section-11-upload-carousell-flow.json`.

- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:18 MYT): deferred retry confirms blocker persists; direct /carousell -> /uploadCarousell still omits runtime-required inventoryId and mutation remains unrevertable due to missing delete/update endpoint for inventory_carousell. Evidence: `docs/sim_artifacts/20260312-191810-section-11-upload-carousell-flow.json`.

- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:26 MYT): deferred retry confirms blocker persists; direct /carousell -> /uploadCarousell still omits runtime-required inventoryId and mutation remains unrevertable due to missing delete/update endpoint for inventory_carousell. Evidence: `docs/sim_artifacts/20260312-192659-section-11-upload-carousell-flow.json`.

- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 20:01 MYT): deferred retry confirms blocker persists; direct /carousell -> /uploadCarousell still omits runtime-required inventoryId and mutation remains unrevertable due to missing delete/update endpoint for inventory_carousell. Evidence: `docs/sim_artifacts/20260312-200121-section-11-upload-carousell-flow.json`.

## 12) Cart flow
Page: `/cart`
Purpose: create carousell movement entry from selected item

- [ ] Simulate add/request movement (`POST /inventory_carousell_movement`)
- [ ] Verify appears in movement get
- [ ] Revert movement status/data to pre-state

APIs:
- `POST /inventory_carousell_movement`
- `GET /inventory_carousell_movement`

- [ ] BLOCKED (2026-03-12 17:05 MYT): mutation skipped under Rule 5 because `/inventory_carousell_movement` contract has no delete endpoint for exact pre-state restoration after create; see `docs/sim_artifacts/20260312-170517-section-12-cart-flow.json`.
- [ ] BLOCKED (2026-03-12 17:10 MYT): revalidation confirms blocker persists; `/cart` navigation params remain consistent to payload mapping, but exact revert after `POST /inventory_carousell_movement` is still impossible without delete endpoint; see `docs/sim_artifacts/20260312-171013-section-12-cart-flow.json`.

- [ ] BLOCKED (2026-03-12 17:13 MYT): revalidation #3 confirms blocker persists; `/cart` navigation params remain consistent to payload mapping, but exact revert after `POST /inventory_carousell_movement` is still impossible without delete endpoint; see `docs/sim_artifacts/20260312-171312-section-12-cart-flow.json`.
- [ ] BLOCKED-DEFERRED (2026-03-12 17:13 MYT): anti-stall applied after 3 consecutive Section 12 blocks; deferred with blocker evidence in `docs/sim_artifacts/20260312-171312-section-12-cart-flow.json` and advanced to Section 13.
- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:09 MYT): deferred retry confirms blocker persists; `/cart` navigation params remain consistent to `POST /inventory_carousell_movement` payload mapping, but mutation remains unsafe because exact pre-state revert is impossible without delete endpoint. Evidence: `docs/sim_artifacts/20260312-190912-section-12-cart-flow.json`.
- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:21 MYT): deferred retry confirms blocker persists; `/cart` navigation params remain consistent to `POST /inventory_carousell_movement` payload mapping, but mutation remains unsafe because exact pre-state revert is impossible without delete endpoint. Evidence: `docs/sim_artifacts/20260312-192116-section-12-cart-flow.json`.
- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:30 MYT): deferred retry confirms blocker persists; `/cart` navigation params remain consistent to `POST /inventory_carousell_movement` payload mapping, but mutation remains unsafe because exact pre-state revert is impossible without delete endpoint. Evidence: `docs/sim_artifacts/20260312-193053-section-12-cart-flow.json`.
- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:43 MYT): deferred retry confirms blocker persists; `/cart` navigation params remain consistent to `POST /inventory_carousell_movement` payload mapping, but mutation remains unsafe because exact pre-state revert is impossible without delete endpoint. Evidence: `docs/sim_artifacts/20260312-194311-section-12-cart-flow.json`.
- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:53 MYT): deferred retry confirms blocker persists; `/cart` navigation params remain consistent to `POST /inventory_carousell_movement` payload mapping, but mutation remains unsafe because exact pre-state revert is impossible without delete endpoint. Evidence: `docs/sim_artifacts/20260312-195340-section-12-cart-flow.json`.

---

## 13) Carousell Update flow
Page: `/carousellUpdate`
Purpose: process status updates for carousell movement

- [ ] Simulate fetch movement list by branch/status
- [ ] Simulate update status path (`PUT /inventory_carousell_movement`)
- [ ] Validate done_bool / side semantics
- [ ] Revert status changes

APIs:
- `GET /inventory_carousell_movement`
- `PUT /inventory_carousell_movement` (multipart)

---

- [ ] BLOCKED (2026-03-12 17:20 MYT): mutation/revert validation found non-exact revert side effect in `PUT /inventory_carousell_movement`; `buyer_side` metadata (`name/date`) changes after buyer done_bool toggle and cannot be restored to pre-state via app-exposed contract, so Section 13 remains blocked. Evidence: `docs/sim_artifacts/20260312-172004-section-13-carousell-update-flow.json`.
- [ ] BLOCKED (2026-03-12 17:25 MYT): revalidation #2 confirms blocker persists on movement `id=9`; buyer done toggle (`true -> false`) restores `buyer=false` but still writes persistent `buyer_side.name/date`, so exact pre-state revert remains impossible via current `PUT /inventory_carousell_movement` contract. Evidence: `docs/sim_artifacts/20260312-172533-section-13-carousell-update-flow.json`.

- [ ] BLOCKED (2026-03-12 17:29 MYT): revalidation #3 confirms blocker persists on movement `id=10`; buyer done toggle (`true -> false`) restores `buyer=false` but still writes persistent `buyer_side.name/date`, so exact pre-state revert remains impossible via current `PUT /inventory_carousell_movement` contract. Evidence: `docs/sim_artifacts/20260312-172906-section-13-carousell-update-flow.json`.
- [ ] BLOCKED-DEFERRED (2026-03-12 17:29 MYT): anti-stall applied after 3 consecutive Section 13 blocks; deferred with blocker evidence in `docs/sim_artifacts/20260312-172906-section-13-carousell-update-flow.json` and advanced to Section 14.

- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:13 MYT): deferred retry confirms blocker persists; `buyer_side.name/date` remains populated even when `buyer=false`, and app `PUT /inventory_carousell_movement` contract exposes no field/path to clear that metadata for exact pre-state restore. Evidence: `docs/sim_artifacts/20260312-191353-section-13-carousell-update-flow.json`.
- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:47 MYT): deferred retry confirms blocker persists; `buyer_side.name/date` metadata remains populated in delivered records and app PUT contract exposes no clear/reset field for exact pre-state restore. Evidence: `docs/sim_artifacts/20260312-194749-section-13-carousell-update-flow.json`.
- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:57 MYT): deferred retry revalidation still blocks safe mutation path; exact pre-state revert remains unsupported because app `PUT /inventory_carousell_movement` contract has no field/path to clear `buyer_side.name/date` once set. Evidence: `docs/sim_artifacts/20260312-195712-section-13-carousell-update-flow.json`.


## 14) Tracking Order flow
Page: `/trackingOrder`
Purpose: route-param driven order tracking

- [x] Verify required route params availability in upstream flow
- [x] Simulate underlying data retrieval used by page
- [x] Validate missing-param behavior

APIs:
- `POST /order_lists`
- `GET /order/{id}`

- [x] COMPLETED (2026-03-12 17:32 MYT): source `/orderList` passes required params (`orderID:int`, `itemName:String`, `url:String`) to `/trackingOrder`; page itself performs no direct API calls and renders `FFAppState().orderFlow` organized upstream via `orderListOrganize(orderListsItem)`. Read-only live retrieval validated with `POST /order_lists` + `GET /order/{id}` (`docs/sim_artifacts/20260312-173224-section-14-tracking-order-flow.json`). Missing-param behavior validated: constructor falls back to `orderID=0` and `itemName='Error'`, but `url` is force-unwrapped (`widget.url!`) in `Image.network`, so missing `url` is runtime-unsafe.

---

## 15) Purchase Order flow
Page: `/purchaseOrder`
Purpose: purchase process visibility/integration

- [x] Map all API calls from page code
- [x] Simulate each call with valid app-like params
- [x] Verify create/update/read behavior
- [x] Revert any mutation
- [x] COMPLETED (2026-03-12 17:35 MYT): page is static UI scaffold with no backend calls in `purchase_order_widget.dart` (no `api_calls.dart` import, no API invocations, no mutation path). Live contract simulation therefore executes zero API calls by design and records integration gap evidence in `docs/sim_artifacts/20260312-173509-section-15-purchase-order-flow.json`.

APIs:
- none implemented in current page code

---

## 16) Consolidation
- [x] Build full finding list by severity (Critical/High/Medium/Low)
- [x] Build concrete fix recommendations + code references
- [x] Build API contract mismatch list (app payload vs backend expectation)
- [x] Build UX-impact list from data/flow defects
- [x] Generate final PDF report
- [x] Send PDF + summary to Izz

---

## Route Coverage Checklist (from router)
- [x] /login
- [x] /dashboardHQ
- [ ] /findInventory
- [x] /order
- [ ] /orderList
- [x] /stockIn
- [x] /carousell
- [x] /trackingOrder
- [x] /purchaseOrder
- [x] /editInventory
- [ ] /uploadCarousell
- [ ] /carousellUpdate
- [x] /itemMovementHistory
- [ ] /cart









- [ ] BLOCKED (2026-03-12 16:55 MYT): read-only revalidation (docs/sim_artifacts/20260312-165405-section-11-upload-carousell-flow.json) confirms blocker persists; direct /carousell -> /uploadCarousell still omits required params while target force-unwraps inventoryId, and mutation remains unsafe because no delete/update revert path exists for inventory_carousell.
- [ ] BLOCKED (2026-03-12 17:00 MYT): read-only revalidation (docs/sim_artifacts/20260312-170001-section-11-upload-carousell-flow.json) confirms blocker persists; direct /carousell -> /uploadCarousell still omits required params while target force-unwraps inventoryId, and mutation remains unsafe because no delete/update revert path exists for inventory_carousell.



- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:25 MYT): deferred retry confirms blocker persists; buyer_side.name/date metadata remains populated in delivered records and app PUT contract exposes no clear/reset field for exact pre-state restore. Evidence: `docs/sim_artifacts/20260312-192344-section-13-carousell-update-flow.json`.


- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:35 MYT): deferred retry confirms blocker persists; buyer_side.name/date metadata remains populated in delivered records and app PUT contract exposes no clear/reset field for exact pre-state restore. Evidence: docs/sim_artifacts/20260312-193505-section-13-carousell-update-flow.json.

- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:38 MYT): deferred retry confirms blocker persists; direct /carousell -> /uploadCarousell still omits runtime-required inventoryId and mutation remains unrevertable due to missing delete/update endpoint for inventory_carousell. Evidence: `docs/sim_artifacts/20260312-193802-section-11-upload-carousell-flow.json`.

- [ ] BLOCKED-DEFERRED-RETRY (2026-03-12 19:51 MYT): deferred retry confirms blocker persists; direct /carousell -> /uploadCarousell still omits runtime-required inventoryId and mutation remains unrevertable due to missing delete/update endpoint for inventory_carousell. Evidence: `docs/sim_artifacts/20260312-195117-section-11-upload-carousell-flow.json`.

