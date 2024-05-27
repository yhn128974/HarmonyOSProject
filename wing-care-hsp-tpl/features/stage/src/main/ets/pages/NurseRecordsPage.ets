import { EcList, EcNotFound } from '@itheima/wing-care'
import { SearchRecordComp } from '../components/SearchRecordComp'
import { ImgRecordDialog } from '../components/ImgRecordDialog'
import { ResManager } from '@hm/basic/Index'

class Params {
  page: number = 1
  pageSize: number = 10
}

// 护理任务记录
@Entry
@Component
struct NurseRecordsPage {
  @StorageProp('topHeight')
  topHeight: number = 0
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
    Navigation() {
      Column() {
        // 1. 搜索
        SearchRecordComp()

        // 2. 列表
        if (this.finished && this.list.length === 0) {
          EcNotFound({ tip: '暂无相关内容哦～' })
        } else {
          Column() {
            EcList({
              loading: this.loading,
              finished: this.finished,
              isRefreshing: $isRefreshing,
              load: this.load,
              refresh: this.refresh
            }) {
              ForEach(this.list, (item: number) => {
                ListItem() {
                  Column({ space: 14 }) {
                    Row() {
                      Column() {
                        Row({ space: 27 }) {
                          Text('李玉虎')
                            .fontColor(ResManager.EC_MID_BLACK)
                            .fontSize(ResManager.EC_PAGE_TITLE_FS)
                            .fontWeight(500)
                            .margin({ bottom: 5 })

                          Text('公共空间清洁')
                            .fontColor(ResManager.EC_MID_59)
                            .fontSize(13)
                        }
                        .width('100%')

                        Column({ space: 5 }) {
                          Text('执行时间：2023年8月2日14:30')
                            .fontColor(ResManager.EC_MID_59)
                            .fontSize(13)
                          Text('执行人：刘爱国')
                            .fontColor(ResManager.EC_MID_59)
                            .fontSize(13)
                        }
                        .margin({ top: 10 })
                        .width('100%')
                        .alignItems(HorizontalAlign.Start)

                      }
                      .layoutWeight(1)

                      // 护理记录图片
                      Image('https://p3.itc.cn/images01/20210302/4ffe526e31724d88bea813d0f9ce31a6.jpeg')
                        .width(92)
                        .height(80)
                        .borderRadius(6)
                    }

                    // 备注
                    Row() {
                      Text('喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具')
                        .fontSize(ResManager.EC_SMALL_FS)
                        .fontColor('#3FA199')
                        .lineHeight(20)
                    }
                    .width('100%')
                    .backgroundColor('#E8F2F1')
                    .borderRadius(5)
                    .padding({ left: 10, right: 10, top: 5, bottom: 8 })

                  }
                  .width('100%')
                  .borderRadius(ResManager.EC_NORMAL_RD)
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
      .width('100%')
      .height('100%')

    }
    .title('护理记录')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}