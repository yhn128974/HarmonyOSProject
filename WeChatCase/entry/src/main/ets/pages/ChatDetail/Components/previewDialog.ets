@CustomDialog
struct PreviewImage {
  controller: CustomDialogController
  url: string = ""
  build() {
    Column() {
      Image(this.url)
        .width('100%')
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