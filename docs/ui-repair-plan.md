# aiventory UI Repair Plan

Status: planning approved by Izz before implementation
Scope: UI/UX repair only
Non-goal: do not change business logic, routing meaning, Xano contracts, state model semantics, or transactional flows

## Objective

Upgrade `aiventory` from:
- functional-cantik / usable ops app

to:
- cantik kuat / polished internal operations product

without changing how the app fundamentally works.

## Core design target

Based on the frontend beauty rulebook, `aiventory` should become:
- operations-first
- calm
- highly legible
- clearly hierarchical
- consistent across screens
- more premium and intentional
- less FlutterFlow-generic

This is **not** a re-product strategy.
This is a UI craft pass.

## Constraints

Must NOT change:
- API request shapes
- auth flow semantics
- route names and route purposes
- branch/HQ permission behavior
- order / stock / movement logic
- cart, carousell, inventory, stock-in, and order business rules
- persisted app-state meaning in `FFAppState`
- backend integration contracts

Allowed to change:
- theme tokens
- typography
- spacing
- card/layout composition
- button/dropdown/input visual treatment
- app bars / section headers / empty states / loading states
- per-screen hierarchy and arrangement, as long as user can still do the same tasks
- icons and labels where they improve clarity without changing function
- animation intensity / timing / polish

## Rollback / safety plan

Before implementation:
1. Keep this document as the source of truth for what is being changed.
2. Make UI changes in small phases.
3. Commit each phase separately with explicit commit messages.
4. Keep a touched-file list in this doc.
5. If Izz dislikes any phase, revert that phase commit only.

Recommended commit strategy:
- Phase 0: planning + baseline notes only
- Phase 1: theme/token foundation
- Phase 2: shared shell and global component polish
- Phase 3: login + dashboard
- Phase 4: find inventory + order list
- Phase 5: stock in + order + carousell flows
- Phase 6: dialogs/forms/empty states/polish pass

## Current diagnosis

### What is already good
- clear product purpose
- task-first navigation
- consistent enough core flow
- practical screen coverage for ops work
- not shell-heavy or aesthetic-fantasy heavy

### What keeps it from being “cantik kuat”
- strong FlutterFlow-generated feel
- generic theme identity
- hierarchy too weak on large screens
- spacing rhythm not refined enough
- cards/forms/actions feel mechanically assembled rather than designed
- too many pages are visually dense without enough calm
- CTA hierarchy is often flat
- app bars and page headers are not premium enough
- dropdowns, buttons, and modals still feel template-default
- motion is present but not always tasteful

## Visual direction to move toward

`aiventory` should feel like:
- premium internal operations app
- trustworthy inventory command surface
- calm and practical, not flashy
- clean and confident
- strong enough for web and mobile

### Visual mood keywords
- operational
- composed
- clean
- efficient
- premium-light
- calm control

### Visual mood to avoid
- startup template
- generic FlutterFlow demo
- consumer-app playful
- neon / dashboard fantasy
- overdecorated SaaS look

## Proposed UI direction

### 1. Theme foundation overhaul

Primary goal:
replace the generic FlutterFlow look with a more intentional operations design system.

Specific changes:
- redefine core palette in `lib/flutter_flow/flutter_flow_theme.dart`
- move away from the current default-feeling purple/teal mix
- use a cleaner operations palette:
  - primary accent: deep turquoise / refined teal
  - secondary accent: cool slate / muted blue-gray
  - backgrounds: soft neutral off-white / cloud gray
  - cards: crisp white with subtle elevation
  - warning/error/success: calmer, more product-grade status colors
- tighten radius system:
  - less random softness
  - more deliberate hierarchy between page cards, inputs, buttons, chips
- standardize shadows:
  - softer, more premium, less “boxy mobile app”
- standardize type scale and semantic usage

Expected outcome:
- app stops feeling generic immediately
- consistency improves globally without changing flows

### 2. Typography upgrade

Primary goal:
make the app feel more mature and less generated.

Specific changes:
- keep or refine heading/body pairing so roles are clearer
- reduce repetitive `.override(...)` feeling through better theme usage where possible
- set a stronger page-title rhythm
- make labels/meta/supporting copy calmer and more secondary
- improve number/stat typography on dashboard and summary surfaces

Expected outcome:
- screen hierarchy becomes clearer
- product feels more expensive and more designed

### 3. Shared shell polish

