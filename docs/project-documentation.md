# Aiventory Project Documentation

## Purpose

Aiventory is a Flutter mobile and web client for internal inventory operations across multiple branches. Based on the current codebase, the app covers four business areas:

- branch-scoped inventory visibility
- purchase and transfer ordering
- stock receiving and stock-out movement tracking
- an internal "Carousell" workflow for selling or requesting stock between branches

This document is derived from the current implementation in `C:\Programming\aiventory\lib`, not from external product documentation.

## Current Product Shape

The app appears to be built for an organization with branch-based operations and a privileged HQ branch. The string `AI Venture` is used in the UI as the branch with elevated access, especially for branch switching and inventory administration.

At a high level:

- normal users operate within a branch context
- the app preloads user, branch, category, and inventory data after login
- inventory listings are tracked separately from inventory master data
- order status changes and stock movements are persisted through Xano APIs
- the Carousell module is a separate branch-to-branch marketplace workflow on top of inventory

## Tech Stack

- Flutter application generated largely from FlutterFlow
- navigation via `go_router`
- app state via `FFAppState` and `provider`
- local persistence via `shared_preferences`
- backend APIs hosted on Xano
- inventory image upload also uses a Google Cloud Function endpoint
- barcode and QR scanning supported in the client

## Application Structure

Primary source directories:

- `C:\Programming\aiventory\lib\main.dart` - app bootstrap and shell
- `C:\Programming\aiventory\lib\flutter_flow\nav\nav.dart` - route registry
- `C:\Programming\aiventory\lib\app_state.dart` - global persisted and in-memory app state
- `C:\Programming\aiventory\lib\backend\api_requests\api_calls.dart` - API client definitions
- `C:\Programming\aiventory\lib\backend\schema\structs` - API/domain structs
- `C:\Programming\aiventory\lib\components` - reusable modal and widget flows

## Startup And Authentication Flow

1. App starts in `main.dart` and initializes `FFAppState`.
2. Router decides whether to show splash/login or the main app.
3. Login uses the auth API and stores the bearer token in app state.
4. After login, the app calls `auth/me`.
5. During bootstrap, the app also loads:
   - inventory master list
   - branch list
   - inventory categories
6. The current branch and branch id are resolved from the logged-in user.
7. The user is navigated to the dashboard tab.

Operational implication: much of the app depends on the initial preload finishing successfully. If preload is stale or partial, several screens will have degraded behavior because they read from `FFAppState`.

## Main Navigation

The bottom navigation currently exposes six primary tabs:

1. Dashboard
2. Find Inventory
3. Stock In
4. Order
5. Order List
6. Carousell

Additional routed screens exist outside the main tab shell:

- Tracking Order
- Purchase Order
- Login
- Edit Inventory
- Upload Carousell
- Carousell Update
- Item Movement History
- Cart

## Screen-By-Screen Map

### 1. Login

Purpose:

- authenticate the user
- establish user branch context
- preload core reference data

Key outputs:

- bearer token
- user profile
- branch list
- inventory categories
- inventory cache

### 2. Dashboard

Purpose:

- provide branch or HQ operational metrics

Main metrics:

- total inventory
- order count
- late orders
- expiring items

Behavior:

- if the current branch is `AI Venture`, the UI exposes a branch switcher
- non-HQ branches appear to view metrics in their own scope
- HQ users can launch add/edit inventory flows from here

### 3. Find Inventory

Purpose:

- search branch inventory listings
- filter paged stock records
- view movement history
- initiate ordering
- initiate stock-out
- edit inventory for HQ/admin users

Important distinction:

- inventory master data describes the item itself
- inventory listing data describes branch-level stock position, expiry, unit, and on-hand quantities

Primary actions:

- search items
- filter expiring stock
- open item movement history
- add order
- stock out
- open edit inventory

### 4. Stock In

Purpose:

- receive inventory into stock
- optionally receive against an existing order

Capabilities:

- scan QR code to identify item by barcode
- capture received quantity and cost data
- upload supporting files
- write inventory movement records
- mark related orders as `received`

This is one of the core transaction screens in the app.

### 5. Order

Purpose:

- create a new order from inventory items

Behavior:

- item selection is seeded from the cached inventory master list
- submitting an order updates order status immediately
- status depends on order channel:
  - `HQ Order` -> `submitted`
  - other channels -> `ordered`

