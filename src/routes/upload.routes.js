const express = require("express");
const router = express.Router();
const {
  uploadProfilePicture,
  deleteProfilePicture,
} = require("../controllers/upload.controller");
const authMiddleWare = require("../middleware/auth.middleware");
const upload = require("../middleware/upload.middleware");

//
router.post(
  "/profile-picture",
  authMiddleWare,
  upload.single("profilePicture"),
  uploadProfilePicture,
);

router.delete("/profile-picture", authMiddleWare, deleteProfilePicture);

module.exports = router;
