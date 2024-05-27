import { ResManager } from '@hm/basic/Index'

/**
 * 测血糖结果
 */
@Entry
@Component
struct TestResultPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 导航右侧内容
  @Builder
  menusBuilder() {
    Row() {
      Text('血糖记录')
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_NORMAL_FS)
    }
    .margin({ right: ResManager.EC_CONTENT_SPACE })
    .height('100%')
    .onClick(() => {

    })

  }
  // 血糖三中状态颜色：正常-#03C4B3 ｜ 过低-#F55A58 ｜ 过高-#FFAB2D

  build() {
    Navigation() {
      // 1. 血糖结果
      Column() {
        // 时间
        Text('8月29日 20:00')
          .fontSize(18)
          .fontColor('#000')
          .fontWeight(500)
          .margin({ top: 15, left: 25, bottom: 15 })
        // 结果
        Column() {
          Column() {
            Row() {
              // 1. 值
              Column() {
                Text() {
                  Span('5.3')
                    .fontSize(51)
                    .fontColor(ResManager.EC_MAIN_COLOR)
                    .fontWeight(700)
                  Span(' mmol/L')
                    .fontSize(14)
                    .fontColor(ResManager.EC_MAIN_COLOR)
                }

                Text('血糖推荐值：')
                  .fontSize(14)
                  .fontColor(ResManager.EC_MID_19)
                  .margin({ top: 8 })
                Text('4.4～6.1mmoI/L')
                  .fontSize(14)
                  .fontColor(ResManager.EC_MID_19)
              }
              .alignItems(HorizontalAlign.Start)

              // 2. 图表
              Column() {
                // Stack({ alignContent: Alignment.Center }) {
                Gauge({ value: 20, min: 0, max: 100 }) {
                  // 描述
                  Column() {
                    Text('血糖达标')
                      .fontSize(14)
                      .fontColor(ResManager.EC_MAIN_COLOR)
                      .fontWeight(500)

                  }
                  .justifyContent(FlexAlign.Center)
                }
                .startAngle(220)
                .endAngle(140)
                .colors([[ResManager.EC_MAIN_COLOR, 0.6], ['#F3F3F3', 0.4]])
                // 边框宽度
                .strokeWidth(12)
                // 圆弧直径
                .width(106)
                .height(106)
                .indicator(null)
                .trackShadow(null)
                .description(null)

                Text('睡前')
                  .fontSize(16)
                  .fontColor(ResManager.EC_MID_19)
                  .fontWeight(500)
                  .margin({ top: -10 })

                // }

              }
              .margin({ top: 20 })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)
          }
          .width('100%')
          .height(158)
          .backgroundColor('rgba(255,255,255,1)')
          .borderRadius(8)
        }
        .margin({ left: 15, right: 15 })
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .height(247)
      .linearGradient({
        angle: 140,
        colors: [['#EBEAF9', 0.15], ['#C0F4F0', 0.61], ['#C2F0FF', 0.8], ['#F7F6F9', 1]]
      })

      // 2. 血糖分析和说明
      Scroll() {
        Column() {
          // 1. 分析结果
          Column() {
            // 标题
            Text() {
              ImageSpan($r('app.media.pic_xuetang'))
                .width(24)
                .aspectRatio(1)
                .margin({ right: 8 })
              Span('血糖分析')
                .fontSize(16)
                .fontColor('#000')
                .fontWeight(500)
            }
            .margin({ top: 10, bottom: 8, left: 15 })

            // == 分析结果 ==
            Text('经过（测量时间）测量，血糖水平为5.3mmol/L。老人的血糖值处于正常范围内，这表明该老人的血糖控制良好，饮食、运动和药物治疗方案都取得了有效成果。没有明显的血糖波动说明身体状况良好。请继续保持当前的生活方式，并定期进行血糖监测，以便及时了解血糖变化，预防潜在的并发症。')
              .padding({ left: 15, right: 15, bottom: 15 })
              .fontSize(13)
              .lineHeight(21)
              .fontColor(ResManager.EC_MID_59)
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .backgroundColor('#fff')
          .borderRadius(8)

          // 2. 建议
          Column() {
            // 标题
            Text() {
              ImageSpan($r('app.media.pic_jianyi'))
                .width(24)
                .aspectRatio(1)
                .margin({ right: 8 })
              Span('控糖建议')
                .fontSize(16)
                .fontColor('#000')
                .fontWeight(500)
            }
            .margin({ top: 10, bottom: 8, left: 15 })

            // == 分析结果 ==
            Text('均衡饮食：尽量选择全谷类、蔬菜和低糖水果。避免过多的糖分和加工食品。\n\n' +

              '规律运动：每天至少30分钟的中等强度运动，如快走或跳舞，有助于提高身体对胰岛素的敏感性。\n\n' +

              '控制体重：保持健康的体重范围，避免肥胖，有助于维持血糖稳定。\n\n' +

              '定期监测：定期检查血糖，以便及时发现问题并进行调整。\n\n' +

              '寻求专业建议：如果你有糖尿病或相关风险因素，最好咨询医生以获取更具体的建议。')
              .padding({ left: 15, right: 15, bottom: 15 })
              .fontSize(13)
              .lineHeight(21)
              .fontColor(ResManager.EC_MID_59)
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .backgroundColor('#fff')
          .borderRadius(8)
          .margin({ top: 15 })
        }
        .margin(15)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

    }
    .title('测血糖')
    .padding({ top: this.topHeight })
    .menus(this.menusBuilder())
    .backgroundColor(ResManager.EC_MID_BG)
    .titleMode(NavigationTitleMode.Mini)
  }
}