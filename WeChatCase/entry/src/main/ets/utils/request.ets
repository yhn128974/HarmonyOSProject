import { http } from '@kit.NetworkKit'
import { ChatResponse, ChatResponseModel } from '../models/chat'

const req = http.createHttp()

export async function getRequestMessage(content: string) {
  try {
    const res = await req.request(`https://api.ownthink.com/bot?appid=xiaosi&userid=user&spoken=${encodeURIComponent(content)}`)
    const result = JSON.parse(res.result.toString()) as ChatResponse
    return result
  } catch (error) {
    return Promise.reject(error)
  }

}