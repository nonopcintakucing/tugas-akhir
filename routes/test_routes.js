const express = require('express')//untuk memanggil express dan arti require adalah meminjam atau mengimpor modul express agar dapat digunakan di file ini
const router = express.Router()//untuk membuat instance router atau membuat tempat route yang akan digunakan di file ini

router.get('/', (req, res) => {//untuk membuat route / yang akan mengembalikan response 'Ini adalah route test'
    res.send('Ini adalah route test')
})

module.exports = router;//untuk mengekspor router agar dapat digunakan di file lain