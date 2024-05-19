import { TabClass } from 'basic/Index'
import { Task_list } from './Task_list'

@Entry
@Component
export struct Task_index {
  @State
  tabsData: TabClass[] = [{
    name: 'waiting',
    title: '待提货'
  }, {
    name: 'line',
    title: '在途'
  }, {
    name: 'finish',
    title: '已完成'
  }]
  @State
  currentIndex: number = 0

  @Builder
  BarBuilder(title: string, index: number) {
    Column() {
      Text(title)
        .padding({
          bottom: 16
        })
        .fontSize(16)
        .fontWeight(this.currentIndex == index ? 600 : FontWeight.Normal)
        .fontColor(this.currentIndex == index ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
      Divider()
        .strokeWidth(4)
        .width(this.currentIndex == index ? 23 : 0)
        .color($r('app.color.primary'))
        .lineCap(LineCapStyle.Round)
        .animation({
          duration: 300
        })
    }

  }

  build() {
    Column() {
      Tabs({ index: $$this.currentIndex }) {
        ForEach(this.tabsData, (item: TabClass, index: number) => {
          TabContent() {
            if (item.name == 'waiting') {
              Task_list()
            } else if (item.name == 'line') {
              Text(item.title)
            } else {
              Text(item.title)
            }
          }.tabBar(this.BarBuilder(item.title, index))
        })

      }.barPosition(BarPosition.Start)
      .barBackgroundColor($r('app.color.white'))
      .animationDuration(300)
      .backgroundColor($r('app.color.background_page'))
    }
  }
}