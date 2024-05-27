export class RouterConfig {
  // 基础
  static BDNAME: string = 'com.Deloitte.elderlyCare'
  static readonly SPLASH_URL: string = `@bundle:${RouterConfig.BDNAME}/home/ets/pages/SplashPage`
  static readonly LOGIN_URL: string = `@bundle:${RouterConfig.BDNAME}/mine/ets/pages/LoginPage`
  static readonly USER_SET_URL: string = `@bundle:${RouterConfig.BDNAME}/mine/ets/pages/SettingPage`
  static readonly USER_NAME_URL: string = `@bundle:${RouterConfig.BDNAME}/mine/ets/pages/NickNamePage`
  // 我的消息
  static readonly USER_MSG_URL: string = `@bundle:${RouterConfig.BDNAME}/message/ets/pages/MsgPage`
  // 负责老人
  static readonly DUTY_HEALTH_DATA_URL: string = `@bundle:${RouterConfig.BDNAME}/duty/ets/pages/HealthDataPage`
  static readonly DUTY_HEALTH_DETAIL_URL: string = `@bundle:${RouterConfig.BDNAME}/duty/ets/pages/HealthDetailPage`
  static readonly DUTY_HEALTH_RECORD_URL: string = `@bundle:${RouterConfig.BDNAME}/duty/ets/pages/HealthRecordPage`
  static readonly DUTY_CARE_TASK_URL: string = `@bundle:${RouterConfig.BDNAME}/duty/ets/pages/CareTaskPage`
  // 护理工作台
  static readonly STAGE_NURSE_RECORDS_URL: string = `@bundle:${RouterConfig.BDNAME}/stage/ets/pages/NurseRecordsPage`
  static readonly STAGE_EXECUTE_URL: string = `@bundle:${RouterConfig.BDNAME}/stage/ets/pages/ExecutePage`
  // 设备安装
  static readonly DEVICE_SETUP_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/SetupDevicePage`
  static readonly DEVICE_SETUP_TIP_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/SetupTipPage`
  static readonly DEVICE_ELDER_SEL_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/ElderSelPage`
  static readonly DEVICE_PRODUCT_SEL_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/ProductDevicePage`
  // 设备绑定
  static readonly DEVICE_BIND_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/BindDevicePage`
  static readonly DEVICE_BIND_TIP_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/BindTipPage`
  static readonly DEVICE_NEAR_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/NearDevicePage`
  static readonly DEVICE_BIND_BLOOD_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/BindBloodPage`
  // 我的设备
  static readonly DEVICE_MY_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/MyDevicePage`
  // 血糖
  static readonly DEVICE_BLOOD_TEST_PREPARE_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/blood_control/TestPreparePage`
  static readonly DEVICE_BLOOD_TEST_START_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/blood_control/TestStartPage`
  static readonly DEVICE_BLOOD_TEST_RESULT_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/blood_control/TestResultPage`
  // 门禁
  static readonly DEVICE_DOOR_NET_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/NetDoorPage`
  static readonly DEVICE_DOOR_NET_CONNECT_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/ConnectNetPage`
  static readonly DEVICE_DOOR_SCAN_WIFI_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/ScanWifiPage`
  static readonly DEVICE_DOOR_CONNECT_TIP_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/ConnectTipPage`
  // 控制
  static readonly DEVICE_DOOR_CONTROL_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/access_control/DoorControlPage`
  static readonly DEVICE_DOOR_BLUE_OPEN_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/access_control/BluetoothOpenPage`
  static readonly DEVICE_DOOR_REMOTE_OPEN_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/access_control/RemoteOpenPage`
  static readonly DEVICE_DOOR_PASSWORD_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/access_control/TempPasswordPage`
  static readonly DEVICE_DOOR_OPEN_RECORD_URL: string =
    `@bundle:${RouterConfig.BDNAME}/device/ets/pages/access_control/OpeningRecordPage`
  // 报警设备
  static readonly DEVICE_ALARM_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/AlarmDevicePage`
  static readonly DEVICE_ALARM_HANDLER_URL: string = `@bundle:${RouterConfig.BDNAME}/device/ets/pages/AlarmHandlePage`
}