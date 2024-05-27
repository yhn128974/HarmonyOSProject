import { ResManager } from '@hm/basic/Index'
import router from '@ohos.router'
import dayjs from 'dayjs'

// 健康数据
@Entry
@Component
struct HealthDataPage {
  @StorageProp('topHeight')
  topHeight: number = 0

  @Builder
  CustomTitle(title: string, icon?: Resource | string, color?: string) {
    Row() {
      Image(icon || ResManager.IC_BACK_BLACK)
        .width(19.65)
        .height(18)
        .margin({ left: 26, right: 18 })
        .onClick(() => router.back())
      Text(title)
        .fontColor(color || ResManager.EC_MID_19)
        .fontSize(ResManager.EC_PAGE_TITLE_FS)
        .fontWeight(500)
    }
    .width('100%')
    .margin({ top: this.topHeight })
    .height(55)
    .backgroundColor('rgba(255,255,255,0)')
  }

  // 表盘数据
  @Builder
  rainbowData(icon: ResourceStr, data: number[], unit: string) {
    Row({ space: 2 }) {
      Image(icon)
        .width(24)
        .aspectRatio(1)
        .margin({ right: 9 })
      Text() {
        Span(data[0] + ' ')
          .fontColor(ResManager.EC_MID_19)
        Span(unit)
          .fontSize(ResManager.EC_MICRO_FS)
          .fontWeight(500)
      }
      .fontSize(15)
      .fontColor(ResManager.EC_MID_99)
      .fontWeight(700)
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      //  1. 详情区
      Scroll() {
        Column() {
          // 老人数据
          Stack({ alignContent: Alignment.BottomEnd }) {
            Column() {
              // 基本信息
              Column({ space: 10 }) {
                Row({ space: 17.5 }) {
                  Text('李云龙')
                    .fontWeight(500)
                    .fontSize(ResManager.EC_MODULE_TITLE_FS)
                    .fontColor(ResManager.EC_MID_WHITE)
                  Text('80岁')
                    .fontSize(ResManager.EC_CARD_FS)
                    .fontColor(ResManager.EC_MID_WHITE)

                  Text('男')
                    .fontColor('#0398FF')
                    .fontSize(ResManager.EC_SMALL_FS)
                    .padding({ left: 10, right: 10, top: 2, bottom: 2 })
                    .backgroundColor('#DBF0FF')
                    .borderRadius(10)

                }
                .width('100%')

                Text('床位：四人间-22床')
                  .fontSize(ResManager.EC_SMALL_FS)
                  .fontColor(ResManager.EC_MID_WHITE)
                Text('护理等级：特级护理')
                  .fontSize(ResManager.EC_SMALL_FS)
                  .fontColor(ResManager.EC_MID_WHITE)
              }
              .margin({ left: 30 })
              .width('100%')
              .alignItems(HorizontalAlign.Start)

              // 监测数据
              Column({ space: 10 }) {
                this.rainbowData($r('app.media.icon_kaluli'), [413], '千卡')
                this.rainbowData($r('app.media.icon_hd_step'), [12813], '步')

                Text() {
                  Span(`${dayjs()
                    .format('MM月DD日')}  `)
                  Span(`${dayjs()
                    .format('hh:mm')}`)
                }
                .fontSize(ResManager.EC_CARD_FS)
                .fontColor(ResManager.EC_MID_99)
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ top: 35 })
              .width('100%')
              .padding({ top: 18, left: 30, bottom: 30 })
              .borderRadius(ResManager.EC_NORMAL_RD)
              .backgroundColor(ResManager.EC_MID_WHITE)
            }
            .padding({ top: 60 + this.topHeight, left: 15, right: 15 })
            .height('100%')
            .linearGradient({
              angle: 180,
              colors: [['#33D0C2', 0], ['#96E3DE', 0.77], ['#F7F6F9', 1]]
            })

            // 挂件
            Image($r('app.media.img_hd_yisheng'))
              .width(76)
              .aspectRatio(0.31)
              .margin({ right: 35, bottom: 45 })
          }
          .width('100%')
          .height(360 + this.topHeight)

          // 健康数据项
          GridRow({ columns: 2, gutter: 10 }) {
            ForEach(Array.from(new Array(10)), (item: undefined, i: number) => {
              GridCol() {
                Column() {
                  // 时间
                  Row() {
                    Image($r('app.media.icon_hd_xueyg'))
                      .width(40)
                      .aspectRatio(1)
                    Column() {
                      Text('8月2日')
                        .fontColor(ResManager.EC_MID_99)
                        .fontSize(ResManager.EC_NORMAL_FS)
                      Text('06:00')
                        .fontColor(ResManager.EC_MID_99)
                        .fontSize(ResManager.EC_NORMAL_FS)
                    }
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)

                  // 数据
                  Column({ space: 20 }) {
                    Row({ space: 5 }) {
                      Text('血压')
                        .fontColor(ResManager.EC_MID_19)
                        .fontWeight(500)
                        .fontSize(ResManager.EC_MODULE_TITLE_FS)
                      Text('异常')
                        .textAlign(TextAlign.Center)
                        .width(37)
                        .height(20)
                        .lineHeight(20)
                        .borderRadius(10)
                        .fontColor(ResManager.EC_SUB_YELLOW)// 正常色值：#DBF0FF ｜ #0398FF
                        .backgroundColor('#FFF0D9')
                        .fontSize(ResManager.EC_SMALL_FS)
                    }

                    Text() {
                      Span('140/87')
                        .fontSize(24)
                        .fontWeight(700)
                        .fontColor(ResManager.EC_MID_19)
                      Span('mmHg')
                        .fontSize(14)
                        .fontColor(ResManager.EC_MID_19)
                    }
                  }
                  .width('100%')
                  .margin({ top: 24 })
                  .alignItems(HorizontalAlign.Start)

                }
              }
              .padding(14)
              .borderRadius(ResManager.EC_NORMAL_RD)
              .backgroundColor(ResManager.EC_MID_WHITE)
              .layoutWeight(1)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/duty/HealthDetailPage'
                })
              })
            })
          }
          .padding(15)
          .margin({ top: -60 })
        }
        .width('100%')
      }
      // .padding({ top: 0, bottom: 60 })
      .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
      .scrollBar(BarState.Off) // 滚动条常驻显示
      .scrollBarColor(Color.Gray) // 滚动条颜色
      .scrollBarWidth(10) // 滚动条宽度
      .edgeEffect(EdgeEffect.None)

      // 2. 导航栏
      this.CustomTitle('健康数据')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)
  }
}