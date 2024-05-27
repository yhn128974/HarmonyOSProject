import { ResManager } from '@hm/basic/Index'
// 自定义tab位置
import { MsgListComp } from './MsgListComp'

class TabItem {
  label: string = ''
}

@Component
export struct MsgStatusComp {
  @State fontColor: ResourceStr = ResManager.EC_MID_99
  @State selectedFontColor: ResourceStr = ResManager.EC_MID_19
  @State activeIndex: number = 0
  private controller: TabsController = new TabsController()
  tabs: TabItem[] = [
    {
      label: '全部'
    },
    {
      label: '未读'
    },
    {
      label: '已读'
    }
  ]
  // 消息类型: 0 老人报警  ｜ 1 任务提醒
  @Prop
  type: number = 0

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 1. tabbar
      Tabs({ index: this.activeIndex, controller: this.controller }) {
        ForEach(this.tabs, (item: TabItem, i: number) => {
          TabContent() {
            MsgListComp({ type: this.type })
          }
        })
      }
      .barPosition(BarPosition.Start)
      // .barBackgroundColor(ResManager.EC_MID_WHITE)
      .onChange((index: number) => {
        this.activeIndex = index
      })
      .width('100%')
      .height('100%')

      // 2. 自定义 bar title
      Row() {
        ForEach(this.tabs, (item: TabItem, i: number) => {
          Column() {
            Text(item.label)
              .fontColor(this.activeIndex === i ? this.selectedFontColor : this.fontColor)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(this.activeIndex === i ? 500 : 400)// .lineHeight(22)
              .margin({ top: 15, bottom: 7 })
            Divider()
              .strokeWidth(2)
              .color(ResManager.EC_MAIN_COLOR)
              .opacity(this.activeIndex === i ? 1 : 0)
              .animation({ duration: 200 })
              .width(18)
          }
          .margin({ right: 30 })
          .onClick(() => {
            this.controller.changeIndex(i)
          })

        })
      }
      .width('100%')
      .padding({ left: 15, right: 15 })

    }
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)
  }
}