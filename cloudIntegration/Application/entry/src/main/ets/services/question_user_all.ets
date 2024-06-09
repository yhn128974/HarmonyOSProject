import { CloudDataBase } from '.'
import { QuestionUserAll } from '../models/question'

export class QuestionUserAllService {

  static async upsertQuestionUserAll(item: QuestionUserAll) {
    const dataBase = await CloudDataBase.getCloudDataBase()

    const result = dataBase!.collection<QuestionUserAll>(QuestionUserAll)
      .upsert(item)

    return result
  }

  // 获取用户已经交过的试题
  static async getQuestionUserDetail(classifyId: number, paperId: number, userId: string) {
    const dataBase = await CloudDataBase.getCloudDataBase()

    const result = dataBase!.collection<QuestionUserAll>(QuestionUserAll)
      .query()
      .equalTo("classify_id", classifyId)
      .equalTo("paper_id", paperId)
      .equalTo("user_id", userId)
      .get()
    return result
  }
}