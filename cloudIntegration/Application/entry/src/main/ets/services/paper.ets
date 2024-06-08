import { QuestionPaper } from '../models'
import { CloudDataBase } from './index'

export class QuestionPaperService {
  static async getQuestionPaperList(classifyID: number) {
    const dataBase = await CloudDataBase.getCloudDataBase()
    // 指定或许的数据类型与参数配置
    return dataBase!.collection<QuestionPaper>(QuestionPaper)
      .query()
      .equalTo("classify_id", classifyID)
      .orderByAsc("order")
      .get()
}
}