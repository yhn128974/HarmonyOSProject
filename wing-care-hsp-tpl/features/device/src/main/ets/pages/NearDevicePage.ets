import { EcDialogTips } from '@itheima/wing-care'
import { ResManager, RouterConfig } from '@hm/basic/Index'
import { deviceParamsStore, EcBlueDevice } from '../utils'
import { ble } from '@kit.ConnectivityKit'
import { Log } from '@abner/log'
import { promptAction, router } from '@kit.ArkUI'
import { bindDeviceApi } from '../api'

@Entry
@Component
struct NearDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 1. 搜索动画
  // 旋转角度
  @State angle: number = 0
  step: number = 5
  timer: number = -1
  // 2. 搜索状态：true 搜索中 | false 结束搜索
  @State
  isSearch: boolean = true
  // true 发现设备 ｜false没有发现设备
  @State
  hasDevice: boolean = false
  @State list: ble.ScanResult[] = []
  notFoundDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips({
      title: '未查找到设备',
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
  // 定义一个连接状态
  @State isConnect: boolean = false;

  aboutToAppear(): void {

    try {
      // 模拟器不能扫描蓝牙
      this.search()

    } catch (error) {
      Log.info(error)
    }
  }

  connect(id: string) {
    this.isConnect = true
    // 链接开门设备
    // EcBlueDevice.connectDoorDevice(id, async () => {
    //   promptAction.showToast({
    //     message: '连接成功'
    //   })
    //   try {
    //     // 1. 连接成功绑定设备api
    //     await bindDeviceApi(deviceParamsStore.getParams().iotId!)
    //
    //     // 2. 跳转提示页面
    //     router.pushUrl({
    //       url: RouterConfig.DEVICE_BIND_TIP_URL,
    //       params: {
    //         tips: 1
    //       }
    //     })
    //
    //   } catch (e) {
    //     router.pushUrl({
    //       url: RouterConfig.DEVICE_BIND_TIP_URL,
    //       params: {
    //         tips: 2
    //       }
    //     })
    //   }
    // })

    //   假设成功
    router.pushUrl({
      url: RouterConfig.DEVICE_BIND_TIP_URL,
      params: {
        tips: 1
      }
    })
  }

  run() {
    this.timer = setInterval(() => {
      this.angle += this.step
      // 每秒 60 桢
    }, 1000 / 60)
  }

  stop() {
    clearInterval(this.timer)
  }

  // 3. 搜索方法
  search() {
    this.run()
    this.list = []
    // 开始扫描
    // EcBlueDevice.scanDevice({ type: "mac", value: '10-8A-9B-8F-EC-3C' }, (list: ble.ScanResult[]) => {
    //   this.isSearch = false
    //   this.stop()
    //
    //   if (list.length > 0) {
    //     this.hasDevice = true
    //     this.list = list
    //
    //   } else {
    //     this.hasDevice = false
    //   }
    // })

    // 模拟数据
    setTimeout(() => {
      this.isSearch = false
      this.stop()
      this.hasDevice = true
      this.list = [
        {
          deviceId: "10-8A-9B-8F-EC-3C",
          rssi: 1,
          data: new ArrayBuffer(45),
          deviceName: "门禁73-EC",
          connectable: true
        }
      ]
    }, 1000)


  }

  // 重新搜索
  reset() {
    this.isSearch = true
    this.hasDevice = false
    this.search()
  }

  // 4. 未找到说明
  @Builder
  tipsContent() {
    Column() {
      Image($r("app.media.pic_shebei_mj"))
        .width(120)
        .aspectRatio(1)
      Column({ space: 5 }) {
        Text('未查找到设备怎么办？')
          .margin({ bottom: 10 })
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
        Text('1、请检查智能门禁电源是否正常')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
        Text('2、请检查手机蓝牙是否已开启')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
        Text('3、其他问题请联系客服 000-000-00000')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
      }
      .width('100%')
      .padding({ left: 14, bottom: 12, right: 14 })
      .alignItems(HorizontalAlign.Start)
    }
  }

  build() {
    Navigation() {
      if (!this.hasDevice) {
        Stack({ alignContent: Alignment.Bottom }) {
          // 搜索中：无设备
          Column() {
            Image(ResManager.IC_FJSB_SS)
              .width(180)
              .aspectRatio(1)
              .rotate({ angle: this.angle })
              .animation({ duration: 200, curve: Curve.LinearOutSlowIn })

            if (this.isSearch) {
              Text('正在查找附近可连接设备')
                .margin({ top: 36 })
                .fontSize(18)
                .fontColor(ResManager.EC_MID_19)
                .fontWeight(600)
            } else {
              Text('暂未发现设备')
                .margin({ top: 36 })
                .fontSize(18)
                .fontColor(ResManager.EC_MID_19)
                .fontWeight(600)
              Text('建议您拔掉设备电源，重新连接电源后再重新扫描')
                .fontSize(ResManager.EC_NORMAL_FS)
                .fontColor(ResManager.EC_MID_99)
                .margin({ top: 20 })
                .padding({ left: 60, right: 60 })
              Button('重新查找')
                .margin({ top: 50 })
                .width(230)
                .onClick(() => this.reset())

            }
          }
          .padding({ top: 80 })
          .width('100%')
          .height('100%')

          Text('未找到设备')
            .fontColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .margin({ bottom: 72 })
            .onClick(() => this.notFoundDialog.open())

        }
        .width('100%')
        .height('100%')
        .backgroundColor('#fff')
      }
      else {
        Column() {
          // 标题
          Row() {
            Text('未连接设备')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
            LoadingProgress()
              .margin({ left: 10 })
              .width(20)
              .height(20)
              .color(ResManager.EC_MID_99)
          }
          .width('100%')
          .margin({ top: 18, bottom: 18 })

          // 设备列表
          List({ space: 10 }) {
            ForEach(this.list, (item: ble.ScanResult, i: number) => {
              ListItem() {
                Row() {
                  Column({ space: 5 }) {
                    Text(item.deviceName)
                      .fontColor(ResManager.EC_MID_19)
                      .fontSize(ResManager.EC_NORMAL_FS)
                    Text(item.deviceId)
                      .fontColor(ResManager.EC_MID_99)
                      .fontSize(ResManager.EC_SMALL_FS)
                  }
                  .alignItems(HorizontalAlign.Start)

                  if (!this.isConnect) {
                    Image($r('app.media.ic_sbbd_ly'))
                      .width(24)
                      .aspectRatio(1)
                      .onClick(() => {
                        try {
                          this.connect(item.deviceId)
                        } catch (e) {
                          promptAction.showToast({
                            message: JSON.stringify(e.message)
                          })
                        }

                      })
                  } else {
                    LoadingProgress()
                      .margin({ left: 10 })
                      .width(20)
                      .aspectRatio(1)
                      .color(ResManager.EC_MID_99)
                  }
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .padding({
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8
                })
                .borderRadius(ResManager.EC_NORMAL_RD)
                .backgroundColor('#fff')
              }
            })
          }
          .layoutWeight(1)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .padding({ left: 15, right: 15 })
        .height('100%')
        .backgroundColor(this.hasDevice ? ResManager.EC_MID_BG : '#fff')
      }
    }
    .title('附近设备')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}