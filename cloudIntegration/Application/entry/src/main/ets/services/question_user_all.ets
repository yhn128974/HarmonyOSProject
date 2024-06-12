import { CloudDataBase } from '.'
import { QuestionScoreDisplay, QuestionUserAll, UserInfo, UserCollect, QuestionUserAnswer } from '../models'

export class QuestionUserAllService {
  // 更新或者插入的结果
  static async upsertQuestionUserAll(item: QuestionUserAll) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionUserAll>(QuestionUserAll)
      .upsert(item)
  }

  // 获取用户是否已经交卷
  static async getQuestionUserDetail(classifyId: number, paperId: number, userId: string) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionUserAll>(QuestionUserAll)
      .query()
      .equalTo("classify_id", classifyId)
      .equalTo("paper_id", paperId)
      .equalTo("user_id", userId)
      .get()
  }

  // 删除用户结果的
  static async delQuestionQuestionUserAll(result: QuestionUserAll) {
    const database = await CloudDataBase.getCloudDataBase()
    return database!.collection<QuestionUserAll>(QuestionUserAll)
      .delete(result)
  }

  // 获取所有人的用户的成绩 前6名
  static async getAllUserTop() {
    const database = await CloudDataBase.getCloudDataBase()
    const result = await database!.collection<QuestionUserAll>(QuestionUserAll)
      .query()
      .orderByDesc("score")
      .limit(6)
      .get()

    // 每个结果去查用户的昵称和头像
    let index = 0
    let arr: QuestionScoreDisplay[] = []
    while (index < result.length) {
      const userResult = await database?.collection<UserInfo>(UserInfo)
        .query()
        .equalTo("user_id", result[index].user_id)
        .get()
      arr.push(new QuestionScoreDisplay(result[index],
        userResult?.length ? userResult[0].avatar : "",
        userResult?.length ? userResult[0].nick_name : "",
      ))
      index++
    }
    return arr
  }
  // 统计所有交卷的人
  static async getUserCollect() {
    const dataBase = await CloudDataBase.getCloudDataBase()
    const result = await dataBase!.collection<QuestionUserAll>(QuestionUserAll)
      .query()
      .get()
    // 对result进行分组
    let map: Record<string, boolean> = {}
    result.forEach(item => {
      if (!map[item.user_id]) {
        map[item.user_id] = true
      }
    })
    const wrongResult = await dataBase!.collection<QuestionUserAnswer>(QuestionUserAnswer)
      .query()
      .equalTo("is_right", false)
      .get()
    let obj = new UserCollect()
    obj.all_people = Object.keys(map).length
    obj.all_wrong = wrongResult.length
    return obj
  }
}