@Preview
@CustomDialog
@Component
struct HmSelectCard {
  @Prop title:string= '请选择'

  @Prop
  buttonText: string = "确定" // 底部按钮文本
  @Prop
  showClose: boolean = true // 显示关闭按钮
  @Prop
  showButton: boolean = true // 显示底部按钮
  confirm: () => void = () => {
  }

  @Builder
  defaultCardContent() {

  }

  @BuilderParam
  cardContent: () => void = this.defaultCardContent
  controller: CustomDialogController

  build() {
    Column() {
      Row() {
        Text(this.title).fontSize(16).fontColor($r('app.color.text_primary'))
        if (this.showClose) {
          Image($r("app.media.ic_btn_close")).width(13).height(13).onClick(() => {
            this.controller.close()
          })
        }

      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height(60)
      .borderRadius({
        topLeft: 16,
        topRight: 16
      })


      // 渲染内容
      Column() {

        this.cardContent()
      }.width('100%')

      // 底部按钮
      if (this.showButton) {
        Row() {
          Button(this.buttonText, { type: ButtonType.Capsule })
            .width(200)
            .backgroundColor($r('app.color.primary'))
            .height(45)
            .onClick(() => {
              this.confirm()
              this.controller.close()
            })
        }.width('100%').justifyContent(FlexAlign.Center)
      }
    }.backgroundColor($r('app.color.white')).justifyContent(FlexAlign.SpaceBetween).padding({
      left: 21.36,
      right: 21.36
    })
  }
}

export { HmSelectCard }