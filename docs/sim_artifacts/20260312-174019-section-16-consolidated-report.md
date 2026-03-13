# Aiventory User-Flow Live API Simulation - Consolidated Report

Date: 2026-03-12 17:40 Malay Peninsula Standard Time

## Final status
- Completed sections: 1,2,3,4,5,6,7,8,9,10,14,15,16
- Blocked-deferred sections: 11 (Upload Carousell), 12 (Cart), 13 (Carousell Update)
- Reason deferred: exact revert requirements cannot be met with current app-exposed contracts.

## Findings by severity
- [Critical] C1 - UploadCarousell direct navigation missing required runtime param
  - Impact: Direct /carousell -> /uploadCarousell path can dereference null inventoryId and break flow.
  - Recommended fix: Pass required params when pushing UploadCarousell route, or guard nullable inventoryId in UploadCarousellWidget init/build.
  - Evidence: docs/sim_artifacts/20260312-170001-section-11-upload-carousell-flow.json
- [Critical] C2 - UploadCarousell create has no exact revert path
  - Impact: POST /inventory_carousell creates persistent rows without delete/update contract; violates safe simulation/revert policy.
  - Recommended fix: Expose delete/update endpoint for inventory_carousell and wire app cleanup path.
  - Evidence: docs/sim_artifacts/20260312-155026-section-11-upload-carousell-flow.json
- [Critical] C3 - Cart create has no delete endpoint for exact pre-state restoration
  - Impact: POST /inventory_carousell_movement cannot be reverted to pre-create absence state.
  - Recommended fix: Add delete endpoint (or backend reversible transaction) for inventory_carousell_movement.
  - Evidence: docs/sim_artifacts/20260312-171312-section-12-cart-flow.json
- [High] H1 - CarousellUpdate revert not exact due buyer_side metadata persistence
  - Impact: PUT toggle true->false leaves buyer_side.name/date mutated; audit correctness risk.
  - Recommended fix: Backend should clear buyer_side metadata when done_bool=false or accept explicit null reset fields.
  - Evidence: docs/sim_artifacts/20260312-172906-section-13-carousell-update-flow.json
- [High] H2 - TrackingOrder missing-param handling unsafe for url
  - Impact: url force unwrap may throw runtime exception when omitted.
  - Recommended fix: Guard null url and show placeholder/fallback image.
  - Evidence: docs/sim_artifacts/20260312-173224-section-14-tracking-order-flow.json
- [Medium] M1 - Order status transition validation not enforced server-side
  - Impact: Sequence-invalid transitions accepted (ordered -> submitted), risking workflow integrity.
  - Recommended fix: Enforce allowed transition matrix in /order_list_status backend.
  - Evidence: docs/sim_artifacts/20260312-152119-section-7-order-list-workflow.json
- [Medium] M2 - Edit inventory invalid required-field case accepted
  - Impact: Empty item_name accepted (HTTP 200), weak validation.
  - Recommended fix: Add server-side required-field validation for PUT /inventory.
  - Evidence: docs/sim_artifacts/20260312-070759-section-5-edit-inventory-flow.json
- [Low] L1 - Carousell route params currently ignored by page API load
  - Impact: Paramized navigation does not affect downstream queries, confusing contract.
  - Recommended fix: Use route params in initial query/filter or remove unused params from route contract.
  - Evidence: docs/sim_artifacts/20260312-154520-section-10-carousell-listing-flow.json

## API contract mismatches
- POST /inventory_carousell
  - App payload: {inventory_id, remark, branch_id, type, category}
  - Backend behavior: create-only; repeated call inserts new row
  - Mismatch: No update/delete counterpart, cannot restore exact pre-state
- POST /inventory_carousell_movement
  - App payload: multipart create from /cart
  - Backend behavior: create exposed + get/put only
  - Mismatch: No delete contract to revert creation
- PUT /inventory_carousell_movement
  - App payload: {id,status,side,done_bool,name}
  - Backend behavior: persists buyer_side metadata even when done_bool false
  - Mismatch: Cannot restore original buyer_side null/empty state
- PUT /order_list_status
  - App payload: status transitions from UI actions
  - Backend behavior: accepts sequence-invalid transition ordered->submitted
  - Mismatch: Server transition guard absent

## UX impacts
- Upload Carousell button from Carousell can fail/crash due missing inventoryId param.
- Cart and Upload mutation tests blocked by unrevertable create operations, slowing QA throughput.
- Carousell Update toggles can leave stale buyer metadata visible to users.
- Tracking Order page may break image rendering when url param missing.
- Order workflow allows unexpected backward transitions, causing queue confusion.

## Deferred queue evidence
- 11) Upload Carousell flow: blocked-deferred (docs/sim_artifacts/20260312-170001-section-11-upload-carousell-flow.json)
- 12) Cart flow: blocked-deferred (docs/sim_artifacts/20260312-171312-section-12-cart-flow.json)
- 13) Carousell Update flow: blocked-deferred (docs/sim_artifacts/20260312-172906-section-13-carousell-update-flow.json)
