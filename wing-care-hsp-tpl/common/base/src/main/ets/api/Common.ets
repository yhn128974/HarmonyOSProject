import { request } from "../utils/Request"
import { AxiosProgressEvent, FormData } from '@ohos/axios'

/**
 * 上传图片
 * @param data
 * @param onUploadProgress
 * @returns
 */
export function uploadApi(data: FormData, context?: Context, onUploadProgress?: (progressEvent: AxiosProgressEvent) => void) {
  return request<string, FormData>({
    url: '/common/upload',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data,
    // onUploadProgress,
    context:context as Context
  })
}