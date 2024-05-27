import { EcDeviceTip } from '@itheima/wing-care';
import { ResManager } from '@hm/basic/Index';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct BindTipPage {
  // 1 成功 | 2 失败
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
          message: '绑定成功',
          btnText: '去查看',
          closeUrl: '',
          url: 'pages/device/MyDevicePage'
        })
      } else {
        EcDeviceTip({ type: 'fail', message: '绑定失败', btnText: '重新绑定' })
        Column({ space: 5 }) {
          Text('绑定失败怎么办？')
            .fontColor('#50A0D8')
            .fontSize(ResManager.EC_NORMAL_FS)
            .fontWeight(700)
            .margin({ bottom: 3.5 })
          Text('1、请检查手机蓝牙是否已开启')
            .fontColor('#50A0D8')
            .fontSize(ResManager.EC_NORMAL_FS)
          Text('2、请检查设备是否正常工作')
            .fontColor('#50A0D8')
            .fontSize(ResManager.EC_NORMAL_FS)
          Text('3、请检查设备是否在手机附近')
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