import express from 'express'
import mongoose from 'mongoose'
import dotenv from 'dotenv'
import { router } from './routes.js'
import cors from 'cors'
import http from 'http'
import socket from 'socket.io'
import { DoumentController } from './controllers/document.controller.js'
const app = express()

var server = http.createServer(app)
const io = socket(server)
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

io.on('connection', socket => {
  console.log('socket connected')
  socket.on('join', roomId => {
    socket.join(roomId)
  })
  socket.on('typing', data => {
    socket.broadcast.to(data.roomId).emit('changes', data)
  })
  socket.on('save', data => {
    DoumentController.updateContent(data)
  })
})

server.listen(8000, '0.0.0.0', () => {
  console.log('app is listening')
})
