import mongoose from 'mongoose'

const userSchema = mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true
  },
  name: {
    type: String,
    required: true
  },
  photoURL: {
    type: String,
    required: true
  }
})

export const User = mongoose.model('user', userSchema)
