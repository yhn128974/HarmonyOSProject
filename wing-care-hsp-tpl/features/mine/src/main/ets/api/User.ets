import { request, LoginParams, UserData } from '@hm/basic'
import { http } from '@kit.NetworkKit'

export function getToken(param: LoginParams) {
  return request<string, LoginParams>({
    url: '/employee/login',
    method: http.RequestMethod.POST,
    data: param
  })
}

export function getUserApi() {
  return request<UserData>({ url: '/employee/user' })
}