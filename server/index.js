import express from 'express'
import mongoose from 'mongoose'
import dotenv from 'dotenv'
import {router} from './routes.js'
import cors from 'cors'
const app = express()

app.use(cors())
app.use(express.json())
app.use(router)

dotenv.config()
mongoose
  .connect(process.env.DB_CONNECTION_STRING)
  .then(() => {
    console.log('mongodb connected')
  })
  .catch(console.log)

app.listen(8000, '0.0.0.0', () => {
  console.log('app is listening')
})
