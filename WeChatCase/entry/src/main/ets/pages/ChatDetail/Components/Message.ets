import { WeChat_CurrentUserKey } from '../../../constant'
import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../../models/message'
import { UserInfo, UserInfoModel } from '../../../models/user'
import { promptAction } from '@kit.ArkUI'
import { PopupItem } from '../../../models/popup'

@Preview
@Component
export struct Message {
  @StorageProp(WeChat_CurrentUserKey)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo)
  @Require
  @Prop currentMessage: MessageInfoModel = new MessageInfoModel({} as MessageInfo)
  // 判断消息的主体是否为自己
  @State isOwnMessage: boolean = this.currentUser.user_id === this.currentMessage?.sendUser?.user_id
  @State showPopup: boolean = false
  // 弹框数据
  @State
  popupList: PopupItem[] = [
    {
      title: '听筒播放',
      icon: $r("app.media.ic_public_ears")
    },
    {
      title: '收藏',
      icon: $r("app.media.ic_public_cube")
    }, {
    title: '转文字',
    icon: $r("app.media.ic_public_trans_text")
  }, {
    title: '删除',
    icon: $r("app.media.ic_public_cancel"),
    itemClick: () => {
      this.delMessage(this.currentMessage.id)
    }
  }, {
    title: '多选',
    icon: $r("app.media.ic_public_multi_select")
  }, {
    title: '引用',
    icon: $r("app.media.ic_public_link")
  }, {
    title: '提醒',
    icon: $r("app.media.ic_public_warin")
  }]
  // 删除信息的方法
  delMessage: (messId: string) => void = () => {
  }

  @Builder
  getContent() {
    GridRow({ columns: 5 }) {
      ForEach(this.popupList, (item: PopupItem) => {
        GridCol() {
          Column() {
            Image(item.icon).fillColor($r('app.color.white')).width(18).aspectRatio(1)
            Text(item.title).fontColor($r('app.color.white')).fontSize(14)
          }.height(60)
        }.onClick(() => {
          // 判断点击事件是否存在并且存在就执行
          item.itemClick && item.itemClick()
        })
      })
    }.padding({
      top: 15,
      left: 10,
      right: 10
    })

  }

  getAudioWidth() {
    let minWidth: number = 20
    let maxWidth: number = 90
    let calWidth: number = minWidth + (100 * this.currentMessage.sourceDuration / 60)
    if (calWidth > maxWidth) return maxWidth + "%"
    return calWidth + "%"
  }

  //实现多个builder
  @Builder
  getTextContent() {
    Text(this.currentMessage.messageContent)
      .backgroundColor(this.isOwnMessage ? $r('app.color.second_primary') : $r('app.color.white'))
      .fontColor($r('app.color.text_primary'))
      .padding(10)
      .margin({
        left: 10,
        right: 10
      })
      .borderRadius(4)

  }

  @Builder
  getAudioContent() {
    Row({
      space: 5
    }) {
      Text(`${this.currentMessage.sourceDuration}'`).fontColor($r('app.color.text_primary'))
      Image($r('app.media.ic_public_recorder')).width(20).aspectRatio(1).rotate({
        angle: this.isOwnMessage ? 180 : 0
      })


    }
    .backgroundColor(this.isOwnMessage ? $r('app.color.second_primary') : $r('app.color.white'))
    .padding(10)
    .margin({
      left: 10,
      right: 10
    })
    .borderRadius(4)
    .width(this.getAudioWidth())
    .direction(this.isOwnMessage ? Direction.Rtl : Direction.Ltr)

  }

  build() {
    Row() {
      Image(this.currentMessage.sendUser.avatar).width(40).aspectRatio(1).borderRadius(4)

      Row() {
        Column() {
          if (this.currentMessage.messageType === MessageTypeEnum.TEXT) {
            this.getTextContent()
          }
          if (this.currentMessage.messageType === MessageTypeEnum.AUDIO) {
            this.getAudioContent()
          }
        } // 添加弹层
        .bindPopup(this.showPopup, {
          builder: this.getContent(),
          popupColor: $r('app.color.popup_back'),
          backgroundBlurStyle: BlurStyle.NONE, //把失焦的模式设置为null，是否颜色不保持
          onStateChange: (isVisible) => {
            // 当手指点了其他位置，关闭状态
            this.showPopup = isVisible.isVisible
          }
        })

      }

      .justifyContent(this.isOwnMessage ? FlexAlign.End : FlexAlign.Start)
      .gesture(LongPressGesture().onAction(() => {
        this.showPopup = true
      }))

      .layoutWeight(6)

      Row().layoutWeight(1)
    }.padding({
      left: 20,
      right: 20
    })
    .direction(this.isOwnMessage ? Direction.Rtl : Direction.Ltr)
  }
}