import { EcList } from '@itheima/wing-care'
import { ResManager } from '@hm/basic/Index'


class Params {
  page: number = 1
  pageSize: number = 10
}

@Component
export struct HealthAlarmComp {
  @Prop
  timeMode: number = 0
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
    // 异常数据列表
    Column() {
      // title
      Text('异常数据')
        .width('100%')
        .fontColor('#151515')
        .fontWeight(500)
        .fontSize(15)
        .margin({
          top: 16,
          bottom: 16
        })
      // 列表
      EcList({
        loading: this.loading,
        finished: this.finished,
        isRefreshing: $isRefreshing,
        load: this.load,
        refresh: this.refresh
      }) {
        ForEach(this.list, (item: number) => {
          ListItem() {
            Column({ space: 10 }) {
              Row() {
                Column() {
                  Badge({
                    value: '',
                    style: { badgeSize: 8, badgeColor: ResManager.EC_SUB_RED },
                    position: BadgePosition.Left
                  }) {
                    Row() {
                      Text('180')
                        .fontSize(26)
                        .fontWeight(700)
                        .fontColor(ResManager.EC_MID_BLACK)
                        .margin({ right: 10 })
                      Text('次/分钟')
                        .fontSize(10)
                        .fontColor(ResManager.EC_MID_99)
                        .alignSelf(ItemAlign.Baseline)
                    }
                    .padding({ left: 20 })
                    .margin({ bottom: 5 })
                  }

                  Text('心率>=180，持续1个周期就报警')
                    .fontSize(10)
                    .fontColor(ResManager.EC_MID_99)
                    .padding({ left: 20 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Text('2028年6月26日  09:40')
                  .fontSize(10)
                  .fontColor(ResManager.EC_MID_99)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
            }
            .width('100%')
            .borderRadius(12)
            .backgroundColor(ResManager.EC_MID_WHITE)
            .padding({ left: 14, right: 14, top: 10, bottom: 10 })
          }
        })
      }
    }
    .layoutWeight(1)
    .padding({ left: 15, right: 15 })
  }
}