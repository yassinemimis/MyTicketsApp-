require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const bcrypt = require('bcryptjs');
const bodyParser = require('body-parser');
const cors = require('cors');
const crypto = require('crypto');
const multer = require('multer');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 5000;

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

// 🔹 API to Buy a Ticket
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
        return res.status(400).json({ message: "⚠️ جميع الحقول المطلوبة لم يتم ملؤها." });
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
                return res.status(500).json({ message: "❌ خطأ أثناء إنشاء الاشتراك.", error: err });
            }
            res.json({ 
                message: "✅ تم إنشاء الاشتراك بنجاح 🎟️", 
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

// 🔹 دالة لحساب تاريخ نهاية الاشتراك بناءً على المدة المختارة
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
    return date.toISOString().split('T')[0]; // إرجاع التاريخ بتنسيق YYYY-MM-DD
}
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, "uploads/"); // حفظ الملفات في مجلد "uploads"
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
      
      // إذا كان هناك سجل
      if (results.length > 0) {
        return res.json({
          message: 'Last active subscription found',
          data: results[0]  // إرجاع السجل الأخير مع جميع البيانات
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
  
app.listen(PORT, () => console.log(`🚀 Server running on http://localhost:${PORT}`));
