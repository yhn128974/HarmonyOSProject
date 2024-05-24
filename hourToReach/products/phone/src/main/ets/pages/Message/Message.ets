import { HmNavBar, TabClass } from 'basic'
import MessageTemplate from './MessageTemplate'
@Entry
@Component
struct Message {
  @State currentTabName: string = 'information'
  @State tabBarData: TabClass[] = [{
    title: '公告',
    name: 'information'
  }, {
    title: '任务通知',
    name: 'notice'
  }]
  @Builder
  TabBuilder(item: TabClass) {
    Column() {
      Text(item.title)
        .fontSize(16)
        .fontColor(this.currentTabName === item.name ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
        .fontWeight(this.currentTabName === item.name ? 500 : 400)
        .lineHeight(50)
        .height(50)
      Divider()
        .strokeWidth(4)
        .color($r('app.color.primary'))
        .opacity(this.currentTabName === item.name ? 1 : 0)
        .width(this.currentTabName === item.name ? 23 : 0)
        .animation({
          duration: 300,
          curve: Curve.EaseOut,
          iterations: 1,
          playMode: PlayMode.Normal
        })
    }
  }

  build() {
    Column() {
      HmNavBar({ title: '消息', showBackIcon: false })
      Tabs({
        barPosition: BarPosition.Start,
        controller: new TabsController()
      }) {
        ForEach(this.tabBarData, (item: TabClass) => {
          TabContent() {
            Flex() {
              MessageTemplate({ type: item.name || '' })
            }.height('100%').backgroundColor($r('app.color.background_page'))
          }.tabBar(this.TabBuilder(item))
        })
      }.animationDuration(300).onChange((index) => {
        this.currentTabName = index === 0 ? 'information' : 'notice'
      })
    }.width('100%').height('100%')
  }
}

export default Message