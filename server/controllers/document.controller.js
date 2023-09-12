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
    } catch (error) {
      res.status(500).json({ message: e.message })
    }
  }
}
