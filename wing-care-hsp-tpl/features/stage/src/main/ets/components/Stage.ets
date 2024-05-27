import { StateList } from './StateList'
import router from '@ohos.router'
import { ResManager } from '@hm/basic/Index'

@Component
export struct Stage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 1. 护理分类tab
  @State
  activeIndex: number = 0
  // 护理任务分类
  tabs: string[] = ['全部', '助餐', '洗头', '剪指甲', '整理床铺', '洗脚脚', '洗澡', '喂药']

  @Builder
  cateBuilder(item: string, i: number) {
    Button(item)
      .height(28)
      .fontSize(ResManager.EC_MODULE_TITLE_FS)
      .fontColor(this.activeIndex === i ? ResManager.EC_MID_WHITE : ResManager.EC_MID_99)
      .backgroundColor(this.activeIndex === i ? ResManager.EC_MAIN_COLOR : ResManager.EC_MID_BG)
      .animation({ duration: 200, curve: Curve.EaseInOut })
  }

  build() {
    Column() {
      // 1. title
      Row() {
        Text('护理工作台')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_PAGE_TITLE_FS)
          .fontWeight(500)
        Text('护理记录')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/stage/NurseRecordsPage'
            })
          })
      }
      .width('100%')
      .height(56)
      .backgroundColor(ResManager.EC_MID_WHITE)
      .padding({ left: 24, right: 15 })
      .justifyContent(FlexAlign.SpaceBetween)


      //  2. tabs
      Tabs({ index: this.activeIndex }) {
        ForEach(this.tabs, (item: string, i: number) => {
          TabContent() {
            // 护理任务列表
            StateList()
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
      .backgroundColor(ResManager.EC_MID_BG)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: this.topHeight })
    .height('100%')
    .backgroundColor('#fff')
  }
}