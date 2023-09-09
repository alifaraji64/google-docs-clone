import { Router } from 'express'

export const router = Router()

import {AuthController} from './controllers/auth.controller.js'
import {authMiddleware} from './middlewares/auth.js'

router.post('/signup', AuthController.signup)
router.get('/user-data', authMiddleware, AuthController.userData)
