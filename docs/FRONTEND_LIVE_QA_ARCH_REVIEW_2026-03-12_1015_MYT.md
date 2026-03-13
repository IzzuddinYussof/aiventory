# Aiventory Frontend Live QA + Architecture Review (Sequential)

**Project:** `C:\Programming\aiventory`  
**Execution time:** 2026-03-12 10:15 MYT (cron-triggered)  
**Mode:** Frontend user-flow route pass (no direct API as primary path)  
**Tester:** OpenClaw agent

## Scope and constraints applied
- Tested pages in required order:
  1. `/login`
  2. `/dashboardHQ`
  3. `/findInventory`
  4. `/order`
  5. `/orderList`
  6. `/stockIn`
  7. `/carousell`
  8. `/trackingOrder`
  9. `/purchaseOrder`
  10. `/editInventory`
  11. `/uploadCarousell`
  12. `/carousellUpdate`
  13. `/itemMovementHistory`
  14. `/cart`
- Followed frontend-live route navigation and visual/UX assessment.
- No live data mutation performed (no create/update/delete submit clicked), therefore revert was not needed.

## Overall status
- **Completion:** Completed all required routes sequentially.
- **Result summary:** **2 BLOCK**, **12 WARN**, **0 clean PASS**.
- **Critical blockers:** `/trackingOrder` and `/cart` render as blank gray screen when opened directly.

---

## Per-page progress log

### 1) `/login` — WARN
- UI renders and is visually usable.
- Accessibility/snapshot tree remains generic/minimal; weak for testability and assistive tooling.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\9f12cfd6-c304-4bb1-8e81-be367d9a57c1.png`

### 2) `/dashboardHQ` — WARN
- Dashboard loads with KPI cards.
- KPI values appear inconsistent (e.g., decimal item count, potentially stale/implausible metrics) without freshness context.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\f00e28ad-63ff-48b7-a6bf-9c6919d41405.png`

### 3) `/findInventory` — WARN
- Data list renders.
- Multiple duplicate cards and `Branch: null` visible; data quality and UX trust issue.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\98caf2a6-1fc5-4a05-8da9-c65c48173bbd.png`

### 4) `/order` — WARN
- Form renders with core controls.
- Required-field clarity and guardrails are weak; upload constraints not shown.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\1ee15503-6aaa-4571-92b9-5c6509030d74.png`

### 5) `/orderList` — WARN
- List and status tabs render.
- Destructive affordance (red action icon) appears high-risk with unclear confirmation flow from list context.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\682ee035-21e1-4c34-943a-f6d33a47dc3b.png`

### 6) `/stockIn` — WARN
- Stock-in form renders.
- Default state displays `Item Name : null`; indicates missing context handoff and brittle first-state UX.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\f308f207-9400-42b6-94c6-a900047034ec.png`

### 7) `/carousell` — WARN
- Marketplace page renders and can show data.
- Content mixing observed (non-marketplace style card appears in selling area), suggesting weak feed/domain filtering.
- Embedded modal error shown in-card with unclear trigger provenance.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\5409e1b5-d15b-4e87-89b6-117b186a1e6f.png`

### 8) `/trackingOrder` — BLOCK
- Blank gray screen (hard failure, no fallback/error UI).
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\e829bf20-379c-436d-9d7b-ebc9d4248e2b.png`

### 9) `/purchaseOrder` — WARN
- Purchase order table renders.
- Potential stale/static date and repeated rows reduce confidence in data correctness.
- Delete action discoverability/guard appears weak.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\9680fdf1-cb3a-4844-8b53-beaf701fb096.png`

### 10) `/editInventory` — WARN
- Edit form renders.
- Required vs optional not explicit; expiry toggle default may create accidental semantics.
- No visible conflict/last-updated cues to prevent stale overwrite.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\1c23bcee-de0a-428a-b749-7752254f1f88.png`

