const { sendResponse } = require("../utils/response");
const { db } = require("../models");
const { uploadFile, deleteFile } = require("../utils/supabaseStorage");

const User = db.User;

const uploadProfilePicture = async (req, res) => {
  try {
    if (!req.file) {
      return sendResponse(res, 400, false, "Please upload a file");
    }

    const user = await User.findByPk(req.user.id);
    if (!user) {
      return sendResponse(res, 404, false, "User Not Found");
    }

    const oldPicture = user.profilePicture;

    const { publicUrl } = await uploadFile(req.file.buffer, req.file.originalname, req.file.mimetype, "profiles");
    await user.update({ profilePicture: publicUrl });

    // hapus foto lama setelah yang baru berhasil ke-upload
    if (oldPicture) {
      deleteFile(oldPicture).catch(() => {});
    }

    return sendResponse(res, 200, true, "Profile picture uploaded successfully", {
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        profilePicture: publicUrl,
        profilePictureUrl: publicUrl,
      },
    });
  } catch (error) {
    console.error("Upload profile picture error : ", error);
    return sendResponse(res, 500, false, error.message || "Server Error");
  }
};

const deleteProfilePicture = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id);
    if (!user) {
      return sendResponse(res, 404, false, "User not found");
    }

    if (!user.profilePicture) {
      return sendResponse(res, 400, false, "No profile picture to delete");
    }

    await deleteFile(user.profilePicture);
    await user.update({ profilePicture: null });

    return sendResponse(res, 200, true, "Profile picture deleted successfully");
  } catch (error) {
    console.error("Delete profile picture error:", error);
    return sendResponse(res, 500, false, "Server Error");
  }
};

module.exports = {
  uploadProfilePicture,
  deleteProfilePicture,
};
