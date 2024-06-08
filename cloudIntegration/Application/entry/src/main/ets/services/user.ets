import { UserInfo } from '../models'
import { CloudDataBase } from './common'

export class UserService {
  //
  static async getUserInfoUserID(UserId: string) {
    const dataBase = await CloudDataBase.getCloudDataBase()

    const result = await dataBase?.collection<UserInfo>(UserInfo)//拿到用户表
      .query()//查询
      .limit(1)
      .equalTo("user_id", UserId)
      .get()
    return result
  }

  //   更新数据表
  static async updateUserInfo(user: UserInfo) {
    const dataBase = await CloudDataBase.getCloudDataBase()
    const result = await dataBase?.collection<UserInfo>(UserInfo)
      .upsert(user) //插入数据字段
    return result
  }
}
