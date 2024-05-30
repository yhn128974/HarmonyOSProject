import { request, LoginParams, UserData, UpdateUserParams } from '@hm/basic'
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

export function updateUserNameApi(nickName: string) {
  return request<null, UpdateUserParams>({
    url: '/employee/user/updateNickname',
    method: 'put',
    params: {
      nickName
    }
  })
}

export function updateUserPhotoApi(avatar: string) {
  return request<null, UpdateUserParams>({
    url: '/employee/user/updateAvatar', method: 'put', params: {
      avatar
    }
  })
}

