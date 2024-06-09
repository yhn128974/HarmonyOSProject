import { QuestionUserAnswer } from '../models'
import { CloudDataBase } from './index'
import { QuestionInfoService } from '../services'

export class QuestionUserAnswerService {
  static async getAnswerList(classifyId: number, paperId: number, userId: string) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionUserAnswer>(QuestionUserAnswer)
      .query()
      .equalTo("classify_id", classifyId)
      .equalTo("paper_id", paperId)
      .equalTo("user_id", userId)
      .orderByAsc("question_info_id")//回答时间
      .get()
  }

  //    增加或者更新某个题目的答案
  static async upsertQuestionAnswer(answer: QuestionUserAnswer) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionUserAnswer>(QuestionUserAnswer).upsert(answer)
  }


  // 是否所有答案都有结果
  static async getIsAllAnswer(classifyId: number, paperId: number, userId: string) {
    const questionList = await QuestionInfoService.getQuestionInfoList(classifyId, paperId)
    // 查入库的答案

    const database = await CloudDataBase.getCloudDataBase()
    const result = await database!.collection<QuestionUserAnswer>(QuestionUserAnswer)
      .query()
      .equalTo("classify_id", classifyId)
      .equalTo("paper_id", paperId)
      .equalTo("user_id", userId)
      .In("question_info_id", questionList.map(item => item.id))
      .get()
    return result.length === questionList.length
  }
}