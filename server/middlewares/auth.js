import jwt from 'jsonwebtoken'
export const authMiddleware = async (req, res, next) => {
  try {
    const jwtFromUser = req.header('jwt')
    console.log(jwtFromUser);
    if (!jwtFromUser) {
      return res.status(401).json({ message: 'no jwt send from the user' })
    }

    const verified = jwt.verify(jwtFromUser, 'jwtKey')
    if (!verified) {
      return res.status(401).json({ message: 'token verification failed' })
    }
    req.id = verified.id
    req.jwt = jwtFromUser;
    next();
  } catch (error) {
    res.status(500).json({ message: error })
  }
}
