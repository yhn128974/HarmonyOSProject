@Preview
@Component
export struct HMCard_item {
  @Prop
  leftTitle: string = "右侧"
  @Prop
  rightTitle: string = '左侧'
  @Prop
  showRightIcon: boolean = true
  @Prop
  showBottomBorder: boolean = true
  // icon的点击事件
  handleRightClick: () => void = () => {
  }

  build() {

    Row() {
      Text(this.leftTitle).fontSize(16).fontColor($r('app.color.text_primary'))
      Row() {
        Text(this.rightTitle).fontColor($r('app.color.text_secondary'))
        if (this.showRightIcon) {
          Image($r('app.media.ic_btn_more')).width(24).aspectRatio(1)
        }
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .border({
      width: { bottom: this.showBottomBorder ? 1 : 0 },
      color: $r('app.color.background_page')
    })
    .width('100%')
    .height(60)
  }
}