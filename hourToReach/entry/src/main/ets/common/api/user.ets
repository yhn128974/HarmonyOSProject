import { Request } from 'basic'
import {
  UserModel,
  UserInfoModel,
  UserTaskInfo,
  DailyMileage,
  UserTaskInfoParams,
  UserTaskInfoModel,
  DailyMileageModel,
  UserTaskInfoParamsModel
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


