import { ResManager, RouterConfig } from '@hm/basic/Index'
import { promptAction, router } from '@kit.ArkUI'
import { WifiAccount } from '../model'
import { Log } from '@abner/log'
import { BlueData, WIFI_CONNECT } from '../utils/Device'
import { EcBlueDevice } from '../utils/EcBlueDevice'
import { emitter } from '@kit.BasicServicesKit'

@Entry
@Component
struct ConnectNetPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // wifi 连接状态: true 连接中 ｜ false 未连接
  @State
  linking: boolean = false
  // 连接倒计时
  @State
  time: number = 10
  timer: number = -1
  @State
  wifi: WifiAccount = {
    ssid: '',
    pwd: ''
  }

  run() {
    this.timer = setInterval(() => {
      if (this.time === 0) {
        router.pushUrl({
          url: RouterConfig.DEVICE_DOOR_CONNECT_TIP_URL,
          params: {
            tips: 2
          }
        })

        return clearInterval(this.timer)
      }

      this.time--
    }, 1000)
  }

  // 开始连接网络
  start() {

    this.linking = true
    this.run()
    // 监听
    this.onConnect()
    // 发送wifi账号
    this.sendWifi()
  }

  onConnect() {
    emitter.on(WIFI_CONNECT, (res) => {
      clearInterval(this.timer)
      if (res.data?.status === 200) {
        router.pushUrl({
          url: RouterConfig.DEVICE_DOOR_CONNECT_TIP_URL,
          params: {
            tips: 1
          }
        })
      } else {
        router.pushUrl({
          url: RouterConfig.DEVICE_DOOR_CONNECT_TIP_URL,
          params: {
            tips: 2
          }
        })
      }
    })
  }

  async sendWifi() {
    try {
      // 数据
      const data: BlueData = {
        command: 'wifi',
        data: [this.wifi.ssid, this.wifi.pwd]
      }
      let res: boolean = await EcBlueDevice.sendWifiData(data)
      if (res) {
        promptAction.showToast({
          message: "发送信息成功"
        })
      } else {
        promptAction.showToast({
          message: "发送信息失败"
        })
      }
      // ...
    } catch (e) {
      Log.error(e)
    }

  }

  onPageShow(): void {
    const params: object = router.getParams()
    Log.warn(params)

    if (params && params['ssid']) {
      this.wifi.ssid = params['ssid']
    }
  }

  // aboutToAppear() {
  //   this.run()
  // }

  aboutToDisappear(): void {
    emitter.off('WIFI_CONNECT')
  }

  build() {
    Navigation() {
      if (!this.linking) {
        // 未连接=》配置
        Column({ space: 5 }) {
          Text('为设备连接Wi-Fi')
            .margin({ bottom: 10 })
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_PAGE_TITLE_FS)
            .fontWeight(500)
          Text('1、请确保接入区络可正常使用')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_NORMAL_FS)
          Text('2、清匆连接公共Wi-Fi、办公Wi-Fi等需要短信验证码或页面登录的Wi-Fi')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_NORMAL_FS)
          Text('3、请勿连提名称前有“5G”的Wi-Fi')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_NORMAL_FS)
        }
        .width('100%')
        .padding({ left: 20, bottom: 12, right: 20 })
        .alignItems(HorizontalAlign.Start)

        Image('/images/img_wifi_demo.png')
          .width(330)
          .height(196)
        // 选择 wifi 连接
        Column() {
          List() {
            ListItem() {
              Row() {
                Text(this.wifi.ssid || '请选择 WIFI')
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)
                Row() {
                  Image($r('app.media.ic_arrow_black'))
                    .width(7)
                    .height(16)
                }
              }
              .width('100%')
              .padding({ top: 14, bottom: 14 })
              .justifyContent(FlexAlign.SpaceBetween)
              .onClick(() => {
                router.pushUrl({
                  url: RouterConfig.DEVICE_DOOR_SCAN_WIFI_URL
                })
              })
            }

            ListItem() {
              Row() {
                Text('Wi-Fi-密码')
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)

                Row() {
                  TextInput({ placeholder: '请输入密码', text: this.wifi.pwd })
                    .onChange((value) => {
                      this.wifi.pwd = value
                    })
                    .placeholderColor(ResManager.EC_MID_99)
                    .placeholderFont({ size: ResManager.EC_NORMAL_FS })
                    .backgroundColor('#fff')
                    .width(150)
                    .textAlign(TextAlign.End)
                    .padding({ right: 20 })
                }
              }
              .width('100%')
              .padding({ top: 5, bottom: 5 })
              .justifyContent(FlexAlign.SpaceBetween)
            }
          }
          .width('100%')
          .height('auto')
          .padding({ left: 14, right: 18, })
          .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
        }
        .margin({
          top: ResManager.EC_CONTENT_SPACE,
          left: ResManager.EC_CONTENT_SPACE,
          right: ResManager.EC_CONTENT_SPACE
        })
        // .width('100%')
        .backgroundColor('#fff')
        .borderRadius(ResManager.EC_NORMAL_RD)

        // 下一步
        Button('下一步')
          .margin({ top: 50 })
          .width(230)
          .backgroundColor(ResManager.EC_MAIN_COLOR)
          .enabled(!!(this.wifi.ssid && this.wifi.pwd))
          .onClick(() => {
            this.start()
          })
      }
      else {
        // 链接页面
        // 连接中...
        Column({ space: 5 }) {
          Text() {
            Span('连接中，等待不超过')
            Span(this.time + '')
              .fontColor(ResManager.EC_MAIN_COLOR)
            Span('秒')
          }
          .margin({ bottom: 10 })
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_PAGE_TITLE_FS)
          .fontWeight(500)

        }
        .width('100%')
        .padding({ left: 20, bottom: 12, right: 20 })
        .alignItems(HorizontalAlign.Start)

        // 连接动图
        Image($r('app.media.pic_linking'))
          .width(240)
          .height(80)
          .margin({ top: 58 })
        Column() {
          Text('设备正在连接 WiFi中，连接过程大概需要1-2分钟请稍等片刻')
            .fontColor('#50A0D8')
            .fontSize(ResManager.EC_NORMAL_FS)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ top: 40, left: 30, right: 30 })
        .padding(15)
        .backgroundColor('#E9F6FF')
        .borderRadius(5)
      }


    }
    .title('')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}