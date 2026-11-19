# init
npm install

# Stop server (Ctrl+C)

# Start lagi
npm run dev


## Notifikasi realtime order (Server-Sent Events)

Dashboard kasir/dapur bisa menerima order baru & perubahan status tanpa polling.

```
GET /api/notifications/orders/stream?token=<JWT>
```

- Auth: `?token=` (karena `EventSource` browser tidak bisa mengirim header) atau header `Authorization: Bearer <JWT>` untuk klien non-browser.
- Scope: user hanya menerima event tenant miliknya. `superadmin` wajib menambahkan `&tenantId=<id>`.
- Batas: 50 koneksi aktif per tenant. Heartbeat dikirim tiap 25 detik.

Event yang dikirim:

| Event | Kapan | Data |
|---|---|---|
| `connected` | saat stream terbuka | `clientId`, `tenantId`, `userId`, `connectedAt` |
| `order.created` | order baru dari staff/waiter/pelanggan | `order` (termasuk `items`) |
| `order.status_updated` | `PUT /api/orders/:id/status` | `order`, `previousStatus`, `changedBy` |
| `order.cancelled` | pelanggan batalkan order lewat menu digital | `order`, `previousStatus` |

Contoh frontend:

```js
const token = localStorage.getItem("token");
const es = new EventSource(
  `https://api.contoh.com/api/notifications/orders/stream?token=${encodeURIComponent(token)}`
);

es.addEventListener("connected", (e) => console.log("SSE siap", JSON.parse(e.data)));

es.addEventListener("order.created", (e) => {
  const {order} = JSON.parse(e.data);
  // tambahkan order baru ke daftar dapur / bunyikan notifikasi
});

es.addEventListener("order.status_updated", (e) => {
  const {order, previousStatus} = JSON.parse(e.data);
  // update kartu order di layar
});

es.onerror = () => {
  // EventSource reconnect otomatis (retry 5 detik). Kalau 401, token sudah
  // kedaluwarsa: login ulang lalu buat EventSource baru.
};
```

Catatan:

- Hub disimpan di memori proses (`src/utils/sse.js`). Kalau backend dijalankan multi-instance, ganti `publishToTenant` dengan Postgres `LISTEN/NOTIFY` atau Redis pub/sub.
- Monitoring koneksi aktif: `GET /api/notifications/stats` (superadmin).
- Token di query string bisa tercatat di access log; kalau perlu, buat endpoint tiket short-lived sebelum membuka stream.
- Uji cepat dengan curl: `curl -N "http://localhost:3000/api/notifications/orders/stream?token=<JWT>"`.


## Privilege role per menu (CRUD)

Setiap tenant bisa mengatur menu apa saja yang boleh diakses tiap role, beserta
aksi `create`, `read`, `update`, `delete`. Privilege disimpan di tabel
`role_permissions` (unik per `tenantId` + `role` + `menuKey`). Kalau belum ada
baris, nilai default di `src/config/permissions.js` yang dipakai.

Role: `owner`, `manager`, `staff`, `kasir`, `waiter`, `kitchen`.
Menu: `dashboard`, `menu`, `staff`, `transactions`, `reports`, `settings`, `notifications`.
`superadmin` selalu akses penuh dan privilege-nya tidak bisa diubah.

### Endpoint

| Method | Path | Akses | Keterangan |
|---|---|---|---|
| GET | `/api/permissions/me` | semua user login | privilege milik user yang login |
| GET | `/api/permissions` | owner, manager, superadmin | matriks semua role di tenant |
| PUT | `/api/permissions/:role` | owner, manager, superadmin | ubah privilege satu role |
| DELETE | `/api/permissions/:role` | owner, manager, superadmin | reset role ke default |

`superadmin` tidak punya tenant, jadi wajib menyertakan `?tenantId=<id>`
(GET/DELETE) atau `tenantId` di body (PUT).

### Contoh ubah privilege

```http
PUT /api/permissions/kasir
Authorization: Bearer <JWT>
Content-Type: application/json

{
  "permissions": [
    { "menuKey": "menu", "canCreate": true, "canRead": true, "canUpdate": false, "canDelete": false },
    { "menuKey": "reports", "canRead": true }
  ]
}
```

- `permissions` wajib array dan minimal satu item.
- Flag yang tidak dikirim memakai nilai efektif saat ini (partial update).
- `menuKey` harus ada di daftar menu; duplikat / tidak dikenal ditolak `400`.

Middleware `requireMenuPermission(menuKey, action)` dipakai di
`src/routes/menu.routes.js` sehingga konfigurasi langsung berlaku untuk
endpoint kategori & item menu.
