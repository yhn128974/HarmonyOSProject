import router from '@ohos.router';
import { WeChat_ConnectKey, WeChat_CurrentUserKey } from '../../constant';
import { UserInfo, UserInfoModel } from '../../models/user';
import BottomInput from './Components/BottomInput'
import { Message } from './Components/Message'

import { MessageInfo, MessageInfoModel } from '../../models/message'
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct ChatDetail {
  @StorageProp(WeChat_CurrentUserKey)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo)
  @Provide talkUser: UserInfoModel = new UserInfoModel({} as UserInfo) //好友
  @State messageList: MessageInfoModel[] = []

  aboutToAppear(): void {
    this.getTalkUser()
  }

  //发送文本消息
  sentTextMessage(content: string) {
    let newMessageInfoModel: MessageInfoModel = new MessageInfoModel({} as MessageInfo)
    newMessageInfoModel.sendUser = this.currentUser //发消息的主体是当前用户
    newMessageInfoModel.connectUser = this.talkUser //链接的主体是聊天对象
    newMessageInfoModel.messageContent = content

    this.messageList.push(newMessageInfoModel)
  }

  getTalkUser() {
    this.talkUser = router.getParams() as UserInfoModel
    promptAction.showToast({
      message: JSON.stringify(this.currentUser)
    })
  }

  build() {
    Column() {
      // Header
      Stack({
        alignContent: Alignment.Start
      }) {
        Image($r('app.media.ic_public_arrow_left')).width(30).aspectRatio(1).onClick(() => {
          router.back();
        }).zIndex(2)
        Text(this.talkUser.username).fontSize($r('app.color.text_primary')).width('100%').textAlign(TextAlign.Center)
      }

      Column() {
        List({
          space: 20
        }) {
          ForEach(this.messageList, (item: MessageInfoModel) => {
            ListItem() {
              Message({
                currentMessage: item
              })
            }
          })
        }
      }
      .layoutWeight(1)
      .padding({
        top: 10,
        bottom: 40
      })
      .backgroundColor($r('app.color.back_color'))

      // Footer
      BottomInput({
        sentTextMessage: (content: string) => {
          this.sentTextMessage(content)
        }
      })
    }.justifyContent(FlexAlign.SpaceBetween)

  }
}