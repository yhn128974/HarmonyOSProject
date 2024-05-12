@Builder
export  function  getRenderItem(left: string, rightClick?: () => void) {
  Row() {
    Text(left)
    Image($r("app.media.ic_public_right"))
      .width(16)
      .height(16)
  }
  .width('100%')
  .padding({
    left: 20,
    right: 20
  })
  .backgroundColor($r("app.color.white"))
  .height(60)
  .justifyContent(FlexAlign.SpaceBetween)
  .border({
    color: $r("app.color.border_color"),
    width: {
      bottom: 0.5
    }
  })
}