const {sendResponse} = require("../utils/response");
const {db} = require("../models");
const {uploadFile, deleteFile} = require("../utils/supabaseStorage");

const MenuCategory = db.MenuCategory;
const MenuItem = db.MenuItem;
const TenantPayment = db.TenantPayment;

// ============== CATEGORIES ==============

const getCategories = async (req, res) => {
  try {
    const categories = await MenuCategory.findAll({
      where: {tenantId: req.user.tenantId},
      order: [
        ["sortOrder", "ASC"],
        ["created_at", "ASC"],
      ],
    });
    return sendResponse(res, 200, true, "Categories retrieved successfully", {
      categories,
    });
  } catch (error) {
    console.error("Get categories error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

const createCategory = async (req, res) => {
  try {
    const {name, sortOrder} = req.body;
    if (!name) {
      return sendResponse(res, 400, false, "Category name is required");
    }

    let categoriesPicture = null;
    if (req.file) {
      const {publicUrl} = await uploadFile(
        req.file.buffer,
        req.file.originalname,
        req.file.mimetype,
        "menu",
      );
      categoriesPicture = publicUrl;
    }

    const category = await MenuCategory.create({
      tenantId: req.user.tenantId,
      name,
      categoriesPicture,
      sortOrder: sortOrder || 0,
    });

    return sendResponse(res, 201, true, "Category created successfully", {
      category,
    });
  } catch (error) {
    console.error("Create category error:", error.message);
    if (error.name === "SequelizeValidationError") {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, error.message || "Server error");
  }
};

const updateCategory = async (req, res) => {
  try {
    const {id} = req.params;
    const {name, sortOrder, isActive} = req.body;

    const category = await MenuCategory.findOne({
      where: {id, tenantId: req.user.tenantId},
    });
    if (!category) {
      return sendResponse(res, 404, false, "Category not found");
    }

    let categoriesPicture = category.categoriesPicture;
    if (req.file) {
      const oldPicture = category.categoriesPicture;
      const {publicUrl} = await uploadFile(
        req.file.buffer,
        req.file.originalname,
        req.file.mimetype,
        "menu",
      );
      categoriesPicture = publicUrl;
      if (oldPicture) deleteFile(oldPicture).catch(() => {});
    }

    await category.update({
      name: name ?? category.name,
      sortOrder: sortOrder ?? category.sortOrder,
      isActive:
        isActive === undefined
          ? category.isActive
          : isActive === "true" || isActive === true,
      categoriesPicture,
    });

    return sendResponse(res, 200, true, "Category updated successfully", {
      category,
    });
  } catch (error) {
    console.error("Update category error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

const deleteCategory = async (req, res) => {
  try {
    const {id} = req.params;

    const category = await MenuCategory.findOne({
      where: {id, tenantId: req.user.tenantId},
    });
    if (!category) {
      return sendResponse(res, 404, false, "Category not found");
    }

    // Item yang masih pakai kategori ini dilepas ke "tanpa kategori", bukan ikut terhapus
    await MenuItem.update(
      {categoryId: null},
      {where: {categoryId: id, tenantId: req.user.tenantId}},
    );

    if (category.categoriesPicture) {
      await deleteFile(category.categoriesPicture);
    }

    await category.destroy();
    return sendResponse(res, 200, true, "Category deleted successfully");
  } catch (error) {
    console.error("Delete category error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== MENU ITEMS ==============

const getMenuItems = async (req, res) => {
  try {
    const {categoryId, available} = req.query;

    const where = {tenantId: req.user.tenantId};
    if (categoryId) where.categoryId = categoryId;
    if (available !== undefined) where.isAvailable = available === "true";

    const items = await MenuItem.findAll({
      where,
      include: [
        {model: MenuCategory, as: "category", attributes: ["id", "name"]},
      ],
      order: [
        ["sortOrder", "ASC"],
        ["created_at", "ASC"],
      ],
    });

    return sendResponse(res, 200, true, "Menu items retrieved successfully", {
      items,
      total: items.length,
    });
  } catch (error) {
    console.error("Get menu items error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

const createMenuItem = async (req, res) => {
  try {
    const {
      name,
      description,
      price,
      originalPrice,
      categoryId,
      isAvailable,
      isFavorite,
      isBanner,
      sortOrder,
    } = req.body;

    if (!name || price === undefined) {
      return sendResponse(res, 400, false, "Name and price are required");
    }

    let imageUrl = null;
    if (req.file) {
      const {publicUrl} = await uploadFile(
        req.file.buffer,
        req.file.originalname,
        req.file.mimetype,
        "menu",
      );
      imageUrl = publicUrl;
    }

    const item = await MenuItem.create({
      tenantId: req.user.tenantId,
      categoryId: categoryId || null,
      name,
      description: description || null,
      price,
      originalPrice: originalPrice || null,
      imageUrl,
      isAvailable:
        isAvailable === undefined
          ? true
          : isAvailable === "true" || isAvailable === true,
      isFavorite: isFavorite === "true" || isFavorite === true,
      isBanner: isBanner === "true" || isBanner === true,
      sortOrder: sortOrder || 0,
    });

    return sendResponse(res, 201, true, "Menu item created successfully", {
      item,
    });
  } catch (error) {
    console.error("Create menu item error:", error);
    if (error.name === "SequelizeValidationError") {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, error.message || "Server error");
  }
};

const updateMenuItem = async (req, res) => {
  try {
    const {id} = req.params;
    const {
      name,
      description,
      price,
      originalPrice,
      categoryId,
      isAvailable,
      isFavorite,
      isBanner,
      sortOrder,
    } = req.body;

    const item = await MenuItem.findOne({
      where: {id, tenantId: req.user.tenantId},
    });
    if (!item) {
      return sendResponse(res, 404, false, "Menu item not found");
    }

    let imageUrl = item.imageUrl;
    if (req.file) {
      const oldImage = item.imageUrl;
      const {publicUrl} = await uploadFile(
        req.file.buffer,
        req.file.originalname,
        req.file.mimetype,
        "menu",
      );
      imageUrl = publicUrl;
      if (oldImage) deleteFile(oldImage).catch(() => {});
    }

    await item.update({
      name: name ?? item.name,
      description: description ?? item.description,
      price: price ?? item.price,
      originalPrice:
        originalPrice === undefined
          ? item.originalPrice
          : originalPrice || null,
      categoryId:
        categoryId === undefined ? item.categoryId : categoryId || null,
      isAvailable:
        isAvailable === undefined
          ? item.isAvailable
          : isAvailable === "true" || isAvailable === true,
      isFavorite:
        isFavorite === undefined
          ? item.isFavorite
          : isFavorite === "true" || isFavorite === true,
      isBanner:
        isBanner === undefined
          ? item.isBanner
          : isBanner === "true" || isBanner === true,
      sortOrder: sortOrder ?? item.sortOrder,
      imageUrl,
    });

    return sendResponse(res, 200, true, "Menu item updated successfully", {
      item,
    });
  } catch (error) {
    console.error("Update menu item error:", error.message);
    if (error.name === "SequelizeValidationError") {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, "Server error");
  }
};

const deleteMenuItem = async (req, res) => {
  try {
    const {id} = req.params;

    const item = await MenuItem.findOne({
      where: {id, tenantId: req.user.tenantId},
    });
    if (!item) {
      return sendResponse(res, 404, false, "Menu item not found");
    }

    if (item.imageUrl) {
      await deleteFile(item.imageUrl);
    }

    await item.destroy();
    return sendResponse(res, 200, true, "Menu item deleted successfully");
  } catch (error) {
    console.error("Delete menu item error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== PUBLIC DIGITAL MENU (tanpa login, untuk QR code di meja) ==============

const getPublicMenu = async (req, res) => {
  try {
    const {slug} = req.params;

    const tenant = await db.Tenant.findOne({where: {slug}});
    if (!tenant) {
      return sendResponse(res, 404, false, "Restaurant not found");
    }

    // const categories = await MenuCategory.findAll({
    //   where: { tenantId: tenant.id},
    //   include: [{
    //     model: MenuItem,
    //     as: 'items',
    //     where: { isAvailable: true },
    //     required: false,
    //     attributes: ['id', 'name', 'description', 'price', 'originalPrice', 'imageUrl', 'isFavorite', 'isBanner'],
    //   }],
    //   order: [['sortOrder', 'ASC']],
    // });

    // 1️⃣ Ambil semua kategori (tanpa include items)
    const categories = await MenuCategory.findAll({
      where: {tenantId: tenant.id},
      attributes: ["id", "name", "categoriesPicture", "sortOrder"],
      order: [["sortOrder", "ASC"]],
    });

    // 2️⃣ Ambil semua item yang tersedia, sekaligus info kategori‑nya
    const items = await MenuItem.findAll({
      where: {
        tenantId: tenant.id,
        isAvailable: true,
      },
      attributes: [
        "id",
        "name",
        "description",
        "price",
        "originalPrice",
        "imageUrl",
        "isFavorite",
        "isBanner",
        "sortOrder",
        "categoryId",
      ],
      order: [
        ["sortOrder", "ASC"],
        ["created_at", "ASC"],
      ],
    });

    // 3️⃣ (Opsional) Tambahkan `categoryName` ke tiap item untuk kemudahan UI
    const itemsWithCategory = items.map((item) => {
      const cat = categories.find((c) => c.id === item.categoryId);
      return {
        ...item.get(),
        categoryName: cat ? cat.name : null,
      };
    });

    const payments = await TenantPayment.findAll({
      where: {tenantId: tenant.id},
      order: [["created_at", "DESC"]],
    });
    return sendResponse(res, 200, true, "Menu retrieved successfully", {
      restaurant: {
        name: tenant.name,
        slug: tenant.slug,
        logoUrl: tenant.logoUrl,
        address: tenant.address,
        phone: tenant.phone,
        qrisUrl: tenant.qrisUrl,
        rekening: tenant.bankAccountNumber,
        payments: payments,
      },
      categories,
      items: itemsWithCategory,
    });
  } catch (error) {
    console.error("Get public menu error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

module.exports = {
  getCategories,
  createCategory,
  updateCategory,
  deleteCategory,
  getMenuItems,
  createMenuItem,
  updateMenuItem,
  deleteMenuItem,
  getPublicMenu,
};
