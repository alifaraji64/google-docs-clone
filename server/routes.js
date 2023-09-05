const { Router } = require('express')
const router = Router()

const AuthController = require('./controllers/auth.controller.js')

router.post('/signup', AuthController.signup)

module.exports = router