Files likely involved:
- `lib/main.dart`
- `lib/flutter_flow/nav/nav.dart`
- theme/shared widgets

Specific changes:
- improve splash/login-to-app transition feel
- restyle bottom navigation so selected state feels more premium and easier to scan
- make page-level top areas feel more structured
- introduce a more consistent page padding rhythm
- unify section spacing across tabs

Expected outcome:
- app feels like one product, not many separate generated screens

### 4. Shared component polish

Files likely involved:
- `lib/flutter_flow/flutter_flow_widgets.dart`
- `lib/flutter_flow/flutter_flow_drop_down.dart`
- selected reusable components under `lib/components/`

Specific changes:
- redesign primary / secondary / destructive button variants
- improve dropdown treatment so filters feel cleaner and less default
- refine text fields and search bars
- standardize cards
- standardize modal/dialog look
- standardize table/list section shells
- standardize chips/status pills where appropriate
- define empty state and loading state visual rules

Expected outcome:
- repeated UI patterns start looking intentional
- screen-level repair becomes easier afterward

## Screen-by-screen change plan

### Phase 3A — Login screen

File:
- `lib/login/login_widget.dart`

Current issues:
- generic login card
- title branding too plain
- spacing okay but not premium
- lacks a stronger “inventory ops product” feel

Planned changes:
- refine branding block for `aiventory`
- improve login card composition
- stronger title/subtitle hierarchy
- calmer input styling
- better CTA prominence
- cleaner loading state
- slightly stronger desktop centering/presentation

Expected result:
- first impression becomes “real internal product”, not template login

### Phase 3B — Dashboard / HQ dashboard

File:
- `lib/dashboard_h_q/dashboard_h_q_widget.dart`

Current issues:
- too much generated density
- stats and filters likely need stronger grouping
- hierarchy flattened by repeated containers and animations

Planned changes:
- make dashboard the clearest “hero” of the app
- redesign metric cards to look more premium and easier to scan
- improve branch selector placement and hierarchy
- reduce noisy animation feeling
- make summary actions clearer
- improve card grouping and breathing room
- introduce stronger section headers for analytics vs actions

Expected result:
- dashboard feels like a control center, not just many widgets stacked

### Phase 4A — Find Inventory

File:
- `lib/find_inventory/find_inventory_widget.dart`

Current issues:
- very function-dense screen
- risk of visual overload
- search, filters, actions, results may compete too equally

Planned changes:
- make search/filter row the clear primary control area
- create stronger hierarchy between:
  - filters
  - result list/table
  - row-level actions
- improve item/result card or row styling
- make stock indicators/statuses easier to scan
- push secondary actions slightly down in emphasis
- improve pagination shell and empty/loading/error states

Expected result:
- dense screen becomes calmer without losing capability

### Phase 4B — Order List

File:
- `lib/order_list/order_list_widget.dart`

Current issues:
- multi-status workflow can easily feel cluttered
- tabs/dropdowns/lists may not have enough contrast in role

Planned changes:
- redesign page header and filter row
- improve segmented/tab hierarchy
- improve order card/list surface styling
- make status colors and status chips more readable and less noisy
- separate summary/filter/action zones more clearly
- improve action affordance for approve/process/receive/cancel flows visually only

Expected result:
- order management feels clearer and more trustworthy

### Phase 5A — Stock In

File:
- `lib/stock_in/stock_in_widget.dart`

Planned changes:
- make scan/receive workflow visually primary
- simplify supporting fields around the main task
- improve form grouping
- clearer confirmation actions
- cleaner upload/supporting evidence presentation

Expected result:
- transaction screen feels safer and easier under pressure

### Phase 5B — Order creation

File:
- `lib/order/order_widget.dart`

Planned changes:
- improve item selection hierarchy
- better summary of selected order items
- clearer separation of search vs selected items vs submit action
- make final CTA more deliberate

Expected result:
- order creation feels less crowded and easier to reason about

### Phase 5C — Carousell flows

Files:
- `lib/carousell/carousell_widget.dart`
- `lib/upload_carousell/upload_carousell_widget.dart`
- `lib/carousell_update/carousell_update_widget.dart`
- possibly `lib/cart/cart_widget.dart`

Planned changes:
- make marketplace-like flows feel cleaner and more visual
- improve item cards, image emphasis, and status clarity
- better distinction between listing/request/update states
- reduce generic generated look in dialogs/forms

