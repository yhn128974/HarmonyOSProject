import { MessageInfoModel } from '../../models/message'
import { WeChatStore } from '../../utils/chat_store'
import { router } from '@kit.ArkUI'
import { emitter } from '@kit.BasicServicesKit'
import { Record_Update_EventName } from '../../constant'
import { PopupItem } from '../../models/popup'
import { scanCore, scanBarcode } from '@kit.ScanKit';
// 导入默认界面需要的日志模块和错误码模块
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export default struct WeChat {
  @State list: MessageInfoModel[] = []
  @State
  popList: PopupItem[] = [
    {
      title: '发起群聊',
      icon: $r('app.media.ic_public_message')
    },
    {
      title: '添加朋友',
      icon: $r('app.media.ic_public_add_friend')
    },
    {
      title: '扫一扫',
      icon: $r('app.media.ic_public_scan'),
      itemClick: () => {
        this.scan()
      }
    },
    {
      title: '收付款',
      icon: $r('app.media.ic_public_receive'),
      itemClick: () => {
        router.pushUrl({
          url: 'pages/PayQrCode/PayQrCode'
        })
      }
    }
  ]
  @State showDropDown: boolean = false

  aboutToAppear(): void {
    this.getAllRecord()
  }

  scan() {
    // 定义扫码参数options
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.ALL],
      enableMultiMode: true,
      enableAlbum: true
    };
    // 扫码
    scanBarcode.startScanForResult(getContext(this), options, (error: BusinessError, result: scanBarcode.ScanResult) => {
      // 收到扫码结果后返回
      hilog.info(0x0001, '[Scan CPSample]', 'Callback scan result: %{public}s', JSON.stringify(result));
    })

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

  @Builder
  ListEndBuilder(user_id: string) {
    Row() {
      Text("删除")
        .fontColor($r('app.color.white'))
        .width(100)
        .textAlign(TextAlign.Center)
    }
    .height(70)
    .padding({
      left: 20,
      right: 20
    })
    .backgroundColor($r('app.color.danger'))
    .onClick(() => {
      if (user_id) {
        let index: number = this.list.findIndex(item => item.connectUser.user_id == user_id)
        if (index > -1) {
          this.list.splice(index, 1)
          WeChatStore.delWeChatMessage(user_id)
        }
      }
    })
  }

  @Builder
  getDropDown() {
    Column() {
      ForEach(this.popList, (item: PopupItem) => {
        Row({
          space: 3
        }) {
          Image(item.icon)
            .width(20)
            .aspectRatio(1)
            .fillColor($r('app.color.white'))
          Text(item.title)
            .layoutWeight(1)
            .fontColor($r('app.color.white'))
            .textAlign(TextAlign.Center)
        }
        .padding({
          left: 10,
          right: 10
        })
        .height(50)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          item.itemClick && item.itemClick()
        })
      })
    }.width(120)
  }

  build() {
    Column() {
      Row() {
        Text('微信')
        Image($r('app.media.ic_public_add_norm'))
          .width(20)
          .aspectRatio(1)
          .position({
            x: '100%'
          })
          .translate({
            x: '-40',
            y: 15
          })
          .bindPopup(this.showDropDown, {
            builder: this.getDropDown(),
            onStateChange: (event) => {
              // 当点击空白区域时 回触发
              this.showDropDown = event.isVisible
            },
            backgroundBlurStyle: BlurStyle.NONE,
            popupColor: $r('app.color.popup_back')
          })
          .onClick(() => {
            this.showDropDown = true
          })
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
          .swipeAction({
            end: {
              builder: this.ListEndBuilder(item.connectUser.user_id)
            }
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
