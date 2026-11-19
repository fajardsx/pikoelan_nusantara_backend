const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth.middleware');
const { requireActiveTenant } = require('../middleware/tenant.middleware');
const { requireMenuPermission } = require('../middleware/permission.middleware');

const {
  createUnit, getUnits, getUnitById, updateUnit, deleteUnit,
} = require('../controllers/stockUnit.controller');

const {
  createStockCategory, getStockCategories, getStockCategoryById,
  updateStockCategory, deleteStockCategory,
} = require('../controllers/stockCategory.controller');

const {
  createStockItem, getStockItems, getStockItemById,
  updateStockItem, deleteStockItem, getStockSummary,
  setMenuItemIngredients, getMenuItemIngredients,
} = require('../controllers/stockItem.controller');

const {
  recordMovement, getMovements, getMovementsByItem,
} = require('../controllers/stockMovement.controller');

// Semua route stock memerlukan login & tenant aktif
router.use(authMiddleware, requireActiveTenant);

// ──────────────────────────────────────────────────
// SATUAN STOK (Units)  →  /api/stock/units
// ──────────────────────────────────────────────────
router.get('/units',      requireMenuPermission('stock', 'read'),   getUnits);
router.post('/units',     requireMenuPermission('stock', 'create'), createUnit);
router.get('/units/:id',  requireMenuPermission('stock', 'read'),   getUnitById);
router.put('/units/:id',  requireMenuPermission('stock', 'update'), updateUnit);
router.delete('/units/:id', requireMenuPermission('stock', 'delete'), deleteUnit);

// ──────────────────────────────────────────────────
// KATEGORI BAHAN BAKU  →  /api/stock/categories
// ──────────────────────────────────────────────────
router.get('/categories',       requireMenuPermission('stock', 'read'),   getStockCategories);
router.post('/categories',      requireMenuPermission('stock', 'create'), createStockCategory);
router.get('/categories/:id',   requireMenuPermission('stock', 'read'),   getStockCategoryById);
router.put('/categories/:id',   requireMenuPermission('stock', 'update'), updateStockCategory);
router.delete('/categories/:id', requireMenuPermission('stock', 'delete'), deleteStockCategory);

// ──────────────────────────────────────────────────
// MASTER BAHAN BAKU (Items)  →  /api/stock/items
// ──────────────────────────────────────────────────
router.get('/summary',    requireMenuPermission('stock', 'read'), getStockSummary);
router.get('/items',      requireMenuPermission('stock', 'read'),   getStockItems);
router.post('/items',     requireMenuPermission('stock', 'create'), createStockItem);
router.get('/items/:id',  requireMenuPermission('stock', 'read'),   getStockItemById);
router.put('/items/:id',  requireMenuPermission('stock', 'update'), updateStockItem);
router.delete('/items/:id', requireMenuPermission('stock', 'delete'), deleteStockItem);

// ──────────────────────────────────────────────────
// MUTASI STOK (Movements)  →  /api/stock/movements
// ──────────────────────────────────────────────────
router.get('/movements',  requireMenuPermission('stock', 'read'),   getMovements);
router.post('/movements', requireMenuPermission('stock', 'create'), recordMovement);
router.get('/movements/item/:stockItemId', requireMenuPermission('stock', 'read'), getMovementsByItem);

// ──────────────────────────────────────────────────
// BAHAN BAKU PER MENU ITEM (BOM)  →  /api/stock/menu-items/:menuItemId/ingredients
// ──────────────────────────────────────────────────
router.get('/menu-items/:menuItemId/ingredients',  requireMenuPermission('stock', 'read'),   getMenuItemIngredients);
router.post('/menu-items/:menuItemId/ingredients', requireMenuPermission('stock', 'update'), setMenuItemIngredients);

module.exports = router;

