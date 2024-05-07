import { VoiceRecordEnum } from '../../../models/voice'
import { emitter } from '@kit.BasicServicesKit'

@Component
struct VoiceInput {
  @Consume
  voiceState: VoiceRecordEnum
  @Consume asrResult: string
  @State list: number[] = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10] //用来生成高度的数组

  aboutToAppear(): void {
    emitter.on('onBuffer', (res) => {
      this.calCHeight(res.data!.buffer)
    })
  }

  aboutToDisappear(): void {
    emitter.off('onBuffer')
  }

  // 计算 20个高度个list
  calCHeight(buffer: ArrayBuffer) {
    // buffer的长度不确定
    // z做一个转化,将buffer转化为dateView
    const view = new DataView(buffer)
    const arr: number[] = []
    const size = Math.floor(buffer.byteLength / 20) //分三十分,每份的大小
    for (let index = 0; index < buffer.byteLength; index += size) {
      let sum = 0
      //   计算每一份里面振幅的平均值
      for (let index2 = index; index2 < index + size; index2 += 2) {
        //   取值
        const sample = view.getInt16(index2, true)
        sum += Math.abs(sample)
      }
      const height = 120 * sum / (size / 2) / 32767 //比例 某一份的高度
      arr.push(height < 10 ? 10 : height)
    }
    this.list = arr
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        // 显示关闭和文本
        Row() {
          if (this.voiceState === VoiceRecordEnum.Cancel) {
            //  取消录音
            Row({
              space: 2
            }) {

            }
            .width(100)
            .height(80)
            .borderRadius(20)
            .backgroundColor($r('app.color.danger'))
            .margin({
              bottom: 60,
              left: 30
            })
          } else if (this.voiceState === VoiceRecordEnum.Transfer) {
            // 语音转文本
            Row() {
              Text(this.asrResult).fontSize(18).fontColor($r('app.color.text_primary'))
            }
            .width(280)
            .height(120)
            .borderRadius(20)
            .backgroundColor($r('app.color.chat_primary'))
            .margin({
              bottom: 60,
            })

          } else if (this.voiceState === VoiceRecordEnum.Recording) {
            //录音
            Row({ space: 2 }) {
              ForEach(this.list, (value: number) => {
                Row()
                  .height(value)
                  .width(2)
                  .borderRadius(1)
                  .backgroundColor($r('app.color.animate_voice_color'))
              })
            }
            .justifyContent(FlexAlign.Center)
            .width(180)
            .height(80)
            .borderRadius(20)
            .backgroundColor($r('app.color.chat_primary'))
            .margin({
              bottom: 60,
            })

          }
        }.width('100%')
        .justifyContent(this.voiceState === VoiceRecordEnum.Cancel ? FlexAlign.Start : FlexAlign.Center)
        .padding({
          left: 40,
          right: 40
        })

        Row() {
          Row() {
            Image($r("app.media.ic_public_cancel"))
              .width(30)
              .height(30)
              .fillColor(this.voiceState === VoiceRecordEnum.Cancel ? $r('app.color.text_primary') : $r("app.color.voice_round_font_color"))
          }
          .width(70)
          .aspectRatio(1)
          .borderRadius(35)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.voiceState === VoiceRecordEnum.Cancel ? $r('app.color.bottom_color') : $r("app.color.voice_round_color"))
          .rotate({
            angle: -10
          })
          .scale({
            x: this.voiceState === VoiceRecordEnum.Cancel ? 1.2 : 1,
            y: this.voiceState === VoiceRecordEnum.Cancel ? 1.2 : 1
          })

          Row() {
            Text("文")
              .fontSize(24)
              .textAlign(TextAlign.Center)
              .fontColor(this.voiceState === VoiceRecordEnum.Transfer ? $r('app.color.text_primary') : $r("app.color.voice_round_font_color"))
          }
          .width(70)
          .aspectRatio(1)
          .borderRadius(35)
          .justifyContent(FlexAlign.Center)

          .backgroundColor(this.voiceState === VoiceRecordEnum.Transfer ? $r('app.color.bottom_color') : $r("app.color.voice_round_color"))
          .rotate({
            angle: 10
          })
          .scale({
            x: this.voiceState === VoiceRecordEnum.Transfer ? 1.2 : 1,
            y: this.voiceState === VoiceRecordEnum.Transfer ? 1.2 : 1
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: 40,
          right: 40
        })
        .margin({
          bottom: 30
        })

        Stack() {
          Image($r("app.media.ic_public_output"))
            .width('100%')
            .height(120)
            .fillColor($r("app.color.bottom_color"))
            .scale({
              x: 1.2
            })
            .fillColor(this.voiceState === VoiceRecordEnum.Recording ? $r('app.color.bottom_color') : $r('app.color.voice_back_color'))
          Image($r("app.media.ic_public_recorder"))
            .width(30)
            .height(30)
            .fillColor($r("app.color.bottom_voice_color"))
            .fillColor(this.voiceState === VoiceRecordEnum.Recording ? $r('app.color.voice_back_color') : $r('app.color.bottom_color'))
        }
        .width('100%')
      }
    }
    .height('100%')
    .backgroundColor($r("app.color.voice_back_color"))

  }
}

export default VoiceInput