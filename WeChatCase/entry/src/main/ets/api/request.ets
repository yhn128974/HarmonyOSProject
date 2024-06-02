import { http } from '@kit.NetworkKit'
import { ChatResponse } from '../models/chat'
import '@ohos/axios'
import axios, { AxiosResponse } from '@ohos/axios'

const req = http.createHttp()

// export async function getRequestMessage(content: string) {
//   try {
//     const res = await req.request(`https://api.ownthink.com/bot?appid=xiaosi&userid=user&spoken=${encodeURIComponent(content)}`)
//     const result = JSON.parse(res.result.toString()) as ChatResponse
//     return result
//   } catch (error) {
//     return Promise.reject(error)
//   }
//
// }

export async function getRequestMessage(content: string) {
  try {
    const res: AxiosResponse = await axios.get<string, AxiosResponse<ChatResponse>>(`https://api.ownthink.com/bot?appid=xiaosi&userid=user&spoken=${encodeURIComponent(content)}`)
    let date = res.data as ChatResponse
    return date

  } catch (error) {
    return Promise.reject(error)
  }

}
