require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const bcrypt = require('bcryptjs');
const bodyParser = require('body-parser');
const cors = require('cors');
const crypto = require('crypto');
const multer = require('multer');
const path = require('path');
const socketIo = require("socket.io");
const http = require("http");

const app = express();
const PORT = process.env.PORT || 5000;
const server = http.createServer(app);
const io = socketIo(server, { cors: { origin: "*",methods: ["GET", "POST"], } });

app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME
});

db.connect(err => {
    if (err) {
        console.error('Database connection error:', err);
        return;
    }
    console.log('✅ Connected to database');
});

app.post('/register', async (req, res) => {
    try {
        const { nom, prenom, email, mot_de_passe } = req.body;

        if (!nom || !prenom || !email || !mot_de_passe) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        const hashedPassword = await bcrypt.hash(mot_de_passe, 10);

        const sql = `INSERT INTO users (nom, prenom, email, mot_de_passe, photo_profil, role) VALUES (?, ?, ?, ?, ?, ?)`;
        db.query(sql, [nom, prenom, email, hashedPassword, null, 'client'], (err, result) => {
            if (err) return res.status(500).json({ message: 'Registration error', error: err });
            res.json({ message: 'Account created successfully' });
        });
    } catch (error) {
        res.status(500).json({ message: 'Server error', error });
    }
});


app.post('/login', (req, res) => {
    const { email, mot_de_passe } = req.body;

    if (!email || !mot_de_passe) {
        return res.status(400).json({ message: 'All fields are required' });
    }

    const sql = 'SELECT * FROM users WHERE email = ?';
    db.query(sql, [email], async (err, results) => {
        if (err) return res.status(500).json({ message: 'Database error', error: err });
        if (results.length === 0) return res.status(401).json({ message: 'Email not registered' });

        const user = results[0];
        const isMatch = await bcrypt.compare(mot_de_passe, user.mot_de_passe);

        if (!isMatch) return res.status(401).json({ message: 'Incorrect password' });

        res.json({ message: 'Login successful', user });
    });
});
app.get('/search-user', (req, res) => {
    const query = req.query.query;
    if (!query) return res.json([]); 

    const sql = `SELECT id, nom, prenom FROM users WHERE id LIKE ? OR nom LIKE ? OR prenom LIKE ? LIMIT 5`;
    db.query(sql, [`%${query}%`, `%${query}%`, `%${query}%`], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ message: "❌ Database error", error: err });
        }
        res.json(results);
    });
});
const generateTicketCode = () => crypto.randomBytes(10).toString('hex');


app.post('/buy-ticket', (req, res) => {
    const { user_id, nombre_passage, total_price, state, share_ticket,type_ticket } = req.body;

    if (!user_id || !nombre_passage || !total_price || !state) {
        return res.status(400).json({ message: "⚠️ All fields are required." });
    }

    const code_ticket = generateTicketCode();
    const valide = "yes";

    const sql = `INSERT INTO tickets (user_id, nombre_passage, code_ticket, total_price, valide, state, share_ticket, type_ticket)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

    db.query(sql, [user_id, nombre_passage, code_ticket, total_price, valide, state, share_ticket || null, type_ticket || "standard"], 
        (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ message: "❌ Error while purchasing the ticket.", error: err });
            }
            res.json({ 
                message: "✅ Ticket purchased successfully 🎫", 
                ticket: { 
                    id: result.insertId, 
                    user_id, 
                    nombre_passage, 
                    code_ticket, 
                    total_price, 
                    valide, 
                    state, 
                    share_ticket,
                    type_ticket: type_ticket || "standard" 
                } 
            });
        });
});
const generateCodeCard = () => crypto.randomBytes(10).toString('hex').toUpperCase();


app.post('/subscribe', (req, res) => {
    const { user_id, state, subscription_type, duration, total_price, student_id_path, date_debut } = req.body;

    if (!user_id || !state || !subscription_type || !duration || !total_price || !date_debut) {
        return res.status(400).json({ message: "⚠️ All required fields are not filled." });
    }

    const code_card = generateCodeCard();
    const date_fin = calculateEndDate(date_debut, duration);
    let statut;
    if (subscription_type === "student") {
        statut = "suspendu";
    } else {
        statut = "actif";
    }
    
    const sql = `INSERT INTO abonnements (user_id, state, subscription_type, code_card, duration, total_price, student_id_path, date_debut, date_fin, statut)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    db.query(sql, [user_id, state, subscription_type, code_card, duration, total_price, student_id_path || null, date_debut, date_fin, statut], 
        (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ message:"Error creating subscription.", error: err });
            }
            res.json({ 
                message:"Subscription created successfully"
, 
                subscription: { 
                    id: result.insertId, 
                    user_id, 
                    state, 
                    subscription_type, 
                    code_card, 
                    duration, 
                    total_price, 
                    student_id_path,
                    date_debut, 
                    date_fin, 
                    statut 
                } 
            });
        });
});


