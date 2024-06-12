// UserInfo 增删改查
import { CloudDataBase } from '.'
import { UserInfo } from '../models'

export class UserService {
  // 获取用户的信息
  static async getUserInfoUserId(userId: string) {
    const dataBase = await CloudDataBase.getCloudDataBase()
    const result = await dataBase?.collection<UserInfo>(UserInfo)
      .query()
      .limit(1)
      .equalTo("user_id", userId)
      .get()
    return result // 返回拿到的结果
    // 拿到了用户的这张表
  }

  // 更新用户的信息
  static async updateUserInfo(user: UserInfo) {
    const dataBase = await CloudDataBase.getCloudDataBase()
    const result = await dataBase?.collection<UserInfo>(UserInfo)
      .upsert(user)
    return result
  }
}