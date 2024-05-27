import { EcList, EcNotFound } from '@itheima/wing-care'
import router from '@ohos.router'
import { ElderSelItemComp } from './components/ElderSelItemComp'
import { ResManager } from '@hm/basic/Index'

class Params {
  page: number = 1
  pageSize: number = 10
}

// 搜索选择老人
@Observed
export class OldItem {
  index: number = 0
  sel: boolean = false

  constructor(index: number, sel: boolean) {
    this.index = index
    this.sel = sel
  }
}

@Entry
@Component
struct NurseRecordsPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  keyword: string = ''
  // 1. 列表
  @State
  list: OldItem[] = []
  // 请求参数
  params: Params = { page: 1, pageSize: 10 }
  // 加载状态
  @State
  finished: boolean = false
  // 加载中loading
  @State
  loading: boolean = false
  // 刷新中
  @State
  isRefreshing: boolean = false
  // 触底加载数据
  load = () => {
    if (this.loading || this.finished) return
    this.loading = true
    // 请求数据
    setTimeout(() => {
      for (let index = 0; index < this.params.pageSize; index++) {
        this.list.push(new OldItem(this.list.length + 1, false))
      }
      this.loading = false
      // 判断是否还有更多
      if (this.list.length === 30) {
        this.finished = true
      } else {
        this.params.page++
      }

    }, 1000)
  }
  // 刷新列表
  refresh = () => {
    setTimeout(() => {
      //  重置列表和状态
      this.loading = false
      this.finished = false
      // 重置请求参数
      this.params.page = 1
      this.list = Array.from(new Array(10))
        .map((item: null, i: number) => (new OldItem(i + 1, false)))
      // 关闭刷新状态
      this.isRefreshing = false
    }, 2000)
  }

  // 2. 搜索老人
  // 3. 点击信息选择老人


  // 4. 确认选择
  onConfirm() {

  }

  build() {
    Navigation() {
      Column() {
        // 1. 搜索
        Search({
          value: $$this.keyword, // $$双向绑定
          placeholder: '请输入老人姓名'
        })
          .backgroundColor('#fff')
          .onSubmit(() => {
            // 输入搜索

          })
          .onChange(() => {

          })
          .margin({ left: 24, right: 24, bottom: 15 })

        // 2. 列表
        if (this.finished && this.list.length === 0) {
          EcNotFound({ tip: '暂无老人哦～' })
        } else {
          Stack({ alignContent: Alignment.Bottom }) {
            Column() {
              EcList({
                loading: this.loading,
                finished: this.finished,
                isRefreshing: $isRefreshing,
                load: this.load,
                refresh: this.refresh
              }) {
                ForEach(this.list, (item: OldItem, i: number) => {
                  ListItem() {
                    ElderSelItemComp({ item: item, i: i })
                  }
                })
              }
            }
            .padding({ bottom: 72, left: 15, right: 15 })

            // 确认选择
            Column() {
              Button('确认')
                .width(312)
                .backgroundColor(ResManager.EC_MAIN_COLOR)
                .onClick(() => {
                  this.onConfirm()
                })
                .enabled(true ? true : false)
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .height(72)
            .backgroundColor('#fff')
            .shadow({ offsetX: 0, offsetY: -2, radius: 60, color: '#0F000000' })

          }
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')

    }
    .title('接入位置')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}