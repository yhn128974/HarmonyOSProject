import { ResManager } from '@hm/basic/Index'
import { EcDialogTips } from '@itheima/wing-care'

@Component
export struct MsgItemComp {
  // 消息类型: 0 老人报警 ｜ 1 任务提醒
  @Prop
  type: number = 0
  @Prop
  item: number
  // 3. 查看详情
  @State
  detailTitle: string = this.type === 0 ? '老人报警' : '任务提醒'
  @State
  detail: number = 0

  @Builder
  tipsContent() {
    if (this.type === 0) {
      Column({ space: 15 }) {
        Text() {
          Span('项目名称：')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_CARD_FS)
          Span('公共卫生清洁' + this.detail)
            .fontColor('#000')
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
        }
        .width('100%')

        Text() {
          Span('老人姓名：')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_CARD_FS)
          Span('翔安')
            .fontColor('#000')
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
        }
        .width('100%')

        Text() {
          Span('期望服务时间：')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_CARD_FS)
          Span('2028年8月2日14:00')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_CARD_FS)
        }
        .width('100%')
      }
      .padding({ left: 18, bottom: 10 })
    } else {
      Column({ space: 15 }) {
        Text() {
          Span('接入位置：')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_CARD_FS)
          Span('110 床位' + this.detail)
            .fontColor('#000')
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
        }
        .width('100%')

        Text() {
          Span('所属产品：')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_CARD_FS)
          Span('智能手表')
            .fontColor('#000')
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
        }
        .width('100%')


        Text() {
          Span('功能名称：')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_CARD_FS)
          Span('心率')
            .fontColor('#000')
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
        }
        .width('100%')

        Text() {
          Span('数据值：')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_CARD_FS)
          Span('160次/分钟')
            .fontColor('#000')
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
        }
        .width('100%')
      }
      .padding({ left: 18, bottom: 10 })
    }
  }

  lookDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips({
      title: this.detailTitle,
      tipsContent: () => {
        this.tipsContent()
      },
      cancelButton: {
        text: '我知道了',
        color: ResManager.EC_MAIN_COLOR,
        // cb:()=>{
        //
        // }
      }
    }),
    alignment: DialogAlignment.Center
  })

  build() {
    Column() {
      Row() {
        Column({ space: 10 }) {
          Badge({
            value: '',
            style: { badgeSize: 4, badgeColor: '#FF6363' },
            position: BadgePosition.RightTop
          }) {
            Text('护理任务提醒' + this.item)
              .fontSize(16)
              .fontWeight(700)
              .fontColor(ResManager.EC_MID_BLACK)
              .margin({ right: 8 })
          }

          Text('您有一个新的护理任务，请及时处理')
            .fontSize(13)
            .fontColor(ResManager.EC_MID_59)

        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Text('09:40')
          .fontSize(13)
          .fontColor(ResManager.EC_MID_59)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
    }
    // .width('100%')
    .margin({ left: 15, right: 15 })
    .borderRadius(12)
    .backgroundColor(ResManager.EC_MID_WHITE)
    .padding({ left: 14, right: 14, top: 10, bottom: 10 })
    .onClick(() => {
      this.detail = this.item
      this.lookDialog.open()
    })
  }
}