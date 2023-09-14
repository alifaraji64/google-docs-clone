import { Router } from 'express'

export const router = Router()

import { AuthController } from './controllers/auth.controller.js'
import { authMiddleware } from './middlewares/auth.js'
import { DoumentController } from './controllers/document.controller.js'

router.post('/signup', AuthController.signup)
router.get('/user-data', authMiddleware, AuthController.userData)
router.post('/create-doc', authMiddleware, DoumentController.createDoc)
router.get('/get-doc', authMiddleware, DoumentController.getDoc)
router.post('/change-doc-title', authMiddleware, DoumentController.changeTitle)
router.get('/get-doc/:id', authMiddleware, DoumentController.getDocById)
