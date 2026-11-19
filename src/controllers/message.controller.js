const {sendResponse} = require("../utils/response");
const {db} = require("../models"); // Import db

const Message = db.Message;

// Get chat history
const getChatHistory = async (req, res) => {
  try {
    const {userId, receipientId} = req.query;

    // Get message between two users (scoped ke tenant milik user yang login,
    // supaya chat restoran A tidak bisa dibaca dari restoran B)
    const messages = await Message.findAll({
      where: {
        tenantId: req.user.tenantId,
        [db.sequelize.Sequelize.Op.or]: [
          {
            senderId: userId,
            recipientId: receipientId,
          },
          {
            senderId: receipientId,
            recipientId: userId,
          },
        ],
      },
      order: [["created_at", "ASC"]],
      limit: 50,
    });
    return sendResponse(res, 200, true, "Chat History", {
      messages,
      total: messages.length,
    });
  } catch (error) {
    console.error("Get chat history error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// get all message (Admin)
const getAllMessages = async (req, res) => {
  try {
    const messages = await Message.findAll({
      where: { tenantId: req.user.tenantId },
      order: [["created_at", "DESC"]],
      limit: 100,
    });

    return sendResponse(res, 200, true, "All messages", {
      messages,
      total: messages.length,
    });
  } catch (error) {
    console.error("Get all message error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// delete message
const deleteMessage = async (req, res) => {
  try {
    const {id} = req.params;

    // scoped ke tenant supaya tidak bisa hapus pesan restoran lain
    const message = await Message.findOne({
      where: { id, tenantId: req.user.tenantId },
    });
    if (!message) {
      return sendResponse(res, 404, false, "Message not found");
    }

    // pakai id dari token (bukan body) supaya tidak bisa dipalsukan
    if (message.senderId !== req.user.id) {
      return sendResponse(res, 403, false, "unauthorized to delete");
    }

    await message.destroy();
    return sendResponse(res, 200, true, "Message delete successfully");
  } catch (error) {
    console.error("Delete message error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

module.exports = {
  getChatHistory,
  getAllMessages,
  deleteMessage,
};
