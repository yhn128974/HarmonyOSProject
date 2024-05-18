@CustomDialog
@Component
export struct HmPreview {
  controller: CustomDialogController
  urls: string[] = []
  selectIndex: number = -1

  build() {
    Column() {
      Swiper() {
        ForEach(this.urls, (url: string) => {
          Image(url).width('100%').onClick(() => {
            this.controller.close()
          })
        })
      }.indicator(false)
      .index(this.selectIndex)
    }.justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.black'))
  }
}