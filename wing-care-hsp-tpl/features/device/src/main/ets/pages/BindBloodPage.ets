import { ResManager } from '@hm/basic/Index';

@Entry
@Component
struct BindBloodPage {
  @StorageProp('topHeight')
  topHeight: number = 0

  build() {
    Navigation() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          Image($r('app.media.gf_cr'))
            .width(310)
            .height(340)
            .margin({ top: 64 })
        }
        .width('100%')
        .height('100%')


        // 提示
        Column() {
          Text('请插入试纸，启动设备')
            .fontSize(18)
            .fontWeight(500)
            .fontColor(ResManager.EC_MID_19)
            .margin({ top: 54, bottom: 26 })
          Button('绑定')
            .width(150)
            .height(40)
            .backgroundColor(ResManager.EC_MAIN_COLOR)
            .fontColor('#fff')
        }
        .width('100%')
        .height(256)
        .backgroundColor('#fff')
      }
      .width('100%')
      .height('100%')
      .linearGradient({
        angle: 137,
        colors: [['#F6F9FE', 0], ['#EFF5FE', 25], ['#F4F3F8', 100]]
      })
    }
    .title('设备绑定')
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
    .titleMode(NavigationTitleMode.Mini)
  }
}