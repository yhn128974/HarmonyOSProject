import { ResManager } from '@hm/basic'
import { AVPlayerClass } from '@itheima/wing-care'

@Entry
@Component
struct BluetoothOpenPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State angle: number = 0
  timer: number = -1

  // 1. 摇一摇动画
  run() {

  }

  build() {
    Navigation() {
      Column() {
        Text('摇一摇开门')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(18)
          .fontWeight(600)
          .margin({ top: 94, bottom: 58 })
        Image($r('app.media.ic_lykm_yyy'))
          .width(126)
          .aspectRatio(1)
          .rotate({
            angle: this.angle
          })
          .animation({ duration: 200 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff')
    }
    .title('蓝牙开门')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}