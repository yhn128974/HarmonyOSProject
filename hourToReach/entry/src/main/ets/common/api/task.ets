import { TaskListDataModel, TaskListParamsModel } from '../models'
import { Request } from 'basic'

export const getTaskList = (params: TaskListParamsModel) => {
  return Request.get<TaskListDataModel>('/tasks/list', params)
}