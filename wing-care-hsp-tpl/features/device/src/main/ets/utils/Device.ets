// 门禁
export type DoorLinkCallback = () => void

// 1. 蓝牙开门 2. 配置设备 wifi 连网
export interface BlueData {
  status?: 200 | 400 //  200 成功  400 失败
  msg?: string // 消息提示
  command?: 'open' | 'wifi'
  data?: string[] // 例如wifi=》 [ssid,pwd]
}

export const WIFI_CONNECT = 'WIFI_CONNECT'

