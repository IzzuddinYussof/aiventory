# KURO - V2 API Contract Draft (Proposal Only)

Timestamp: 2026-03-11 23:36 (Asia/Kuala_Lumpur)
Scope: Draft NEW endpoint contracts only (no live API modification).

## Design Principles
- Versioned endpoints under `/v2/*` (parallel rollout, no breaking change to existing live APIs).
- Standardized error shape for all v2 APIs:
  - `code` (string)
  - `message` (string)
  - `field_errors` (object<string, array<string>>)
  - `request_id` (string)
- Auth requirement explicit per endpoint (`Authorization: Bearer <token>`).
- Idempotency enforced for mutation endpoints using `Idempotency-Key` header + request `checksum`.

---

## 1) POST /v2/inventory_movement

### Purpose
Create inventory movement safely with duplicate protection and deterministic replay behavior.

### Headers
- `Authorization: Bearer <token>` (required)
- `Idempotency-Key: <uuid>` (required)
- `Content-Type: application/json`

### Request Body
```json
{
  "inventory_id": 123,
  "branch_id_from": 1,
  "branch_id_to": 2,
  "branch": "AI Venture",
  "expiry_date": "2026-12-31",
  "quantity": 5.0,
  "unit": "box",
  "unit_cost": 12.5,
  "total_cost": 62.5,
  "tx_type": "stock_in",
  "note": "PO receive",
  "doc": "PO-2026-0001",
  "order_list_id": 456,
  "updates": {
    "name": "Izz",
    "timestamp": 1773272160,
    "branch": "HQ"
  },
  "checksum": "sha256:0f9a..."
}
```

### Validation Rules
- `inventory_id`, `branch_id_from`, `branch_id_to`, `quantity`, `tx_type`, `checksum` required.
- `Idempotency-Key` required and UUID format.
- `quantity` > 0.
- `tx_type` enum: `stock_in|stock_out|transfer|adjustment`.
- `expiry_date` either null/empty OR valid ISO-8601 date (`YYYY-MM-DD`).
- `checksum` must match server recomputation over canonical request fields.

### Success Response (201)
```json
{
  "request_id": "req_01J...",
  "idempotency": {
    "key": "4f8dd3c0-...",
    "replayed": false,
    "retention_seconds": 86400
  },
  "data": {
    "movement_id": 9876,
    "status": "created"
  }
}
```

### Replay Response (200)
```json
{
  "request_id": "req_01J...",
  "idempotency": {
    "key": "4f8dd3c0-...",
    "replayed": true,
    "retention_seconds": 86400
  },
  "data": {
    "movement_id": 9876,
    "status": "replayed"
  }
}
```

### Error Samples
- `400 validation_error`
- `401 unauthorized`
- `409 checksum_mismatch`
- `409 idempotency_conflict` (same key, different payload)

### Idempotency Policy (Proposed)
- Retention window: **24 hours (86400s)**.
- Key uniqueness scope: `tenant/user + endpoint`.
- Same key + same canonical payload => return stored response (replay-safe).
- Same key + different canonical payload => reject with `409 idempotency_conflict`.

---

## 2) POST /v2/inventory_carousell

### Purpose
Create carousell listing/movement record with strict expiry validation (remove hardcoded date behavior risk).

### Headers
- `Authorization: Bearer <token>` (required)
- `Content-Type: application/json`

### Request Body
```json
{
  "inventory_id": 123,
  "branch": "AI Venture",
  "branch_id": 1,
  "image_url": "https://...",
  "expiry_date": "2026-12-31",
  "initial_quantity": 10,
  "available_quantity": 10,
  "sold_quantity": 0,
  "unit": "pcs",
  "unit_cost": 5.5,
  "total_cost": 55,
  "remark": "new listing",
  "type": "supply"
}
```

### Validation Rules
- `expiry_date` required only for expiry-controlled items; if provided must be ISO date.
- Reject fixed literal/historic invalid defaults (e.g. stale constant dates).
- `available_quantity <= initial_quantity`.
- `sold_quantity >= 0` and `sold_quantity + available_quantity <= initial_quantity`.
- `type` enum: `supply|request`.

### Success Response (201)
```json
{
  "request_id": "req_01J...",
  "data": {
    "inventory_carousell_id": 4321,
    "status": "created"
  }
}
```

### Error Samples
- `400 validation_error`
- `401 unauthorized`
- `422 invalid_expiry_date`

---

## 3) GET /v2/system/platform_support

### Purpose
Expose supported client targets so frontend can gate unsupported platform paths early.

### Headers
- `Authorization: Bearer <token>` (optional by policy; recommend required for internal app)

### Query Params (optional)
- `app_version`
- `channel` (e.g., `stable|beta`)

### Success Response (200)
```json
{
  "request_id": "req_01J...",
  "data": {
    "platforms": {
      "web": true,
      "android": true,
      "ios": true,
      "windows": false,
      "macos": false,
      "linux": false
    },
    "min_supported_versions": {
      "web": "1.0.0",
      "android": "1.0.0",
      "ios": "1.0.0"
    },
    "message": "Windows desktop is currently not supported."
  }
}
```

### Error Samples
- `401 unauthorized`
- `500 internal_error`

---

## Rollout Notes
1. Keep current `/inventory_movement` and `/inventory_carousell` untouched.
2. Add dual-write/compare in staging first if needed.
3. Publish OpenAPI (or JSON schema) for Hitokiri execution pack.
4. Frontend can migrate incrementally behind feature flag.
