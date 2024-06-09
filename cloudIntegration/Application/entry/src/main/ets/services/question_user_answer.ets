import { QuestionUserAnswer } from '../models'
import { CloudDataBase } from './index'


export class QuestionUserAnswerService {
  static async getAnswerList(classifyId: number, paperId: number, userId: string) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionUserAnswer>(QuestionUserAnswer)
      .query()
      .equalTo("classify_id", classifyId)
      .equalTo("paper_id", paperId)
      .equalTo("user_id", userId)
      .orderByAsc("answer_time")
      .get()
  }

  //    增加或者更新某个题目的答案
  static async upsertQuestionAnswer(answer: QuestionUserAnswer) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionUserAnswer>(QuestionUserAnswer).upsert(answer)
  }
}