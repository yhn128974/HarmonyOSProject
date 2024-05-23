import { HmNavBar, HMCard_item, HMCard, ImageUrl, } from 'basic'
import router from '@ohos.router'
import { ExceptionParamsType, ExceptionParamsTypeModel, } from '../../common/models'
import { CommonRouterParams } from '../../common/models'

@Entry
@Component
struct ExceptDetail {
  @State submitForm: ExceptionParamsTypeModel = new ExceptionParamsTypeModel({} as ExceptionParamsType)

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.formData) {
      // 检查formData
      this.submitForm = params.formData as ExceptionParamsTypeModel
    }
  }

  @Builder
  getCardChildren() {
    HMCard_item({ leftTitle: '异常时间', rightTitle: this.submitForm.exceptionTime, showRightIcon: false, })
    HMCard_item({ leftTitle: '上报位置', rightTitle: this.submitForm.exceptionPlace, showRightIcon: false, })
    HMCard_item({ leftTitle: '异常类型', rightTitle: this.submitForm.exceptionType, showRightIcon: false })
    HMCard_item({ leftTitle: '异常描述', showBottomBorder: false, showRightIcon: false, rightTitle: '' })
    Row() {
      Text(this.submitForm.exceptionDescribe).fontSize(14).fontColor($r('app.color.text_primary'))
    }.padding(15).justifyContent(FlexAlign.Start).width('100%')
  }

  @Builder
  getUpload() {
    if (this.submitForm.exceptionImagesList?.length) {
      Text("异常图片").width('100%').padding(10)
      Flex({ wrap: FlexWrap.Wrap, direction: FlexDirection.Row }) {
        ForEach(this.submitForm.exceptionImagesList, (item: ImageUrl) => {
          Image(item.url)
            .width(95)
            .height(95)
            .borderRadius(4)
            .margin({ right: 15 })
        })
      }
      .width('100%').margin({ top: 16.5, bottom: 16.5 })
    }
  }

  build() {
    Column() {
      HmNavBar({ title: '异常详情' })

      HMCard() {
        this.getCardChildren()
      }

      HMCard() {
        this.getUpload()
      }
    }.height('100%').backgroundColor($r('app.color.background_page'))
  }
}

export default ExceptDetail