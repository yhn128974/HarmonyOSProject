import { HMCard, HMCard_item } from 'basic'

@Entry
@Component
export default struct My_index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      // 基本信息
      Column() {
        Image($r("app.media.ic_avatar_driver"))
          .width(67)
          .height(67)
          .borderRadius(34.5)
          .backgroundColor($r('app.color.white'))
        Text("司机")
          .fontSize(18)
          .fontWeight(600)
          .lineHeight(25)
          .margin({
            top: 9,
            bottom: 9
          })
          .fontColor($r('app.color.white'))
        Text(`司机编号: 66666666`).fontSize(14).fontWeight(400).lineHeight(20).fontColor($r('app.color.white'))
        Text(`手机号: 66666666`)
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .margin({
            top: 10
          })
          .fontColor($r('app.color.white'))
      }
      .backgroundImage($r("app.media.bg_page_my"))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height(292)
      .margin({
        top: -2
      })

      // 本月任务
      Column() {
        Text("- 本月任务 -").fontSize(14).fontColor($r('app.color.text_secondary')).lineHeight(20)
        Row() {
          Column() {
            Text("1000").fontSize(18).fontColor($r('app.color.text_primary')).lineHeight(25).margin({
              bottom: 17
            })
            Text("任务总量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

          Column() {
            Text("1000")
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("完成任务量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

          Column() {
            Text("1000")
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("运输里程(km)").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)
        }.justifyContent(FlexAlign.SpaceBetween).width('100%').layoutWeight(1)
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(8)
      .margin({ left: 14.5, right: 14.5, top: -55, bottom: 15 })
      .height(134)
      .padding({ top: 13.5, bottom: 13.5 })
      .justifyContent(FlexAlign.SpaceBetween)

      // 信息列表
      HMCard() {
        Column() {
          HMCard_item({
            leftTitle: "车辆信息",
            rightTitle: "",
            showRightIcon: true,
            showBottomBorder: true,
            handleRightClick: () => {
            }
          })
          HMCard_item({
            leftTitle: "任务数据",
            rightTitle: "",
            showRightIcon: true,
            showBottomBorder: true,
            handleRightClick: () => {
            }
          })
          HMCard_item({
            leftTitle: "系统设置",
            rightTitle: "",
            showRightIcon: true,
            showBottomBorder: false,
            handleRightClick: () => {
            }
          })

        }
      }

    }.width('100%').height('100%').backgroundColor($r('app.color.background_page')).borderRadius(8)
  }
}