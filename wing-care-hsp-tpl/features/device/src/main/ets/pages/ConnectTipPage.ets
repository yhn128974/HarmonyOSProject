import { EcDeviceTip } from '@itheima/wing-care';
import router from '@ohos.router';
import { ResManager } from '@hm/basic/Index';

@Entry
@Component
struct ConnectTipPage {
  // 1 成功 ｜ 2 失败
  @State
  tips: 1 | 2 = 1

  aboutToAppear() {
    const params: object = router.getParams()
    if (params && params['tips']) {
      this.tips = params['tips']
    }
  }

  build() {
    Column() {
      if (this.tips === 1) {
        EcDeviceTip({
          type: 'success',
          message: '配网成功',
          btnText: '去查看',
          url: 'pages/device/MyDevicePage'
        })
      } else {
        EcDeviceTip({
          type: 'fail',
          message: '配网失败',
          btnText: '重新配置',
          url: 'pages/device/ConnectNetPage'
        })
        Column({ space: 5 }) {
          Text('配网失败怎么办？')
            .fontColor('#50A0D8')
            .fontSize(ResManager.EC_NORMAL_FS)
            .fontWeight(700)
            .margin({ bottom: 3.5 })
          Text('1、请确认网络连接是否正常')
            .fontColor('#50A0D8')
            .fontSize(ResManager.EC_NORMAL_FS)
          Text('2、请检查IP地址是否有效')
            .fontColor('#50A0D8')
            .fontSize(ResManager.EC_NORMAL_FS)
          Text('3、请检查智能门禁电源是否正常')
            .fontColor('#50A0D8')
            .fontSize(ResManager.EC_NORMAL_FS)
        }
        .width('83%')
        .alignItems(HorizontalAlign.Start)
        .margin({ top: 40, left: 30, right: 30 })
        .padding(20)
        .backgroundColor('#E9F6FF')
        .borderRadius(5)
      }
    }
  }
}