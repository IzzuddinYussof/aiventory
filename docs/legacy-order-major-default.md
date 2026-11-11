# Legacy new-order major-unit default

The legacy new-order writer now obtains the selected catalog item's canonical
`quantity_major` using the same `inventory_id` binding as the order insert.
It records a creation-time `recording_unit` snapshot and
`recording_unit_mode = "major"`.

This is backend-only. There are no client input, UI, amount, quantity, branch,
price, role, notification, update, approval or receiving changes. Quantities are
not converted. Incoming extra unit fields cannot override the canonical label.
Missing items or blank/non-text major labels fail with a standard input-error
precondition before insertion, without falling back to the minor unit.
Existing orders are not backfilled or relabeled.

## Maintained source

- `scripts/legacy_order_major_default.cjs`: inert native-graph adapter.
  It changes only the existing new-create branch, adding a canonical item lookup,
  unit resolver, precondition and two insert bindings. `reverse()` provides an
  exact preservation check. It contains no publisher, credentials or network I/O.
- `scripts/test_legacy_order_major_default.cjs`: executes captured actual native
  nodes with isolated database adapters. It also proves preservation of the full
  unrelated graph and NEXT writer. Existing-order paths are proven by exact
  subtree equality and branch selection, not re-executed production updates.

Private full resource backups must never be committed. To rerun against an
operator's restricted evidence directory containing `before-678.json` and
`before-4164.json`:

```sh
LEGACY_MAJOR_EVIDENCE=/path/to/private/evidence \
  node scripts/test_legacy_order_major_default.cjs
```

Set `LEGACY_MAJOR_GRAPH` to an independently read-back native graph to test the
published definition. Optional `after-4164.json` is compared byte-for-byte as a
parsed graph against the prior NEXT definition.

## Verification and limits

The authorized backend publication was independently read back on 2026-11-11.
All 25 isolated cases passed again using the published graph. Removing only the
scoped additions recovered the original full executable graph. Authentication,
inputs, result, unrelated metadata, NEXT writer, order schema, four observed
catalog records and six protected existing orders were unchanged.

No frontend build or deployment was required. No live test purchase, Stock-in,
stock mutation or existing-order edit was performed. This proves isolated actual
writer logic and published-definition parity, not a live positive HTTP creation.
Persisted-row acceptance should use the user's next normal legitimate order.
