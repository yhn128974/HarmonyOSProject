import { MessageInfoModel } from '../../models/message'
import { WeChatStore } from '../../utils/chat_store'
import { router } from '@kit.ArkUI'
import { emitter } from '@kit.BasicServicesKit'
import { Record_Update_EventName } from '../../constant'

@Component
export default struct WeChat {
  @State list: MessageInfoModel[] = []

  aboutToAppear(): void {
    this.getAllRecord()
  }

  async getAllRecord() {
    this.list = await WeChatStore.getAllLastRecord()
    emitter.on(Record_Update_EventName, async () => {
      this.list = await WeChatStore.getAllLastRecord()
    })
  }

  // 将时间转化为具体的时间，时间是当天的话显示 时分，如果不是当天的化显示日期
  transTime(timeStap: number) {
    const sendTime = new Date(timeStap)
    if (sendTime.getDate() === new Date().getDate()) {
      return sendTime.getHours().toString().padStart(2, "0") + ":" + sendTime.getMinutes().toString().padStart(2, "0")
    } else {
      return sendTime.getMonth().toString().padStart(2, "0") + ":" + sendTime.getDay().toString().padStart(2, "0")
    }
  }

  build() {
    Column() {
      Row() {
        Text('微信')
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(50)

      List({
        space: 10
      }) {
        ForEach(this.list, (item: MessageInfoModel) => {
          ListItem() {
            Row() {
              Image(item.connectUser.avatar).width(50).aspectRatio(1).borderRadius(4)
              Column() {
                Text(item.connectUser.username).fontColor($r('app.color.text_primary')).layoutWeight(1)
                Text(item.messageContent)
                  .fontColor($r('app.color.text_primary'))
                  .fontSize(14)
                  .layoutWeight(1)
                  .maxLines(1)
                  .textOverflow({
                    overflow: TextOverflow.Ellipsis
                  })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .height(50)
              .padding({
                left: 4,
                bottom: 4
              })

              Text(this.transTime(item.sentTime)).width(50)
                .fontColor($r('app.color.text_second'))
                .fontSize(14)
            }.width('100%').height(50)
          }.onClick(() => {
            router.pushUrl({
              url: 'pages/ChatDetail/ChatDetail',
              params: item.connectUser
            })
          })
        })
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .divider({
        strokeWidth: 1
      })

    }.width('100%').height('100%')
  }
}
