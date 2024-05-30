import router from '@ohos.router'
import { getDeviceMap, ResManager, ecBlue } from '@hm/basic/Index'
import { getUnbindDeviceListApi } from '../api'
import { DeviceItem, UnBindProductItem } from '../model'


@Entry
@Component
export struct BindDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 1. 列表
  @State
  list: UnBindProductItem[] = []
  @State flag: number = 0
  @State
  selectedProd: UnBindProductItem | null = null
  selectedDevice: DeviceItem | null = null
  // 加载数据
  load = async () => {
    // 请求数据
    const data = await getUnbindDeviceListApi()
    data.forEach(item => {
      // 产品是否展开：false 没有点击查看更多 | true 点击了查看更多
      item.isExpand = false
      item.deviceList?.forEach((device: DeviceItem) => {
        // 当前产品下设备选中状态
        device.isSelected = false
      })
    })
    this.list = data

  }

  // 2. 产品选择和折叠
  // 加载更多和收起
  toggle(item: UnBindProductItem) {
    this.list = this.list.map((prod: UnBindProductItem) => {
      if (item.productId === prod.productId) {
        //   控制当前点击的产品的折叠按钮
        return {
          isExpand: !prod.isExpand,
          deviceList: prod.deviceList,
          productId: prod.productId,
          productName: prod.productName
        }
      } else {
        return prod
      }
    })
  }

  // 选择某个产品下设备
  /**
   *
   * @param item 当前选择产品
   * @param device 当前点击产品下的某个设备
   */
  selectDevice(item: UnBindProductItem, device: DeviceItem) {
    //   1.取消之前的选中
    this.list.forEach((prod) => {
      prod.deviceList.forEach((dev) => {
        if (dev.isSelected) {
          dev.isSelected = false
        }
      })
    })
    // 2.把当前的选中
    device.isSelected = !device.isSelected
    this.selectedProd = item
    this.selectedDevice = device
    this.flag = Date.now()

  }

  @Builder
  productItem(item: UnBindProductItem) {
    Column({ space: 18 }) {
      // 1. 产品分类
      Row() {
        Text(getDeviceMap(0, item.productName)?.cn)
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
        // 点击查看更多后显示
        if (item.isExpand) {
          Text() {
            Span('收起')
            ImageSpan($r('app.media.ic_arrow_up'))
              .width(12.8)
              .height(5.6)
              .verticalAlign(ImageSpanAlignment.CENTER)
              .margin({ bottom: 2 })
          }
          .fontColor(ResManager.EC_MAIN_COLOR)
          .fontSize(ResManager.EC_SMALL_FS)
          .onClick(() => {
            this.toggle(item)
          })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      //  2. 设备列表
      GridRow({ columns: 2, gutter: 10 }) {
        // 数据超出 6 同时没有点击查看更多
        if (item.deviceList?.length! > 6 && !item.isExpand) {
          ForEach(item.deviceList?.slice(0, 6), (device: DeviceItem, i: number) => {
            GridCol() {
              // Column() {
              if (i < 5) {
                Column() {
                  // 选择设备
                  Text(device.deviceName)
                    .fontColor(device.isSelected ? '#fff' : ResManager.EC_MID_19)
                    .fontSize(ResManager.EC_SMALL_FS)
                }
                .width('100%')
                .padding({
                  left: 15,
                  right: 15,
                  top: 10,
                  bottom: 10
                })
                .borderRadius(ResManager.EC_NORMAL_RD)
                .backgroundColor(device.isSelected && i < 5 ? ResManager.EC_MAIN_COLOR : '#fff')
                .onClick(() => {
                  this.selectDevice(item, device)
                })
              } else {
                Column() {
                  // 数据超出 6条 显示
                  Text() {
                    Span('查看更多')
                    ImageSpan($r('app.media.ic_arrow_down'))
                      .width(12.8)
                      .height(5.6)
                      .verticalAlign(ImageSpanAlignment.CENTER)
                      .margin({ bottom: 2 })
                  }
                  .fontColor(ResManager.EC_MAIN_COLOR)
                  .fontSize(ResManager.EC_SMALL_FS)
                }
                .width('100%')
                .padding({
                  left: 15,
                  right: 15,
                  top: 10,
                  bottom: 10
                })
                .borderRadius(ResManager.EC_NORMAL_RD)
                .backgroundColor(device.isSelected && i < 5 ? ResManager.EC_MAIN_COLOR : '#fff')
                .onClick(() => {
                  this.toggle(item)
                })
              }
            }
          }
          )
        } else {
          ForEach(item.deviceList, (device: DeviceItem) => {
            GridCol() {
              Column() {
                Text(device.deviceName)
                  .fontColor(device.isSelected ? '#fff' : ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_SMALL_FS)
              }
              .width('100%')
              .padding({
                left: 15,
                right: 15,
                top: 10,
                bottom: 10
              })
              .borderRadius(ResManager.EC_NORMAL_RD)
              .backgroundColor(device.isSelected ? ResManager.EC_MAIN_COLOR : '#fff')
              .onClick(() => {
                this.selectDevice(item, device)
              })
            }
          }
          )
        }

      }

    }
    .width('100%')

  }

  aboutToAppear() {
    this.load()
  }

  checkBlueAccess() {
    ecBlue.checkBluePermission()
  }

  build() {
    Navigation() {
      Stack({ alignContent: Alignment.Bottom }) {
        // 产品列表
        Column() {
          List({
            space: 10
          }) {
            ForEach(this.list, (item: UnBindProductItem) => {
              ListItem() {
                this.productItem(item)
              }
            }, (item: UnBindProductItem) => this.flag + JSON.stringify(item)
            )
          }
          .width('100%')
          .height('100%')
          .scrollBar(BarState.Off)
        }
        .margin({ top: 18 })
        .padding({ bottom: 72, left: 15, right: 15 })

        // 确认选择
        Column() {
          Button('确认')
            .enabled(!!this.selectedProd)
            .width(312)
            .backgroundColor(ResManager.EC_MAIN_COLOR)
            .onClick(() => {
              this.checkBlueAccess()
              // router.pushUrl({
              //   url: 'pages/device/NearDevicePage'
              // })
            })

        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height(72)
        .backgroundColor('#fff')
        .shadow({
          offsetX: 0,
          offsetY: -2,
          radius: 60,
          color: '#0F000000'
        })

      }
    }
    .title('设备绑定')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}