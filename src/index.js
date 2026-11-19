const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const dotenv = require("dotenv");
const cors = require("cors");
const path = require("path");

// Load environment variables
dotenv.config();

// import database
const {testConnection} = require("./config/db");
const {db, syncDatabase} = require("./models");
// Import routes
const authRoutes = require("./routes/auth.routes");
const tenantRoutes = require("./routes/tenant.routes");
const userRoutes = require("./routes/user.routes");
const uploadRoutes = require("./routes/upload.routes");
const messageRoutes = require("./routes/message.routes");
const menuRoutes = require("./routes/menu.routes");
const orderRoutes = require("./routes/order.routes");
const publicRoutes = require("./routes/public.routes");
const permissionRoutes = require("./routes/permission.routes");
const notificationRoutes = require("./routes/notification.routes");
const tenantPaymentRoutes = require('./routes/tenantPayment.routes');
const promoRoutes = require("./routes/promo.routes");
const memberRoutes = require("./routes/member.routes");
const stockRoutes = require("./routes/stock.routes");

const multer = require("multer");

// Create Express app
const app = express();

//
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*",
    method: ["GET", "POST"],
  },
});

// Middleware
app.use(cors()); // Enable CORS
app.use(express.json()); // Parse JSON bodies
app.use(express.urlencoded({extended: true})); // Parse URL-encoded bodies

// Serve static files
app.use("/uploads", express.static(path.join(__dirname, "../uploads")));

