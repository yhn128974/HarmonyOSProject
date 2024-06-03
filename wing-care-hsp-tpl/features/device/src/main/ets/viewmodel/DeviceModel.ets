export class Device {
  name: string = ''
  icon: Resource | string=''
}

export class DeviceCate {
  title: string = ''
  list: Device[]=[]
  cb?: () => void = () => {
  }
}
// 设备状态查询
export interface DeviceStatusData {
  /**
   * 设备名称
   */
  name: string;

  /**
   * 设备状态，设备状态，ONLINE：设备在线，OFFLINE：设备离线，ABNORMAL：设备异常，INACTIVE：设备未激活，FROZEN：设备冻结
   */
  status: string;
}