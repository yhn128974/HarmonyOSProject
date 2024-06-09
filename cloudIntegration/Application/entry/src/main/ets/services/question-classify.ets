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

  // 获取数据分类详细的id
  static async getQuestionClassifyDetail(classifyId: number) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionClassify>(QuestionClassify).query()
      .equalTo("is_del", false)
      .equalTo("id", classifyId)
      .get()
  }
}