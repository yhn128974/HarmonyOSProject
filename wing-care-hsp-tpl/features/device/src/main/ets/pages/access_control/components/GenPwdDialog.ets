import { ResManager } from '@hm/basic/Index'

@CustomDialog
export struct GenPwdDailog {
  controller: CustomDialogController

  build() {
    Column() {
      //  1. 标题
      Row() {
        Text('临时密码已生效')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(18)
          .fontWeight(500)
      }
      .width('100%')
      .padding({ left: 18, right: 18 })
      .height(56)

      // 2. 提示内容

      // 按钮
      Row() {
        // 取消
        Button('取消')
          .onClick(() => {
            this.controller.close()
          })
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .backgroundColor('#fff')
          .fontColor(ResManager.EC_MID_59)
        // 确定
        Divider()
          .vertical(true)
          .height(24)
          .color(ResManager.EC_MID_99)

        Button('确定')
          .onClick(() => {
            this.controller.close()

          })
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .backgroundColor('#fff')
          .fontColor(ResManager.EC_MAIN_COLOR)

      }
      .width('100%')
      .margin({ top: 10, bottom: 10 })
      .justifyContent(FlexAlign.SpaceAround)
    }
  }
}