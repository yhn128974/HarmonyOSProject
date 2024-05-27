import { EcDialogUpload, ResManager } from '@hm/basic';

// 护理任务执行
@Entry
@Component
struct ExecutePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State notes: string = '';
  // 上传弹层控制
  uploadDialog: CustomDialogController = new CustomDialogController({
    // 使用自定义弹层组件
    builder: EcDialogUpload({}),
    alignment: DialogAlignment.Bottom
  })

  aboutToAppear() {
    this.uploadDialog.open()
  }

  build() {
    Navigation() {
      Column() {
        // 1. 时间和图片
        List() {
          ListItem() {
            Row() {
              Text('执行时间')
                .fontColor(ResManager.EC_MID_19)
                .fontSize(ResManager.EC_MODULE_TITLE_FS)
              Text('2023年8月2日18:30')
                .fontColor(ResManager.EC_MID_99)
                .fontSize(ResManager.EC_NORMAL_FS)
            }
            .width('100%')
            .padding({ bottom: 15 })
            .justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Text('执行图片')
                .fontColor(ResManager.EC_MID_19)
                .fontSize(ResManager.EC_MODULE_TITLE_FS)

              // 上传
              Row({ space: 10 }) {
                //  1. 上传按钮
                Column() {
                  Image($r("app.media.ic_btn_carema"))
                    .width(24)
                    .aspectRatio(1)
                }
                .justifyContent(FlexAlign.Center)
                .width(48)
                .height(48)
                .backgroundColor('#F2F2F2')
                .borderRadius(4)
                .onClick(() => {
                  this.uploadDialog.open()
                })

                // 2. 上传预览
                Column() {
                  Stack({ alignContent: Alignment.TopEnd }) {
                    Image('https://img2.baidu.com/it/u=3770577849,3048098919&fm=253&fmt=auto&app=138&f=JPEG?w=750&h=500')
                      .width('100%')
                      .aspectRatio(1)
                      .borderRadius(4)

                    // 删除上传
                    Image($r("app.media.ic_btn_cdelete"))
                      .width(19)
                      .aspectRatio(1)
                  }
                  .width('100%')
                  .height('100%')
                }
                .justifyContent(FlexAlign.Center)
                .width(48)
                .height(48)
                .backgroundColor('#F2F2F2')
                .borderRadius(4)
              }

            }
            .width('100%')
            .padding({ top: 15 })
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .height('auto')
        .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
        .padding(ResManager.EC_CONTENT_SPACE)
        .backgroundColor('#fff')
        .borderRadius(ResManager.EC_NORMAL_RD)

        // 2. 备注
        Text('执行备注')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
          .margin({ top: 20, bottom: 13 })

        Column() {
          TextArea({ text: this.notes, placeholder: '请输入备注信息' })
            .onChange(val => {
              this.notes = val
            })
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

        //   提交按钮
        Button('确定')
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
    .title('执行记录')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}