Expected result:
- Carousell workflow feels like a real sub-product, not a bolt-on screen

### Phase 5D — Supporting detail screens

Files likely involved:
- `lib/tracking_order/tracking_order_widget.dart`
- `lib/item_movement_history/item_movement_history_widget.dart`
- `lib/edit_inventory/edit_inventory_widget.dart`
- `lib/purchase_order/purchase_order_widget.dart`

Planned changes:
- improve header hierarchy
- improve list/timeline/detail readability
- improve form surface quality
- unify detail screen styling with rest of app

Expected result:
- secondary flows stop feeling visually lower quality than primary flows

## Specific things that need to change

### Global visual system
- primary color system
- background/surface system
- typography hierarchy
- radii and elevation system
- button variants
- dropdown variants
- field/input variants
- chips/status presentation
- empty/loading/error state styling
- app bar/page title styling
- bottom nav styling
- card shell styling

### Layout and spacing
- page top spacing
- section spacing
- card internal spacing
- filter/action row spacing
- mobile list/card breathing room
- desktop max width behavior where needed

### Hierarchy
- stronger page hero/title areas
- clearer separation between primary and secondary actions
- better visual grouping of controls vs data
- better use of supporting text/meta text
- flatter/noisier generated layers need reduction

### Interaction polish
- button pressed/hover/loading states
- safer destructive action styling
- calmer dialogs
- cleaner toasts/feedback
- less aggressive or less generic on-page animations

### Density reduction without removing features
- reduce visual noise in dense screens
- reduce equal-weight actions competing on the same screen
- clarify what user should do first on each page
- make tables/lists/cards easier to scan quickly

## What I will deliberately NOT do

- no API contract rewrite
- no state model rewrite
- no navigation rewrite into a totally new architecture
- no business process redesign
- no feature removal unless purely presentational and approved later
- no backend restructuring in this UI phase

## Phase progress log

### Phase 1 — theme/token foundation
Status: completed
Branch: `ui-repair-phase1`

What this phase changed:
- semantic color palette shifted from generic FlutterFlow purple/teal to a calmer operations-grade teal/slate system
- light and dark surface system upgraded for cleaner contrast and calmer density
- text hierarchy tokens tightened for stronger titles, calmer labels, and more premium rhythm
- base Material shell colors aligned with the new surface/background system

What this phase did NOT change:
- route structure
- workflow logic
- API/state/business semantics
- screen-specific layouts yet
- per-screen button/dropdown redesign yet

Touched files in this phase:
- `lib/flutter_flow/flutter_flow_theme.dart`
- `lib/main.dart`

Rollback instruction:
- revert only the Phase 1 commit

## Touched file target list (expected)

High probability:
- `lib/flutter_flow/flutter_flow_theme.dart`
- `lib/flutter_flow/flutter_flow_widgets.dart`
- `lib/flutter_flow/flutter_flow_drop_down.dart`
- `lib/main.dart`
- `lib/login/login_widget.dart`
- `lib/dashboard_h_q/dashboard_h_q_widget.dart`
- `lib/find_inventory/find_inventory_widget.dart`
- `lib/order_list/order_list_widget.dart`
- `lib/stock_in/stock_in_widget.dart`
- `lib/order/order_widget.dart`
- `lib/carousell/carousell_widget.dart`
- `lib/edit_inventory/edit_inventory_widget.dart`
- `lib/tracking_order/tracking_order_widget.dart`
- `lib/item_movement_history/item_movement_history_widget.dart`
- selected files under `lib/components/`

Possible but only if needed:
- `lib/upload_carousell/upload_carousell_widget.dart`
- `lib/carousell_update/carousell_update_widget.dart`
- `lib/cart/cart_widget.dart`
- `lib/purchase_order/purchase_order_widget.dart`

## Success criteria

The UI repair is successful if:
- `aiventory` no longer feels like a generic FlutterFlow app
- app feels more premium without becoming flashy
- dense ops screens become calmer and easier to scan
- page hierarchy becomes obvious
- shared components look like a deliberate design system
- no workflow behavior is broken
- each phase can be reverted cleanly if Izz dislikes it

## Working conclusion

`aiventory` does not need a product rewrite.
It needs a strong, disciplined visual and compositional pass.

The main move is:
- keep the same functionality
- keep the same product scope
- upgrade the UI layer so the app feels edited, intentional, and strong.
