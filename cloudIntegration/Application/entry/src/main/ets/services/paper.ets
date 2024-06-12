import { CloudDataBase } from '.'
import { QuestionPaper } from '../models'

export class QuestionPaperService {
  static async getQuestionPaperList(classifyId: number) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionPaper>(QuestionPaper)
      .query()
      .equalTo("classify_id", classifyId)
      .orderByAsc("order")
      .get()
  }
}