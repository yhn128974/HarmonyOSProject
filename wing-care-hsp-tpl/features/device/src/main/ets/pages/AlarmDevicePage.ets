import { ResManager } from '@hm/basic/Index'
// 自定义tab位置
import { AlarmListComp } from './components/AlarmListComp'

class AlarmTabItem {
  label: string = ''
}

@Entry
@Component
struct AlarmDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State fontColor: ResourceStr = ResManager.EC_MID_99
  @State selectedFontColor: ResourceStr = ResManager.EC_MID_19
  @State activeIndex: number = 0
  private controller: TabsController = new TabsController()
  tabs: AlarmTabItem[] = [
    {
      label: '待处理'
    },
    {
      label: '已处理'
    }
  ]

  build() {
    Navigation() {
      Stack({ alignContent: Alignment.Top }) {
        // 1. tabbar
        Tabs({ index: this.activeIndex, controller: this.controller }) {
          ForEach(this.tabs, (item: AlarmTabItem, i: number) => {
            TabContent() {
              AlarmListComp({ type: i })
            }
            .padding({ top: 15 })
          })
        }
        .barPosition(BarPosition.Start)
        .barHeight(52)
        .barBackgroundColor(ResManager.EC_MID_WHITE)
        .onChange((index: number) => {
          this.activeIndex = index
        })
        .width('100%')
        .height('100%')

        // 2. 自定义 barTitle
        Row({ space: 10 }) {
          ForEach(this.tabs, (item: AlarmTabItem, i: number) => {
            Column() {
              Text(item.label)
                .fontColor(this.activeIndex === i ? this.selectedFontColor : this.fontColor)
                .fontSize(ResManager.EC_MODULE_TITLE_FS)
                .fontWeight(this.activeIndex === i ? 500 : 400)
                .margin({ bottom: 7 })
              Divider()
                .strokeWidth(2)
                .color(ResManager.EC_MAIN_COLOR)
                .opacity(this.activeIndex === i ? 1 : 0)
                .width(18)
            }
            .margin({ right: 10 })
            .animation({ duration: 200 })
            .onClick(() => {
              this.controller.changeIndex(i)
            })

          })
        }
        .width('100%')
        .height(52)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 15, right: 15 })

      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title('报警设备')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor('#fff')
  }
}