const User = require('../models/User')

class AuthController {
  static async signup (req, res) {
    console.log('sign up')
    const { email, name, photoURL } = req.body
    let user = await User.findOne({ email })
    if (user) {
      return res.json({ msg: 'user already exists' })
    }
    //user doesn't exist on database we can register
    let newUser = new User({ email, name, photoURL })
    newUser = await newUser.save()
    res.json(newUser)
  }
}

module.exports = AuthController
