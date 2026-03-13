# Aiventory Master Audit TODO

Legend:
- [ ] not started
- [~] in progress / partial
- [x] completed
- [!] blocked

Last updated: 2026-03-12 (MYT, B2 completed)

## Phase 1 - Inventory/bootstrap

- [x] Build route/page inventory from router and exports.
- [x] Build API endpoint inventory from api_calls.dart.
- [x] Map shared/global state dependencies from app_state.dart.
- [x] Produce architecture, baseline report, and machine state files.

## Phase 2+ - Deep code-first audits (ordered execution queue)

### A. Auth + bootstrap integrity
1. [x] Login submit contract and token extraction correctness (`login_widget.dart`, `api_calls.dart`)
2. [x] `authMe` bootstrap sequencing and failure handling (`login_model.dart`)
3. [x] Branch list bootstrap and duplicate/default-branch consistency (`login_model.dart`, `app_state.dart`)
4. [x] Inventory category bootstrap and downstream dropdown dependency integrity (`login_model.dart`, consumers)

### B. Global state correctness and persistence
5. [x] Persisted state load safety and corruption handling (`app_state.dart`)
6. [x] `allInventory` lifecycle integrity (dedup/update policy across edit/search flows)
7. [ ] Branch context propagation (`branch`, `branchId`, `branchIdUser`) across all payload builders
8. [ ] Order and carousell cached list mutation correctness (`orderLists`, `carousellList`, status update lists)

### C. Dashboard + navigation contracts
9. [ ] Dashboard API contract (`dashboardHQCall`) param validity and role/branch behavior
10. [ ] Dashboard navigation payload completeness to downstream pages

### D. Find inventory flow
11. [ ] Initial listing fetch params and pagination assumptions (`find_inventory_widget.dart`)
12. [ ] Search+supplier+category filter contract (source constraints vs payload fields)
13. [ ] Branch/date filter conversion integrity (DateTime -> API expiry_date)
14. [ ] Cross-page param passing to edit/history/cart/stock flows from selection context

### E. Inventory master/edit flow
15. [ ] `getInventory` load contract and null-state handling (`edit_inventory_widget.dart`)
16. [ ] Edit submit payload completeness (`editInventoryCall`) with/without image
17. [ ] Enum/dropdown constrained fields (category, expiry bool, unit quantities) integrity
18. [ ] Post-edit state update correctness (`addToAllInventory` duplication risk)

### F. Stock-in and movement flow
19. [ ] Inventory search + barcode lookup constraints (`stock_in_widget.dart`)
20. [ ] Unit dropdown source integrity and required-field enforcement
21. [ ] `inventoryMovementPost` payload contract (required/optional/defaults)
22. [ ] Attachment upload + movement submit transaction integrity (partial failure risk)
23. [ ] Linked order status update (`received`) consistency and rollback gap analysis

### G. Order creation and lifecycle
24. [ ] Order creation payload (`orderStatusUpdateCall`) field correctness from Order page
25. [ ] Order channel/status derivation integrity (`submitted` vs `ordered`)
26. [ ] Order list retrieval filter contract and status-list constraints
27. [ ] All status transition actions in OrderList (approve/reverse/cancel/ordered) contract audit
28. [ ] Shared component status editor (`components/edit_status_widget.dart`) side effects

### H. Carousell flow
29. [ ] Carousell listing query contract and search/category behavior
30. [ ] Carousell upload payload correctness (including expiry_date behavior)
31. [ ] Carousell movement create contract from Cart flow
32. [ ] Carousell movement update contract (`carousellMovementPut`) state machine safety
33. [ ] Carousell state refresh and cache coherence after create/update

### I. Movement history and destructive action safety
34. [ ] Item history listing filters and pagination contract
35. [ ] Item movement delete payload safety + authorization assumptions
36. [ ] UX impact assessment for destructive operations and stale-state refresh

### J. Secondary pages / residual routes
37. [ ] TrackingOrder route param contract and downstream API usage
38. [ ] PurchaseOrder page contract and integration role
39. [ ] Any unreferenced API wrappers and dead-path risk review

### K. Consolidation
40. [ ] Produce final consolidated findings (severity-ranked)
41. [ ] Produce remediation roadmap by impact/effort
42. [ ] Export final report PDF to `C:\Users\User\.openclaw\media\generation\aiventory-audit-final-report.pdf`
43. [ ] Delivery summary prepared for Telegram 59918803

## Current next item
- NEXT: B3 - Branch context propagation (`branch`, `branchId`, `branchIdUser`) across all payload builders
