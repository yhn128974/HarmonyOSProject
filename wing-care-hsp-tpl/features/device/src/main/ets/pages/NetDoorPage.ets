import { EcDialogTips } from '@itheima/wing-care'
import { ResManager } from '@hm/basic/Index'

@Entry
@Component
struct NetDoorPage {
  @StorageProp('topHeight')
  topHeight: number = 0

  // 1. 未闪烁说明
  @Builder
  tipsContent() {
    Column() {
      Image($r("app.media.pic_shebei_mj"))
        .width(120)
        .aspectRatio(1)
      Column({ space: 5 }) {
        Text('指示灯未闪烁怎么办？')
          .margin({ bottom: 10 })
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
        Text('1、请检查智能门禁电源是否正常')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
        Text('2、请确认管理员密码与无线网指令是否正确')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
        Text('3、若需要检修或更换智能门禁的指示灯，请联系客服000-000-00000')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
      }
      .width('100%')
      .padding({ left: 14, bottom: 12, right: 14 })
      .alignItems(HorizontalAlign.Start)
    }
  }

  notFoundDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips({
      title: '未看到指示灯闪烁',
      titleAlign: 'center',
      // 解决 this 指向问题
      tipsContent: () => {
        this.tipsContent()
      },
      cancelButton: {
        text: '我知道了',
        color: ResManager.EC_MAIN_COLOR,
        // cb:()=>{
        //
        // }
      }
    }),
    alignment: DialogAlignment.Bottom
  })

  // 2. 配置 wifi
  @Builder
  wifiContent() {
    Column() {
      Row({ space: 8.5 }) {
        Image(ResManager.IC_MJPW_WIFI)
          .width(34)
          .aspectRatio(1)
        Column({ space: 2 }) {
          Text('WIFI')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_CARD_FS)
          Text('请确认手机已开启WIFI功能')
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

  wifiDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips({
      title: '请开启以下权限',
      // 解决 this 指向问题
      tipsContent: () => {
        this.wifiContent()
      },
      // confirmButton: {
      //   text: '去设置',
      //   // color:ResManager.EC_MAIN_COLOR,
      //   cb: () => {
      //
      //   }
      // },
      cancelButton: {
        text: '我知道了',
        color: ResManager.EC_MAIN_COLOR
        // cb:()=>{
        //
        // }
      }
    }),
    alignment: DialogAlignment.Center
  })

  aboutToAppear() {
    // this.notFoundDialog.open()
    this.wifiDialog.open()
  }

  build() {
    Navigation() {
      Column() {
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            Image($r("app.media.pic_shebei_mj"))
              .width(180)
              .height(200)
            Column() {
              Text('1、请在门禁设备上输入管理员密码')
                .fontColor('#50A0D8')
                .fontSize(ResManager.EC_NORMAL_FS)
              Text('2、输入“无线网配置指令”开启无线配网模式')
                .fontColor('#50A0D8')
                .fontSize(ResManager.EC_NORMAL_FS)
              Text('3、指示灯闪烁后点击下一步')
                .fontColor('#50A0D8')
                .fontSize(ResManager.EC_NORMAL_FS)
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 40, left: 30, right: 30 })
            .padding(15)
            .backgroundColor('#E9F6FF')
            .borderRadius(5)
          }
          .padding({ top: 40 })
          .width('100%')
          .height('100%')

          Column() {
            Row() {
              Checkbox()
                .select(true)
                .selectedColor(ResManager.EC_MAIN_COLOR)
              Text('指示灯闪烁')
                .fontColor(ResManager.EC_MID_19)
                .fontSize(18)
                .fontWeight(500)
            }
            .margin({ bottom: 16 })

            Button('下一步')
              .width(230)
              .margin({ bottom: 25 })
              .backgroundColor(ResManager.EC_MAIN_COLOR)

            Text('未看到指示灯闪烁')
              .fontColor(ResManager.EC_MAIN_COLOR)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
              .margin({ bottom: 72 })
              .onClick(() => this.notFoundDialog.open())
          }
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff')
    }
    .title('门禁配网')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}