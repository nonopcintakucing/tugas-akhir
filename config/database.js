const mysql = require('mysql2');

const db = mysql.createConnection({
    host: '127.0.0.1', // Ganti dengan host database Anda
    user: 'root', // Ganti dengan username database Anda
    password: '', // Ganti dengan password database Anda
    database: 'belajar_express' // Ganti dengan nama database Anda
});

module.exports = db;

