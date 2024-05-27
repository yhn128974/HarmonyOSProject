import { ResManager } from '@hm/basic/Index'
import router from '@ohos.router'
import { HealthChartComp } from './components/HealthChartComp'
import { HealthAlarmComp } from './components/HealthAlarmComp'

@Entry
@Component
struct HealthDetailPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  activeIndex: number = 0
  tabs: string[] = ['日', '周']

  // 自定义导航栏 title
  @Builder
  CustomTitle() {
    Row() {
      // 左侧
      Row() {
        Image(ResManager.IC_BACK_WHITE)
          .width(19.65)
          .height(18)
          .margin({ left: 26, right: 18 })
          .onClick(() => router.back())
        Text('血压')
          .fontColor('#fff')
          .fontSize(ResManager.EC_PAGE_TITLE_FS)
          .fontWeight(500)
      }

      // 右侧
      Text('历史记录')
        .fontSize(ResManager.EC_NORMAL_FS)
        .fontColor('#fff')
        .margin({ right: 18 })
    }
    .width('100%')
    .height(55)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#33D0C2')
  }

  // 自定义 tabbar
  @Builder
  CustomBar(item: string, i: number) {
    Column() {
      Text(item)
        .fontColor(this.activeIndex === i ? ResManager.EC_MAIN_COLOR : ResManager.EC_MID_99)
        .fontSize(13)
      Divider()
        .margin({ top: 5 })
        .width(16)
        .strokeWidth(2)
        .color(this.activeIndex === i ? ResManager.EC_MAIN_COLOR : ResManager.EC_MID_BG)
    }
  }

  build() {
    Navigation() {
      Column() {
        Tabs({ index: this.activeIndex }) {
          ForEach(this.tabs, (item: string, i: number) => {
            TabContent() {
              // 日0/周1 健康数据
              Column() {
                // 1. 图表
                HealthChartComp({ timeMode: i })

                // 2.  报警或异常数据列表
                HealthAlarmComp({ timeMode: i })
              }
              .width('100%')
              .height('100%')
            }
            .tabBar(this.CustomBar(item, i))
          })

        }
        .barPosition(BarPosition.Start)
        .barWidth(100)
        .onChange((i) => this.activeIndex = i)

      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title(this.CustomTitle)
    .padding({ top: this.topHeight })
    .backgroundColor('#33D0C2')
    .hideBackButton(true)
    .titleMode(NavigationTitleMode.Mini)
  }
}