import { MessageCountData, request } from '@hm/basic'
import { http } from '@kit.NetworkKit'
import { AxiosHeaders } from '@ohos/axios'


export function getMessageCountApi() {
  return request<MessageCountData>({
    url: '/employee/message/statisticsUnreadByType',
    method: http.RequestMethod.GET,
  })
}