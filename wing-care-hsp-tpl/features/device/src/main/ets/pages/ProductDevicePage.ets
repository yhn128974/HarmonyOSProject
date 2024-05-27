import { Device } from '../viewmodel/DeviceModel'
import router from '@ohos.router'
import { ResManager } from '@hm/basic/Index'

@Entry
@Component
struct ProductDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  list: Device[] = [
    {
      name: '拉绳呼叫器',
      icon: '/images/img_xzsb_lshjq.png'
    },
    {
      name: 'SOS按钮',
      icon: '/images/img_xzsb_sosbtn.png'
    },
    {
      name: '烟雾报警器',
      icon: '/images/img_xzsb_ywbjq.png'
    },
    {
      name: '多功能传感器',
      icon: '/images/img_xzsb_dgncgq.png'
    },
    {
      name: '门磁感应器',
      icon: '/images/img_xzsb_mcgyq.png'
    },
    {
      name: '监控设备',
      icon: '/images/img_xzsb_sbjk.png'
    },
    {
      name: '睡眠检测带',
      icon: '/images/img_xzsb_smjcd.png'
    },
    {
      name: '血糖仪',
      icon: '/images/img_xzsb_xty.png'
    },
    {
      name: '智能手表',
      icon: '/images/img_xzsb_znsb.png'
    }
  ]

  build() {
    Navigation() {
      Column() {
        GridRow({ columns: 3, gutter: { x: 10, y: 10 } }) {
          ForEach(this.list, (item: Device, i: number) => {
            GridCol() {
              Stack({ alignContent: Alignment.TopEnd }) {
                Column({ space: 10 }) {
                  Image(item.icon)
                    .width(50)
                    .aspectRatio(1)
                  Text(item.name)
                    .fontColor(ResManager.EC_MID_19)
                    .fontSize(ResManager.EC_SMALL_FS)
                }
                .width('100%')
                .padding({ top: 13, bottom: 20 })
                .borderRadius(8)
                .backgroundColor(ResManager.EC_MID_WHITE)

                if (i % 2 === 0) {
                  Text('已绑定')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .backgroundColor('#FFDBF0FF')
                    .borderRadius(10)
                    .fontColor('#FF0398FF')
                    .fontSize(ResManager.EC_SMALL_FS)
                    .margin({ top: 10, right: 5 })
                }
              }
            }
            .onClick(()=>{
              router.back()
            })

            // .layoutWeight(1)
          })
        }
      }
      .padding({ left: 15, right: 15 })
    }
    .title('所属产品')
    .titleMode(NavigationTitleMode.Mini)
    .padding({top:this.topHeight})
    .backgroundColor(ResManager.EC_MID_BG)
  }
}