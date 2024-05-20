@CustomDialog
@Component
@Preview
struct HmLoading {
  controller: CustomDialogController
  title: string = '数据处理中..'

  build() {
    Row({ space: 6 }) {
      Text(this.title)
        .fontSize(16)
        .fontColor($r("app.color.text_primary"))
      LoadingProgress()
        .width(30)
        .height(30)
        .color($r("app.color.primary"))
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor("rgba(0,0,0,0.1)")
  }
}

export { HmLoading }