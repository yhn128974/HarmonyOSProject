import { ResManager } from '@hm/basic/Index'

@Entry
@Component
struct ScanWifiPage {
  @StorageProp('topHeight')
  topHeight: number = 0

  build() {
    Navigation() {
      Column() {
        // 标题
        Row() {
          Text('WIFI列表')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
          LoadingProgress()
            .margin({ left: 10 })
            .width(20)
            .height(20)
            .color(ResManager.EC_MID_99)
        }
        .width('100%')
        .margin({ top: 18, bottom: 18 })

        // 设备列表
        List({ space: 10 }) {
          ForEach(
            Array(20)
              .fill(1),
            (item: number, i: number) => {
              ListItem() {
                Row() {
                  Column({ space: 5 }) {
                    Text(item + '')
                      .fontColor(ResManager.EC_MID_19)
                      .fontSize(ResManager.EC_NORMAL_FS)
                    Text(item + '')
                      .fontColor(ResManager.EC_MID_99)
                      .fontSize(ResManager.EC_SMALL_FS)
                  }
                  .alignItems(HorizontalAlign.Start)

                  Image(ResManager.IC_MJPW_WIFI)
                    .width(24)
                    .aspectRatio(1)
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .borderRadius(ResManager.EC_NORMAL_RD)
                .backgroundColor('#fff')
              }
            })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .padding({ left: 15, right: 15 })
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title('查找WIFI')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}
