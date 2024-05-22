import { HMCard, HMCard_item, HmNavBar, HmUpload, ImageUrl, transTimeFormat, HmSelectCard } from 'basic'
import { promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams, ExceptionParamsType, ExceptionParamsTypeModel } from '../../common/models'
import { exceptionReport } from '../../common/api'

@Entry
@Component
struct ExceptionReport {
  @State currentSingleItemIndex: number = -1
  exceptionList: string[] = ['发动机困难', '不着车,漏油', '照明失灵', '有异动', '排烟器温度异常', '其他问题']
  @State currentExceptionParams: ExceptionParamsTypeModel = new ExceptionParamsTypeModel({} as ExceptionParamsType)

  aboutToAppear(): void {
    const res = router.getParams() as CommonRouterParams
    this.currentExceptionParams.transportTaskId = res.id || ''
  }

  async handleCurrentExceptionParams() {
    await exceptionReport(this.currentExceptionParams)
  }

  BtnEnable() {
    return !!(this.currentExceptionParams.exceptionDescribe &&
    this.currentExceptionParams.exceptionPlace &&
    this.currentExceptionParams.exceptionTime &&
    this.currentExceptionParams.exceptionType &&
    this.currentExceptionParams.exceptionDescribe)
  }

  selectTypeDialog: CustomDialogController = new CustomDialogController({
    builder: HmSelectCard({
      cardContent: () => {
        this.getCardContent()
      },
      confirm: () => {
        this.currentExceptionParams.exceptionType = this.exceptionList[this.currentSingleItemIndex]

      }
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom
  })

  @Builder
  getCardContent() {
    ForEach(this.exceptionList, (item: string, index: number) => {
      if (index == this.exceptionList.length - 1) {
        this.getSingleItem(item, false, index)
      } else {
        this.getSingleItem(item, true, index)
      }
    })
  }

  @Builder
  getSingleItem(item: string, showBottomBorder: boolean, index: number) {
    Row() {
      Text(item).fontSize(14).fontColor($r('app.color.text_primary'))
      Image(this.currentSingleItemIndex === index ? $r('app.media.ic_check_true') : $r('app.media.ic_check_false'))
        .width(32)
        .aspectRatio(1)
        .onClick(() => {
          this.currentSingleItemIndex = index
        })
    }.height(60).width('100%').justifyContent(FlexAlign.SpaceBetween).border({
      color: $r('app.color.background_divider'),
      width: {
        bottom: showBottomBorder ? 1 : 0
      }
    })
  }

  build() {
    Column() {
      HmNavBar({ title: '上报异常' })
      Scroll() {
        Column() {
          HMCard() {
            HMCard_item({
              leftTitle: '异常时间',
              rightTitle: this.currentExceptionParams.exceptionTime ?? '请选择',
              handleRightClick: () => {
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true,
                  onDateAccept: (value: Date) => {
                    this.currentExceptionParams.exceptionTime = transTimeFormat(value)
                  }
                })
              }
            })
            HMCard_item({
              leftTitle: '上报位置',
              rightTitle: this.currentExceptionParams.exceptionPlace ?? '请选择',
              handleRightClick: () => {
                router.pushUrl({
                  url: 'pages/selectLocation/selectLocation'
                })
              }
            })
            HMCard_item({
              leftTitle: '异常类型',
              rightTitle: this.currentExceptionParams.exceptionType ?? '请选择',
              handleRightClick: () => {
                this.selectTypeDialog.open()
              }
            })

            HMCard_item({ leftTitle: '异常描述', rightTitle: '', showRightIcon: false, showBottomBorder: false })
            TextArea({
              placeholder: '请输入异常描述',
              text: this.currentExceptionParams.exceptionDescribe
            })
              .maxLength(50)
              .height(130)
              .borderRadius(8)
              .placeholderColor($r('app.color.text_secondary'))
              .fontSize(14)
              .onChange((value) => {
                this.currentExceptionParams.exceptionDescribe = value
              })
            Text(`${this.currentExceptionParams.exceptionDescribe?.length || 0}/50`)
              .margin({
                top: -30
              })
              .textAlign(TextAlign.End)
              .width('100%')
              .padding({ right: 15 })
              .fontColor($r('app.color.text_secondary'))
            Row().height(20)

          }

          HMCard() {
            HmUpload({
              title: '上传图片(最多6张)',
              currentImageList: [],
              canUpload: true,
              handleCurrentImageListChange: (list: ImageUrl[]) => {
                this.currentExceptionParams.exceptionImagesList = list
              }
            })
            Row().height(20)
          }
        }
      }.padding({
        bottom: 80
      })
      .layoutWeight(1)


      Row() {
        Button("提交")
          .height(50)
          .width(207)
          .backgroundColor($r('app.color.primary'))
          .enabled(this.BtnEnable())
          .onClick(() => {
            this.handleCurrentExceptionParams()
          })

      }
      .position({
        y: '100%'
      })
      .height(70)
      .translate({
        y: -70
      })
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.white'))
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}