function calculateEndDate(startDate, duration) {
    let date = new Date(startDate);
    switch (duration) {
        case "1mois":
            date.setMonth(date.getMonth() + 1);
            break;
        case "3mois":
            date.setMonth(date.getMonth() + 3);
            break;
        case "6mois":
            date.setMonth(date.getMonth() + 6);
            break;
        case "1ans":
            date.setFullYear(date.getFullYear() + 1);
            break;
    }
    return date.toISOString().split('T')[0]; 
}
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, "uploads/");
    },
    filename: (req, file, cb) => {
      cb(null, Date.now() + path.extname(file.originalname));
    },
  });
  
  const upload = multer({
    storage: storage,
    fileFilter: (req, file, cb) => {
      const fileTypes = /pdf|jpg|jpeg|png|docx/; 
      const extName = fileTypes.test(path.extname(file.originalname).toLowerCase());
  
      if (extName) {
        return cb(null, true);
      } else {
        cb("Error: Only PDF, JPG, JPEG, PNG, and DOCX files are allowed!"); 
      }
    },
  });
  
 
  app.post("/upload", upload.single("file"), (req, res) => {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded!" });
    }
    res.status(200).json({
      message: "File uploaded successfully!",
      filePath: `uploads/${req.file.filename}`,
    });
  });
  app.use("/uploads", express.static("uploads"));

  app.get('/last-active-subscription/:user_id', (req, res) => {
    const userId = req.params.user_id;  
    
    const query = `
      SELECT * FROM abonnements
      WHERE statut = 'actif' AND user_id = ?
      ORDER BY date_fin DESC
      LIMIT 1;
    `;
    
    db.query(query, [userId], (err, results) => {
      if (err) {
        console.error('Error executing query:', err);
        return res.status(500).json({ error: 'An error occurred while fetching data' });
      }
      

      if (results.length > 0) {
        return res.json({
          message: 'Last active subscription found',
          data: results[0] 
        });
      } else {
        return res.status(404).json({ message: 'No active subscription found for this user' });
      }
    });
  });

  app.get('/last-active-tickets/:user_id', (req, res) => {
    const userId = req.params.user_id;  
    
    const query = `
      SELECT * FROM tickets
      WHERE statut = 'actif' AND user_id = ?
      ORDER BY date_creation DESC
      LIMIT 1;
    `;
    
    db.query(query, [userId], (err, results) => {
      if (err) {
        console.error('Error executing query:', err);
        return res.status(500).json({ error: 'An error occurred while fetching data' });
      }
      

      if (results.length > 0) {
        return res.json({
          message: 'Last active subscription found',
          data: results[0] 
        });
      } else {
        return res.status(404).json({ message: 'No active subscription found for this user' });
      }
    });
  });
  app.get('/pending-abonnements', (req, res) => {
    const sql = `
        SELECT * FROM abonnements 
        INNER JOIN users ON abonnements.user_id = users.id
        WHERE validation = 'pending'
    `;

    db.query(sql, (err, results) => {
        if (err) {
            console.error("Error fetching data:", err);
            res.status(500).json({ error: "An error occurred while retrieving data" });
        } else {
            res.json(results);
        }
    });
});

app.put('/update-abonnement/:id', (req, res) => {
  const abonnementId = req.params.id;
  const { validation } = req.body; 
console.log(req.body);
console.log(abonnementId);
  if (!['approved', 'rejected'].includes(validation)) {
      return res.status(400).json({ error: "Invalid validation status" });
  }

  const sql = `UPDATE abonnements SET validation = ? WHERE id_ab = ?`;

  db.query(sql, [validation, abonnementId], (err, result) => {
      if (err) {
          console.error("❌ Error updating abonnement:", err);
          return res.status(500).json({ error: "An error occurred while updating validation status" });
      }

      if (result.affectedRows === 0) {
          return res.status(404).json({ error: "Abonnement not found" });
      }

      res.json({ message: `Abonnement ${abonnementId} updated to ${validation}` });
  });
});

