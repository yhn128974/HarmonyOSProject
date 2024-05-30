//  2. 未绑定设备列表
export interface DeviceItem {
  iotId: string
  nodeId: string
  deviceName: string
  isSelected: boolean
}

export interface UnBindProductItem {
  productId: string
  productName: string
  // 是否展开：false 没有点击查看更多 | true 点击了查看更多
  isExpand: boolean
  deviceList: DeviceItem[]
}