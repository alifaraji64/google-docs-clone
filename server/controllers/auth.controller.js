import { User } from '../models/User.js'
import jwt from 'jsonwebtoken'

export class AuthController {
  static async signup (req, res) {
    console.log('sign up')
    try {
      const { email, name, photoURL } = req.body
      let user = await User.findOne({ email })
      if (user) {
        return res.status(409).json({ message: 'user already exists' })
      }
      //user doesn't exist on database we can register
      let newUser = new User({ email, name, photoURL })
      newUser = await newUser.save()
      let token = jwt.sign({ id: newUser._id }, 'jwtKey')
      res.json({ user: newUser, jwt: token })
    } catch (error) {
      console.log(error)
      res.status(500).json({ message: error })
    }
  }

  static async userData (req, res) {
    try {
      let user = await User.findById(req.id)
      return res.json({ user, token: req.token })
    } catch (error) {}
  }
}
