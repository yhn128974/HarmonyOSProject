/**
 * 获取映射关系
 * @param type 0: 获取产品 1: 获取设备属性
 * @param name 设备属性/产品英文名称
 */
import { DeviceFunctionList, ProductNameList } from '../constants'

export function getDeviceMap(type: 0 | 1, name: string) {
  if (type === 0) {
    return ProductNameList.find(item => item.en === name)
  } else {
    return DeviceFunctionList.find(item => item.en === name)
  }
}