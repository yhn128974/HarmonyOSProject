/**
 * iot 平台 api
 * 查询未绑定设备产品列表
 * @returns
 */
import { UnBindProductItem } from '../model'
import { request } from '@hm/basic'
import { http } from '@kit.NetworkKit'
import { DeviceStatusData } from '../viewmodel/DeviceModel'

export function getUnbindDeviceListApi() {
  return request<UnBindProductItem[]>({ url: '/employee/iot/deviceTree' })
}

/**
 * 获取我的设备列表
 * @returns
 */
export function getMyDeviceListApi() {
  return request<UnBindProductItem[]>({ url: `/employee/iot/listDeviceByCurrentUser` })
}

export function unbindDeviceApi(iotId: string) {
  return request<null>({ url: `/employee/iot/unBindingDevice/${iotId}`, method: http.RequestMethod.PUT })
}

export function bindDeviceApi(iotId: string) {
  return request({ url: `/employee/iot/bindingDevice/${iotId}`, method: 'put' })
}

export function getDeviceStatusApi(iotId: string) {
  return request<DeviceStatusData>({ url: `/employee/iot/getDeviceStatus/${iotId}` })
}