# SIM_LOGIN_FLOW_LIVE

Generated: 2026-03-12T05:56:11.777Z

## 1) Login (valid credentials)
- status: 200
- ok: true
- has authToken: true
- token (masked): eyJhbGciOi...ytlJ8s

## 2) auth/me using token
- status: 200
- ok: true
- user branch: N/A
- user access: N/A

## 3) Bootstrap GET calls
- /inventory: status 200, count 897
- /branch_list_basic: status 200, count 12
- /inventory_category_list: status 200, count 14

## 4) Wrong email test
- status: 403
- ok: false
- response message: Email not found

## 5) App flow simulation notes
- Token was stored in simulated state object and used for auth/me.
- Derived branch mapping by matching authMe.branch against branch_list_basic.label.
- Full raw responses are saved in docs/SIM_LOGIN_FLOW_LIVE.json.
