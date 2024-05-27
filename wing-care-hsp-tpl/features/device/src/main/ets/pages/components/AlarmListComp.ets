// 报警设备列表
import { EcList } from '@itheima/wing-care'
import { router } from '@kit.ArkUI'
import { ResManager } from '@hm/basic/Index'

class Params {
  page: number = 1
  pageSize: number = 10
}

@Component
export struct AlarmListComp {
  // 消息类型: 0 待处理 ｜ 1 已处理
  type: number = 0
  // 1. 列表
  @State
  list: number[] = []
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
        this.list.push(this.list.length + 1)
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
        .map((item: null, i: number) => i + 1)
      // 关闭刷新状态
      this.isRefreshing = false
    }, 2000)
  }

  build() {
    // 列表
    EcList({
      loading: this.loading,
      finished: this.finished,
      isRefreshing: $isRefreshing,
      load: this.load,
      refresh: this.refresh,
      gutter: 15
    }) {
      ForEach(this.list, (item: number) => {
        ListItem() {
          Column() {
            Row() {
              Column({ space: 10 }) {
                Text('老人数据异常' + item)
                  .fontSize(16)
                  .fontWeight(700)
                  .fontColor(ResManager.EC_MID_BLACK)
                  .margin({ right: 8 })

                Text() {
                  Span('1011床位  ')
                  Span('心率  ')
                  Span('智能手表  ')
                  Span('20次/分钟')
                }
                .fontSize(13)
                .fontColor(ResManager.EC_MID_59)

              }
              .alignItems(HorizontalAlign.Start)

              Text('09:40')
                .fontSize(13)
                .fontColor(ResManager.EC_MID_59)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Top)

            // 1. 待处理=》操作
            if (this.type === 0) {
              Button('处理')
                .margin({ top: 15 })
                .alignSelf(ItemAlign.End)
                .width(60)
                .height(28)
                .fontSize(ResManager.EC_SMALL_FS)
                .fontWeight(500)
                .backgroundColor(ResManager.EC_MAIN_COLOR)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/device/AlarmHandlePage',
                    params: {
                      a: 1
                    }
                  })
                })
            }
            // 2. 已处理=》显示
            if (this.type === 1) {
              Column() {
                Text('处理结果：已及时呼叫120送往附近医院，目前老人心率已经平稳，脱离危险，目前老人仍在医院进行治疗，老人大概7天后可回归养老院，回归后需要特别注意老人的身体。')
                  .fontColor('#3FA199')
                  .fontSize(ResManager.EC_SMALL_FS)
                  .lineHeight(17)
                  .margin({ bottom: 9 })
                Text('2023年8月2日16:21')
                  .fontColor('#3FA199')
                  .fontSize(ResManager.EC_SMALL_FS)
                  .alignSelf(ItemAlign.End)
              }
              .margin({ top: 10 })
              .padding({ left: 9, right: 9, top: 5, bottom: 5 })
              .borderRadius(5)
              .backgroundColor('#E8F2F1')
            }

          }
          // .width('100%')
          .margin({ left: 15, right: 15 })
          .borderRadius(12)
          .backgroundColor(ResManager.EC_MID_WHITE)
          .padding(15)
        }
      })
    }
  }
}