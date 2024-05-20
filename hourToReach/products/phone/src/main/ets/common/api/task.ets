import { TaskDetailInfoModel, TaskListDataModel, TaskListParamsModel ,PickUpParamsModel} from '../models'
import { Request } from 'basic'

export const getTaskList = (params: TaskListParamsModel) => {
  return Request.get<TaskListDataModel>('/tasks/list', params)
}

export const getTaskDetail = (id: string) => {
  return Request.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}
// 根据
export const pickUp = (data: PickUpParamsModel) => {
  return Request.post<null>("/tasks/takeDelivery", data)
}

