import { BASE_URL, TOKEN_KEY } from '../constants'
import http from '@ohos.net.http';
import { ResponseData } from '../models'
import { promptAction } from '@kit.ArkUI';
import { TokenStore } from '../store';
import { JSON } from '@kit.ArkTS';

const httpRequest = http.createHttp()

async function requestHttp<T>(url: string = "", method: http.RequestMethod = http.RequestMethod.GET,
  data?: object): Promise<T> {
  // 定义URL
  let urlStr = BASE_URL + url;
  // 如果是get请求手动拼装请求地址格式
  if (method === http.RequestMethod.GET) {

    // data参数都拼接到地址上  ?a=1&b=2&c=3
    if (data && Object.keys(data).length) {
      // 改造url
      urlStr += "?" + Object.keys(data).filter(key =>!!data[key]).map(key => {
        return `${key}=${data[key]}`
      }).join("&")
    }

  }

  try {
    let res = await httpRequest.request(
      urlStr,
      {
      //  data参数
      extraData: method !== http.RequestMethod.GET ? data : "", // 当请求类型不等于get时 复制
      header: {
        "Content-Type": "application/json",
        Authorization: AppStorage.get(TOKEN_KEY) as string || "", // 设置请求头的token 每个接口都有
      },
      method,
      readTimeout: 10000 // 如果多少秒没响应就断开
    })

    if (res.responseCode == 401) {
      //   401token失效
      //   移动端产品去做无感刷新
      //   提示错误 删除当前的token
      promptAction.showToast({
        message: '登陆失效'
      })
      TokenStore.setToken("") //清空token
      AppStorage.set(TOKEN_KEY, "") //清空token
      return Promise.reject(new Error('登陆失效'))
    } else if (res.responseCode == 404) {
      promptAction.showToast({
        message: '请求地址错误'
      })
      return Promise.reject(new Error('请求地址错误'))
    } else {
      //ResponseData<T> ={ code:"",data:T,msg:"}
      const data = JSON.parse((res.result) as string) as ResponseData<T>

      if (data.code === 200) {

        if (data.data) {
          return data.data as T
        } else {
          return Promise.resolve(null as T)
        }

      } else {
        promptAction.showToast({
          message: data.msg
        })
        return Promise.reject(new Error(data.msg))
      }
    }
  } catch (error) {
    promptAction.showToast({
      message: error.message
    })
    return Promise.reject(error)
  }
}

export class Request {
  static post<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.POST, data)
  }

  static get<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.GET, data)
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.DELETE, data)
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.PUT, data)
  }
}