// Health check endpoint
app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "API is running with socket.io!",
    version: "1.0.0",
    timestamp: new Date().toISOString(),
  });
});

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/tenants", tenantRoutes);
app.use("/api/users", userRoutes);
app.use("/api/upload", uploadRoutes);
app.use("/api/messages", messageRoutes);
app.use("/api/menu", menuRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/public", publicRoutes);
// Notifikasi realtime order (Server-Sent Events)
app.use("/api/notifications", notificationRoutes);
app.use("/api/permission", permissionRoutes);
// Konfigurasi privilege role per menu
app.use("/api/payments", tenantPaymentRoutes);
app.use("/api/promos", promoRoutes);
app.use("/api/members", memberRoutes);
app.use("/api/stock", stockRoutes);


// ============== SOCKET.IO EVENTS ==============

// Store connected users
const connectedUsers = new Map();

// Socket.io Events
io.on("connection", (socket) => {
  console.log(`User connected: ${socket.id}`);

  // Event: User joins the chat
  // tenantId WAJIB dikirim client supaya chat antar restoran tidak bercampur
  socket.on("user_join", (data) => {
    const {userId, userName, tenantId} = data;

    // Simpan socket ke room khusus tenant-nya (isolasi antar restoran)
    socket.data.tenantId = tenantId;
    socket.data.userId = userId;
    socket.join(`tenant_${tenantId}`);

    // Store user connected
    connectedUsers.set(userId, {
      socketId: socket.id,
      userName: userName,
      tenantId: tenantId,
      status: "online",
      jointAt: new Date(),
    });

    console.log(`👤 ${userName} joined (ID: ${userId}, tenant: ${tenantId})`);

    // Notify users pada tenant yang sama saja
    const onlineUsersInTenant = Array.from(connectedUsers.values()).filter(
      (u) => u.tenantId === tenantId
    );
    io.to(`tenant_${tenantId}`).emit("user_joined", {
      userId: userId,
      userName: userName,
      onlineUsers: onlineUsersInTenant,
    });
  });

  // event: User sends message
  socket.on("send_message", async (data) => {
    const {senderId, senderName, receipientId, message, timestamp, tenantId} = data;
    console.log(`message from ${senderName} (tenant ${tenantId}): ${message}`);

    try {
      // Simpan ke database supaya chat history persist (sebelumnya TODO)
      const saved = await db.Message.create({
        tenantId,
        senderId,
        senderName,
        recipientId: receipientId,
        message,
      });

      const chatMessage = {
        id: saved.id,
        senderId: saved.senderId,
        senderName: saved.senderName,
        receipientId: saved.recipientId,
        message: saved.message,
        timestamp: saved.createdAt,
        read: saved.read,
      };

      // Broadcast hanya ke socket yang berada di tenant yang sama
      io.to(`tenant_${tenantId}`).emit("receive_message", chatMessage);
    } catch (error) {
      console.error("❌ Failed to save message:", error.message);
      socket.emit("message_error", {message: "Failed to send message"});
    }
  });

  // event: user typing
  socket.on("typing", (data) => {
    const {userId, userName, tenantId} = data;

    socket.to(`tenant_${tenantId}`).emit("user_typing", {
      userId: userId,
      userName: userName,
    });
  });

  // event: user stop tyeping
  socket.on("stop_typing", (data) => {
    const {userId, tenantId} = data;

    socket.to(`tenant_${tenantId}`).emit("user_stop_typing", {
      userId: userId,
    });
  });

  // event: User Disconnect
  socket.on("disconnect", () => {
    // find user
    let disconnectedUser = null;
    let disconnectedTenant = null;
    for (const [userId, userData] of connectedUsers.entries()) {
      if (userData.socketId === socket.id) {
        disconnectedUser = userId;
        disconnectedTenant = userData.tenantId;
        connectedUsers.delete(userId);
        break;
      }
    }
    if (disconnectedUser) {
      console.log(`❌ User disconnected: ${disconnectedUser}`);
      const onlineUsersInTenant = Array.from(connectedUsers.values()).filter(
        (u) => u.tenantId === disconnectedTenant
      );
      io.to(`tenant_${disconnectedTenant}`).emit("user_left", {
        userId: disconnectedUser,
        onlineUsers: onlineUsersInTenant,
      });
    }
  });

  // event: Get online users (hanya untuk tenant socket ini)
  socket.on("get_online_users", () => {
    const tenantId = socket.data.tenantId;
    const onlineUsersInTenant = Array.from(connectedUsers.values()).filter(
      (u) => u.tenantId === tenantId
    );
    socket.emit("online_users_list", {
      users: onlineUsersInTenant,
    });
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found",
    path: req.originalUrl,
    method: req.method,
  });
});

// Error handler yang lebih detail
app.use((err, req, res, next) => {
  //console.error("Error Name:", err.name);
  console.error("Error Message:", err.message);
  console.error("Error Stack:", err.stack);

  // handle multi error
  if (err instanceof multer.MulterError) {
    if (err.code == "LIMIT_FILE_SIZE") {
      return res.status(400).json({
        success: false,
        message: "File size too large. Maximum 5MB",
      });
    }

    return res.status(400).json({
      success: false,
      message: err.message,
    });
  }

  res.status(err.status || 500).json({
    success: false,
    message: err.message || "Internal Server Error!",
    error:
      process.env.NODE_ENV === "development"
        ? {message: err.message, stack: err.stack}
        : undefined,
  });
});

// Initialize database & start server
// (sebelumnya server.listen dipanggil 2x - di sini & di bawah - sehingga
// bentrok port; sekarang server hanya dimulai SETELAH db siap)
const PORT = process.env.PORT || 3000;

const startServer = async () => {
  try {
    // test database connection
    await testConnection();

    // sync database
    await syncDatabase();

    // Start server (pakai `server`, bukan `app`, supaya socket.io ikut jalan)
    server.listen(PORT, () => {
      console.log(`
    ╔════════════════════════════════════════╗
║  🚀 Server running with Socket.io      ║
║  📝 Environment: ${process.env.NODE_ENV || "development"}              ║
║  🔗 Local: http://localhost:${PORT}       ║
║  💾 Database: Connected                ║
║  💬 Chat: Enabled                      ║
╚════════════════════════════════════════╝
    `);
    });
  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
};

startServer();


