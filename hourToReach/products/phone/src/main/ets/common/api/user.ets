import { Request } from 'basic'
import {
  UserModel,
  UserInfoModel,
  UserTaskInfoModel,
  UserTaskInfoParamsModel,
  UserCarDataTypeModel
} from '../models'


export function handleLogin(account: UserModel) {
  return Request.post<string>('/login/account', account)
}

// 获取用户信息
export function getUserInfo() {
  return Request.get<UserInfoModel>("/users")
}

// 获取任务数据
export function getMissionInfo(account: UserTaskInfoParamsModel) {
  return Request.get<UserTaskInfoModel>("/users/taskReport", account)
}
// 获取用户车辆信息
export const getUserCarInfo = () => {
  return Request.get<UserCarDataTypeModel>("/users/truck")
}

