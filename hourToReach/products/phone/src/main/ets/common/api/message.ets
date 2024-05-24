import { Request } from 'basic'
import { MessageQueryTypeModel, MessageDataModel } from '../models'

// 获取信息
export const getMessage = (params: MessageQueryTypeModel) => {
  return Request.get<MessageDataModel>("/messages/page", params)
}

// 标记已读
export const readMessage = (id: string) => {
  return Request.put<null>(`/messages/${id}`)
}

// 全部已读
export const readAllMessage = (contentType: string) => {
  return Request.put<null>(`/messages/readAll/${contentType}`)
}