import { ResManager } from '@hm/basic/Index'

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

  run() {
    this.timer = setInterval(() => {
      if (this.time === 0) return clearInterval(this.timer)
      this.time--
    }, 1000)
  }

  // 开始连接网络
  start() {
    this.linking = true
    this.run()
  }

  // aboutToAppear() {
  //   this.run()
  // }

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
                Text('YJY-5G')
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
              })
            }

            ListItem() {
              Row() {
                Text('Wi-Fi-密码')
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)

                Row() {
                  TextInput({ placeholder: '请输入密码' })
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
          .onClick(() => {
            this.start()
          })
      } else {
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