const { Op } = require('sequelize');
const { db } = require('../models');
const { sendResponse } = require('../utils/response');

const StockItem = db.StockItem;
const StockUnit = db.StockUnit;
const StockCategory = db.StockCategory;
const StockMovement = db.StockMovement;
const MenuItemStock = db.MenuItemStock;
const MenuItem = db.MenuItem;

// ============== CREATE BAHAN BAKU ==============
const createStockItem = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const {
      name, categoryId, unitId, sku,
      description,currentStock,minimumStock, costPrice, supplier, notes,
    } = req.body;

    if (!name || !unitId) {
      return sendResponse(res, 400, false, 'Name and unitId are required');
    }

    // Validasi unit milik tenant ini
    const unit = await StockUnit.findOne({ where: { id: unitId, tenantId, isActive: true } });
    if (!unit) {
      return sendResponse(res, 400, false, 'Unit not found or inactive. Please create it first in /api/stock/units');
    }

    // Cek nama duplikat
    const existing = await StockItem.findOne({ where: { tenantId, name: name.trim() } });
    if (existing) {
      return sendResponse(res, 400, false, `Stock item "${name.trim()}" already exists`);
    }

    // Validasi category jika diberikan
    if (categoryId) {
      const cat = await StockCategory.findOne({ where: { id: categoryId, tenantId } });
      if (!cat) {
        return sendResponse(res, 400, false, 'Stock category not found');
      }
    }

    const item = await StockItem.create({
      tenantId,
      categoryId: categoryId || null,
      unitId,
      sku: sku ? String(sku).trim() : null,
      name: name.trim(),
      description: description || null,
      currentStock: currentStock ?parseFloat(currentStock): 0,
      minimumStock: minimumStock ? parseFloat(minimumStock) : 0,
      costPrice: costPrice ? parseFloat(costPrice) : 0,
      supplier: supplier || null,
      notes: notes || null,
      isActive: true,
    });

    const fullItem = await StockItem.findByPk(item.id, {
      include: [
        { model: StockUnit, as: 'unit', attributes: ['id', 'name', 'symbol'] },
        { model: StockCategory, as: 'category', attributes: ['id', 'name'] },
      ],
    });

    return sendResponse(res, 201, true, 'Stock item created successfully', { stockItem: fullItem });
  } catch (error) {
    console.error('Create stock item error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET ALL BAHAN BAKU ==============
const getStockItems = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const {
      search, categoryId, unitId, isActive,
      lowStock, page = 1, limit = 30,
      sortBy = 'name', order = 'ASC',
    } = req.query;

    const where = { tenantId };

    if (search) {
      where[Op.or] = [
        { name: { [Op.iLike]: `%${search}%` } },
        { sku: { [Op.iLike]: `%${search}%` } },
        { supplier: { [Op.iLike]: `%${search}%` } },
      ];
    }
    if (categoryId) where.categoryId = categoryId;
    if (unitId) where.unitId = unitId;
    if (isActive !== undefined) where.isActive = isActive === 'true' || isActive === true;

    // Filter stok di bawah minimum (low stock alert)
    if (lowStock === 'true') {
      where[Op.and] = [
        { minimumStock: { [Op.gt]: 0 } },
        db.sequelize.where(
          db.sequelize.col('current_stock'),
          { [Op.lt]: db.sequelize.col('minimum_stock') }
        ),
      ];
    }

    const validSortFields = ['name', 'currentStock', 'minimumStock', 'costPrice', 'createdAt'];
    const sortField = validSortFields.includes(sortBy) ? sortBy : 'name';
    const sortOrder = order.toUpperCase() === 'DESC' ? 'DESC' : 'ASC';

    const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);

    const { count, rows: stockItems } = await StockItem.findAndCountAll({
      where,
      limit: parseInt(limit, 10),
      offset,
      order: [[sortField, sortOrder]],
      include: [
        { model: StockUnit, as: 'unit', attributes: ['id', 'name', 'symbol'] },
        { model: StockCategory, as: 'category', attributes: ['id', 'name'] },
      ],
    });

    return sendResponse(res, 200, true, 'Stock items retrieved successfully', {
      stockItems,
      pagination: {
        totalItems: count,
        totalPages: Math.ceil(count / limit),
        currentPage: parseInt(page, 10),
        limit: parseInt(limit, 10),
      },
    });
  } catch (error) {
    console.error('Get stock items error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET BAHAN BAKU BY ID ==============
const getStockItemById = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const item = await StockItem.findOne({
      where: { id, tenantId },
      include: [
        { model: StockUnit, as: 'unit' },
        { model: StockCategory, as: 'category' },
        {
          model: StockMovement,
          as: 'movements',
          limit: 10,
          order: [['createdAt', 'DESC']],
          include: [{ model: db.User, as: 'recordedBy', attributes: ['id', 'name'] }],
        },
        {
          model: MenuItemStock,
          as: 'usedInMenus',
          include: [{ model: MenuItem, as: 'menuItem', attributes: ['id', 'name', 'price'] }],
        },
      ],
    });

    if (!item) {
      return sendResponse(res, 404, false, 'Stock item not found');
    }

    return sendResponse(res, 200, true, 'Stock item retrieved successfully', { stockItem: item });
  } catch (error) {
    console.error('Get stock item by id error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== UPDATE BAHAN BAKU ==============
const updateStockItem = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;
    const {
      name, categoryId, unitId, sku,
      description,currentStock, minimumStock, costPrice, supplier, notes, isActive,
    } = req.body;

    const item = await StockItem.findOne({ where: { id, tenantId } });
    if (!item) {
      return sendResponse(res, 404, false, 'Stock item not found');
    }

    if (name) {
      const trimmedName = name.trim();
      if (trimmedName !== item.name) {
        const dup = await StockItem.findOne({ where: { tenantId, name: trimmedName, id: { [Op.ne]: id } } });
        if (dup) return sendResponse(res, 400, false, `Stock item "${trimmedName}" already exists`);
        item.name = trimmedName;
      }
    }

    if (unitId !== undefined) {
      const unit = await StockUnit.findOne({ where: { id: unitId, tenantId, isActive: true } });
      if (!unit) return sendResponse(res, 400, false, 'Unit not found or inactive');
      item.unitId = unitId;
    }

    if (categoryId !== undefined) {
      if (categoryId) {
        const cat = await StockCategory.findOne({ where: { id: categoryId, tenantId } });
        if (!cat) return sendResponse(res, 400, false, 'Stock category not found');
      }
      item.categoryId = categoryId || null;
    }

    if (sku !== undefined) item.sku = sku ? String(sku).trim() : null;
    if (description !== undefined) item.description = description || null;
    if (currentStock !== undefined) item.currentStock = parseFloat(currentStock);
    if (minimumStock !== undefined) item.minimumStock = parseFloat(minimumStock);
    if (costPrice !== undefined) item.costPrice = parseFloat(costPrice);
    if (supplier !== undefined) item.supplier = supplier || null;
    if (notes !== undefined) item.notes = notes || null;
    if (isActive !== undefined) item.isActive = Boolean(isActive);

    await item.save();

    const fullItem = await StockItem.findByPk(item.id, {
      include: [
        { model: StockUnit, as: 'unit', attributes: ['id', 'name', 'symbol'] },
        { model: StockCategory, as: 'category', attributes: ['id', 'name'] },
      ],
    });

    return sendResponse(res, 200, true, 'Stock item updated successfully', { stockItem: fullItem });
  } catch (error) {
    console.error('Update stock item error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== DELETE BAHAN BAKU ==============
const deleteStockItem = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const item = await StockItem.findOne({ where: { id, tenantId } });
    if (!item) {
      return sendResponse(res, 404, false, 'Stock item not found');
    }

    const movementCount = await StockMovement.count({ where: { stockItemId: id } });
    const bomCount = await MenuItemStock.count({ where: { stockItemId: id } });

    if (movementCount > 0 || bomCount > 0) {
      item.isActive = false;
      await item.save();
      return sendResponse(res, 200, true, 'Stock item has history or is linked to menus; deactivated instead of deleted', { stockItem: item });
    }

    await item.destroy();
    return sendResponse(res, 200, true, 'Stock item deleted successfully');
  } catch (error) {
    console.error('Delete stock item error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET STOCK SUMMARY / STATISTIK ==============
const getStockSummary = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { sequelize: seq } = db;

    const totalItems = await StockItem.count({ where: { tenantId, isActive: true } });

    // Hitung item dengan stok di bawah minimum (low stock)
    const lowStockItems = await StockItem.count({
      where: {
        tenantId,
        isActive: true,
        minimumStock: { [Op.gt]: 0 },
        [Op.and]: seq.where(seq.col('current_stock'), { [Op.lt]: seq.col('minimum_stock') }),
      },
    });

    // Hitung item dengan stok = 0
    const outOfStockItems = await StockItem.count({
      where: {
        tenantId,
        isActive: true,
        currentStock: 0,
      },
    });

    // Total nilai stok (currentStock × costPrice)
    const stockItemsForValue = await StockItem.findAll({
      where: { tenantId, isActive: true },
      attributes: ['currentStock', 'costPrice'],
    });
    const totalStockValue = stockItemsForValue.reduce((sum, item) => {
      return sum + (parseFloat(item.currentStock) * parseFloat(item.costPrice || 0));
    }, 0);

    return sendResponse(res, 200, true, 'Stock summary retrieved', {
      totalActiveItems: totalItems,
      lowStockItems,
      outOfStockItems,
      totalStockValue: Math.round(totalStockValue * 100) / 100,
    });
  } catch (error) {
    console.error('Get stock summary error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== LINK BAHAN BAKU KE MENU ITEM (BOM) ==============
const setMenuItemIngredients = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { menuItemId } = req.params;
    const { ingredients } = req.body;
    // ingredients: [ { stockItemId, quantityPerServing, notes? }, ... ]

    const menuItem = await MenuItem.findOne({ where: { id: menuItemId, tenantId } });
    if (!menuItem) {
      return sendResponse(res, 404, false, 'Menu item not found');
    }

    if (!Array.isArray(ingredients)) {
      return sendResponse(res, 400, false, '"ingredients" must be an array');
    }

    // Validasi setiap bahan baku
    for (const ing of ingredients) {
      if (!ing.stockItemId || !ing.quantityPerServing || parseFloat(ing.quantityPerServing) <= 0) {
        return sendResponse(res, 400, false, 'Each ingredient must have stockItemId and quantityPerServing > 0');
      }
      const si = await StockItem.findOne({ where: { id: ing.stockItemId, tenantId, isActive: true } });
      if (!si) {
        return sendResponse(res, 400, false, `Stock item ID ${ing.stockItemId} not found or inactive`);
      }
    }

    const t = await db.sequelize.transaction();
    try {
      // Hapus BOM lama untuk menu item ini, lalu re-insert
      await MenuItemStock.destroy({ where: { menuItemId, tenantId }, transaction: t });

      const records = ingredients.map((ing) => ({
        tenantId,
        menuItemId: parseInt(menuItemId, 10),
        stockItemId: ing.stockItemId,
        quantityPerServing: parseFloat(ing.quantityPerServing),
        notes: ing.notes || null,
      }));

      await MenuItemStock.bulkCreate(records, { transaction: t });
      await t.commit();

      const bom = await MenuItemStock.findAll({
        where: { menuItemId, tenantId },
        include: [
          { model: StockItem, as: 'stockItem', include: [{ model: StockUnit, as: 'unit', attributes: ['id', 'name', 'symbol'] }] },
        ],
      });

      return sendResponse(res, 200, true, 'Menu item ingredients updated successfully', { menuItemId, ingredients: bom });
    } catch (err) {
      await t.rollback();
      throw err;
    }
  } catch (error) {
    console.error('Set menu item ingredients error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET BAHAN BAKU DARI MENU ITEM (BOM) ==============
const getMenuItemIngredients = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { menuItemId } = req.params;

    const menuItem = await MenuItem.findOne({ where: { id: menuItemId, tenantId } });
    if (!menuItem) {
      return sendResponse(res, 404, false, 'Menu item not found');
    }

    const bom = await MenuItemStock.findAll({
      where: { menuItemId, tenantId },
      include: [
        {
          model: StockItem,
          as: 'stockItem',
          attributes: ['id', 'name', 'currentStock', 'minimumStock'],
          include: [{ model: StockUnit, as: 'unit', attributes: ['id', 'name', 'symbol'] }],
        },
      ],
    });

    return sendResponse(res, 200, true, 'Menu item ingredients retrieved', {
      menuItem: { id: menuItem.id, name: menuItem.name },
      ingredients: bom,
    });
  } catch (error) {
    console.error('Get menu item ingredients error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

module.exports = {
  createStockItem,
  getStockItems,
  getStockItemById,
  updateStockItem,
  deleteStockItem,
  getStockSummary,
  setMenuItemIngredients,
  getMenuItemIngredients,
};

