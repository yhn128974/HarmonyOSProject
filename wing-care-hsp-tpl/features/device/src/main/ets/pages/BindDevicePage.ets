import { EcDialogTips } from '@itheima/wing-care'
import router from '@ohos.router'
import { ResManager } from '@hm/basic/Index'
import { util } from '@kit.ArkTS'
import { Log } from '@abner/log'

export interface DeviceItem {
  iotId: string
  nodeId: string
  deviceName: string
  isSelected: boolean
}

export interface UnBindProductItem {
  productId: string
  productName: string
  // 是否展开：false 没有点击查看更多 | true 点击了查看更多
  isExpand: boolean
  deviceList: DeviceItem[]
}


@Entry
@Component
struct BindDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 1. 列表
  @State
  list: UnBindProductItem[] = []
  // 加载数据
  load = () => {
    // 请求数据
    setTimeout(() => {
      for (let index = 0; index < 3; index++) {
        if (index === 0) {
          this.list.push({
            productId: util.generateRandomUUID(true),
            productName: '智能血糖' + (this.list.length + 1),
            isExpand: false,
            deviceList: Array.from(Array(6))
              .map((it: null, i: number) => {
                let _dv: DeviceItem = {
                  iotId: util.generateRandomUUID(true),
                  nodeId: util.generateRandomUUID(true),
                  deviceName: 'blood' + (i + 1),
                  isSelected: false
                }
                return _dv
              })
          })
        } else {
          this.list.push({
            productId: util.generateRandomUUID(true),
            productName: '智能门禁' + (this.list.length + 1),
            isExpand: false,
            deviceList: Array.from(Array(10))
              .map((it: null, i: number) => {
                let _dv: DeviceItem = {
                  iotId: util.generateRandomUUID(true),
                  nodeId: util.generateRandomUUID(true),
                  deviceName: 'door' + (i + 1),
                  isSelected: false
                }
                return _dv
              })
          })
        }

      }
    }, 1000)
  }
  // 2. 产品选择和折叠
  // 加载更多和收起
  toggle(item: UnBindProductItem) {
  }

  // 选择某个产品下设备
  /**
   *
   * @param item 当前选择产品
   * @param device 当前点击产品下的某个设备
   */
  selectDevice(item: UnBindProductItem, device: DeviceItem) {
  }

  @Builder
  productItem(item: UnBindProductItem) {
    Column({ space: 18 }) {
      // 1. 产品分类
      Row() {
        Text(item.productName)
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
            }
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
            .width(312)
            .backgroundColor(ResManager.EC_MAIN_COLOR)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/device/NearDevicePage'
              })
            })
            .enabled(true ? true : false)
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