app.get('/api/conversations/:userId', (req, res) => {
  const userId = req.params.userId;

  const query = `
      SELECT DISTINCT 
          u.id, 
          u.nom, 
          u.prenom, 
          u.email, 
          u.photo_profil, 
          u.role,
          (
              SELECT m.contenu 
              FROM messages m 
              WHERE (m.sender_id = u.id AND m.receiver_id = ?) 
                 OR (m.sender_id = ? AND m.receiver_id = u.id) 
              ORDER BY m.date_envoi DESC 
              LIMIT 1
          ) AS lastMessage,
          (
              SELECT m.date_envoi 
              FROM messages m 
              WHERE (m.sender_id = u.id AND m.receiver_id = ?) 
                 OR (m.sender_id = ? AND m.receiver_id = u.id) 
              ORDER BY m.date_envoi DESC 
              LIMIT 1
          ) AS lastMessageTime
      FROM users u 
      WHERE u.id IN (
          SELECT DISTINCT 
              CASE 
                  WHEN m.sender_id = ? THEN m.receiver_id 
                  ELSE m.sender_id 
              END 
          FROM messages m 
          WHERE m.sender_id = ? OR m.receiver_id = ? 
      ) 
      ORDER BY lastMessageTime DESC;
  `;

  db.query(query, [userId, userId, userId, userId, userId, userId, userId], (error, results) => {
      if (error) {
          console.error('Query error:', error);
          return res.status(500).json({ error:'An error occurred while retrieving data' });
      }
      res.json(results);
  });
});
;

app.post("/sendMessage", async (req, res) => {
  try {
    const { sender_id, receiver_id, contenu } = req.body;
    const query = "INSERT INTO messages (sender_id, receiver_id, contenu) VALUES (?, ?, ?)";
    
    db.query(query, [sender_id, receiver_id, contenu], (err, result) => {
      if (err) {
        console.error(" Error inserting message:", err);
        return res.status(500).json({ success: false, error: err.message });
      }

      const messageData = { id: result.insertId, sender_id, receiver_id, contenu, date_envoi: new Date() };

      io.to(receiver_id.toString()).emit("newMessage", messageData);

      res.json({ success: true, message: messageData });
    });
  } catch (error) {
    console.error(" Server error:", error);
    res.status(500).json({ success: false, error: error.message });
  }
});


app.get("/messages/:user1/:user2", async (req, res) => {
  try {
    const { user1, user2 } = req.params;
    const query = `
      SELECT * FROM messages 
      WHERE (sender_id = ? AND receiver_id = ?) 
         OR (sender_id = ? AND receiver_id = ?) 
      ORDER BY date_envoi ASC
    `;

    db.query(query, [user1, user2, user2, user1], (err, results) => {
      if (err) {
        console.error("Error fetching messages:", err);
        return res.status(500).json({ success: false, error: err.message });
      }
      res.json(results);
    });
  } catch (error) {
    console.error("Server error:", error);
    res.status(500).json({ success: false, error: error.message });
  }
});


io.on("connection", (socket) => {
  console.log("🔵 User connected");

  socket.on("join", (userId) => {
    console.log(`👤 User ${userId} joined`);
    socket.join(userId.toString()); 
  });

  socket.on("disconnect", () => {
    console.log("🔴 User disconnected");
  });
});


function sendNotification(userId, message) {
  io.to(userId.toString()).emit("notification", { message });
  console.log(`📩 Sent notification to user ${userId}: ${message}`);
}


setTimeout(() => {
  sendNotification(1, "🚀 Hello! This is your first notification.");
}, 5000);


app.put("/update-photo/:id", upload.single("photo_profil"), (req, res) => {
  const userId = req.params.id;

 
  if (!req.file) {
    return res.status(400).json({ error: "A new image must be uploaded." });
  }

  const newPhoto = req.file.filename;

  db.query("SELECT photo_profil FROM users WHERE id = ?", [userId], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    
    if (result.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }

    const oldPhoto = result[0].photo_profil;


    db.query(
      "UPDATE users SET photo_profil = ? WHERE id = ?",
      [newPhoto, userId],
      (err, updateResult) => {
        if (err) {
          return res.status(500).json({ error: err.message });
        }


        if (oldPhoto) {
          const fs = require("fs");
          const oldPhotoPath = `uploads/${oldPhoto}`;
          fs.unlink(oldPhotoPath, (err) => {
            if (err) console.error("Error deleting old image:", err);
          });
        }

        res.json({
          message: "Image updated successfully",
          newPhotoUrl: `http://localhost:5000/uploads/${newPhoto}`,
        });
      }
    );
  });
});

app.post("/validate", (req, res) => {
  const { code_ticket } = req.body;
 console.log(code_ticket);
  if (!code_ticket) {
    return res.status(400).json({ error: "Code ticket is required" });
  }

  db.query(
    "SELECT * FROM tickets WHERE code_ticket = ?",
    [code_ticket],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: "Database error" });
      }

      if (results.length === 0) {
        return res.status(404).json({ valid: false, message: "Ticket not found" });
      }

      const ticket = results[0];

  
      if (ticket.statut === "actif" && ticket.valide === "yes") {
        res.json({ valid: true, message: "Ticket is valid", ticket });
      } else {
        res.json({ valid: false, message: "Ticket is expired or suspended", ticket });
      }
    }
  );
});

