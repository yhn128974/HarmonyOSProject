import { ResManager } from '@hm/basic/Index'
import router from '@ohos.router'

// 设备管理
class ManageDeivceItem {
  name: string = ''
  icon: ResourceStr = ''
  url: string = ''
}

@Entry
@Component
struct ManageDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  scroller: Scroller = new Scroller()
  list: ManageDeivceItem[] = [
    { name: '设备安装', icon: $r('app.media.pic_sbgl_sbaz'), url: 'pages/device/SetupDevicePage' },
    { name: '设备绑定', icon: $r('app.media.pic_sbgl_sbbd'), url: 'pages/device/BindDevicePage' },
    { name: '我的设备', icon: $r('app.media.pic_sbgl_wdesb'), url: 'pages/device/MyDevicePage' },
    { name: '报警设备', icon: $r('app.media.pic_sbgl_bjsb'), url: 'pages/device/AlarmDevicePage' },

  ]

  @Builder
  CustomTitle(title: string, icon?: Resource | string, color?: string) {
    Row() {
      Image(icon || ResManager.IC_BACK_BLACK)
        .width(19.65)
        .height(18)
        .margin({ left: 26, right: 18 })
        .onClick(() => router.back())
      Text(title)
        .fontColor(color || ResManager.EC_MID_19)
        .fontSize(ResManager.EC_PAGE_TITLE_FS)
        .fontWeight(500)
    }
    .margin({ top: this.topHeight })
    .width('100%')
    .height(55)
    .backgroundColor('rgba(255,255,255,0)')
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      //  1. 详情区
      Scroll(this.scroller) {
        Column() {
          Image($r('app.media.pic_sbgl_bjpt'))
            .width('100%')
            .height(240)

          // 健康数据项
          GridRow({ columns: 2, gutter: 10 }) {
            ForEach(this.list, (item: ManageDeivceItem) => {
              GridCol() {
                Column() {
                  Image(item.icon)
                    .width('100%')
                    .aspectRatio(1.13)
                    .aspectRatio(1)
                    .borderRadius({
                      topLeft: ResManager.EC_NORMAL_RD,
                      topRight: ResManager.EC_NORMAL_RD
                    })

                  Text(item.name)
                    .fontColor(ResManager.EC_MID_19)
                    .fontWeight(500)
                    .fontSize(ResManager.EC_MODULE_TITLE_FS)
                    .padding({ top: 16, bottom: 16 })

                }
              }
              .borderRadius(ResManager.EC_NORMAL_RD)
              .backgroundColor(ResManager.EC_MID_WHITE)
              .layoutWeight(1)
              .onClick(() => {
                router.pushUrl({
                  url: item.url
                })
              })
            })
          }
          .padding({ left: 15, right: 15 })
          .margin({ top: 20 })
        }
        .width('100%')

        // .height('100%')
      }
      .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
      .scrollBar(BarState.Off) // 滚动条常驻显示
      .edgeEffect(EdgeEffect.None)

      // 2. 导航栏
      this.CustomTitle('设备管理')

    }
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)

  }
}