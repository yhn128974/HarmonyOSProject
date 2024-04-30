import { promptAction } from '@kit.ArkUI'

@Preview
@Component
struct BottomInput {
  @State showVoice: boolean = false //是否显示语音输入
  @State content: string = '' //输入内容
  sentTextMessage: (content: string) => void = () => {
  }

  build() {
    Row() {
      Image(this.showVoice ? $r('app.media.ic_public_keyboard') : $r('app.media.ic_public_sound'))
        .width(25)
        .aspectRatio(1)
        .onClick(() => {
          this.showVoice = !this.showVoice
        })
      if (this.showVoice) {
        Button('按住说话')
          .type(ButtonType.Normal)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .height(35)
          .borderRadius(2)
          .backgroundColor($r('app.color.white'))
          .margin({
            left: 10,
            right: 10
          })

      } else {
        TextInput({
          text: $$this.content
        })
          .onSubmit(() => {
            if (this.content) {
              this.sentTextMessage(this.content)
              this.content = ''
            }
          })
          .layoutWeight(1)
          .height(35)
          .borderRadius(2)
          .backgroundColor($r('app.color.white'))
          .margin({
            left: 10,
            right: 10
          })
      }
      Image($r('app.media.ic_public_add_norm')).width(25).aspectRatio(1)

    }.width('100%').padding({
      left: 10,
      right: 10
    }).height(60).backgroundColor($r('app.color.second_back_color'))
  }
}

export default BottomInput