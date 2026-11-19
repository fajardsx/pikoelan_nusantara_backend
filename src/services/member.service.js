const { db } = require('../models');

const Member = db.Member;
const MemberPointHistory = db.MemberPointHistory;

// Kriteria batas pembelanjaan / kunjungan untuk kenaikan tier otomatis
const TIER_THRESHOLDS = {
  platinum: { minSpent: 5000000, minVisits: 30, pointMultiplier: 2.0 },
  gold: { minSpent: 1500000, minVisits: 15, pointMultiplier: 1.5 },
  silver: { minSpent: 500000, minVisits: 5, pointMultiplier: 1.2 },
  bronze: { minSpent: 0, minVisits: 0, pointMultiplier: 1.0 },
};

/**
 * Normalisasi format nomor telepon (menghapus spasi, strip, tanda kurung, dan mengubah awalan +62/62 menjadi 0)
 * @param {string} phone
 * @returns {string}
 */
const normalizePhoneNumber = (phone) => {
  if (!phone) return '';
  let cleaned = String(phone).trim().replace(/[\s\-\(\)\.]/g, '');
  if (cleaned.startsWith('+62')) {
    cleaned = '0' + cleaned.slice(3);
  } else if (cleaned.startsWith('62')) {
    cleaned = '0' + cleaned.slice(2);
  }
  return cleaned;
};

/**
 * Validasi apakah format nomor telepon valid (harus angka 9-15 digit, diawali 08/02/0xxx)
 * @param {string} phone
 * @returns {boolean}
 */
const isValidPhoneNumber = (phone) => {
  const normalized = normalizePhoneNumber(phone);
  // Validasi nomor telepon umum di Indonesia (panjang 9 - 15 digit)
  const phoneRegex = /^0[0-9]{8,14}$/;
  return phoneRegex.test(normalized);
};

/**
 * Hasilkan variasi format nomor telepon (+62, 62, 0) untuk pencarian database yang fleksibel
 * @param {string} phone
 * @returns {string[]}
 */
const getPhoneVariants = (phone) => {
  const normalized = normalizePhoneNumber(phone);
  if (!normalized) return [];
  const withoutLeadingZero = normalized.startsWith('0') ? normalized.slice(1) : normalized;
  return [
    normalized,                    // 08123456789
    `62${withoutLeadingZero}`,      // 628123456789
    `+62${withoutLeadingZero}`,     // +628123456789
    String(phone).trim(),          // nilai input mentah
  ].filter((v, idx, arr) => arr.indexOf(v) === idx && v.length > 0);
};

/**
 * Generate unique member code per tenant
 * Format: MBR-<tenantId>-<sequence> (contoh: MBR-1-0001)
 */
const generateMemberCode = async (tenantId) => {
  const count = await Member.count({ where: { tenantId } });
  const sequence = String(count + 1).padStart(4, '0');
  return `MBR-${tenantId}-${sequence}`;
};

/**
 * Evaluasi kenaikan tier berdasarkan total spending atau total kunjungan
 */
const evaluateTier = (totalSpent, totalVisits) => {
  const spent = parseFloat(totalSpent) || 0;
  const visits = parseInt(totalVisits, 10) || 0;

  if (spent >= TIER_THRESHOLDS.platinum.minSpent || visits >= TIER_THRESHOLDS.platinum.minVisits) {
    return 'platinum';
  }
  if (spent >= TIER_THRESHOLDS.gold.minSpent || visits >= TIER_THRESHOLDS.gold.minVisits) {
    return 'gold';
  }
  if (spent >= TIER_THRESHOLDS.silver.minSpent || visits >= TIER_THRESHOLDS.silver.minVisits) {
    return 'silver';
  }
  return 'bronze';
};

/**
 * Hitung poin reward yang didapat dari belanja (1 poin per Rp 10.000 dengan bonus multiplier tier)
 */
const calculatePointsEarned = (orderAmount, tier = 'bronze') => {
  const amount = parseFloat(orderAmount) || 0;
  const basePoints = Math.floor(amount / 10000); // 1 poin tiap Rp 10.000
  const multiplier = TIER_THRESHOLDS[tier]?.pointMultiplier || 1.0;
  return Math.floor(basePoints * multiplier);
};

/**
 * Tambah catatan perolehan/pemotongan poin ke riwayat
 */
const addPointRecord = async ({ tenantId, memberId, orderId = null, type, points, description }, transaction = null) => {
  const options = transaction ? { transaction } : {};
  return await MemberPointHistory.create(
    {
      tenantId,
      memberId,
      orderId,
      type,
      points,
      description,
    },
    options
  );
};

module.exports = {
  TIER_THRESHOLDS,
  normalizePhoneNumber,
  isValidPhoneNumber,
  getPhoneVariants,
  generateMemberCode,
  evaluateTier,
  calculatePointsEarned,
  addPointRecord,
};
