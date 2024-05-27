import { ResManager } from '@hm/basic/Index'

class RecordItem {
  name: string = ''
}

class OpenRecord {
  month: string = ''
  list: RecordItem[] = []
}

@Entry
@Component
struct OpeningRecordPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  list: OpenRecord[] = [
    {
      month: '12',
      list: [
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
      ]
    },
    {
      month: '11',
      list: [
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' }
      ]
    },
    {
      month: '10',
      list: [
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' },
        { name: '李玉湖' }
      ]
    }
  ]

  @Builder
  groupHead(month: string) {
    // 月份
    Row() {
      Text() {
        Span(month)
          .fontColor('#000')
          .fontSize(24)
          .fontWeight(500)
        Span('月')
          .fontColor('#000')
          .fontSize(14)
          .fontWeight(500)
      }
    }
    .width('100%')
    .padding({ left: 15, right: 15 })
    .height(52)
    .borderRadius(ResManager.EC_NORMAL_RD)
    .backgroundImage($r('app.media.pic_month_ban'))
    .backgroundImageSize(ImageSize.Cover)
    .margin({ bottom: 10 })
  }

  build() {
    Navigation() {
      Column() {
        // 1. 年月过滤器
        Row() {
          Text('2023年12月')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
          // 三角形
          Polygon({ width: 10, height: 10 })
            .points([[0, 0], [5, 8], [10, 0]])
            .fill(Color.Black)
            .margin({ left: 8, top: 2 })
        }
        .width('100%')
        .padding({ top: 10, left: 30, bottom: 15 })

        // 2. 月份列表
        List({ space: 10 }) {
          ForEach(this.list, (item: OpenRecord) => {
            ListItemGroup({ space: 10, header: this.groupHead(item.month) }) {
              ForEach(item.list, (it: RecordItem, i: number) => {
                ListItem() {
                  Column({ space: 12 }) {
                    Row() {
                      Text(it.name + i)
                        .fontColor('#000')
                        .fontSize(20)
                        .fontWeight(500)
                      Text('远程开门')
                        .padding({ left: 6.5, right: 6.5, top: 2.5, bottom: 2.5 })
                        .borderRadius(10)
                        .backgroundColor('#DBF0FF')
                        .fontColor('#0398FF')
                        .fontSize(ResManager.EC_SMALL_FS)

                    }
                    .width('100%')
                    .justifyContent(FlexAlign.SpaceBetween)

                    Row() {
                      Text('18909876787')
                        .fontColor(ResManager.EC_MID_59)
                        .fontSize(ResManager.EC_CARD_FS)
                      Text('2023年8月2日14:03:09')
                        .fontColor(ResManager.EC_MID_59)
                        .fontSize(ResManager.EC_CARD_FS)
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.SpaceBetween)
                  }
                  .width('100%')
                  .padding(15)
                  .borderRadius(ResManager.EC_NORMAL_RD)
                  .backgroundColor('#fff')

                }
              })
            }
          })
        }
        .sticky(StickyStyle.Header)
        .scrollBar(BarState.Off)
        .padding({ left: 15, right: 15 })
        .layoutWeight(1)

      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title('开门记录')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor(ResManager.EC_MID_BG)
    .padding({ top: this.topHeight })

    // .backgroundColor('red')
  }
}