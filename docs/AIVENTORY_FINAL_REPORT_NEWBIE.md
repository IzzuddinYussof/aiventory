# Laporan Final Aiventory (Versi Mesra Newbie)

Tarikh: 12 Mac 2026  
Mode test: Simulasi flow user + live API (ikut cara app sebenar)

## Ringkasan Paling Penting

- Aliran utama app berjaya disemak dari login sampai consolidation.
- Report final berjaya siap.
- Ada 3 bahagian yang ditanda **blocked-final** sebab kalau teruskan, ia berisiko ubah data live tanpa cara revert yang selamat.

## Apa Yang Sudah Berjaya

### 1) Login dan bootstrap
- Login dengan credential sah berjaya.
- API asas selepas login berjaya:
  - auth/me
  - inventory list
  - branch list
  - inventory category list

### 2) Flow utama yang lulus
- Dashboard: lulus
- Find Inventory: lulus
- Edit Inventory: lulus (termasuk revert)
- Order + Order List + Stock In: lulus (termasuk revert test yang selamat)
- Item Movement History: lulus (termasuk delete test-created record)
- Tracking Order: lulus (ada nota kecil di bawah)
- Purchase Order: route ok, tapi page masih belum ada integration API sebenar

## Bahagian Yang Blocked-Final (Bukan gagal total, tapi dihentikan dengan sengaja)

### Section 11: Upload Carousell
Masalah:
- Route direct dari carousell tak pass param penting (`inventoryId`), tapi page upload perlukan nilai tu.
- Endpoint create carousell tak ada flow delete/update yang jelas untuk restore state asal dengan selamat.

Kesan:
- Kalau terus test mutation berulang, data test boleh terkumpul.

### Section 12: Cart
Masalah:
- Untuk movement create, tiada endpoint delete yang jelas untuk buang record dan balikkan ke state asal tepat.

Kesan:
- Susah nak pastikan data live bersih 100% selepas test.

### Section 13: Carousell Update
Masalah:
- Selepas toggle status, metadata buyer-side ada kes tak revert tepat ke nilai asal.

Kesan:
- Revert exact pre-state tak konsisten.

## Isu Penting Yang Perlu Dev Betulkan Dulu

1. Betulkan navigation ke Upload Carousell
- Pastikan route dari carousell hantar param yang diperlukan (`inventoryId` dll).

2. Sediakan revert-safe endpoint untuk test/live ops
- Contoh: endpoint delete/undo yang jelas untuk:
  - inventory_carousell
  - inventory_carousell_movement

3. Betulkan logic revert buyer-side pada carousell movement
- Pastikan metadata boleh kembali tepat ke nilai asal.

4. Tracking Order: harden null safety
- Jika `url` tiada, elakkan force unwrap yang boleh crash.

5. Purchase Order: implement API integration
- Sekarang page masih scaffold, belum ada create/read/update sebenar.

## Cadangan Tindakan Lepas Ini (Simple)

Fasa 1 (cepat):
- Fix route param Upload Carousell
- Tambah endpoint revert/delete yang selamat

Fasa 2:
- Retest semula Section 11, 12, 13 sahaja
- Confirm semua mutation boleh revert bersih

Fasa 3:
- Tutup report final v2 (all clear)

## Kesimpulan

App dah cover banyak flow penting dan banyak part dah lulus.  
Yang tinggal sekarang bukan “test tak jalan”, tapi lebih kepada **infrastruktur revert + consistency** untuk 3 section tertentu.  
Lepas 3 isu tu dibetulkan, retest boleh dibuat cepat dan lebih bersih.
