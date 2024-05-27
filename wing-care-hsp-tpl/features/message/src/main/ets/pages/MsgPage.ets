// 消息类型
import { MsgStatusComp } from '../components/MsgStatusComp'
import router from '@ohos.router'
import { ResManager } from '@hm/basic/Index'

class MsgItem {
  type: string = ''
  count: number = 0
  defaultIcon: ResourceStr = ''
  selectIcon: ResourceStr = ''
}

@Entry
@Component
struct MsgPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  activeType: number = 0
  private controller: TabsController = new TabsController()
  // 消息类型
  msgTypes: MsgItem[] = [
    {
      type: '老人报警',
      count: 6,
      defaultIcon: $r("app.media.ic_wode_jkbj"),
      selectIcon: $r("app.media.ic_wode_jkbj_sel")
    },
    {
      type: '任务提醒',
      count: 2,
      defaultIcon: $r("app.media.ic_wode_rwtx"),
      selectIcon: $r("app.media.ic_wode_rwtx_sel")
    }
  ]

  // 导航右侧内容
  @Builder
  menusBuilder() {
    Row() {
      Text('全部已读')
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_NORMAL_FS)
    }
    .margin({ right: ResManager.EC_CONTENT_SPACE })
    .height('100%')

  }

  build() {
    Navigation() {
      Stack({ alignContent: Alignment.Top }) {
        // tab 分类
        Tabs({ index: this.activeType, controller: this.controller }) {
          ForEach(this.msgTypes, (item: MsgItem, i: number) => {
            TabContent() {
              // 消息类型: 0 老人报警  ｜ 1 任务提醒
              MsgStatusComp({ type: i })
            }
          })
        }
        .barPosition(BarPosition.Start)
        .barBackgroundColor(ResManager.EC_MID_WHITE)
        .onChange((index: number) => {
          this.activeType = index
        })

        //  消息分类bar title自定义
        Row({ space: 5 }) {
          ForEach(this.msgTypes, (item: MsgItem, i: number) => {
            Badge({
              count: item.count,
              position: BadgePosition.RightTop,
              style: { badgeColor: '#FF6363', borderColor: '#fff', borderWidth: 2 }
            }) {
              Button({ stateEffect: true }) {
                Row() {
                  Image(this.activeType === i ? item.selectIcon : item.defaultIcon)
                    .width(20)
                    .aspectRatio(1)
                  Text(item.type)
                    .fontSize(ResManager.EC_NORMAL_FS)
                    .fontColor(this.activeType === i ? '#fff' : ResManager.EC_MID_19)
                }
                .padding({ left: 15, right: 15, top: 8, bottom: 8 })

                // .alignItems(VerticalAlign.Bottom)
              }
              .backgroundColor(this.activeType === i ? ResManager.EC_MAIN_COLOR : '#fff')
              .animation({ duration: 200 })
              .onClick(() => {
                this.controller.changeIndex(i)
              })
            }
          })
        }
        .width('100%')
        .padding({ left: 15, right: 15, top: 10, bottom: 10 })
        // .height(48)
        .alignItems(VerticalAlign.Center)
        .backgroundColor('#fff')
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)

    }
    .title('我的消息')
    .titleMode(NavigationTitleMode.Mini)
    .menus(this.menusBuilder())
    .padding({ top: this.topHeight })
    .backgroundColor('#fff')
  }
}