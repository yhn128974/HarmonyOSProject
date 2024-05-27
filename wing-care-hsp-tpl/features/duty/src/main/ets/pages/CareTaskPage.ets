// 护理详情
import { CareTaskListComp } from './components/CareTaskListComp'
import router from '@ohos.router'
import { ResManager } from '@hm/basic/Index'

class TaskItem {
  name: string = ''
  count: number = 0
}

@Entry
@Component
struct CareTaskPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 1. 护理分类tab
  @State
  activeIndex: number = 0
  // 护理任务分类
  tabs: TaskItem[] = [
    { name: '全部任务', count: 26 },
    { name: '助餐', count: 10 },
    { name: '洗头', count: 2 },
    { name: '剪指甲', count: 12 },
    { name: '整理床铺', count: 18 },
    { name: '洗脚脚', count: 10 },
    { name: '洗澡', count: 2 },
    { name: '喂药', count: 9 }
  ]

  aboutToAppear() {
    const params = router.getParams()
    console.info('路由参数：', JSON.stringify(params))
  }

  @Builder
  cateBuilder(item: TaskItem, i: number) {
    Column({ space: 2 }) {
      Text(item.name)
        .fontColor(this.activeIndex === i ? '#fff' : ResManager.EC_MAIN_COLOR)
        .fontSize(13)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(item.count + '')
        .fontColor(this.activeIndex === i ? '#fff' : ResManager.EC_MAIN_COLOR)
        .fontSize(ResManager.EC_PAGE_TITLE_FS)
        .fontWeight(700)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .margin({ right: 10 })
    .width(62)
    .padding({ top: 10, bottom: 5 })
    .borderRadius(ResManager.EC_NORMAL_RD)
    .backgroundColor(this.activeIndex === i ? ResManager.EC_MAIN_COLOR : '#E8F2F1')
  }

  build() {
    Navigation() {
      // tabs
      Column() {
        Tabs({ index: this.activeIndex }) {
          ForEach(this.tabs, (item: TaskItem, i: number) => {
            TabContent() {
              // 护理任务列表
              CareTaskListComp()
            }
            .tabBar(this.cateBuilder(item, i))
          })
        }
        .width('100%')
        .barMode(BarMode.Scrollable)
        .onChange((i: number) => {
          this.activeIndex = i
        })
        .animationDuration(300)
        .layoutWeight(1)
      }
      .padding(15)

    }
    .width('100%')
    .height('100%')
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
    .title('李玉湖的护理任务')
    .titleMode(NavigationTitleMode.Mini)
  }
}