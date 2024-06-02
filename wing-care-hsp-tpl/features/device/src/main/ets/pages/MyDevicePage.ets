import { Device, DeviceCate } from '../viewmodel/DeviceModel'
import router from '@ohos.router'
import { getDeviceMap, ProductNameMap, ResManager, RouterConfig } from '@hm/basic/Index'
import { DeviceItem, UnBindProductItem } from '../model'
import { getMyDeviceListApi, unbindDeviceApi } from '../api'
import { promptAction } from '@kit.ArkUI'
import { EcNotFound } from '@itheima/wing-care'
import { deviceParamsStore } from '../utils'

// 设备选择
@Entry
@Component
struct MyDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  scroller: Scroller = new Scroller()
  @State
  devices: UnBindProductItem[] = []

  async getMyDevices() {
    const data = await getMyDeviceListApi()
    this.devices = data
  }

  aboutToAppear(): void {
    this.getMyDevices()
  }

  // 解绑
  async unbind(item: DeviceItem) {
    AlertDialog.show({
      title: '解除确认',
      message: '确认要解除该设备吗？',
      primaryButton: {
        value: '取消',
        fontColor: ResManager.EC_MID_59,
        action: () => {

        }
      },
      secondaryButton: {
        value: '确定',
        fontColor: ResManager.EC_MAIN_COLOR,
        action: async () => {
          await unbindDeviceApi(item.iotId)
          this.getMyDevices()
          promptAction.showToast({ message: '解绑成功' })
        }
      },
      alignment: DialogAlignment.Center
    })
  }

  // 3. 处理设备控制跳转
  handlerControlPage = (selectedProd: UnBindProductItem, iotId: string, nodeId: string) => {
    //
    deviceParamsStore.setParams(iotId, nodeId)
    if (selectedProd.productName === ProductNameMap.Access_control) {
      router.pushUrl({
        url: RouterConfig.DEVICE_DOOR_CONTROL_URL
      })
    } else if (selectedProd.productName === ProductNameMap.Blood_glucose_meter) {
      router.pushUrl({
        url: RouterConfig.DEVICE_ELDER_SEL_URL
      })
    } else {
      AlertDialog.show({
        message: '暂不支持的设备类型！'
      })
    }
  }

  build() {
    // 导航栏
    Navigation() {
      Column() {
        // 设备列表
        Scroll(this.scroller) {
          if (this.devices.length > 0) {
            Column({ space: 20 }) {
              ForEach(this.devices, (prod: UnBindProductItem) => {
                Column() {
                  // 标题
                  Text(getDeviceMap(0, prod.productName)?.cn)
                    .fontColor(ResManager.EC_MID_19)
                    .fontSize(ResManager.EC_MODULE_TITLE_FS)
                    .fontWeight(500)
                    .margin({ bottom: 18 })
                  // 内容
                  GridRow({ columns: 2, gutter: { x: 10, y: 10 } }) {
                    ForEach(prod.deviceList, (item: DeviceItem, i: number) => {
                      GridCol() {
                        Stack({ alignContent: Alignment.TopEnd }) {
                          Column({ space: 10 }) {
                            Image(getDeviceMap(0, prod.productName)?.icon)
                              .width(80)
                              .aspectRatio(1)
                            Text(item.deviceName)
                              .fontColor(ResManager.EC_MID_19)
                              .fontSize(ResManager.EC_SMALL_FS)
                          }
                          .width('100%')
                          .padding({ top: 30, bottom: 20 })
                          .borderRadius(8)
                          .backgroundColor(ResManager.EC_MID_WHITE)
                          .onClick(() => {
                            this.handlerControlPage(prod, item.iotId!, item.nodeId!)
                          })

                          Text('解绑')
                            .fontColor(ResManager.EC_MAIN_COLOR)
                            .fontSize(ResManager.EC_SMALL_FS)
                            .margin({ top: 10, right: 10 })
                            .onClick(() => {
                              this.unbind(item)
                            })

                        }
                      }
                      .onClick(() => {

                      })
                    })
                  }
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
              })
            }
            .width('100%')
          } else {
            EcNotFound({ tip: '暂无设备记录～' })
          }
        }
        .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
        .scrollBar(BarState.Off) // 滚动条常驻显示
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
      .padding(15)

    }
    .title('我的设备')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}

