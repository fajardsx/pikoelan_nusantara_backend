// ============================================================
// Server-Sent Events (SSE) hub
// ------------------------------------------------------------
// Dipakai untuk notifikasi realtime satu arah: server -> browser.
// Contoh: dashboard kasir/dapur langsung menerima order baru tanpa polling.
//
// CATATAN SKALA: daftar klien disimpan di memori proses ini. Kalau backend
// dijalankan lebih dari satu instance (pm2 cluster / beberapa container),
// broadcast hanya sampai ke klien yang terhubung ke instance yang sama.
// Untuk skala horizontal, ganti publishToTenant dengan Postgres
// LISTEN/NOTIFY atau Redis pub/sub.
// ============================================================

const HEARTBEAT_INTERVAL_MS = 25 * 1000;
// Batasi jumlah koneksi per tenant supaya tidak jadi celah DoS koneksi menggantung
const MAX_CLIENTS_PER_TENANT = 50;

// tenantId (string) -> Set<client>
const clientsByTenant = new Map();
let clientIdSeq = 0;

// Format payload sesuai spec SSE: "field: value\n" dan diakhiri baris kosong
const serializeEvent = ({id, event, data}) => {
  let payload = "";
  if (id !== undefined && id !== null) payload += `id: ${id}\n`;
  payload += `event: ${event}\n`;
  payload += `data: ${JSON.stringify(data)}\n\n`;
  return payload;
};

// res.write bisa melempar error kalau socket sudah tertutup di tengah loop;
// jangan sampai satu klien mati menghentikan broadcast untuk klien lain.
const safeWrite = (res, payload) => {
  try {
    res.write(payload);
  } catch (error) {
    // diamkan - pembersihan dilakukan oleh event "close" di subscribe()
  }
};

const getTenantClients = (tenantId) => clientsByTenant.get(String(tenantId)) || new Set();

// Daftarkan koneksi baru & kirim handshake + retry interval.
// Mengembalikan {client} kalau sukses, atau {error} kalau melebihi kuota.
const subscribe = ({tenantId, userId, res}) => {
  if (tenantId === undefined || tenantId === null || tenantId === "") {
    return {error: "tenantId is required"};
  }

  const key = String(tenantId);
  const clients = clientsByTenant.get(key) || new Set();

  if (clients.size >= MAX_CLIENTS_PER_TENANT) {
    return {error: `Too many active notification connections for this restaurant (max ${MAX_CLIENTS_PER_TENANT})`};
  }

  clientIdSeq += 1;
  const client = {
    id: `${Date.now()}-${clientIdSeq}`,
    tenantId: key,
    userId,
    res,
  };
  clients.add(client);
  clientsByTenant.set(key, clients);

  // Header SSE: no-cache + X-Accel-Buffering supaya nginx/Cloudflare tidak
  // menahan response (buffering membuat event tidak sampai ke browser).
  res.writeHead(200, {
    "Content-Type": "text/event-stream; charset=utf-8",
    "Cache-Control": "no-cache, no-transform",
    "Connection": "keep-alive",
    "X-Accel-Buffering": "no",
  });
  if (typeof res.flushHeaders === "function") res.flushHeaders();

  // Soket tidak boleh timeout menunggu data (koneksi SSE memang idle lama)
  if (res.req?.socket) {
    res.req.socket.setTimeout(0);
    res.req.socket.setNoDelay(true);
    res.req.socket.setKeepAlive(true);
  }

  // retry: berapa lama browser menunggu sebelum reconnect otomatis
  safeWrite(res, "retry: 5000\n\n");
  safeWrite(
    res,
    serializeEvent({
      event: "connected",
      data: {
        clientId: client.id,
        tenantId: key,
        userId,
        connectedAt: new Date().toISOString(),
      },
    })
  );

  // Bersihkan map saat klien menutup tab / koneksi putus
  res.on("close", () => unsubscribe(client));
  res.on("error", () => unsubscribe(client));

  return {client};
};

const unsubscribe = (client) => {
  const clients = clientsByTenant.get(client.tenantId);
  if (!clients) return;

  clients.delete(client);
  if (clients.size === 0) clientsByTenant.delete(client.tenantId);
};

// Kirim event ke semua klien milik satu tenant.
// Mengembalikan jumlah klien yang menerima event (berguna untuk logging).
const publishToTenant = (tenantId, event, data) => {
  if (tenantId === undefined || tenantId === null || tenantId === "") return 0;

  const clients = clientsByTenant.get(String(tenantId));
  if (!clients || clients.size === 0) return 0;

  const payload = serializeEvent({
    id: Date.now().toString(),
    event,
    data,
  });

  clients.forEach((client) => safeWrite(client.res, payload));
  return clients.size;
};

// Hanya untuk debugging/monitoring
const getSseStats = () => {
  const tenants = {};
  let total = 0;

  clientsByTenant.forEach((clients, tenantId) => {
    tenants[tenantId] = clients.size;
    total += clients.size;
  });

  return {totalClients: total, tenants};
};

const closeAllSseClients = () => {
  clientsByTenant.forEach((clients) => {
    clients.forEach((client) => {
      try {
        client.res.end();
      } catch (error) {
        // abaikan
      }
    });
  });
  clientsByTenant.clear();
};

// Heartbeat berkala: komentar SSE (baris diawali ":") menjaga koneksi tetap
// hidup melewati proxy/tunnel yang memutus koneksi idle.
const heartbeatTimer = setInterval(() => {
  if (clientsByTenant.size === 0) return;

  const payload = `: heartbeat ${new Date().toISOString()}\n\n`;
  clientsByTenant.forEach((clients) => clients.forEach((client) => safeWrite(client.res, payload)));
}, HEARTBEAT_INTERVAL_MS);

// unref supaya timer ini tidak menahan proses tetap hidup (mis. saat script CLI)
if (typeof heartbeatTimer.unref === "function") heartbeatTimer.unref();

module.exports = {
  subscribe,
  unsubscribe,
  publishToTenant,
  getSseStats,
  closeAllSseClients,
};
