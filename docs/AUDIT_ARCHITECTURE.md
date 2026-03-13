# Aiventory Audit Architecture (Code-First)

Last updated: 2026-03-12 (MYT, B2 completed)
Mode: Source-code and API-contract audit only (no `flutter run`, no live UI automation)

## 1) System map

- Frontend: Flutter (FlutterFlow-generated structure)
- Routing: `go_router` in `lib/flutter_flow/nav/nav.dart`
- Global state: singleton `FFAppState` in `lib/app_state.dart`
- Backend integration: API wrappers in `lib/backend/api_requests/api_calls.dart`
- Data contracts: Structs in `lib/backend/schema/structs/*.dart`

## 2) Route/page inventory

Source of truth: `lib/flutter_flow/nav/nav.dart`, `lib/index.dart`

- `/` -> splash/login initializer
- `/login` -> `LoginWidget`
- `/dashboardHQ` -> `DashboardHQWidget`
- `/findInventory` -> `FindInventoryWidget`
- `/order` -> `OrderWidget`
- `/orderList` -> `OrderListWidget`
- `/stockIn` -> `StockInWidget`
- `/carousell` -> `CarousellWidget`
- `/trackingOrder` -> `TrackingOrderWidget`
- `/purchaseOrder` -> `PurchaseOrderWidget`
- `/editInventory` -> `EditInventoryWidget`
- `/uploadCarousell` -> `UploadCarousellWidget`
- `/carousellUpdate` -> `CarousellUpdateWidget`
- `/itemMovementHistory` -> `ItemMovementHistoryWidget`
- `/cart` -> `CartWidget`

Bottom-nav root pages (`NavBarPage`): dashboardHQ, findInventory, StockIn, Order, orderList, Carousell.

## 3) API surface (contracts to audit)

Primary base: `https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03`
Secondary base used in specific calls: `https://xqoc-ewo0-x3u2.s2.xano.io/api:0o-ZhGP6`

### AuthGroup
- `POST /auth/login`
- `GET /auth/me` (Bearer token)

### InventoryGroup
- `GET /inventory_barcode`
- `GET /inventory`
- `PUT /inventory` (multipart)
- `GET /inventory/{inventoryId}`

### InventoryListingGroup
- `GET /inventory_listing` (api:0o-ZhGP6)
- `GET /inventory_listing_expiring_count`

### InventoryMovementGroup
- `GET /inventory_movement`
- `POST /inventory_movement` (JSON)
- `GET /item_history` (api:0o-ZhGP6)
- `DELETE /item_movement_delete` (JSON)

### OrderGroup
- `GET /order/{orderId}`
- `POST /order_lists` (JSON)
- `PUT /order_list_status` (JSON)

### InventoryCategoryGroup
- `GET /inventory_category_list`

### BranchGroup
- `GET /branch_list_basic`

### DashboardGroup
- `GET /dashboard_inventory_hq`

### CarousellGroup
- `GET /inventory_carousell`
- `POST /inventory_carousell` (JSON)
- `POST /inventory_carousell_movement` (multipart params)
- `GET /inventory_carousell_movement`
- `PUT /inventory_carousell_movement` (multipart params)

### Standalone calls
- `POST /uploadFile_inventory` (`UploadFileCall`)
- Cloud function upload (`UploadImageInventoryCall`)

## 4) Page-purpose and key action map

- Login: authenticate, bootstrap user/session state, preload inventory/branch/category lists.
- DashboardHQ: dashboard summary by access/branch, navigate to operational modules.
- FindInventory: filtered inventory listing by branch/date/search/supplier + transitions to edit/history/cart/stock-out flows.
- StockIn: stock movement posting + optional order status transition to `received`.
- Order: create orders (`submitted` or `ordered`) with optional file upload.
- OrderList: list workflow by statuses and perform status transitions (approve/cancel/reverse/ordered/etc).
- Carousell: list/search carousell inventory and navigation to cart/upload/update flows.
- UploadCarousell: create carousell inventory listing with optional image upload.
- CarousellUpdate: fetch and update carousell movement status.
- EditInventory: load and update inventory master data.
- ItemMovementHistory: list movement history and delete movement entry.
- Cart: carousell movement transaction submission flow.
- TrackingOrder / PurchaseOrder: workflow support pages (deep audit queued in TODO).

## 5) Shared/global state dependencies (high impact)

`FFAppState` keys frequently used across pages:
- Auth/session: `token`, `user`
- Scope/branching: `branch`, `branchId`, `branchIdUser`, `branchLists`
- Inventory catalogs: `allInventory`, `inventoryCategoryLists`
- Operational caches: `orderLists`, `DashboardHQ`, `expiringCount`, `carousellList`, movement lists
- Selection context: `chosenInventory`, `chosenOrder`, `inventoryCurrent`

Risk theme: multiple pages derive API payloads from mutable global values (especially branch and user fields); stale persisted state can propagate wrong branch/user context.

## 6) Navigation dependency hotspots

- Login -> Dashboard only after parallel bootstrap calls complete.
- Dashboard -> FindInventory/Order/OrderList/Carousell and detail routes.
- FindInventory -> EditInventory / ItemMovementHistory / StockIn / Cart (with many route params).
- OrderList -> StockIn + TrackingOrder with status mutation side effects.
- UploadCarousell returns to Carousell context and refreshes shared list.

## 7) Known high-risk contract mismatches (from static review)

1. Hardcoded expiry date in carousell create payload
   - `CarousellPostCall` sends `"expiry_date": "2025-05-05"` regardless of input.
2. Branch fallback-to-0 can silently widen scope
   - Branch resolution defaults to `0` when `user.branch` label is not found, while synthetic `{id:0,label:All Dentabay}` is always appended.
3. Branch matching uses mutable display label
   - `branchId`/`branchIdUser` derive from `where(label == user.branch).firstOrNull`, vulnerable to label drift/duplicates.
4. `allInventory` cache coherence gap (duplication + stale overwrite)
   - Edit flow appends edited inventory via `addToAllInventory` instead of id-based upsert; startup/login refresh can later overwrite with older server snapshots.
   - `FFAppState` list mutators do in-place mutation without `notifyListeners`, so cross-page consumers can miss cache changes unless they self-refresh.
5. Parallel side effects in StockIn
   - inventory movement submit and order status update run in `Future.wait`, potential partial success state.
6. Route payload fragility
   - many cross-page params are nullable and used directly in business actions.
7. Auth bootstrap sequencing risk
   - dashboard navigation is triggered within one branch of `Future.wait`, before other bootstrap dependencies are guaranteed successful.
8. Stale token retry loop risk
   - failed `authMe` path does not invalidate persisted token, so startup can repeatedly replay failing bootstrap.
9. Category bootstrap consistency risk
   - category preload runs in parallel while dashboard navigation is triggered from branch preload path; category-dependent dropdown/chips pages can initialize with stale persisted category cache until async refresh settles.
10. Persisted-state atomicity/observability gap
   - persisted auth/branch restore is not atomic with `branchIdUser`, list decode corruption is partially tolerated, and `_safeInit` suppresses init exceptions.

## 8) Audit execution strategy for next phases

- Execute first unchecked TODO item each run.
- For each item: verify data source constraints, payload completeness, failure path, state integrity, navigation param safety.
- Capture evidence with exact file and line references.
- Mark status done/partial/blocked with reason in `AUDIT_TODO.md` and `AUDIT_MASTER_STATE.json`.