### 11) `/uploadCarousell` — WARN
- Upload form available.
- Validation semantics inconsistent; file constraints and posting safeguards not explicit.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\5e7130e0-4664-4531-9465-3f73cbb6bc38.png`

### 12) `/carousellUpdate` — WARN
- Buying/Selling tables render.
- Action affordances rely heavily on icon color/sign without explicit labels; `N/A` source states unclarified.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\0c512bf5-eaeb-4a23-9bec-58618e128143.png`

### 13) `/itemMovementHistory` — WARN
- History page renders but opens with `ID: 0` and empty branch context.
- Empty-state appears even when context likely missing; route contract not strongly guarded.
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\746cb5fd-b077-43d5-b349-f1ad56bf1afd.png`

### 14) `/cart` — BLOCK
- Blank gray screen (hard failure, no fallback/error UI).
- Revert status: No mutation.
- Evidence: `C:\Users\User\.openclaw\media\browser\9833a599-c67c-4014-a2b4-fc9005fce808.png`

---

## Architecture review (critical)

### A) Route parameter safety is brittle (causes blank screens)
- `tracking_order_widget.dart` force-unwraps optional URL:
  - `widget!.url!` (line ~126)
- `cart_widget.dart` constructor marks many nullable fields as required, then force-unwraps:
  - e.g., `widget!.image!` (line ~107)
- In `nav.dart`, direct route builders pass query params that may be absent; there is no defensive fallback screen.

**Impact:** direct deep-links or malformed navigation payload can crash build and produce gray blank pages (`/trackingOrder`, `/cart`).

**Recommendation:**
1. Introduce route-level guard (`if required params missing => error scaffold + safe back CTA`).
2. Remove force unwrap on user-supplied route fields.
3. Add typed route DTO + validator for each page requiring payload.

### B) Role-routing/auth architecture is still hardcoded
- `login_model.dart` routes all successful logins to HQ:
  - `context.goNamed(DashboardHQWidget.routeName);`

**Impact:** role-blind landing and wrong-home-route risk for AM/DSA.

**Recommendation:** centralized route resolver based on canonical role/access map and backend-provided home route key where possible.

### C) Validation gate debt on login submit
- `login_widget.dart` submit button calls API directly on press (no explicit pre-submit `FormState.validate` gate).
- Dual autofocus still present for email and password fields in same screen.

**Impact:** avoidable backend calls, inconsistent keyboard focus behavior, poorer UX resilience.

**Recommendation:** enforce single-focus policy + explicit local validation gate before any auth call.

### D) Data contract hygiene gaps surfaced in UI
- `Branch: null`, duplicate items, `ID: 0` defaults, mixed domain cards in Carousell view.

**Impact:** user trust erosion, higher operator error risk.

**Recommendation:**
1. Introduce frontend contract normalizer (null-to-empty humanized transforms only after schema validation).
2. Block rendering of impossible business states unless flagged with explicit warning badge.
3. Add telemetry for invalid payload shape counts per route.

---

## Backend-side effect risk (from frontend behavior)
Although no mutations were executed in this run, current UI patterns suggest elevated risk if users proceed:
- Destructive icons are prominent with uncertain confirmation affordance.
- Forms allow ambiguous/incomplete first-state context (`null`/missing identity).
- Route payload assumptions may send malformed request context after partial navigation.

**Mitigation ideas:**
- idempotency keys for mutation endpoints,
- deterministic confirmation dialogs with pre/post snapshots,
- optimistic UI only with explicit rollback hooks.

---

## Redundancy and improvement opportunities
1. Create shared `SafeRouteScaffold` for missing parameter / empty context handling.
2. Extract form field components with unified required markers and validator rendering.
3. Standardize action buttons: icon + text + risk tier (normal/warn/destructive).
4. Add a page-level `data freshness` badge for KPI and lists.
5. Add route smoke tests in CI for all named routes with empty and valid parameter permutations.

---

## Final verdict
- Sequential frontend-live QA route pass completed.
- Two hard blockers must be fixed before production confidence (`/trackingOrder`, `/cart` blank-screen paths).
- Architecture debt around route safety, role routing, and validation gates remains high-priority.

## Live mutation + revert statement
- **No live create/update/delete action executed during this pass.**
- **Therefore no revert action was required, and there are no residual test mutations from this run.**
