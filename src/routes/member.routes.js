const express = require('express');
const router = express.Router();
const {
  createMember,
  getMembers,
  lookupMember,
  validateMemberByPhone,
  getMemberById,
  updateMember,
  adjustMemberPoints,
  getMemberPointHistory,
  deleteMember,
  getMemberStats,
} = require('../controllers/member.controller');
const authMiddleware = require('../middleware/auth.middleware');
const { requireActiveTenant } = require('../middleware/tenant.middleware');
const { requireMenuPermission } = require('../middleware/permission.middleware');

// Semua route membership butuh login & tenant aktif
router.use(authMiddleware, requireActiveTenant);

// Statistik & Lookup cepat
// Statistik & Lookup / Validasi
router.get('/stats', requireMenuPermission('memberships', 'read'), getMemberStats);
router.get('/lookup', requireMenuPermission('memberships', 'read'), lookupMember);
router.post('/validate-phone', requireMenuPermission('memberships', 'read'), validateMemberByPhone);
router.get('/validate-phone', requireMenuPermission('memberships', 'read'), validateMemberByPhone);
router.get('/by-phone/:phone', requireMenuPermission('memberships', 'read'), validateMemberByPhone);

// Points & History
router.post('/:id/points', requireMenuPermission('memberships', 'update'), adjustMemberPoints);
router.get('/:id/history', requireMenuPermission('memberships', 'read'), getMemberPointHistory);

// CRUD Member
router.get('/', requireMenuPermission('memberships', 'read'), getMembers);
router.post('/', requireMenuPermission('memberships', 'create'), createMember);
router.get('/:id', requireMenuPermission('memberships', 'read'), getMemberById);
router.put('/:id', requireMenuPermission('memberships', 'update'), updateMember);
router.delete('/:id', requireMenuPermission('memberships', 'delete'), deleteMember);

module.exports = router;

