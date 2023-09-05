const express = require('express')
const mongoose = require('mongoose')
const dotenv = require('dotenv')
const router = require('./routes')
const app = express()
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
