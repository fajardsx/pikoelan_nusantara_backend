const { Op } = require('sequelize');
const { db } = require('../models');
const { sendResponse } = require('../utils/response');

const StockCategory = db.StockCategory;

// ============== CREATE KATEGORI BAHAN BAKU ==============
const createStockCategory = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { name, description } = req.body;

    if (!name) {
      return sendResponse(res, 400, false, 'Category name is required');
    }

    const existing = await StockCategory.findOne({
      where: { tenantId, name: name.trim() },
    });
    if (existing) {
      return sendResponse(res, 400, false, `Stock category "${name.trim()}" already exists`);
    }

    const category = await StockCategory.create({
      tenantId,
      name: name.trim(),
      description: description || null,
      isActive: true,
    });

    return sendResponse(res, 201, true, 'Stock category created successfully', { category });
  } catch (error) {
    console.error('Create stock category error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET ALL KATEGORI ==============
const getStockCategories = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { isActive } = req.query;

    const where = { tenantId };
    if (isActive !== undefined) {
      where.isActive = isActive === 'true' || isActive === true;
    }

    const categories = await StockCategory.findAll({
      where,
      order: [['name', 'ASC']],
    });

    return sendResponse(res, 200, true, 'Stock categories retrieved successfully', { categories });
  } catch (error) {
    console.error('Get stock categories error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET KATEGORI BY ID ==============
const getStockCategoryById = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const category = await StockCategory.findOne({ where: { id, tenantId } });
    if (!category) {
      return sendResponse(res, 404, false, 'Stock category not found');
    }

    return sendResponse(res, 200, true, 'Stock category retrieved successfully', { category });
  } catch (error) {
    console.error('Get stock category by id error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== UPDATE KATEGORI ==============
const updateStockCategory = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;
    const { name, description, isActive } = req.body;

    const category = await StockCategory.findOne({ where: { id, tenantId } });
    if (!category) {
      return sendResponse(res, 404, false, 'Stock category not found');
    }

    if (name) {
      const trimmedName = name.trim();
      if (trimmedName !== category.name) {
        const dup = await StockCategory.findOne({
          where: { tenantId, name: trimmedName, id: { [Op.ne]: id } },
        });
        if (dup) {
          return sendResponse(res, 400, false, `Stock category "${trimmedName}" already exists`);
        }
        category.name = trimmedName;
      }
    }

    if (description !== undefined) category.description = description || null;
    if (isActive !== undefined) category.isActive = Boolean(isActive);

    await category.save();
    return sendResponse(res, 200, true, 'Stock category updated successfully', { category });
  } catch (error) {
    console.error('Update stock category error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== DELETE KATEGORI ==============
const deleteStockCategory = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const category = await StockCategory.findOne({ where: { id, tenantId } });
    if (!category) {
      return sendResponse(res, 404, false, 'Stock category not found');
    }

    const used = await db.StockItem.count({ where: { categoryId: id } });
    if (used > 0) {
      category.isActive = false;
      await category.save();
      return sendResponse(res, 200, true, 'Category is in use by stock items; deactivated instead of deleted', { category });
    }

    await category.destroy();
    return sendResponse(res, 200, true, 'Stock category deleted successfully');
  } catch (error) {
    console.error('Delete stock category error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

module.exports = {
  createStockCategory,
  getStockCategories,
  getStockCategoryById,
  updateStockCategory,
  deleteStockCategory,
};

