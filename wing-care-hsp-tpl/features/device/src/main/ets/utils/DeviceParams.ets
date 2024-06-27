// 存储设备绑定相关的参数
interface DeviceParamsModel {
  // 设备 Id
  iotId?: string
  // 设备标识
  nodeId?: string
  // 老人 Id
  elderId?: string
  // 测量时间：凌晨0-睡前7
  dateType?: number
}

class DeviceParamsStore {
  private data: DeviceParamsModel = {}

  //   获取参数
  getParams() {
    return this.data
  }
  
  //   设置参数
  setParams(iotId?: string, nodeId?: string,) {
    this.data.iotId = iotId
    this.data.nodeId = nodeId
  }

  //   清空参数
  clear() {
    this.data = {}
  }
}

export const deviceParamsStore = new DeviceParamsStore()
