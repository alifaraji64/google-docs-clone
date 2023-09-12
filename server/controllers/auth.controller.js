import { User } from '../models/User.js'
import jwt from 'jsonwebtoken'

export class AuthController {
  static async signup (req, res) {
    console.log('sign up')
    try {
      const { email, name, photoURL } = req.body
      let user = await User.findOne({ email })
      let token
      if (user) {
        token = jwt.sign({ id: user._id }, 'jwtKey')
        return res.json({ user, jwt: token })
      }
      //user doesn't exist on database we can register
      let newUser = new User({ email, name, photoURL })
      newUser = await newUser.save()
      token = jwt.sign({ id: newUser._id }, 'jwtKey')
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
