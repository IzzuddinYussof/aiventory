# KURO Auth Injection Path Audit 005 (Static, Non-Live)

Date: 2026-03-12 00:55 (Asia/Kuala_Lumpur)
Scope: `lib/backend/api_requests/api_manager.dart`, `lib/backend/api_requests/api_calls.dart`
Mode: static analysis only (no live API calls, no code mutation)

## Executive Summary
Auth behavior in current generated client is internally inconsistent:
1) `ApiManager` contains a global bearer injection hook (`_accessToken`), but no setter/public mutator exists, so this path appears unreachable from app code.
2) Only `AutMeCall` explicitly passes `Authorization` header via argument token.
3) Most API calls provide empty headers and therefore rely on either public endpoints or currently-dead global token path.

This creates contract ambiguity for any endpoint intended to be protected.

## Evidence
- `api_manager.dart` defines private token store only:
  - `static String? _accessToken;` (line ~256)
- `makeApiCall` injects header only if private token is non-null:
  - `headers[HttpHeaders.authorizationHeader] = 'Bearer $_accessToken';` (line ~522-523)
- No setter/reset API exists in `ApiManager` for `_accessToken`.
- `AutMeCall` uniquely sets `Authorization` directly in call headers from parameter token (`api_calls.dart`, auth group section).
- Remaining call wrappers mostly pass `headers: {}`.

## Risk Assessment
- Severity: High (for protected-route reliability)
- Impact:
  - Protected endpoints can silently behave as unauthenticated if backend expects bearer from global path.
  - Test assertions may be flaky across sessions if token routing is mixed (explicit per-call vs implicit global).
  - Increases false assumptions that "auth is handled centrally" while implementation is effectively partial.

## Proposed Resolution (No live API modification)
1) Lock v2 auth policy matrix explicitly per endpoint (required/optional/public) and publish as backend spec artifact.
2) For v2 client contract, select one strategy only:
   - explicit per-call token header, OR
   - centralized token middleware with reachable setter API.
3) Introduce v2 diagnostic endpoint proposal (new endpoint, non-breaking):
   - `GET /v2/system/auth_probe`
   - Returns normalized auth interpretation (`authenticated`, `subject_id`, `auth_source`, `request_id`) to validate header propagation deterministically in test env.
4) Extend HKT execution pack with auth-source assertions once mock/staging exposes v2 probe.

## Status
- Documentation/report only.
- No code changes, no API execution, no test data mutation.
