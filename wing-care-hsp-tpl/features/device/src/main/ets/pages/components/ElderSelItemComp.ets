import { ResManager } from '@hm/basic/Index'
import { OldItem } from '../ElderSelPage'

@Component
export struct ElderSelItemComp {
  @ObjectLink
  item: OldItem
  @Prop
  i: number

  toggle() {

  }

  build() {
    Row() {
      // 选择框
      Checkbox({ name: 'checkbox' + this.i, group: 'checkboxGroup' })
        .select(this.item.sel)
        .selectedColor(ResManager.EC_MAIN_COLOR)
        .width(12)
        .height(12)
        .margin({ right: 18 })
        .onClick(() => {
          this.toggle()
        })
      // 老人信息
      Column({ space: 14 }) {
        Row() {
          Text('李玉虎' + this.item.index)
            .fontColor(ResManager.EC_MID_BLACK)
            .fontSize(ResManager.EC_PAGE_TITLE_FS)
            .fontWeight(500)
          Text('230203197810101989')
            .fontColor(ResManager.EC_MID_59)
            .fontSize(13)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Text('101房间-1011床位')
          .fontColor(ResManager.EC_MID_59)
          .fontSize(13)

      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .borderRadius(ResManager.EC_NORMAL_RD)
      .backgroundColor(ResManager.EC_MID_WHITE)
      .padding({ left: 14, right: 14, top: 10, bottom: 16 })
      .onClick(() => {
        this.toggle()
      })
    }
  }
}