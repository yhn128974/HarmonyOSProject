import { ResManager } from '@hm/basic/Index'
import router from '@ohos.router'

class ControlItem {
  name: string = ''
  url: string = ''
}

@Entry
@Component
struct DoorControlPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 控制列表
  list: ControlItem[] = [
    { name: '蓝牙开门', url: 'pages/device/access_control/BluetoothOpenPage' },
    { name: '远程开门', url: 'pages/device/access_control/RemoteOpenPage' },
    { name: '临时密码', url: 'pages/device/access_control/TempPasswordPage' },
    { name: '开门记录', url: 'pages/device/access_control/OpeningRecordPage' },
  ]

  @Builder
  cellItem(title: string, url: string = '') {
    Row() {
      Text(title)
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
    .onClick(() => router.pushUrl({ url }))
  }

  build() {
    Navigation() {
      //  1. 设备信息
      Column({ space: 8 }) {
        Text('smoke alarm 002')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .margin({ top: 20 })
        Text('在线')
          .fontColor('#fff')
          .fontSize(ResManager.EC_SMALL_FS)
          .padding({
            left: 14,
            right: 14,
            top: 2.5,
            bottom: 2.5
          })
          .backgroundColor('#0398FF')
          .borderRadius(10)
        Image($r("app.media.pic_shebei_mj"))
          .width(120)
          .aspectRatio(1)
      }
      .width('100%')
      .height('30%')

      // .height(232)

      // 2. 设备控制：快捷导航
      Column() {
        List() {
          ForEach(this.list, (item: ControlItem) => {
            ListItem() {
              this.cellItem(item.name, item.url)
            }
          })
        }
        .width('100%')
        .height('auto')
        .padding({ left: 14, right: 18, })
        .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
      }
      .margin({ top: 20, left: ResManager.EC_CONTENT_SPACE, right: ResManager.EC_CONTENT_SPACE })
      .backgroundColor('#fff')
      .borderRadius(ResManager.EC_NORMAL_RD)
    }
    .title('门禁管理')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
    .backgroundImage($r("app.media.pic_mjgl_bj"))
    .backgroundImageSize({ width: '100%', height: '36.2%' })

  }
}