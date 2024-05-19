import { TaskDetailInfoModel, TaskListDataModel, TaskListParamsModel } from '../models'
import { Request } from 'basic'

export const getTaskList = (params: TaskListParamsModel) => {
  return Request.get<TaskListDataModel>('/tasks/list', params)
}

export const getTaskDetail = (id: string) => {
  return Request.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}