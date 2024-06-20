export class HmConfirmModel {
  fontColor?: ResourceStr = ''
  fontSize?: number = 16
  text: string = ""
  action?: () => void = () => {
  }
}

@CustomDialog
@Preview
@Component
export struct HMConfirm {

  controller: CustomDialogController

  @Prop
  message: string = "确定要退出登录吗？"

  @Prop buttonList: HmConfirmModel[] = [{
    text: '确定',
    fontSize: 14,
    fontColor: $r('app.color.text_secondary')
  }]

  build() {
    Row() {
      Column() {
        Row() {
          Text(this.message)
            .fontSize(16)
            .fontColor($r('app.color.text_primary'))
        }
        .width('100%')
        .height(88)
        .justifyContent(FlexAlign.Center)
        .border({
          color: $r('app.color.background_divider'),
          width: {
            bottom: 0.5
          }
        })

        Row() {
          ForEach(this.buttonList, (item: HmConfirmModel, index: number) => {
            Text(item.text)
              .fontSize(item.fontSize || 16)
              .textAlign(TextAlign.Center)
              .fontColor(item.fontColor || $r('app.color.text_secondary'))
              .layoutWeight(1)
              .border({
                color: $r('app.color.background_divider'),
                width: {
                  right: this.buttonList.length > 1 && index !== this.buttonList.length - 1
                    ? 0.5 : 0
                }
              })
              .height('100%')
              // 异步action防止外部传入的函数为异步函数,函数执行完毕前CustomDialogController被销毁
              .onClick(async () => {
                if (item.action) {
                  await item.action()
                }
                this.controller.close()
              })
          })
        }
        .height(49)
        .width('100%')
      }
    }
    .width(278)
    .borderRadius(12)
    .backgroundColor($r('app.color.white'))
  }
}
