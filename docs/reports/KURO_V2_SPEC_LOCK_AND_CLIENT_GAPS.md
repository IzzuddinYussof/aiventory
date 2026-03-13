# KURO - V2 Spec Lock + Client Gaps (Proposal Only)

Timestamp: 2026-03-12 00:08 (Asia/Kuala_Lumpur)
Scope: Static backend/client audit only. No live API changes, no runtime API calls.

## A) Spec Lock Decisions (to unblock execution)

These decisions resolve the 4 open ambiguities raised by Hitokiri/Shiro and are consistent with existing v2 contract intent.

1) Invalid `expiry_date` status policy
- Decision: Return `422` with `code="invalid_expiry_date"` for semantically invalid date values.
- Keep `400 validation_error` for missing/shape/type-level failures.
- Rationale: clearer client branching; avoids overloading generic validation bucket.

2) Idempotency behavior after 24h retention
- Decision: after retention expiry, same `Idempotency-Key` is treated as NEW request (no replay guarantee).
- Response behavior:
  - if business state still allows create -> normal `201 created`.
  - if business state conflicts -> domain error as usual (not `idempotency_conflict` unless key still within window).
- Recommendation: expose `idempotency.retention_seconds` in success responses (already in draft).

3) Auth policy for `GET /v2/system/platform_support`
- Decision: require `Authorization` in production app path (`401 unauthorized` if absent/invalid).
- Optional exception: allow anonymous access only for public web landing route if explicitly split to `/v2/public/platform_support`.
- Rationale: avoid leaking internal rollout/version policy and keep behavior aligned with internal app endpoints.

4) Checksum canonicalization reference for `/v2/inventory_movement`
- Decision: canonical payload = JSON object with fixed field order and normalized scalars before SHA-256.
- Proposed canonical key order:
  1. inventory_id
  2. branch_id_from
  3. branch_id_to
  4. tx_type
  5. quantity
  6. unit
  7. unit_cost
  8. total_cost
  9. expiry_date
  10. order_list_id
  11. doc
  12. note
- Normalization rules:
  - trim strings, lowercase enum-like fields (`tx_type`, `unit`),
  - decimal normalized to fixed precision (example 6 d.p.),
  - null and empty-string policy must be explicit per field (recommended: serialize null as null, not empty string).

---

## B) Additional Client Gaps Found in `api_calls.dart`

1) `NotifyAlertGroup.headers` structure is non-standard and likely unusable
- Current shape:
  - `{'Key': 'Authorization', 'Value': 'Bearer [token]'}`
- Risk: caller expects direct header map (`{'Authorization': 'Bearer ...'}`), so this template may never apply correctly.
- Proposal: replace with standard header contract in v2-ready call wrappers.

2) `UploadImageInventoryCall.parentFolderId` is declared but not used in request params
- Risk: caller thinks folder target is configurable but server never receives it.
- Proposal: either wire `parent_folder_id` param or remove misleading argument.

3) Auth inconsistency across business endpoints remains high
- Many write/read business endpoints pass empty headers despite authenticated domain context.
- Proposal: for new `/v2/*`, enforce explicit bearer auth requirement and reject unauthenticated calls by policy.

---

## C) Non-live rollout recommendation

1. Freeze these decisions into a single v2 schema artifact (OpenAPI/JSON schema).
2. Publish mock/staging URL + seed/cleanup hooks.
3. Let Hitokiri execute contract pack against mock/staging.
4. Let Shiro run thin-client parser and UX assertion checks against real error payloads.

No live API modified in this run.
