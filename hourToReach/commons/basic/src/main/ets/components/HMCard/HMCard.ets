@Component
export struct HMCard {
  @BuilderParam
  ThisBuilderParam: () => void

  build() {

    Column() {
      if (this.ThisBuilderParam) {
        this.ThisBuilderParam()
      }
    }
    .padding({ left: 17.5, right: 17.5 })
    .backgroundColor($r('app.color.white'))
    .margin({ left: 14.5, right: 14.5, bottom: 15 })
    .borderRadius(8)

  }
}