
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const db = require('./config/database');
const testRoutes = require('./routes/test_routes');
const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes tambahan
app.use('/api', testRoutes);

// ===============================
// CRUD USER
// ===============================

// Menampilkan semua user
app.get('/getuser', (req, res) => {
    const sql = 'SELECT * FROM user';

    db.query(sql, (err, result) => {
        if (err) {
            return res.status(500).json(err);
        }

        res.json(result);
    });
});

// Menampilkan user berdasarkan ID
app.get('/getuser/id/:id', (req, res) => {
    const sql = 'SELECT * FROM user WHERE id = ?';

    db.query(sql, [req.params.id], (err, result) => {
        if (err) {
            return res.status(500).json(err);
        }

        res.json(result);
    });
});

// Menambahkan user
app.post('/user', async (req, res) => {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
        return res.status(400).json({
            message: 'Nama, email, dan password harus diisi'
        });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);

        const sql = `
            INSERT INTO user (name, email, password)
            VALUES (?, ?, ?)
        `;

        db.query(sql, [name, email, hashedPassword], (err, result) => {
            if (err) {
                return res.status(500).json(err);
            }

            res.status(201).json({
                message: 'User berhasil ditambahkan',
                id: result.insertId
            });
        });
    } catch (error) {
        res.status(500).json({
            message: 'Terjadi kesalahan pada server'
        });
    }
});

// Login user
app.post('/login', (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({
            message: 'Email dan password harus diisi'
        });
    }

    const sql = 'SELECT * FROM user WHERE email = ?';

    db.query(sql, [email], async (err, result) => {
        if (err) {
            return res.status(500).json(err);
        }

        if (result.length === 0) {
            return res.status(401).json({
                message: 'Email tidak ditemukan'
            });
        }

        if (!result[0].password) {
            return res.status(401).json({
                message: 'Akun belum memiliki password'
            });
        }

        try {
            const cocok = await bcrypt.compare(
                password,
                result[0].password
            );

            if (!cocok) {
                return res.status(401).json({
                    message: 'Password salah'
                });
            }

            res.json({
                message: 'Login berhasil',
                user: {
                    id: result[0].id,
                    name: result[0].name,
                    email: result[0].email
                }
            });
        } catch (error) {
            res.status(500).json({
                message: 'Terjadi kesalahan pada server'
            });
        }
    });
});

// Mengubah user
app.put('/user/:id', async (req, res) => {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
        return res.status(400).json({
            message: 'Semua data harus diisi'
        });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);

        const sql = `
            UPDATE user
            SET name = ?, email = ?, password = ?
            WHERE id = ?
        `;

        db.query(
            sql,
            [name, email, hashedPassword, req.params.id],
            (err, result) => {
                if (err) {
                    return res.status(500).json(err);
                }

                if (result.affectedRows === 0) {
                    return res.status(404).json({
                        message: 'User tidak ditemukan'
                    });
                }

                res.json({
                    message: 'User berhasil diperbarui'
                });
            }
        );
    } catch (error) {
        res.status(500).json({
            message: 'Terjadi kesalahan pada server'
        });
    }
});

// Menghapus user
app.delete('/user/:id', (req, res) => {
    const sql = 'DELETE FROM user WHERE id = ?';

    db.query(sql, [req.params.id], (err, result) => {
        if (err) {
            return res.status(500).json(err);
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({
                message: 'User tidak ditemukan'
            });
        }

        res.json({
            message: 'User berhasil dihapus'
        });
    });
});

// ===============================
// CRUD DATA SISWA
// ===============================

// Menampilkan semua data siswa
app.get('/siswa', (req, res) => {
    const sql = 'SELECT * FROM siswa';

    db.query(sql, (err, result) => {
        if (err) {
            return res.status(500).json(err);
        }

        res.json(result);
    });
});

// Menambahkan data siswa
app.post('/siswa', (req, res) => {
    const {
        nipd,
        nama_lengkap,
        jenis_kelamin,
        alamat,
        kelas,
        jurusan
    } = req.body;

    if (!nipd || !nama_lengkap || !jenis_kelamin ||
        !alamat || !kelas || !jurusan) {
        return res.status(400).json({
            message: 'Semua data siswa harus diisi'
        });
    }

    const sql = `
        INSERT INTO siswa
        (nipd, nama_lengkap, jenis_kelamin, alamat, kelas, jurusan)
        VALUES (?, ?, ?, ?, ?, ?)
    `;

    db.query(sql, [
        nipd,
        nama_lengkap,
        jenis_kelamin,
        alamat,
        kelas,
        jurusan
    ], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).json({
                message: 'Gagal menambahkan siswa'
            });
        }

        res.status(201).json({
            message: 'Siswa berhasil ditambahkan',
            id: result.insertId
        });
    });
});

// Menampilkan data siswa berdasarkan ID
app.get('/siswa/:id', (req, res) => {
    const sql = 'SELECT * FROM siswa WHERE id = ?';

    db.query(sql, [req.params.id], (err, result) => {
        if (err) {
            return res.status(500).json(err);
        }

        if (result.length === 0) {
            return res.status(404).json({
                message: 'Data siswa tidak ditemukan'
            });
        }

        res.json(result[0]);
    });
});

// Mengubah data siswa
app.put('/siswa/:id', (req, res) => {
    const {
        nipd,
        nama_lengkap,
        jenis_kelamin,
        alamat,
        kelas,
        jurusan
    } = req.body;

    const sql = `
        UPDATE siswa
        SET nipd = ?, nama_lengkap = ?, jenis_kelamin = ?,
            alamat = ?, kelas = ?, jurusan = ?
        WHERE id = ?
    `;

    db.query(sql, [
        nipd,
        nama_lengkap,
        jenis_kelamin,
        alamat,
        kelas,
        jurusan,
        req.params.id
    ], (err, result) => {
        if (err) {
            return res.status(500).json(err);
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({
                message: 'Data siswa tidak ditemukan'
            });
        }

        res.json({
            message: 'Data siswa berhasil diperbarui'
        });
    });
});

// Menghapus data siswa
app.delete('/siswa/:id', (req, res) => {
    const sql = 'DELETE FROM siswa WHERE id = ?';

    db.query(sql, [req.params.id], (err, result) => {
        if (err) {
            return res.status(500).json(err);
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({
                message: 'Data siswa tidak ditemukan'
            });
        }

        res.json({
            message: 'Data siswa berhasil dihapus'
        });
    });
});

// ===============================
// MENJALANKAN SERVER
// ===============================

app.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});
