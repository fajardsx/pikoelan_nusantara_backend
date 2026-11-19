const multer = require("multer");

// memoryStorage: file ditampung di RAM sebentar (req.file.buffer), lalu
// controller yang upload ke Supabase Storage. Tidak pernah ditulis ke disk
// lokal - penting karena banyak hosting (termasuk serverless) disknya sementara.
const storage = multer.memoryStorage();

const fileFilter = (req, file, cb) => {
  const allowedTypes = ["image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"];

  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error("Invalid file type. Only JPEG, PNG, GIF, and WEBP are allowed"), false);
  }
};

const uploadMenuImage = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
});

module.exports = uploadMenuImage;
