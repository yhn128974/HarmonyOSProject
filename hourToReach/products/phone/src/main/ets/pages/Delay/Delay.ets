import { HmNavBar, HMCard, HMCard_item, transTimeFormat } from 'basic'
import { promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams, DelayParamsType, DelayParamsTypeModel } from '../../common/models'
import { delay } from '../../../ets/common/api'

@Entry
@Component
struct Delay {
  @State oldTime: string = ""
  @State currentDelayParams: DelayParamsTypeModel = new DelayParamsTypeModel({} as DelayParamsType)

  aboutToAppear(): void {
    const res = router.getParams() as CommonRouterParams
    if (res.oldTime && res.id) {
      this.oldTime = res.oldTime
      this.currentDelayParams.id = res.id
    }
  }

  getBtnEnable() {
    return !!(this.currentDelayParams.id && this.currentDelayParams.delayReason && this.currentDelayParams.delayTime)
  }

  // 处理延时
  async handleDelay() {
    await delay(this.currentDelayParams)
    promptAction.showToast({
      message: '延迟提货成功'
    })
    router.back()
  }

  build() {
    Column() {
      HmNavBar({ title: '延迟提货' })
      HMCard() {
        HMCard_item({ leftTitle: '原定时间', rightTitle: this.oldTime, showRightIcon: false })
        HMCard_item({
          leftTitle: '延迟时间', rightTitle: '',
          handleRightClick: () => {
            DatePickerDialog.show({
              useMilitaryTime: true,
              showTime: true,
              onDateChange: (value: Date) => {
                this.currentDelayParams.delayTime = transTimeFormat(value)
              }
            })
          }
        })
        TextArea({ placeholder: '请输入延迟提货原因', text: this.currentDelayParams.delayReason })
          .backgroundColor($r('app.color.background_page'))
          .margin({
            top: 20
          })
          .borderRadius(8)
          .height(130)
          .placeholderColor($r('app.color.text_secondary'))
          .fontSize(14)
          .onChange((value: string) => {
            this.currentDelayParams.delayReason = value
          })
          .maxLength(50)

        Text(`${this.currentDelayParams.delayReason?.length || 0}/50`)
          .margin({
            top: -30
          })
          .textAlign(TextAlign.End)
          .width('100%')
          .padding({ right: 15 })
          .fontColor($r('app.color.text_secondary'))

        Row() {
          Button("提交")
            .height(50)
            .width(207)
            .backgroundColor($r('app.color.primary'))
            .onClick(() => {
              this.handleDelay()
            })
            .enabled(this.getBtnEnable())
        }.justifyContent(FlexAlign.Center).padding({
          top: 20,
          bottom: 20
        })

      }

    }
    .height('100%').backgroundColor($r('app.color.background_page')
    )
  }
}