const express = require("express");
const router = express.Router();
const {
  getChatHistory,
  getAllMessages,
  deleteMessage,
} = require("../controllers/message.controller"); // Import

const authMiddleware = require("../middleware/auth.middleware"); // Import

// get chat history between 2 users
router.get("/chat-history", authMiddleware, getChatHistory);

// get all messages (admin)
router.get("/all", authMiddleware, getAllMessages);

// delete message
router.delete('/:id', authMiddleware, deleteMessage);

module.exports = router;
