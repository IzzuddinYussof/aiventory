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

