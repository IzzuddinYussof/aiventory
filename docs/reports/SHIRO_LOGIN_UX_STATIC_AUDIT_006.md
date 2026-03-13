# SHIRO_LOGIN_UX_STATIC_AUDIT_006

## Scope
Static UX/frontend audit on login flow based on source inspection (no live API mutation, no test data touched).

Files reviewed:
- `lib/login/login_widget.dart`
- `lib/login/login_model.dart`
- `lib/backend/schema/structs/user_struct.dart`

## Findings

### 1) High - Role-blind post-login redirect
- Evidence:
  - `login_model.dart:125` -> `context.goNamed(DashboardHQWidget.routeName);`
  - `user_struct.dart` contains `role`, `access`, `accessList` fields, but redirect path does not branch by these fields.
- UX impact:
  - AM/DSA users risk landing on wrong first screen.
  - Wrong-information architecture for non-HQ users; potential permission mismatch confusion.
- Recommendation:
  - Add role/access routing map after `authMe` success (HQ/AM/DSA specific home routes).
  - Add safe fallback page for unknown role and explicit message.

### 2) Medium - Dual autofocus causes focus instability
- Evidence:
  - `login_widget.dart:233` email field `autofocus: true`
  - `login_widget.dart:356` password field `autofocus: true`
- UX impact:
  - Competing autofocus targets can cause inconsistent first focus, especially web/desktop keyboard flow.
  - Accessibility friction for screen-reader and tab-first users.
- Recommendation:
  - Keep autofocus only on email field.
  - Ensure tab order deterministic (email -> password -> Sign In).

### 3) Medium - Missing client-side validation before submit
- Evidence:
  - Login call is fired directly on button press (`login_widget.dart:496`) without local required/email-format guard and without enclosing `Form` validation gate.
- UX impact:
  - Empty/invalid inputs go straight to API, then user only gets generic dialog.
  - Extra unnecessary backend requests and weaker inline guidance.
- Recommendation:
  - Wrap fields with `Form` + `GlobalKey<FormState>`.
  - Add validators: required email, valid email format, required password.
  - Block submit until valid; show inline field errors instead of only modal dialog.

## Notes
- Existing loading overlay (`_isLoading`) is good baseline for double-submit prevention.
- This run intentionally avoided duplicate bootstrap rerun; focus is new static UX signal extraction aligned with active role-flow preparation.

## Data/Revert
- Data touched: No
- API touched: No live API mutation
- Revert required: No
