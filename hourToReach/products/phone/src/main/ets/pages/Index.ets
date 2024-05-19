import { TabClass } from 'basic'
import My_index from './my/My_Index'
import {Task_index} from './Task/Task_index'
@Entry
@Component
struct Index {
  @State
  @Watch('handleUpdateName')
  currentIndex: number = 0 // 当前激活项

  @Provide currentName:string=''
  @State tabsData: TabClass[] = [{
    title: '任务',
    name: 'task',
    icon: $r("app.media.ic_tab_btn_task")
  }, {
    title: '消息',
    name: 'message',
    icon: $r("app.media.ic_tab_btn_mess_nor")
  }, {
    title: '我的',
    name: 'my',
    icon: $r("app.media.ic_tab_btn_mine_nor")
  }]

  handleUpdateName(){
    this.currentName=this.tabsData[this.currentIndex].name
  }
  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Image(item.icon).width(22).height(22)
        .fillColor(item.name === this.tabsData[this.currentIndex].name ?
        $r('app.color.primary') : $r('app.color.text_secondary'))
      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .margin({ top: 5 })
        .fontColor(item.name === this.tabsData[this.currentIndex].name ?
        $r('app.color.primary') : $r('app.color.text_secondary'))
    }.alignItems(HorizontalAlign.Center)
  }

  build() {

    Tabs({ barPosition: BarPosition.End, index: $$this.currentIndex }) {
      ForEach(this.tabsData, (item: TabClass) => {
        // TabContent在被选中后才会被创建渲染
        TabContent() {
          if (item.name === 'task') {
            Task_index()
          }
          else if (item.name === 'message') {
            Text("消息组件")
          }
          else {
            My_index()
          }
        }.tabBar(this.getTabBar(item))
      })
    }
  }
}


