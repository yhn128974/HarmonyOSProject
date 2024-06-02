import { Log } from '@abner/log';
import { ble, constant } from '@kit.ConnectivityKit';
import { promptAction } from '@kit.ArkUI';
import { DoorLinkCallback } from './Device';

interface ScanFilter {
  type: 'mac' | 'name'
  value: string
}


/**
 *
 * @param nodeId 10-8A-9B-8F-EC-3C
 * @param deviceName JL-ITHEIMA-8A10(BLE)
 * @returns
 */
export class EcBlueDevice {
  static timer: number
  static dev: ble.GattClientDevice | null = null
  // 给蓝牙设备发送数据的特征服务的实例
  static wrChar: ble.BLECharacteristic | null = null

  static isMatchDoor(nodeId: string, deviceName: string) {
    const adrs = nodeId.split('-')
    const flag = adrs[1] + adrs[0]
    return deviceName.includes(flag)
  }

  static scanDevice(scanFilter: ScanFilter, callback: (list: ble.ScanResult[]) => void) {
    if (EcBlueDevice.timer) {
      clearTimeout(EcBlueDevice.timer)
    } else {
      let list: ble.ScanResult[] = []
      // 1. 监听扫描结果
      ble.on("BLEDeviceFind", (devices: ble.ScanResult[]) => {
        // 打印扫到设备
        devices.forEach(item => {
          Log.warn(`扫描中...\n ${item.deviceName || '--'} ${item.deviceId}`)
        })
        list.push(...devices)
        let valid = devices.filter(devItem => {
          // 过滤条件
          // return !list.some(ListItem => ListItem.deviceId === devItem.deviceId)
          if (scanFilter.type === 'mac') {
            return list.some(item => item.deviceId === devItem.deviceId) === false
              && EcBlueDevice.isMatchDoor(scanFilter.value, devItem.deviceName)
          } else {
            return list.some(item => item.deviceId === devItem.deviceId) === false
              && devItem.deviceName.startsWith(scanFilter.value)
          }
        })
        if (valid.length > 0) {
          list.push(...valid)
          if (scanFilter.type === 'mac') {
            callback(list)
            clearTimeout(EcBlueDevice.timer)
            ble.off('BLEDeviceFind')
            ble.stopBLEScan()
          }
        }
      });

      // 扫描参数
      let scanOptions: ble.ScanOptions = {
        interval: 500,
        dutyMode: ble.ScanDuty.SCAN_MODE_LOW_POWER,
        matchMode: ble.MatchMode.MATCH_MODE_AGGRESSIVE,
      }

      //  2. 开启扫描
      ble.startBLEScan(null, scanOptions);

      EcBlueDevice.timer = setTimeout(() => {
        callback(list)
        // 解绑事件并停止扫描
        ble.off('BLEDeviceFind')
        ble.stopBLEScan()

      }, 10000)
    }

  }

  /**
   * 连接门禁
   * @param deviceId
   * @param callback
   */
  static connectDoorDevice(deviceId: string, callback: DoorLinkCallback) {
    EcBlueDevice.destroy()
    EcBlueDevice.dev = ble.createGattClientDevice(deviceId)
    // 1. 连接设备
    EcBlueDevice.dev.connect()
    EcBlueDevice.dev.on('BLEConnectionStateChange', async (res) => {

      if (res.state === constant.ProfileConnectionState.STATE_CONNECTED) {
        // 告诉页面连接成功
        callback()

        // 2. 发现服务
        try {
          const res = await EcBlueDevice.dev?.getServices()

          // 查找自定义读写服务
          const ser = res?.find(item => item.serviceUuid.startsWith('0000AE30'))

          if (ser) {
            Log.info(ser)
            // 1. 读写特征值 => app 给蓝牙设备发送数据
            EcBlueDevice.wrChar = ser.characteristics.find(item => item.characteristicUuid.startsWith('0000AE10'))!
            // 2. 通知特征值=> 设备给手机发送数据
            const ntChar = ser.characteristics.find(item => item.characteristicUuid.startsWith('0000AE04'))
            // 监听特征值变化，设备通信
            EcBlueDevice.dev?.on('BLECharacteristicChange', (res) => {


            })
            // 向服务端发送设置通知此特征值请求
            await EcBlueDevice.dev?.setCharacteristicChangeNotification(ntChar, true)

          } else {
            promptAction.showToast({ message: '未找到服务' })
          }

          // client协商远端蓝牙低功耗设备的最大传输单元
          EcBlueDevice.dev?.setBLEMtuSize(300)


        } catch (e) {
          Log.error('门禁设备报错：' + JSON.stringify(e))
        }
      }
    })
  }

  static destroy() {
    if (EcBlueDevice.dev) {
      try {
        EcBlueDevice.dev.disconnect()
      } catch (e) {
        Log.error('设备断开报错：' + JSON.stringify(e))
      }
      EcBlueDevice.dev.close()
      EcBlueDevice.dev = null
    }
  }
}