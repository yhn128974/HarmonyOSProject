import axios, {
  AxiosError,
  AxiosResponse,
  InternalAxiosRequestConfig,
  AxiosRequestConfig,
  Method,
  RawAxiosRequestHeaders,
  AxiosHeaders
} from '@ohos/axios';
import { Log } from '@abner/log';
import { UserSore } from '.';
import { router } from '@kit.ArkUI';
import { RouterConfig } from '../constants';
import { Context } from '@ohos.abilityAccessCtrl';


export const currentAxios = axios.create({
  baseURL: 'http://zhyl-harmony.itheima.net',
  timeout: 5000,
  // headers: {
  //   Authorization: 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw'
  // }
})

// 添加请求拦截器
currentAxios.interceptors.request.use(
  async (config: InternalAxiosRequestConfig) => {

    // 对请求数据做点什么
    Log.info(`1-请求配置${config.method!}-${config.url}：${JSON.stringify(config.params || config.data)}`)


    const currentToken = await UserSore.getUserInfo()
    if (currentToken.token) {
      //win 平台伙伴使用写死 token
      config.headers.Authorization =
        'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw'
    }

    return config;
  },
  (error: AxiosError) => {
    return Promise.reject(error)
  }
)

// 添加响应拦截器
currentAxios.interceptors.response.use(
  (response: AxiosResponse) => {
    if (response.data?.code && response.data.code !== 200) {
      AlertDialog.show({
        message: response.data?.msg
      })
      Log.error('3-code请求错误：' + JSON.stringify(response.data))
      return Promise.reject(response.data)
    }
    Log.warn('2-请求成功结果：' + JSON.stringify(response.data))
    // 简化数据返回
    return response.data?.data

  },
  (error: AxiosError) => {
    AlertDialog.show({
      message: error.response?.status + '：' + error.message
    })
    // 对响应错误做点什么

    // 处理401token失效
    if (error.response?.status == 401) {
      UserSore.delUser()
      router.replaceUrl({
        url: RouterConfig.LOGIN_URL
      })
    }
    return Promise.reject(error);
  }
)
// 1. 请求参数类型 2.响应数据类型
// request 请求参数类型
interface RequestParams<R> {
  url?: string;
  method?: Method | string;
  params?: R;
  data?: R;
  headers?: RawAxiosRequestHeaders | AxiosHeaders;
  context?: Context;
}

export function request<T = null, R = null>(requestParams: RequestParams<R>): Promise<T> {
  // 内核
  return currentAxios<null, T>(requestParams)
}