This suggests the order screen is being used for both internal HQ approval flows and direct procurement flows.

### 6. Order List

Purpose:

- view operational orders
- filter by recent days and active statuses
- approve, process, cancel, roll back, or receive orders
- open stock-in flow from an order
- open tracking timeline

Observed statuses in use:

- `submitted`
- `ordered`
- `approved`
- `pending`
- `pending_payment`
- `processed`
- `received`
- `canceled` or `cancelled`

Implementation note:

The codebase currently uses both `canceled` and `cancelled`. That is a data consistency risk if the backend treats them differently.

### 7. Tracking Order

Purpose:

- show item-level order context and a visual status flow

Behavior:

- consumes route parameters and state built before navigation
- uses custom ordering logic from `custom_functions.dart`

This is primarily a detail/timeline view, not a transactional screen.

### 8. Purchase Order

Purpose:

- intended purchase order screen

Current state:

- routed and visible in the codebase
- appears incomplete or placeholder
- button handlers still contain print statements rather than production actions

Treat this as non-operational until verified otherwise.

### 9. Edit Inventory

Purpose:

- edit inventory master data

Capabilities:

- fetch an existing inventory item by id
- edit barcode, supplier, unit ratios, price, remarks, and expiry settings
- scan barcode
- upload image
- save changes back to the backend

This is administrative/master-data maintenance, distinct from stock transactions.

### 10. Item Movement History

Purpose:

- show paginated stock movement history for a selected item

Capabilities:

- page through history records
- delete movement entries

This is a high-impact screen because deleting movement history can alter inventory auditability.

### 11. Carousell

Purpose:

- browse internal branch-to-branch listings

Listing types:

- `Selling`
- `Request`

Capabilities:

- list and filter carousell entries
- open upload flow
- open status/update flow
- open cart/transaction flow

Operational interpretation:

This is not public e-commerce. It is an internal transfer or resale/request channel for inventory between branches.

### 12. Upload Carousell

Purpose:

- create a Carousell listing

Capabilities:

- choose inventory
- choose listing type
- set price/quantity
- upload image
- optionally set expiry details for selling items with expiry tracking

### 13. Cart

Purpose:

- convert a listing into a branch-to-branch transaction

Capabilities:

- choose quantity
- choose delivery method
- compute total cost
- create carousell movement record

Behavior:

- branch source and destination flip based on whether the listing is `Selling` or `Request`
- action label changes between `Buy Now` and `Sell Now`

### 14. Carousell Update

Purpose:

- operational queue for in-progress Carousell transactions

Capabilities:

- separate buy-side and sell-side views
- update transaction state
- mark receipt or cancellation

This is effectively the fulfillment screen for Carousell deals.

### 15. Stock Out Modal

Purpose:

- reduce stock and record outbound movement

Behavior:

- posts an inventory movement with negative quantity
- writes transaction type `Stock Out`

## Core Business Workflows

### Inventory Visibility

1. User logs in.
2. App preloads inventory master data and branch metadata.
3. Find Inventory screen fetches branch inventory listings with pagination.
4. User drills into movement history, stock out, or ordering.

### Order Lifecycle

1. User creates order from inventory item.
2. Initial status becomes `submitted` or `ordered`.
3. Order List drives approval and process transitions.
4. Stock In can be launched from the order.
5. Receiving inventory writes movement records and updates order to `received`.

### Stock Receiving

1. User opens Stock In directly or from an order.
2. Item is selected manually or by scan.
3. Quantity and file attachments are submitted.
4. Backend records an inventory movement.
5. If linked to an order, the order status is updated.

### Stock Out

1. User chooses an item in Find Inventory.
2. Stock Out modal submits a negative movement.
3. Listing history should reflect the deduction.

### Carousell Transaction

1. User creates a `Selling` or `Request` listing.
2. Another branch opens the listing in Cart.
3. Cart creates a Carousell movement record.
4. Carousell Update screen manages in-progress fulfillment.
5. Seller or buyer updates the transaction to received or cancelled.

## Backend API Map

Primary backend patterns are defined in `api_calls.dart`.

### Inventory

- `GET /inventory_barcode` - find item by barcode
- `GET /inventory` - inventory master list
- `PUT /inventory` - edit inventory
- `GET /inventory/{id}` - get one inventory item

