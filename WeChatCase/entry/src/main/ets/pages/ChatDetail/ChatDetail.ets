import router from '@ohos.router';
import { WeChat_ConnectKey, WeChat_CurrentUserKey } from '../../constant';
import { UserInfo, UserInfoModel } from '../../models/user';
import BottomInput from './Components/BottomInput'
import { Message } from './Components/Message'

import { MessageInfo, MessageInfoModel } from '../../models/message'
import { promptAction } from '@kit.ArkUI';
import { getRequestMessage } from '../../utils/request'
import { ChatResponse, ChatResponseModel } from '../../models/chat';
import { WeChatStore } from '../../utils/chat_store';

@Entry
@Component
struct ChatDetail {
  @StorageProp(WeChat_CurrentUserKey)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo)
  @Provide talkUser: UserInfoModel = new UserInfoModel({} as UserInfo) //好友
  @State messageList: MessageInfoModel[] = []
  @State talkUserInputIng: boolean = false;
  scroller = new Scroller()

  aboutToAppear(): void {
    this.getTalkUser()
  }

  getTalkUser() {
    this.talkUser = router.getParams() as UserInfoModel
    // promptAction.showToast({
    //   message: JSON.stringify(this.currentUser)
    // })
    this.getAllRecord()
  }

  async getAllRecord() {
    // 异步promise需要await 修饰符接受参数
    this.messageList = await WeChatStore.getWeChatMessage(this.talkUser.user_id)

    this.scroller.scrollEdge(Edge.Bottom)
  }

  //发送文本消息
  sentTextMessage(content: string) {
    let newMessageInfoModel: MessageInfoModel = new MessageInfoModel({} as MessageInfo)
    newMessageInfoModel.sendUser = this.currentUser //发消息的主体是当前用户
    newMessageInfoModel.connectUser = this.talkUser //链接的主体是聊天对象
    newMessageInfoModel.messageContent = content
    this.messageList.push(newMessageInfoModel)
    // 添加聊天记录到首选项中
    WeChatStore.addOneWeChatMessage(this.talkUser.user_id, newMessageInfoModel)
    //
    this.scroller.scrollEdge(Edge.Bottom)
    setTimeout(() => {
      this.getResponseMessage(content)
    }, 1000)
  }

  //获取响应的消息
  async getResponseMessage(content: string) {
    this.talkUserInputIng = true
    // 根据输入内容发生请求
    const result = await getRequestMessage(content)
    let newMessageInfoModel = new MessageInfoModel({
      messageContent: result.data?.info?.text,
      sendUser: this.talkUser,
      connectUser: this.talkUser,
    } as MessageInfo)
    this.messageList.push(newMessageInfoModel) // 添加到信息的底部
    // 添加聊天记录到首选项中
    WeChatStore.addOneWeChatMessage(this.talkUser.user_id, newMessageInfoModel)
    this.talkUserInputIng = false
    //
    this.scroller.scrollEdge(Edge.Bottom)
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
        Text(this.talkUserInputIng ? "对方正在输入" : "" + this.talkUser.username)
          .fontSize($r('app.color.text_primary'))
          .width('100%')
          .textAlign(TextAlign.Center)
      }

      Column() {
        List({
          space: 20,
          scroller: this.scroller
        }) {
          ForEach(this.messageList, (item: MessageInfoModel) => {
            ListItem() {
              Message({
                currentMessage: item
              })
            }
          })
        }.onAppear(() => {
          this.scroller.scrollEdge(Edge.End)
        })
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