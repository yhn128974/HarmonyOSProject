import { TaskInfoItemModel, TaskTypeEnum, TaskInfoItem } from '../../models'
import { promptAction, router } from '@kit.ArkUI'
import { JSON } from '@kit.ArkTS'

@Preview
@Component
export struct TaskItemCard {
  @Prop item: TaskInfoItemModel = new TaskInfoItemModel({} as TaskInfoItem)

  // 去详细页面提货
  toPickUp() {

    if (this.getBtnEnable()) {
      router.pushUrl({
        url: 'pages/Task/Task_list/TaskDetail',
        params: {
          id: this.item.id
        }
      })
    }
  }

  getBtnText() {
    let res: string = Number(this.item.status).toString()
    switch (res) {
      case TaskTypeEnum.Waiting.toString(): {
        return "提货"
      }
      case TaskTypeEnum.Line.toString(): {
        return "交货"
      }
      case TaskTypeEnum.Delivered.toString(): {
        return "回车登记"
      }
      default:
        return res
    }
  }

  getBtnEnable() {
    if (this.item.enablePickUp) {
      return true
    }
    let res: string = Number(this.item.status).toString()
    switch (res) {
      case TaskTypeEnum.Line.toString(): {
        return true
      }
      case TaskTypeEnum.Delivered.toString(): {
        return true
      }
      default:
        return false
    }

  }

  build() {
    Column() {


      Row() {
        Text(`任务编号：${this.item.id}`)
          .fontSize(16)
          .fontColor($r("app.color.text_primary"))
          .fontWeight(500)
          .lineHeight(22)
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')

      Row() {
        Text("起")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r("app.color.text_primary"))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(`${this.item.startAddress}`)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 21 }).width('100%')

      Row() {
        Text("止")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r('app.color.primary'))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(`${this.item.endAddress}`)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 14.5 }).width('100%')

      Divider()
        .vertical(true)
        .height(2)
        .color($r('app.color.background_divider'))
        .opacity(0.6)
        .margin({ left: 8, right: 8, top: 21 })
      Row() {
        Column() {
          Text('提货时间').fontSize(14).fontColor($r('app.color.text_secondary'))
          Text(this.item.planDepartureTime).fontSize(14).fontColor($r('app.color.text_secondary')).margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)

        Button(this.getBtnText(), { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .fontColor($r("app.color.white"))
          .fontSize(14)
          .height(32)
          .enabled(this.getBtnEnable())
          .onClick(() => {
            this.toPickUp()
          })

      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
    }
    .margin({ left: 15, right: 15, top: 15 })
    .padding({ left: 19.5, right: 19.5, bottom: 18.5, top: 18.5 })
    .borderRadius(10)
    .backgroundColor($r('app.color.white'))

  }
}

