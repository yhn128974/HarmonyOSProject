import { Request } from 'basic'
import { UserModel, UserInfoModel } from '../models'


export function handleLogin(account: UserModel) {
  return Request.post<string>('/login/account', account)
}

// 获取用户信息
export function getUserInfo() {
  return Request.get<UserInfoModel>("/users")
}
