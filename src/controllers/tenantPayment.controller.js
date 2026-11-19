const { sendResponse } = require('../utils/response');
const { db } = require('../models');
const TenantPayment = db.TenantPayment;
const { uploadFile, deleteFile } = require('../utils/supabaseStorage');

// Get all payments for tenant
const getPayments = async (req, res) => {
  try {
    const payments = await TenantPayment.findAll({
      where: { tenantId: req.user.tenantId },
      order: [['created_at', 'DESC']],
    });
    return sendResponse(res, 200, true, 'Payments retrieved successfully', { payments });
  } catch (error) {
    console.error('Get payments error:', error.message);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// Get single payment
const getPayment = async (req, res) => {
  try {
    const { id } = req.params;
    const payment = await TenantPayment.findOne({
      where: { id, tenantId: req.user.tenantId },
    });
    if (!payment) {
      return sendResponse(res, 404, false, 'Payment not found');
    }
    return sendResponse(res, 200, true, 'Payment retrieved', { payment });
  } catch (error) {
    console.error('Get payment error:', error.message);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// Create payment - accepts optional QRIS image upload (field name: qris)
const createPayment = async (req, res) => {
  try {
    const { bankAccountName, bankAccountNumber, phoneConfirmation, deliveryDescription } = req.body;
    let qrisUrl = req.body.qrisUrl || null;
    // If a file is uploaded, store it and get public URL
    if (req.file) {
      const { publicUrl } = await uploadFile(
        req.file.buffer,
        req.file.originalname,
        req.file.mimetype,
        'payment',
      );
      qrisUrl = publicUrl;
    }
    const payment = await TenantPayment.create({
      tenantId: req.user.tenantId,
      bankAccountName,
      bankAccountNumber,
      phoneConfirmation,
      deliveryDescription,
      qrisUrl,
    });
    return sendResponse(res, 201, true, 'Payment created', { payment });
  } catch (error) {
    console.error('Create payment error:', error.message);
    if (error.name === 'SequelizeValidationError') {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, 'Server error');
  }
};

// Update payment - can replace QRIS via new upload (field name: qris) or keep existing URL
const updatePayment = async (req, res) => {
  try {
    const { id } = req.params;
    const payment = await TenantPayment.findOne({ where: { id, tenantId: req.user.tenantId } });
    if (!payment) {
      return sendResponse(res, 404, false, 'Payment not found');
    }
    const { bankAccountName, bankAccountNumber, phoneConfirmation, deliveryDescription, qrisUrl: qrisUrlBody } = req.body;
    let qrisUrl = qrisUrlBody ?? payment.qrisUrl;
    // If a new file is uploaded, replace the old image
    if (req.file) {
      // Delete old file if exists
      if (payment.qrisUrl) {
        await deleteFile(payment.qrisUrl);
      }
      const { publicUrl } = await uploadFile(
        req.file.buffer,
        req.file.originalname,
        req.file.mimetype,
        'payment',
      );
      qrisUrl = publicUrl;
    }
    await payment.update({
      bankAccountName: bankAccountName ?? payment.bankAccountName,
      bankAccountNumber: bankAccountNumber ?? payment.bankAccountNumber,
      phoneConfirmation: phoneConfirmation ?? payment.phoneConfirmation,
      deliveryDescription: deliveryDescription ?? payment.deliveryDescription,
      qrisUrl,
    });
    return sendResponse(res, 200, true, 'Payment updated', { payment });
  } catch (error) {
    console.error('Update payment error:', error.message);
    if (error.name === 'SequelizeValidationError') {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, 'Server error');
  }
};

// Delete payment - also remove stored QRIS image if present
const deletePayment = async (req, res) => {
  try {
    const { id } = req.params;
    const payment = await TenantPayment.findOne({ where: { id, tenantId: req.user.tenantId } });
    if (!payment) {
      return sendResponse(res, 404, false, 'Payment not found');
    }
    // Remove QRIS image from storage if it exists
    if (payment.qrisUrl) {
      await deleteFile(payment.qrisUrl);
    }
    await payment.destroy();
    return sendResponse(res, 200, true, 'Payment deleted');
  } catch (error) {
    console.error('Delete payment error:', error.message);
    return sendResponse(res, 500, false, 'Server error');
  }
};

module.exports = {
  getPayments,
  getPayment,
  createPayment,
  updatePayment,
  deletePayment,
};

