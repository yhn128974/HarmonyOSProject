import { Log } from '@abner/log';
import wifiManager from '@ohos.wifiManager';

export type WifiListCb = (list: wifiManager.WifiScanInfo[]) => void

class EcWifi {


  /**
   * 检测 wifi 是否开启
   * @returns
   */
  isWifiOpen() {
    try {
      return wifiManager.isWifiActive()
    } catch (error) {
      Log.error("failed:" + JSON.stringify(error));
      return false
    }
  }

  scanWifi(cb: WifiListCb) {

    console.log("wifiManager.getScanInfoList" + canIUse('SystemCapability.Communication.WiFi.STA'))

    try {
      let scanInfoList = wifiManager.getScanInfoList();
      Log.info("scanInfoList:" + JSON.stringify(scanInfoList));
      let len = scanInfoList.length;
      Log.log("wifi received scan info: " + len);
      if (len > 0) {
        cb(scanInfoList)
      }
    } catch (error) {
      Log.error("failed:" + JSON.stringify(error));
    }
  }
}

export const ecWifi = new EcWifi()