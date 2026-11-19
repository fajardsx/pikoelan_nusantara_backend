const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const {sendResponse} = require("../utils/response");
const {generateToken} = require("../utils/token");
const {sendVerificationEmail} = require("../utils/email");
const {uploadFile, deleteFile} = require("../utils/supabaseStorage");
const {db} = require("../models");

const Tenant = db.Tenant;
const User = db.User;
const TenantPayment = db.TenantPayment;

// Ubah "Nama Restoran Enak" -> "nama-restoran-enak"
const slugify = (text) => {
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
};

// Bikin slug unik, kalau sudah dipakai tambahkan angka di belakang
const generateUniqueSlug = async (name) => {
  const base = slugify(name);
  let slug = base;
  let counter = 1;

  while (await Tenant.findOne({where: {slug}})) {
    slug = `${base}-${counter}`;
    counter += 1;
  }

  return slug;
};

// ============== ONBOARDING: daftar restoran baru + akun owner ==============
const registerTenant = async (req, res) => {
  const t = await db.sequelize.transaction();

  try {
    const {restaurant, owner} = req.body;

    if (
      !restaurant?.name ||
      !owner?.name ||
      !owner?.email ||
      !owner?.password
    ) {
      await t.rollback();
      return sendResponse(
        res,
        400,
        false,
        "Please provide restaurant name and owner name, email, password",
      );
    }

    // Cek email owner belum dipakai
    const existingUser = await User.findOne({where: {email: owner.email}});
    if (existingUser) {
      await t.rollback();
      return sendResponse(res, 400, false, "Email already registered");
    }

    const slug = await generateUniqueSlug(restaurant.name);

    // 1. Buat tenant (restoran) - belum aktif sampai email owner diverifikasi
    const tenant = await Tenant.create(
      {
        name: restaurant.name,
        slug,
        address: restaurant.address || null,
        phone: restaurant.phone || null,
        email: restaurant.email || null,
        plan: "free",
        isActive: false,
      },
      {transaction: t},
    );

    // 2. Buat user pertama sebagai owner restoran itu
    const hashedPassword = await bcrypt.hash(owner.password, 10);
    const {rawToken, hashedToken} = generateToken();
    const ownerUser = await User.create(
      {
        tenantId: tenant.id,
        role: "owner",
        name: owner.name,
        email: owner.email,
        password: hashedPassword,
        emailVerified: false,
        emailVerificationToken: hashedToken,
        emailVerificationExpires: new Date(Date.now() + 24 * 60 * 60 * 1000),
      },
      {transaction: t},
    );

    // 3. Tautkan tenant ke owner-nya
    await tenant.update({ownerId: ownerUser.id}, {transaction: t});

    await t.commit();

    // Kirim email verifikasi di luar transaction (kalau gagal kirim, tidak perlu rollback pendaftaran)
    try {
      await sendVerificationEmail(ownerUser, rawToken);
    } catch (emailError) {
      console.error("Failed to send verification email:", emailError.message);
    }

    const token = jwt.sign(
      {
        id: ownerUser.id,
        email: ownerUser.email,
        tenantId: tenant.id,
        role: ownerUser.role,
      },
      process.env.JWT_SECRET,
      {expiresIn: process.env.JWT_EXPIRE},
    );

    return sendResponse(
      res,
      201,
      true,
      "Restaurant registered successfully. Please check your email to verify your account.",
      {
        tenant: {
          id: tenant.id,
          name: tenant.name,
          slug: tenant.slug,
          plan: tenant.plan,
          isActive: false,
        },
        user: {
          id: ownerUser.id,
          name: ownerUser.name,
          email: ownerUser.email,
          role: ownerUser.role,
          emailVerified: false,
        },
        requiresVerification: true,
        token,
      },
    );
  } catch (error) {
    await t.rollback();
    console.error("Register tenant error:", error);
    if (error.name === "SequelizeValidationError") {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== Info restoran milik user yang sedang login ==============
const getMyTenant = async (req, res) => {
  try {
    const tenant = await Tenant.findByPk(req.user.tenantId, {
      include: [
        {model: User, as: "users", attributes: {exclude: ["password"]}},
        {model: TenantPayment, as: "payments", required: false},
      ],
    });

    if (!tenant) {
      return sendResponse(res, 200, true, "Restaurant not found", {
        tenant: null,
      });
    }

    return sendResponse(res, 200, true, "Restaurant retrieved successfully", {
      tenant,
    });
  } catch (error) {
    console.error("Get tenant error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== Update profil restoran (owner/manager saja) ==============
// Support upload logo: kirim multipart/form-data dengan field file `logo`.
// Bisa juga update tanpa file (JSON biasa) + opsional logoUrl/logo_url atau removeLogo=true.
const updateMyTenant = async (req, res) => {
  try {
    const {
      name,
      address,
      phone,
      email,
      logoUrl,
      logo_url,
      removeLogo,
      qrisUrl,
      qris_url,
      removeQris,
      bankAccountNumber,
    } = req.body;

    const tenant = await Tenant.findByPk(req.user.tenantId);
    if (!tenant) {
      return sendResponse(res, 404, false, "Restaurant not found");
    }

    // ----- Logo handling -----
    let newLogoUrl = tenant.logoUrl;
    if (req.files && req.files.logo && req.files.logo[0]) {
      const logoFile = req.files.logo[0];
      const oldLogo = tenant.logoUrl;
      const {publicUrl} = await uploadFile(
        logoFile.buffer,
        logoFile.originalname,
        logoFile.mimetype,
        "tenants",
      );
      newLogoUrl = publicUrl;
      if (oldLogo) deleteFile(oldLogo).catch(() => {});
    } else if (removeLogo === true || removeLogo === "true") {
      if (tenant.logoUrl) deleteFile(tenant.logoUrl).catch(() => {});
      newLogoUrl = null;
    } else if (logoUrl !== undefined || logo_url !== undefined) {
      const incoming = logoUrl ?? logo_url;
      if (incoming === null || incoming === "" || incoming === "null") {
        if (tenant.logoUrl) deleteFile(tenant.logoUrl).catch(() => {});
        newLogoUrl = null;
      } else if (typeof incoming === "string" && incoming.trim() !== "") {
        newLogoUrl = incoming.trim();
      }
    }

    // ----- QRIS handling -----
    let newQrisUrl = tenant.qrisUrl;
    // upload file via multipart field 'qris'
    if (req.files && req.files.qris && req.files.qris[0]) {
      const qrisFile = req.files.qris[0];
      const oldQris = tenant.qrisUrl;
      const {publicUrl} = await uploadFile(
        qrisFile.buffer,
        qrisFile.originalname,
        qrisFile.mimetype,
        "qris",
      );
      newQrisUrl = publicUrl;
      if (oldQris) deleteFile(oldQris).catch(() => {});
    } else if (removeQris === true || removeQris === "true") {
      if (tenant.qrisUrl) deleteFile(tenant.qrisUrl).catch(() => {});
      newQrisUrl = null;
    } else if (qrisUrl !== undefined || qris_url !== undefined) {
      const incoming = qrisUrl ?? qris_url;
      if (incoming === null || incoming === "" || incoming === "null") {
        newQrisUrl = null;
      } else if (typeof incoming === "string" && incoming.trim() !== "") {
        newQrisUrl = incoming.trim();
      }
    }

    await tenant.update({
      name: name || tenant.name,
      address: address ?? tenant.address,
      phone: phone ?? tenant.phone,
      email: email ?? tenant.email,
      logoUrl: newLogoUrl,
      qrisUrl: newQrisUrl,
      bankAccountNumber: bankAccountNumber ?? tenant.bankAccountNumber,
    });

    // ----- Payment handling -----
    const {payment} = req.body;
    if (payment) {
      const {
        bankAccountName,
        bankAccountNumber,
        phoneConfirmation,
        deliveryDescription,
      } = payment;
      // Find existing payment for this tenant (single record assumed)
      let paymentRecord = await TenantPayment.findOne({
        where: {tenantId: req.user.tenantId},
      });
      // Prepare QRIS URL handling
      if (!paymentRecord) {
        // Create new payment record
        paymentRecord = await TenantPayment.create({
          tenantId: req.user.tenantId,
          bankAccountName,
          bankAccountNumber,
          phoneConfirmation,
          deliveryDescription,
          qrisUrl: newQrisUrl,
        });
      } else {
        // Update existing payment record
        await paymentRecord.update({
          bankAccountName: bankAccountName ?? paymentRecord.bankAccountName,
          bankAccountNumber:
            bankAccountNumber ?? paymentRecord.bankAccountNumber,
          phoneConfirmation:
            phoneConfirmation ?? paymentRecord.phoneConfirmation,
          deliveryDescription:
            deliveryDescription ?? paymentRecord.deliveryDescription,
          qrisUrl: newQrisUrl,
        });
      }
    }
    // after all updates (logo, QRIS, tenant fields, and payment handling)
    return sendResponse(res, 200, true, "Restaurant updated successfully", {
      tenant,
    });
  } catch (error) {
    console.error("Update tenant error:", error.message);
    if (error.name === "SequelizeValidationError") {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, error.message || "Server error");
  }
};

// ============== Tambah staff baru ke restoran (owner/manager saja) ==============
const inviteStaff = async (req, res) => {
  try {
    const {name, email, password, role} = req.body;

    if (!name || !email || !password) {
      return sendResponse(
        res,
        400,
        false,
        "Please provide name, email, and password",
      );
    }

    const allowedRoles = ["manager", "staff", "kasir", "waiter", "kitchen"];
    const staffRole = allowedRoles.includes(role) ? role : "staff";

    const existingUser = await User.findOne({where: {email}});
    if (existingUser) {
      return sendResponse(res, 400, false, "Email already registered");
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const staffUser = await User.create({
      tenantId: req.user.tenantId,
      role: staffRole,
      name,
      email,
      password: hashedPassword,
    });

    return sendResponse(res, 201, true, "Staff added successfully", {
      user: {
        id: staffUser.id,
        name: staffUser.name,
        email: staffUser.email,
        role: staffUser.role,
      },
    });
  } catch (error) {
    console.error("Invite staff error:", error);
    if (error.name === "SequelizeValidationError") {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== Hapus staff dari restoran (owner/manager saja) ==============
const deleteStaff = async (req, res) => {
  try {
    const {id} = req.params; // staff user ID
    // Find staff belonging to same tenant
    const staffUser = await User.findOne({
      where: {id, tenantId: req.user.tenantId},
    });
    if (!staffUser) {
      return sendResponse(res, 404, false, "Staff not found");
    }
    // Prevent deleting owner
    if (staffUser.role === "owner") {
      return sendResponse(res, 403, false, "Cannot delete owner");
    }
    await staffUser.destroy();
    return sendResponse(res, 200, true, "Staff deleted successfully");
  } catch (error) {
    console.error("Delete staff error:", error);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== SUPERADMIN: lihat semua tenant di platform ==============
const getAllTenants = async (req, res) => {
  try {
    const tenants = await Tenant.findAll({
      order: [["created_at", "DESC"]],
    });

    // hitung jumlah staff & order per tenant biar dashboard superadmin ada datanya
    const tenantsWithStats = await Promise.all(
      tenants.map(async (tenant) => {
        const [userCount, orderCount] = await Promise.all([
          User.count({where: {tenantId: tenant.id}}),
          db.Order.count({where: {tenantId: tenant.id}}),
        ]);
        return {...tenant.toJSON(), userCount, orderCount};
      }),
    );

    return sendResponse(res, 200, true, "Tenants retrieved successfully", {
      tenants: tenantsWithStats,
      total: tenantsWithStats.length,
    });
  } catch (error) {
    console.error("Get all tenants error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== SUPERADMIN: aktifkan/nonaktifkan tenant ==============
const updateTenantStatus = async (req, res) => {
  try {
    const {id} = req.params;
    const {isActive} = req.body;

    if (typeof isActive !== "boolean") {
      return sendResponse(res, 400, false, "isActive must be true or false");
    }

    const tenant = await Tenant.findByPk(id);
    if (!tenant) {
      return sendResponse(res, 404, false, "Restaurant not found");
    }

    await tenant.update({isActive});

    return sendResponse(
      res,
      200,
      true,
      `Restaurant ${isActive ? "activated" : "deactivated"} successfully`,
      {tenant},
    );
  } catch (error) {
    console.error("Update tenant status error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

module.exports = {
  registerTenant,
  getMyTenant,
  updateMyTenant,
  inviteStaff,
  deleteStaff,
  getAllTenants,
  updateTenantStatus,
};
