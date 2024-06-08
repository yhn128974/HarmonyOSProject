import { CloudDataBase } from '.'
import { QuestionInfo } from '../models'


export class QuestionInfoService {
  static async getQuestionInfoList(classifyId: number, paperId: number) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionInfo>(QuestionInfo)
      .query()
      .equalTo("classify_id", classifyId)
       .and()
      .equalTo("paper_id", paperId)
      .orderByAsc("order")
      .get()
  }
}