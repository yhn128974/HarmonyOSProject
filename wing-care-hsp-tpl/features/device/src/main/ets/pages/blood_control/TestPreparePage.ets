/**
 * 测血糖准备
 */
import { BloodTimeItem, BloodTimeList, ResManager } from '@hm/basic/Index'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct TestPreparePage {
  // 血糖测试时段
  @State bloodTime: BloodTimeItem[] = BloodTimeList

  selectTime(time: BloodTimeItem) {
    this.bloodTime = this.bloodTime.map(item => {
      if (item.label === time.label) {
        // item.isSelected = !item.isSelected
        item.isSelected = true
        // 存储选中...

        return item
      } else {
        item.isSelected = false
        return item
      }
    })
  }

  goTest() {
    router.pushUrl({
      url: 'pages/device/blood_control/TestStartPage'
    })
  }

  build() {
    Navigation() {
      Column() {
        // 1. 测血糖按钮
        Column() {
          Image($r('app.media.ic_xtcs'))
            .width(50)
            .aspectRatio(1)
          Text('测血糖')
            .fontColor('#fff')
            .fontSize(23)
            .fontWeight(500)
        }
        .width(156)
        .aspectRatio(1)
        .justifyContent(FlexAlign.Center)
        .borderRadius(78)
        .linearGradient({
          angle: 180,
          // 按下之后变色
          colors: [['#07E4DA', 0], ['#03C4B3', 1]]
        })
        .margin({ top: 88 })
        .onClick(() => {
          this.goTest()
        })


        // 2. 选择测试时间
        GridRow({ columns: 3, gutter: 18 }) {
          ForEach(this.bloodTime, (time: BloodTimeItem) => {
            GridCol() {
              Column() {
                Text(time.label)
                  .fontColor(time.isSelected ? '#fff' : ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_SMALL_FS)
                  .fontWeight(500)
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .height(28)
              .padding({ left: 15, right: 15 })
              .borderRadius(28)
              .backgroundColor(time.isSelected ? ResManager.EC_MAIN_COLOR : '#F3F3F3')
              .onClick(() => {
                this.selectTime(time)
              })
            }
          })
        }
        .margin({ top: 50, left: 50, right: 50 })

      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff')
    }
    .title('测血糖')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor(ResManager.EC_MID_BG)
  }
}