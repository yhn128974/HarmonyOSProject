import { QuestionClassify } from '../models'
import { CloudDataBase } from './index'

export class QuestionClassifyServer {
  static async getQuestClassify() {
    const database = await CloudDataBase.getCloudDataBase()
    const data = await database!.collection<QuestionClassify>(QuestionClassify)
      .query()
      .orderByAsc("id")
      .get()
    return data
  }
}