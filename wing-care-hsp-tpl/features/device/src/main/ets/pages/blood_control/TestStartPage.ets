/**
 * 测血糖开始
 */
import { EcLoading, EcDialogTips } from '@itheima/wing-care'
import { ResManager } from '@hm/basic/Index'

@Entry
@Component
struct TestStartPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 测血糖状态：0-请插入试纸，启动设备 ｜ 1-轻刺指尖，取一滴血滴在试纸上
  @State
  status: 0 | 1 = 0
  // 全屏 loading 弹层
  @State
  tip: string = '连接中...'
  @State
  // icon: ResourceStr = $r('app.media.ic_ok')
  icon: ResourceStr = $r('app.media.ic_loading')
  @State
  animate: boolean = true
  loading: CustomDialogController = new CustomDialogController({
    builder: EcLoading({
      tip: this.tip,
      icon: this.icon,
      wd: 60,
      ht: 60,
      animate: this.animate
    }),
    customStyle: true,
    // autoCancel: false,
    alignment: DialogAlignment.Center
    // isModal: false
  })

  aboutToAppear(): void {
    this.blueDialog.open()
  }

  // 无法连接提示
  @Builder
  tipsContent() {
    Column() {
      Row({ space: 8.5 }) {
        Image($r('app.media.ic_xtlj'))
          .width(34)
          .aspectRatio(1)
        Column({ space: 2 }) {
          // Text('蓝牙')
          //   .fontColor(ResManager.EC_MID_19)
          //   .fontSize(ResManager.EC_CARD_FS)
          Text('检查试纸是否完全插入')
            .fontColor(ResManager.EC_MID_99)
            .fontSize(ResManager.EC_CARD_FS)
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 13, right: 13 })
      .height(60)
      .borderRadius(30)
      .backgroundColor('#E8E7EA')
    }
    .width('100%')
    .padding({ left: 15, right: 15 })

  }

  blueDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips({
      title: '无法连接到血糖仪',
      tipsContent: () => {
        this.tipsContent()
      },
      cancelButton: {
        text: '取消',
        color: ResManager.EC_MID_59,
        cb: () => {
          this.blueDialog.close()
        }
      },
      confirmButton: {
        text: '重新连接',
        color: ResManager.EC_MAIN_COLOR,
        cb: () => {

          this.blueDialog.close()
        }
      }
    }),
    alignment: DialogAlignment.Center
  })

  connect() {
    this.tip = '测量中...'
    this.animate = true
    this.loading.open()
  }

  @Builder
  step(index: string) {
    Column() {
      Text(index)
        .fontSize(23)
        .fontWeight(500)
        .fontColor('#fff')
    }
    .justifyContent(FlexAlign.Center)
    .width(36)
    .aspectRatio(1)
    .borderRadius(36)
    .backgroundColor(ResManager.EC_MAIN_COLOR)
  }

  build() {
    Navigation() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          Image(this.status === 0 ? $r('app.media.gf_cr') : $r('app.media.gf_cs'))
            .width(310)
            .height(340)
            .margin({ top: 64 })
        }
        .width('100%')
        .height('100%')


        // 提示
        Column() {
          // 步骤
          Row() {
            this.step('1')
            Stack({ alignContent: Alignment.TopStart }) {
              Row() {

              }
              .width(70)
              .height(1)
              .border({ width: 2, color: ResManager.EC_MID_LINE })

              Row() {

              }
              .width(this.status === 0 ? 35 : 70)
              .height(1)
              .border({ width: 2, color: ResManager.EC_MAIN_COLOR })
            }
            .margin({ left: 10, right: 10 })


            this.step('2')

          }
          .margin({ top: 55 })

          // 说明
          Text(this.status === 0 ? '请插入试纸，启动设备' : '轻刺指尖，取一滴血滴在试纸上')
            .fontSize(18)
            .fontWeight(500)
            .fontColor(ResManager.EC_MID_19)
            .margin({ top: 30, bottom: 26 })
            .onClick(() => this.connect())
        }
        .width('100%')
        .height(256)
        .backgroundColor('#fff')
      }
      .width('100%')
      .height('100%')
      .linearGradient({
        angle: 137,
        colors: [['#F6F9FE', 0], ['#EFF5FE', 0.25], ['#F4F3F8', 1]]
      })
    }
    .title('测血糖')
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
    .titleMode(NavigationTitleMode.Mini)
  }
}