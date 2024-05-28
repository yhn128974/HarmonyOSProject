import { request } from '@hm/basic'
import { http } from '@kit.NetworkKit'
import { AxiosHeaders } from '@ohos/axios'
import { MessageCountData } from '../models'

export function getMessageCountApi() {
  return request<MessageCountData>({
    url: '/employee/message/statisticsUnreadByType',
    method: http.RequestMethod.GET,
  })
}