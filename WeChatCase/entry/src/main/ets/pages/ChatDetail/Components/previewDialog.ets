import { MessageTypeEnum } from '../../../models/message'

@CustomDialog
struct PreviewImage {
  controller: CustomDialogController
  url: string = ""
  showTyPe: MessageTypeEnum = MessageTypeEnum.IMAGE

  videoController:VideoController=new VideoController()
  @Builder videoBuilder(url:string){
    Stack(){
      Video({
        src: this.url,
        controller:this.videoController
      })
        .width('100%')
        .height('100%')
        .autoPlay(true)
        .loop(true)
        .controls(false)
      Image($r('app.media.ic_public_play')).width(30).aspectRatio(1).fillColor($r('app.color.second_primary'))
    }

  }
  build() {
    Column() {
      if (this.showTyPe === MessageTypeEnum.IMAGE) {
        Image(this.url)
          .width('100%')
      }
      if (this.showTyPe === MessageTypeEnum.VIDEO) {

        this.videoBuilder(this.url)

        // Video({
        //   src: this.url
        // })
        //   .width('100%')
        //   .height('100%')
        //   .autoPlay(true)
        //   .loop(true)
        //   .controls(false)
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