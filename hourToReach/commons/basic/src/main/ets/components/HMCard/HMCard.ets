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
    .margin(15)
    .borderRadius(8)

  }
}