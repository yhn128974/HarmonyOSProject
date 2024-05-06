import { MessageTypeEnum } from '../../../models/message'

@CustomDialog
struct PreviewImage {
  controller: CustomDialogController
  url: string = ""
  showTyPe: MessageTypeEnum = MessageTypeEnum.IMAGE

  build() {
    Column() {
      if (this.showTyPe === MessageTypeEnum.IMAGE) {
        Image(this.url)
          .width('100%')
      }
      if (this.showTyPe === MessageTypeEnum.VIDEO) {
        Video({
          src: this.url
        })
          .width('100%')
          .height('100%')
          .autoPlay(true)
          .loop(true)
          .controls(false)
      }

    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
    .onClick(() => {
      this.controller.close()
    })
    .justifyContent(FlexAlign.Center)
  }
}

export default PreviewImage