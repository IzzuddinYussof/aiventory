# KURO Client Request Shape Audit 004

Timestamp: 2026-03-12 00:38 (Asia/Kuala_Lumpur)
Scope: Static-only backend/client contract audit on `lib/backend/api_requests/api_calls.dart` (no live API calls, no code mutation)

## Summary
Audit ini fokus pada request-shape risk yang boleh sebabkan backend menerima payload salah tanpa frontend nampak error jelas.

## New Findings

### 1) "Quoted-null" payload risk in JSON template bodies (High)
Affected blocks:
- `InventoryMovementPostCall` (`updates.name`, `updates.branch`, `branch`, `expiry_date`, `unit`, `tx_type`, `note`, `doc`)
- `CarousellPostCall` (`branch`, `image_url`, `unit`, `expiry`, `remark`, `type`)
- `ItemMovementDeleteCall` (`inventory_movement_id`, `inventory_id`, `branch`, `expiry_date`)
- `OrderListsCall` / `OrderStatusUpdateCall` string fields

Pattern used:
```dart
"field": "${escapeStringForJson(value)}"
```
`escapeStringForJson(null)` returns `null`, but because interpolation is wrapped by quotes, final JSON becomes string literal `"null"` instead of JSON `null`.

Impact:
- Backend validation may pass wrong semantic value (`"null"`) and silently store bad data.
- Contract assertions for v2 endpoint behavior can be noisy due to type ambiguity.

Proposal (v2 contract rule):
- Enforce strict nullable handling: null should serialize as JSON null (no quotes), not string.
- Add server-side reject rule for known nullable-string anti-pattern (`"null"`, `"undefined"`, empty string for required fields).

---

### 2) Mixed transport style (JSON vs multipart) without explicit contract boundary (Medium)
Observed:
- Some create/update calls use JSON body (`inventoryMovementPost`, `orderStatusUpdate`).
- Others use multipart params for non-file payloads (`login`, `carousellMovementPost`, `carousellMovementPut`).

Impact:
- Harder to standardize auth middleware, signature/checksum, and error handling.
- Increases risk for parser mismatch when v2 rollout begins.

Proposal:
- Document transport contract per endpoint in v2 matrix.
- Prefer JSON for non-file business payload endpoints in v2.

---

### 3) Auth coverage ambiguity remains broad (Medium)
Observed:
- Only `autMe` sends `Authorization` header explicitly.
- Business endpoints rely on unknown lower-layer behavior.

Impact:
- Security posture unclear; potential unauthorized access if backend policy drift occurs.

Proposal:
- Publish endpoint-level auth policy map in `/v2/system/platform_support` or companion metadata endpoint.
- Hitokiri execution should include mandatory `401/403` assertions for every protected v2 endpoint.

---

## Link to Existing Findings
This audit extends prior items (hardcoded expiry, checksum omission, namespace split, malformed header map, unused parentFolderId). No contradictions found.

## Handoffs
- Hitokiri: Add explicit test cases for quoted-null rejection and nullable-field type enforcement.
- Shiro: Ensure frontend serializer/parser never emits string literal `"null"` for optional fields in v2 clients.

## Safety/Mutation Log
- Live API: untouched
- Test data: none
- Revert required: none
