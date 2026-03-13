# HITOKIRI Test Design - V2 API Contract Coverage

Timestamp: 2026-03-11 23:20 (Asia/Kuala_Lumpur)
Author: Lisa (Hitokiri)

## Scope
Design test coverage for proposed NEW endpoints only (no live API mutation):
- `POST /v2/inventory_movement`
- `POST /v2/inventory_carousell`
- `GET /v2/system/platform_support`

## 1) Test Matrix - POST /v2/inventory_movement

### Functional happy path
- HKT-V2-MOV-001: valid movement request with unique `idempotency_key` returns success + movement id.
- HKT-V2-MOV-002: same payload + same key replay returns duplicate-safe response (same movement id, no double-write).

### Validation
- HKT-V2-MOV-003: missing `idempotency_key` rejected (4xx).
- HKT-V2-MOV-004: malformed/short key rejected.
- HKT-V2-MOV-005: invalid quantity (zero/negative/non-numeric) rejected.
- HKT-V2-MOV-006: missing required fields (`item_id`, `from_location`, `to_location`, `quantity`, `movement_type`) rejected with field-level error detail.

### Consistency + integrity
- HKT-V2-MOV-007: checksum mismatch (if checksum provided) rejected deterministically.
- HKT-V2-MOV-008: concurrent duplicate submission (parallel request, same key) must not create duplicate movement rows.
- HKT-V2-MOV-009: same payload but different keys creates distinct movements (expected exactly 2 rows).

### Security/contract behavior
- HKT-V2-MOV-010: unauthorized call denied per policy.
- HKT-V2-MOV-011: forbidden role denied (if role-based policy exists).
- HKT-V2-MOV-012: response must not leak internal stack trace/DB internals.

## 2) Test Matrix - POST /v2/inventory_carousell

### Functional happy path
- HKT-V2-CAR-001: valid payload with ISO `expiry_date` accepted.

### Validation
- HKT-V2-CAR-002: hardcoded stale date pattern (e.g. `2025-05-05`) still accepted only if semantically valid by business rules; else reject with reason.
- HKT-V2-CAR-003: invalid date format (`DD/MM/YYYY`, text date) rejected.
- HKT-V2-CAR-004: impossible date (`2026-02-30`) rejected.
- HKT-V2-CAR-005: missing `expiry_date` rejected (if mandatory).
- HKT-V2-CAR-006: expiry in the past rejected (if policy: must be future).

### Integrity + UX-grade erroring
- HKT-V2-CAR-007: validation error returns user-safe message + machine-readable field code.
- HKT-V2-CAR-008: duplicate listing prevention behavior documented and testable.

## 3) Test Matrix - GET /v2/system/platform_support

- HKT-V2-PLT-001: endpoint returns explicit booleans/enum for web/android/ios/windows.
- HKT-V2-PLT-002: response schema stable and versioned.
- HKT-V2-PLT-003: unsupported platform value never returned silently (must be explicit false/unknown).
- HKT-V2-PLT-004: endpoint accessible at app bootstrap latency budget (target p95 to be set by backend).

## 4) Non-functional requirements to lock in spec
- Idempotency retention window (example: 24h) and collision strategy.
- Error contract standardization (`code`, `message`, `field_errors`, `request_id`).
- Observability fields (`request_id`, `idempotency_key`, timestamp) for audit trace.

## 5) Preconditions for execution
Current app UI bootstrap is blocked (blank render). Therefore this cycle is test-design only.
Execution-ready conditions:
1) API mock/staging spec published.
2) Seed dataset + cleanup contract provided.
3) Auth policy matrix declared.

## 6) Planned evidence artifacts (next run)
- API request/response captures (sanitized)
- Duplicate-submit race test logs
- Revert/cleanup proof for created test records
