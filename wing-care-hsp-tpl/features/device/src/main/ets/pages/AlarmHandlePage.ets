import { ResManager } from '@hm/basic/Index';

// 报警处理
@Entry
@Component
struct AlarmHandlePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State result: string = '';

  build() {
    Navigation() {
      Column() {
        // 1. 处理时间
        List() {
          ListItem() {
            Row() {
              Text('处理时间')
                .fontColor(ResManager.EC_MID_19)
                .fontSize(ResManager.EC_MODULE_TITLE_FS)
                .fontWeight(500)

              Row() {
                Text('2023年8月2日18:30')
                  .fontColor(ResManager.EC_MID_99)
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
                // this.timeDialog.open()
              })
            }
            .width('100%')
            .padding({ top: 5, bottom: 5 })
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .padding({ left: 15, right: 15 })
        .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
        .backgroundColor('#fff')
        .borderRadius(ResManager.EC_NORMAL_RD)

        // 2. 处理结果
        Text('处理结果')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
          .margin({ top: 20, bottom: 13 })

        Column() {
          TextArea({ text: $$this.result, placeholder: '请输入处理结果' })
            .height(108)
            .fontSize(13)
            .placeholderColor(ResManager.EC_MID_99)
            .placeholderFont({ size: 13 })
            .maxLength(100)
            .showCounter(true)
            .borderRadius(4)
        }
        .width('100%')
        .borderRadius(ResManager.EC_NORMAL_RD)
        .backgroundColor(ResManager.EC_MID_WHITE)
        .padding(14)

        // 提交按钮
        Button('提交')
          .enabled(false)
          .margin({ top: 20 })
          .width(230)
          .height(40)
          .alignSelf(ItemAlign.Center)
          .fontColor('#fff')
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .backgroundColor(ResManager.EC_MAIN_COLOR)

      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({ left: ResManager.EC_CONTENT_SPACE, right: ResManager.EC_CONTENT_SPACE })
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title('报警处理')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}