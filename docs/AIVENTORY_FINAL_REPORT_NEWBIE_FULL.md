# Laporan Final Aiventory (Bahasa Simple, Content Penuh)

Tarikh: 13 Mac 2026  
Mode test: Simulasi flow user + live API ikut kontrak app sebenar (bukan UI click automation).

---

## 1) Apa saya buat sebenarnya

Saya test ikut flow user dari awal sampai akhir:

1. Login
2. Bootstrap data awal
3. Dashboard
4. Find Inventory
5. Edit Inventory
6. Order
7. Order List
8. Stock In
9. Item Movement History
10. Carousell listing
11. Upload Carousell
12. Cart
13. Carousell Update
14. Tracking Order
15. Purchase Order
16. Consolidation

Untuk bahagian yang ada mutation (ubah data), saya cuba buat cara selamat:
- simpan state asal
- buat test
- revert balik

Kalau revert tak boleh dibuat dengan selamat, saya stop dan tandakan blocker.

---

## 2) Ringkasan hasil

### Yang lulus dengan baik
- Login + auth flow
- Bootstrap data awal
- Dashboard
- Find Inventory
- Edit Inventory (dengan revert)
- Order
- Order List
- Stock In
- Item Movement History
- Tracking Order (dengan nota risiko param)

### Yang tidak lengkap / blocked-final
- Section 11: Upload Carousell
- Section 12: Cart
- Section 13: Carousell Update

Sebab utama 3 section ni bukan sebab “tak boleh test langsung”, tapi sebab **susah/tiada cara revert exact state** dengan API flow yang exposed sekarang.

---

## 3) Senarai penuh isu yang ditemui (lengkap)

Di bawah ni saya susun dalam bahasa simple, tapi content penuh.

### A. CRITICAL / HIGH PRIORITY

#### A1) Upload Carousell: route direct tak hantar param penting
Masalah:
- Dari Carousell ke Upload Carousell, route direct ada situasi tak bawa `inventoryId`.
- Tapi page Upload perlukan nilai ni untuk jalan normal.

Kesan:
- Boleh jadi crash / null issue / flow tak konsisten.
- Behavior direct vs param jadi tak stabil.

Cadangan fix:
- Wajibkan route param yang diperlukan bila navigate ke Upload Carousell.
- Letak guard awal kalau param tiada (jangan terus force guna).

---

#### A2) Upload Carousell: create endpoint tak ada laluan revert selamat
Masalah:
- Bila create row `inventory_carousell`, app-exposed flow tak ada delete/undo jelas untuk buang test row dengan tepat.

Kesan:
- Data test boleh terkumpul dalam production/live.
- QA susah nak pastikan DB bersih lepas test.

Cadangan fix:
- Tambah endpoint delete/undo yang controlled.
- Atau sediakan mode test flag + cleanup job rasmi.

---

#### A3) Cart movement: tiada delete untuk restore exact pre-state
Masalah:
- Untuk movement create (`inventory_carousell_movement`), tiada delete flow yang clear dari app contract.

Kesan:
- Lepas test create, sukar nak balik tepat ke “sebelum test”.

Cadangan fix:
- Sediakan endpoint delete/undo untuk movement yang dicipta semasa test.

---

#### A4) Carousell Update: buyer-side metadata tak revert tepat
Masalah:
- Lepas toggle status (done true/false), metadata buyer-side ada kes kekal isi walaupun sepatutnya reset.

Kesan:
- State jadi tak konsisten.
- Revert exact pre-state gagal.

Cadangan fix:
- Betulkan update logic supaya bila reverse state, metadata ikut reverse juga.
- Tambah validation pada backend supaya state machine jelas.

---

### B. MEDIUM PRIORITY

#### B1) Order status transition terlalu longgar
Masalah:
- Transition yang pelik (contoh ordered -> submitted) masih diterima API.

Kesan:
- Data workflow boleh jadi bercelaru.

Cadangan fix:
- Enforce state machine di backend.
- Reject transition yang tak valid.

---

#### B2) Tracking Order param `url` berisiko (null safety)
Masalah:
- Ada path yang boleh bagi `url` kosong/missing tapi penggunaan dalam page berisiko force unwrap.

Kesan:
- Potensi runtime error/crash.

Cadangan fix:
- Letak default safe value / guard check sebelum render.

---

#### B3) Carousell mode param vs direct tak konsisten guna data
Masalah:
- Ada route mode yang pass param, tapi penggunaan downstream tak memberi effect yang jelas/meaningful.

Kesan:
- Developer confus, QA confus, behavior sukar dijangka.

Cadangan fix:
- Standardize: sama ada param mode memang dipakai penuh, atau buang param yang tak perlu.

---

#### B4) Purchase Order masih scaffold
Masalah:
- UI ada, tapi API integration create/read/update belum siap.

Kesan:
- Feature belum betul-betul usable.

Cadangan fix:
- Implement API integration penuh + handling success/error + validation.

---

### C. LOW / OBSERVATION

#### C1) Banyak flow bergantung param dari page sebelum
Masalah:
- Kalau upstream param tak lengkap, downstream page jadi fragile.

Cadangan fix:
- Set contract lebih ketat (required params + type checks) di boundary route/page.

---

## 4) Status per section (detail)

1. Login: PASS  
2. Bootstrap: PASS  
3. Dashboard: PASS  
4. Find Inventory: PASS  
5. Edit Inventory: PASS (revert ok)  
6. Order: PASS  
7. Order List: PASS (dengan penemuan transition longgar)  
8. Stock In: PASS  
9. Item Movement History: PASS  
10. Carousell listing: PASS (dengan nota konsistensi param usage)  
11. Upload Carousell: BLOCKED-FINAL  
12. Cart: BLOCKED-FINAL  
13. Carousell Update: BLOCKED-FINAL  
14. Tracking Order: PASS (dengan nota null safety)  
15. Purchase Order: PARTIAL (route ok, API integration belum siap)  
16. Consolidation: DONE  

---

## 5) Prioriti fix (ikut urutan paling berbaloi)

### Priority 1 (buat dulu)
1. Fix route + param contract untuk Upload Carousell
2. Sediakan endpoint revert/delete untuk:
   - inventory_carousell
   - inventory_carousell_movement
3. Fix revert logic buyer-side di Carousell Update

### Priority 2
4. Enforce order status transition rules (state machine)
5. Harden null safety Tracking Order (`url`)

### Priority 3
6. Lengkapkan Purchase Order API integration
7. Kemas semula konsistensi param usage direct vs param flow

---

## 6) Retest plan lepas dev fix

Selepas fix dibuat, retest fokus:
- Section 11
- Section 12
- Section 13

Kriteria lulus retest:
- Mutation boleh dibuat
- Revert boleh balik exact pre-state
- Tiada data test tertinggal

Lepas 3 ni clear, report v2 boleh ditutup sebagai selesai penuh.

---

## 7) Kesimpulan akhir

Benda utama bukan “app langsung tak jalan”. Banyak flow utama sebenarnya dah okay.  
Masalah besar sekarang ialah **safety dan consistency untuk mutation/revert** pada beberapa flow penting.

Maksud mudah:
- Feature ada
- Tapi untuk QA live yang betul-betul bersih, kita perlukan pintu revert yang proper
- Bila pintu tu siap, baki issue boleh settle cepat
