# Legacy linked Stock In receipt contract

This adapter is for the legacy authenticated `POST inventory_movement` and `PUT order_list_status` graphs only. It does not modify NEXT arrival acknowledgement or receipt-confirmation routes.

## Receipt ownership and compatibility

- Every successful **linked Stock In** owns the movement, actual received quantity, receipt timestamp, authenticated actor and stock projection in one native transaction. Unlinked/manual movement retains its original graph.
- Partial quantity accumulates and stays `ordered`; fulfillment of the ordered quantity sets `received`. No order quantity is guessed from a status request or historical movement.
- An existing-order legacy `status=received` request is a read-only/no-op response of the current order, with `receipt_status_changed:false` and reason `LINKED_STOCK_IN_TRANSACTION_OWNS_RECEIPT`. It cannot create receipt state before, after or while a movement fails.
- The no-op intercept is **before** the original generic edit; guarding only the nested received-audit branch is insufficient.
- Stable actor + `updates.timestamp` identifies retries; identical payload returns its original movement. Changed payload conflicts. Existing untracked movement requires reconciliation, never an automatic historical backfill.
- Existing-ID non-received statuses, new-order creation, authentication, input descriptors and response contracts outside this no-op are preserved from the current native before-image.

The legacy Flutter Stock In screen sends the movement and received-status requests concurrently. The generic legacy status editor also offers `received` with the same request shape. These calls cannot be distinguished reliably. Under the approved rule that legacy Received means direct Stock In, **neither status-only call may invent receipt state**. The editor receives the actual unchanged order rather than a false changed-status result. Other editor statuses keep their original implementation. NEXT consumers use separate APIs and are not reclassified as direct Stock In.

## Verification

Focused, pure/generated-graph suite:

```sh
LEGACY_NATIVE_FIXTURE_DIR=/private/native-before-images node --test test/legacy_stockin_receipt.test.cjs
```

Explicitly authorized synthetic PostgreSQL regression runner:

```sh
LEGACY_NATIVE_FIXTURE_DIR=/private/native-before-images \
LEGACY_DB_ACCESS_MODULE=/private/existing-approved-access.cjs \
node test/legacy_stockin_receipt.postgres.cjs --allow-synthetic-qa --sql-only
```

The private access module must expose `client(write)` and `req(path)`. The fixture directory contains the retained exact definitions and receives the restricted mutation ledger/proof. The runner creates only marker-owned synthetic inventory/orders/movements, uses two independent database sessions, waits for a proven lock wait on the owned request PID, and deletes exact ledger IDs afterward. It exercises emitted planner and SQL, duplicate/distinct concurrent requests, both status/movement orderings, rejection, and failure after movement/receipt writes. It does **not** exercise native stock projection or canonical HTTP and must not be described as doing so. Without `--sql-only`, it additionally requires fresh unchanged canonical definitions before running. SQL-only proof cannot authorize publication.

Publication is a separate exact-resource step: fresh before-image equality, source-hash-pinned passing race/rollback proof, native acceptance, independent exact readback, canonical authenticated synthetic HTTP acceptance, NEXT preservation and exact cleanup are required. A source commit is not deployment. No real order replay or historical repair is part of this change.

## Scoped release evidence

The approved authoritative contract was published only to legacy definitions 1102 and 678. Focused suite: 16 passing tests; emitted READ/UPDATE SQL: 9 assertions on temporary transaction-local copies; two-session PostgreSQL: 8 race/rollback/idempotency gates. Authenticated canonical synthetic HTTP proves status-first plus rejected movement makes no receipt, partial and full persisted movement derives actual receipt quantity/audit, late status cannot overwrite, identical retry inserts once, and expiry-present movement preserves linkage/type/unit/cost. Independent exact readback preserves authentication/inputs and full NEXT definitions 4164/4173; fresh-connection exact fixture residue checks are zero.

Limits: no installed-client/browser test or historical repair. Existing function82 projection was preserved and executed, not redesigned. The synthetic two-receipt run produced three stock-listing rows (including a repeated movement-linked row); do not interpret this scoped receipt release as proof of aggregate projection correctness. That pre-existing projection behavior needs a separate scoped investigation if requested. Restricted operational receipts are kept outside Git in the task QA artifact directory.
