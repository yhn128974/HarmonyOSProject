import { ResManager } from '@hm/basic/Index'
import { Device, DeviceCate } from '../viewmodel/DeviceModel'
// 设备选择
@Entry
@Component
struct SelDevicePage {
  scroller: Scroller = new Scroller()
  private devices: DeviceCate[] = [
    {
      title:'报警器',
      list:[
        {
          name:'拉绳呼叫器',
          icon:'/images/img_xzsb_lshjq.png'
        },
        {
          name:'SOS按钮',
          icon:'/images/img_xzsb_sosbtn.png'
        },
        {
          name:'烟雾报警器',
          icon:'/images/img_xzsb_ywbjq.png'
        }
      ]
    },
    {
      title:'传感器',
      list:[
        {
          name:'多功能传感器',
          icon:'/images/img_xzsb_dgncgq.png'
        },
        {
          name:'门磁感应器',
          icon:'/images/img_xzsb_mcgyq.png'
        },
        {
          name:'监控设备',
          icon:'/images/img_xzsb_sbjk.png'
        }
      ]
    },
    {
      title:'健康监测',
      list:[
        {
          name:'睡眠检测带',
          icon:'/images/img_xzsb_smjcd.png'
        },
        {
          name:'血糖仪',
          icon:'/images/img_xzsb_xty.png'
        },
        {
          name:'智能手表',
          icon:'/images/img_xzsb_znsb.png'
        }
      ]
    },
    {
      title:'健康监测',
      list:[
        {
          name:'睡眠检测带',
          icon:'/images/img_xzsb_smjcd.png'
        },
        {
          name:'血糖仪',
          icon:'/images/img_xzsb_xty.png'
        },
        {
          name:'智能手表',
          icon:'/images/img_xzsb_znsb.png'
        }
      ]
    },
    {
      title:'健康监测',
      list:[
        {
          name:'睡眠检测带',
          icon:'/images/img_xzsb_smjcd.png'
        },
        {
          name:'血糖仪',
          icon:'/images/img_xzsb_xty.png'
        },
        {
          name:'智能手表',
          icon:'/images/img_xzsb_znsb.png'
        }
      ]
    },
    {
      title:'',
      list:[]
    }
  ]

  // 设备列表项
  @Builder
  deviceItem(title: string, list: Device[]) {
    Column() {
      // 标题
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_MODULE_TITLE_FS)
        .fontWeight(500)
        .margin({ bottom: 18 })
      // 内容
      Row({ space: 10 }) {
        ForEach(list, (item: Device) => {
          Column({ space: 10 }) {
            Image(item.icon)
              .width(50)
              .aspectRatio(1)
            Text(item.name)
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_SMALL_FS)
          }
          .padding({ top: 13, bottom: 20 })
          .borderRadius(8)
          .layoutWeight(1)
          .backgroundColor(ResManager.EC_MID_WHITE)
        })

      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    // 导航栏
    Navigation() {
      Column() {
        Column() {
          Text('您正在为1032床位安装设备')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_SMALL_FS)
        }
        .width('100%')
        .margin({bottom:20})
        .alignItems(HorizontalAlign.Start)
        // 设备列表
        Scroll(this.scroller) {
          Column({space:20}) {
            ForEach(this.devices, (item: DeviceCate) => {
               this.deviceItem(item.title, item.list)
            })
          }
          .width('100%')
        }
        .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
        .scrollBar(BarState.Off) // 滚动条常驻显示
        // .edgeEffect(EdgeEffect.None)
        // .onScroll((xOffset: number, yOffset: number) => {
        //   console.info(xOffset + ' ' + yOffset)
        // })
        // .onScrollEdge((side: Edge) => {
        //   console.info('To the edge')
        // })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
      .padding(15)

    }
    .title('选择设备')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor(ResManager.EC_MID_BG)
  }
}