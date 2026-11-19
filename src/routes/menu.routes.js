const express = require('express');
const router = express.Router();
const {
  getCategories,
  createCategory,
  updateCategory,
  deleteCategory,
  getMenuItems,
  createMenuItem,
  updateMenuItem,
  deleteMenuItem,
} = require('../controllers/menu.controller');
const authMiddleware = require('../middleware/auth.middleware');
const { requireActiveTenant } = require('../middleware/tenant.middleware');
const { requireMenuPermission } = require('../middleware/permission.middleware');
const uploadMenuImage = require('../middleware/menuUpload.middleware');

// Semua route menu butuh login & tenant aktif
router.use(authMiddleware, requireActiveTenant);

// Kategori: akses mengikuti privilege role pada menu "menu"
router.get('/categories', requireMenuPermission('menu', 'read'), getCategories);
router.post('/categories', requireMenuPermission('menu', 'create'), uploadMenuImage.single('image'), createCategory);
router.put('/categories/:id', requireMenuPermission('menu', 'update'), uploadMenuImage.single('image'), updateCategory);
router.delete('/categories/:id', requireMenuPermission('menu', 'delete'), deleteCategory);

// Item menu: akses mengikuti privilege role pada menu "menu"
router.get('/items', requireMenuPermission('menu', 'read'), getMenuItems);
router.post('/items', requireMenuPermission('menu', 'create'), uploadMenuImage.single('image'), createMenuItem);
router.put('/items/:id', requireMenuPermission('menu', 'update'), uploadMenuImage.single('image'), updateMenuItem);
router.delete('/items/:id', requireMenuPermission('menu', 'delete'), deleteMenuItem);

module.exports = router;
