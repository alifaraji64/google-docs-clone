import { Document } from '../models/Document.js'

export class DoumentController {
  static async createDoc (req, res) {
    try {
      const { createdAt } = req.body
      let document = new Document({
        uid: req.id,
        title: 'Untitled Document',
        createdAt
      })
      await document.save()
      return res.json(document)
    } catch (error) {
      res.status(500).json({ message: e.message })
    }
  }
  static async getDoc (req, res) {
    try {
      let documents = await Document.find({ uid: req.id })
      return res.json(documents)
    } catch (error) {
      res.status(500).json({ message: e.message })
    }
  }
  static async changeTitle (req, res) {
    const { id, title } = req.body
    const document = await Document.findByIdAndUpdate(id, { title })
    try {
      const { id, title } = req.body
      const document = await Document.findByIdAndUpdate(id, { title })
      return res.json(document)
    } catch (error) {
      res.status(500).json({ message: e.message })
    }
  }

  static async getDocById (req, res) {
    try {
      const document = await Document.findById(req.params.id)
      return res.json(document)
    } catch (error) {
      res.status(500).json({ message: e.message })
    }
  }
}
