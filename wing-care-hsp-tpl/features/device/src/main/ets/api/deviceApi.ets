/**
 * iot 平台 api
 * 查询未绑定设备产品列表
 * @returns
 */
import { UnBindProductItem } from '../model'
import { request } from '@hm/basic'

export function getUnbindDeviceListApi() {
  return request<UnBindProductItem[]>({ url: '/employee/iot/deviceTree' })
}