### Authentication

- `POST /auth/login`
- `GET /auth/me`

### Inventory Listing

- `GET /inventory_listing` - paged branch inventory listing
- `GET /inventory_listing_expiring_count`

### Inventory Movement

- `GET /inventory_movement`
- `POST /inventory_movement`
- `GET /item_history`
- `DELETE /item_movement_delete`

### Orders

- `GET /order/{id}`
- `POST /order_lists`
- `PUT /order_list_status`

### Reference Data

- `GET /inventory_category_list`
- `GET /branch_list_basic`

### Dashboard

- `GET /dashboard_inventory_hq`

### Carousell

- `GET /inventory_carousell`
- `POST /inventory_carousell`
- `POST /inventory_carousell_movement`
- `GET /inventory_carousell_movement`
- `PUT /inventory_carousell_movement`

### Uploads

- `POST /uploadFile_inventory`
- Google Cloud Function `upload_image`

## Backend Topology

The code uses two Xano API namespaces:

- `api:s4bMNy03`
- `api:0o-ZhGP6`

Most business endpoints use the first namespace. Some listing and history endpoints use the second namespace. That split should be documented by the backend team because it adds maintenance overhead and may indicate multiple backend versions or workspaces.

## Data Model Overview

### User

Important fields observed:

- id
- branch
- role
- access
- accessList

Role and access checks appear to be partly data-driven and partly branch-name driven.

### Branch

Important fields observed:

- id
- branch

The client stores both branch name and branch id and uses them in many flows.

### Inventory

Represents item master data. Important attributes include:

- item name
- category
- supplier
- barcode
- image
- unit information and ratios
- pricing
- expiry support

### Inventory Listing

Represents branch stock position for an inventory item. Important attributes include:

- branch id
- inventory id
- expiry date
- quantity on hand
- quantity reserved
- average unit cost
- unit
- nested inventory metadata

### Inventory Movement

Represents stock transaction history. Important attributes include:

- inventory id
- quantity delta
- transaction type
- attachments
- related metadata such as branch and cost fields

### Order List

Represents operational order data. Important attributes include:

- order id
- item and quantity fields
- branch context
- status flow/history
- remarks and pricing fields

### Dashboard Data

Current dashboard aggregate payload contains:

- total inventory
- order count
- late orders
- expiring items

### Carousell

Represents a marketplace listing. Important attributes include:

- branch and branch id
- inventory reference
- type
- image
- quantity fields
- cost fields
- expiry date
- category and supplier

### Carousell Movement

Represents a transaction created from a Carousell listing. Important attributes include:

- listing reference
- from/to branch ids
- quantity
- delivery method
- buyer/seller flags
- status

## Global State Model

`FFAppState` functions as the central client-side store. It holds:

- auth token
- current branch and branch ids
- current user
- cached inventory list
- cached branch list
- cached categories
- current dashboard data
- chosen inventory and chosen order objects
- order lists and carousell lists

This makes screen transitions easy, but it also means:

- stale state can leak across screens
- app reload behavior matters
- hidden coupling exists between screens that assume certain cached values already exist

## Custom Logic Worth Knowing

`custom_functions.dart` contains business-significant logic:

- timestamp conversion helpers
- `orderListOrganize()` for building ordered status timelines
- `dayDifference()` for age-based order filtering

These functions are small, but they directly influence what users see in operational status views.

## Known Risks And Gaps

1. Documentation is currently reverse-engineered from code, not validated with product owners.
2. `PurchaseOrder` appears incomplete.
3. The repo only contains the default Flutter smoke test.
4. Global app state is broad and tightly coupled to screen behavior.
5. HQ behavior is partially encoded by branch name string comparisons.
6. Order cancellation spelling is inconsistent: `canceled` and `cancelled`.
7. Multiple API namespaces are used without in-repo explanation.
8. Deleting movement history is available in the UI and may need stronger guardrails or audit controls.

## Recommended Next Documentation Work

1. confirm business terminology with the product owner
2. document the canonical order status state machine
3. document the backend contract for each API group
4. identify which files are safe to regenerate from FlutterFlow and which contain business logic that must be preserved
5. add setup and test instructions once the team standardizes local development flow

