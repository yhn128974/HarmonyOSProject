@Preview
@Component
export struct HmCheckBox {
  title: string = "测试"
  confirmText: string = "是"
  cancelText: string = '否'
  @Prop
  value: boolean = true
  checkChange: (value: boolean) => void = () => {
  }

  build() {
    Row() {
      Row() {
        Text(this.title).fontSize(14).fontColor($r('app.color.text_primary'))
        //   右侧内容
        Row() {
          Row() {
            Image(this.value ? $r('app.media.ic_radio_true') : $r('app.media.ic_radio_false'))
              .width(32)
              .aspectRatio(1)
            Text(this.confirmText)
          }.onClick(() => {
            this.value = true
            this.checkChange(this.value)
          })

          Row() {
            Image(!this.value ? $r('app.media.ic_radio_true') : $r('app.media.ic_radio_false'))
              .width(32)
              .aspectRatio(1)
            Text(this.cancelText)
          }.onClick(()=>{
            this.value=false
            this.checkChange(this.value)
          })
        }

      }
      .borderRadius(10)
      .height(60)
      .backgroundColor($r('app.color.white'))
      .width('100%')
      .padding({
        left: 15,
        right: 15
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }.width('100%').padding({
      left: 15,
      right: 15
    })
  }
}