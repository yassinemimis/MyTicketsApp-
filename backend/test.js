const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const mysql = require("mysql2");

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// إعداد قاعدة البيانات MySQL
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "123456789",
  database: "tram"
});

db.connect((err) => {
  if (err) throw err;
  console.log("✅ MySQL Connected...");
});

// تخزين المستخدمين المتصلين
let onlineUsers = {};

io.on("connection", (socket) => {
  console.log("🔵 User connected", socket.id);

  socket.on("join", (userId) => {
    onlineUsers[userId] = socket.id;
    console.log(`👤 User ${userId} joined`);
    socket.join(userId.toString());
  });

  socket.on("disconnect", () => {
    const userId = Object.keys(onlineUsers).find(
      (key) => onlineUsers[key] === socket.id
    );
    if (userId) {
      delete onlineUsers[userId];
      console.log(`🔴 User ${userId} disconnected`);
    }
  });
});

// إرسال إشعار إلى مستخدم معين
const sendNotification = (userId, message) => {
  const query = "INSERT INTO notifications (user_id, message) VALUES (?, ?)";
  db.query(query, [userId, message], (err, result) => {
    if (err) throw err;
    console.log(`📩 Sent notification to user ${userId}: ${message}`);
    
    // إرسال الإشعار عبر Socket.IO إذا كان المستخدم متصلًا
    if (onlineUsers[userId]) {
      io.to(userId.toString()).emit("notification", { message });
    }
  });
};

// نقطة API لإرسال إشعار من Postman
app.post("/send-notification", express.json(), (req, res) => {
  const { userId, message } = req.body;
  sendNotification(userId, message);
  res.json({ success: true, message: "Notification sent" });
});

server.listen(5000, () => {
  console.log("🚀 Server running on http://192.168.1.3:3000");
});
