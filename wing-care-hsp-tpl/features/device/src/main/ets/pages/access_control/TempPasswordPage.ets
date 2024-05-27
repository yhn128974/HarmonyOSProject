import { EcDialogTips } from '@itheima/wing-care'
import { ResManager } from '@hm/basic/Index'

@Entry
@Component
struct TempPasswordPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 1. 有效时长选择
  @State
  timeRange: string[][] = []
  @State
  selectTime: number | number[] = 0
  @State
  selectTimeValue: string[] = []

  // 创建时分数据
  createTimeRange() {
    const hours: string[] = []
    const minutes: string[] = []
    for (let i = 0; i < 24; i++) {
      if (i < 10) {
        hours.push('0' + i)
      } else {
        hours.push(i + '')
      }
    }
    for (let i = 1; i < 60; i++) {
      if (i < 10) {
        minutes.push('0' + i)
      } else {
        minutes.push(i + '')
      }
    }
    this.timeRange.push(hours, minutes)
  }

  aboutToAppear() {
    this.createTimeRange()
  }

  // 2. 有效次数选择
  @State
  numRange: string[] = ['不限次', '限1次', '限3次', '限5次', '限10次', '限30次', '限60次']
  @State
  selectNum: number | number[] = 0
  @State
  selectNumValue: string = ''

  // 3. 生成密码弹层
  @Builder
  tipsContent() {
    Column({ space: 6 }) {
      Column() {
        Text('234668')
          .fontColor(ResManager.EC_MAIN_COLOR)
          .fontSize(36)
          .fontWeight(700)
          .letterSpacing(20)
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(64)
      .backgroundColor('#F7F6F9')
      .border({ width: 1, color: ResManager.EC_MID_LINE })
      .borderRadius(4)
      .margin({ bottom: 6 })

      Text('有效期：2024年10月12日 10:00:00')
        .fontColor(ResManager.EC_MID_99)
        .fontSize(ResManager.EC_CARD_FS)
      Text('有效次数：2次')
        .fontColor(ResManager.EC_MID_99)
        .fontSize(ResManager.EC_CARD_FS)
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ left: 18, right: 18, bottom: 18 })
  }

  genPwdDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips({
      title: '临时密码已生效',
      // 解决 this 指向问题
      tipsContent: () => {
        this.tipsContent()
      },
      confirmButton: {
        text: '复制密码',
        // color:ResManager.EC_MAIN_COLOR,
        cb: () => {

        }
      },
      cancelButton: {
        text: '取消',
        // color:'red',
        cb: () => {
          this.genPwdDialog.close()
        }
      },
    }),
    alignment: DialogAlignment.Center
  })

  build() {
    Navigation() {
      // 说明
      Text('生成临时密码来分享你的开门权限')
        .width('100%')
        .padding({ left: 20 })
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_NORMAL_FS)
      Column() {
        List() {
          ListItem() {
            Row() {
              Text('有效时长')
                .fontColor(ResManager.EC_MID_19)
                .fontSize(ResManager.EC_MODULE_TITLE_FS)
                .fontWeight(500)

              Row() {
                Text('2小时30分钟')
                  .fontColor(ResManager.EC_MID_59)
                  .fontSize(ResManager.EC_NORMAL_FS)
                  .width(150)
                  .height(40)
                  .textAlign(TextAlign.End)
                  .margin({ right: 14 })
                Image($r('app.media.ic_arrow_black'))
                  .width(7)
                  .height(16)
                  .margin({ right: 4 })
              }
              .onClick(() => {
              })
            }
            .width('100%')
            .padding({ top: 5, bottom: 5 })
            .justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Text('有效次数')
                .fontColor(ResManager.EC_MID_19)
                .fontSize(ResManager.EC_MODULE_TITLE_FS)
                .fontWeight(500)

              Row() {
                Text('不限次')
                  .fontColor(ResManager.EC_MID_59)
                  .fontSize(ResManager.EC_NORMAL_FS)
                  .width(150)
                  .height(40)
                  .textAlign(TextAlign.End)
                  .margin({ right: 14 })
                Image($r('app.media.ic_arrow_black'))
                  .width(7)
                  .height(16)
                  .margin({ right: 4 })
              }
            }
            .width('100%')
            .padding({ top: 5, bottom: 5 })
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .height('auto')
        .padding({ left: 14, right: 18, })
        .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
      }
      .margin({ top: 15, left: ResManager.EC_CONTENT_SPACE, right: ResManager.EC_CONTENT_SPACE })
      // .width('100%')
      .backgroundColor('#fff')
      .borderRadius(ResManager.EC_NORMAL_RD)

      // 操作
      Button('生成临时密码')
        .margin({ top: 50 })
        .width(230)
        .backgroundColor(ResManager.EC_MAIN_COLOR)
        .onClick(() => {
          this.genPwdDialog.open()
        })

      Column({ space: 5 }) {
        Text('分享操作步骤')
          .fontColor('#50A0D8')
          .fontSize(ResManager.EC_NORMAL_FS)
          .fontWeight(700)
          .margin({ bottom: 3.5 })
        Text('1、选择临时密码的"有效时长"和"有效次数"')
          .fontColor('#50A0D8')
          .fontSize(ResManager.EC_CARD_FS)
        Text('2、点击"生成临时密码"按钮后，生成临时密码')
          .fontColor('#50A0D8')
          .fontSize(ResManager.EC_CARD_FS)
        Text('3、将密码复制后发送给朋友')
          .fontColor('#50A0D8')
          .fontSize(ResManager.EC_CARD_FS)
      }
      .width('83%')
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 26, left: 30, right: 30 })
      .padding(15)
      .backgroundColor('#E9F6FF')
      .borderRadius(5)
    }
    .title('临时密码')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}