app.post("/validatecard", (req, res) => {
  const { code_ticket } = req.body;
 console.log(code_ticket + 'ttttttt');
  if (!code_ticket) {
    return res.status(400).json({ error: "Code card is required" });
  }

  db.query(
    "SELECT * FROM abonnements WHERE code_card = ?",
    [code_ticket],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: "Database error" });
      }

      if (results.length === 0) {
        return res.status(404).json({ valid: false, message: "card not found" });
      }

      const card = results[0];

   
      if (card.statut === "actif" && card.validation === "approved") {
        res.json({ valid: true, message: "card is valid", card });
      } else {
        res.json({ valid: false, message: "card is expired or suspended", card });
      }
    }
  );
});


app.post("/validate-and-update", (req, res) => {
  const { code_ticket } = req.body;

  if (!code_ticket) {
    return res.status(400).json({ error: "Code ticket is required" });
  }

      
        db.query(
          "UPDATE tickets SET valide = 'no' WHERE code_ticket = ?",
          [code_ticket],
          (updateErr, updateResult) => {
            if (updateErr) {
              return res.status(500).json({ error: "Failed to update ticket" });
            }

            res.json({
              valid: true,
              message: "Ticket is valid and has been used",
              ticket: { valide: "no" }, 
            });
          }
        );
    
    }
  );

  app.put('/api/users/:id', (req, res) => {
    const userId = req.params.id;
    const { nom, prenom, email, phone, address, photo_profil } = req.body;
    console.log(nom +prenom+email+phone+address );
    const sql = `UPDATE users SET nom = ?, prenom = ?, email = ?, phone = ?, address = ? WHERE id = ?`;
    const values = [nom, prenom, email, phone, address,  userId];
  
    db.query(sql, values, (err, result) => {
      if (err) {
        console.error('Error updating user:', err);
        return res.status(500).json({ message: 'Database error' });
      }
  
      if (result.affectedRows === 0) {
        return res.status(404).json({ message: 'User not found' });
      }
  
      res.json({ message: 'User updated successfully' });
    });
  });

app.post("/send-notification", (req, res) => {
  const { user_id, message } = req.body;

  const sql = "INSERT INTO notifications (user_id, message) VALUES (?, ?)";
  db.query(sql, [user_id, message], (err, result) => {
    if (err) {
      console.error(" Error sending notification:", err);
      return res.status(500).json({ error: "Database error" });
    }
    console.log(`📩 Notification sent to user ${user_id}: ${message}`);
    res.json({ success: true });
  });
});
app.put("/notifications/:id/read", (req, res) => {
  const id = req.params.id;
  const sql = "UPDATE notifications SET lu = 1 WHERE id = ?";

  db.query(sql, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: "Database error" });
    }
    res.json({ message: "Notification marked as read" });
  });
});


app.put("/notifications/:userId/read-all", (req, res) => {
  const userId = req.params.userId;
  const sql = "UPDATE notifications SET lu = 1 WHERE user_id = ?";

  db.query(sql, [userId], (err, result) => {
    if (err) {
      return res.status(500).json({ error: "Database error" });
    }
    res.json({ message: "All notifications marked as read" });
  });
});

app.get("/notifications/:user_id", (req, res) => {
  const { user_id } = req.params;
  const sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY date_envoi DESC";

  db.query(sql, [user_id], (err, results) => {
    if (err) {
      console.error(" Error fetching notifications:", err);
      return res.status(500).json({ error: "Database error" });
    }
    res.json(results);
  });
});

app.get("/notifications/:userId/unread-count", (req, res) => {
  const userId = req.params.userId;
  const sql = "SELECT COUNT(*) AS unread_count FROM notifications WHERE user_id = ? AND lu = 0";

  db.query(sql, [userId], (err, result) => {
    if (err) {
      return res.status(500).json({ error: "Database error" });
    }
    res.json({ unread_count: result[0].unread_count });
  });
});

// async function createUser(nom, prenom, email, mot_de_passe, role = 'client') {
//   try {
//       const hashedPassword = await bcrypt.hash(mot_de_passe, 10);

//       const sql = `INSERT INTO users (nom, prenom, email, mot_de_passe, photo_profil, role) VALUES (?, ?, ?, ?, ?, ?)`;

//       db.query(sql, [nom, prenom, email, hashedPassword, null, role], (err, result) => {
//           if (err) {
//               console.error(" Error creating user:", err);
//           } else {
//               console.log("User created successfully:", result.insertId);
//           }
//       });
//   } catch (error) {
//       console.error("Encryption error:", error);
//   }
// }
// createUser("controller", "controller", "controller@gmail.com", "controller123", "controller");

app.listen(PORT, () => console.log(`🚀 Server running on http://localhost:${PORT}`));
