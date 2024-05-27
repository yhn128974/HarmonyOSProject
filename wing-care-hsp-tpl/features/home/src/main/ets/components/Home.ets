import { ResManager } from '@hm/basic/Index'
import router from '@ohos.router'

// 模块排列位置
enum Pos {
  x = 'x',
  y = 'y'
}

@Component
export struct Home {
  // 消息
  @Builder
  /**
   *
   * @param title
   * @param icon
   * @param url
   */
  msgItem(title: string, icon: Resource | string, count: number, i: number) {
    Column() {
      Badge({
        count, position: BadgePosition.RightTop, style: {
          badgeColor: '#FF6363',
          borderColor: '#fff',
          borderWidth: 2,
          badgeSize: 20
        }
      }) {
        Image(icon)
          .width(40)
          .aspectRatio(1)
          .margin({ bottom: 10 })
      }

      Text(title)
        .fontSize(ResManager.EC_SMALL_FS)
        .fontColor(ResManager.EC_MID_19)
    }
    .layoutWeight(1)
    .borderRadius(8)
    .padding({ top: 20, bottom: 23 })
    .backgroundColor(ResManager.EC_MID_WHITE)
    .onClick(() => {
      router.pushUrl({
        url: '@bundle:com.heima.elderly.pro/message/ets/pages/MsgPage',
        params: {
          type: i
        }
      })
    })
  }

  // 模块item
  @Builder
  /**
   *
   * @param title
   * @param icon
   * @param pos
   * @param url
   */
  careItem(title: string, icon: ResourceStr, pos: Pos, url: string = '') {
    if (pos === Pos.x) {
      // 护理工作台
      Row({ space: 10 }) {
        Image(icon)
          .width(48)
          .aspectRatio(1)
        Text(title)
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
      }
      .padding({ top: 20, bottom: 23, left: 13, right: 13 })
      // .borderRadius(8)
      // .layoutWeight(1)
      // .backgroundColor(ResManager.EC_MID_WHITE)
      .modStyle()
      .onClick(() => {
        router.pushUrl({
          url
        })
      })
    } else {
      // 设备管理
      Column({ space: 10 }) {
        Image(icon)
          .width(40)
          .aspectRatio(1)
        Text(title)
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_SMALL_FS)
      }
      .padding({ top: 23, bottom: 23 })
      // .borderRadius(8)
      // .layoutWeight(1)
      // .backgroundColor(ResManager.EC_MID_WHITE)
      .modStyle()
      .onClick(() => {
        router.pushUrl({
          url
        })
      })
    }
  }

  // 可复用样式
  @Styles
  modStyle() {
    .borderRadius(8)
    .layoutWeight(1)
    .backgroundColor(ResManager.EC_MID_WHITE)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column({ space: 25 }) {
        Column() {
          // 1.1 广告图
          Image($r('app.media.img_banner'))
            .width('100%')
            .aspectRatio(1.32)

          //  1.2 消息提醒
          Column() {
            Row({ space: 10 }) {
              this.msgItem('老人报警消息', $r("app.media.ic_home_jkbj"), 6, 1)
              this.msgItem('任务提醒消息', $r("app.media.ic_home_rwtx"), 2, 0)
            }
          }
          .margin({
            top: -50,
            left: ResManager.EC_CONTENT_SPACE,
            right: ResManager.EC_CONTENT_SPACE,
          })
        }
        .width('100%')

        Column({ space: 25 }) {
          //  1.3 护理工作台
          Column() {
            // 标题
            Text('护理工作台')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
              .margin({ bottom: 13 })
            // 内容
            Row({ space: 10 }) {
              this.careItem('护理任务', $r('app.media.icon_home_hlrw'), Pos.x, 'pages/duty/CareTaskPage')
              this.careItem('护理记录', $r('app.media.icon_home_hljl'), Pos.x, 'pages/stage/NurseRecordsPage')

            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          //  1.4 设备管理
          Column() {
            // 标题
            Text('设备管理')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
              .margin({ bottom: 13 })
            // 内容
            Row({ space: 10 }) {
              this.careItem('设备安装', $r('app.media.icon_home_sbaz'), Pos.y, 'pages/device/SetupDevicePage')
              this.careItem('设备绑定', $r('app.media.icon_home_sbkz'), Pos.y, 'pages/device/BindDevicePage')
              this.careItem('我的设备', $r('app.media.icon_home_wdsb'), Pos.y, 'pages/device/MyDevicePage')
              this.careItem('报警设备', $r('app.media.icon_home_bjsb'), Pos.y, 'pages/device/AlarmDevicePage')

            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

        }
        .width('100%')
        .padding({ left: 15, right: 15 })

      }
      .width('100%')
      .height('100%')

      // 2. 服务口号
      Row() {
        Image($r('app.media.img_home_kouhao'))
          .width(211)
          .height(15)
      }
      .margin({ bottom: 28 })
      .onClick(() => router.pushUrl({ url: 'pages/test/TestPage' }))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)
  }
}
