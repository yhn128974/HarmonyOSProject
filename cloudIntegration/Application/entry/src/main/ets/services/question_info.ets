import { CloudDataBase } from '.'
import { QuestionInfo } from '../models'

export class QuestionInfoService {
  static async getQuestionList(classifyId: number, paperId: number) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionInfo>(QuestionInfo)
      .query()
      .equalTo("classify_id", classifyId)
      .equalTo("paper_id", paperId)
      .orderByAsc("order")
      .get()
  }
}