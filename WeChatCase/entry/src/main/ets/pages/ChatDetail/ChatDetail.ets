import router from '@ohos.router';
import { WeChat_ConnectKey, WeChat_CurrentUserKey } from '../../constant';
import { UserInfo, UserInfoModel } from '../../models/user';
import BottomInput from './Components/BottomInput'
import { Message } from './Components/Message'

import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../models/message'
import { promptAction } from '@kit.ArkUI';
import { getRequestMessage } from '../../utils/request'
import { ChatResponse, ChatResponseModel } from '../../models/chat';
import { WeChatStore } from '../../utils/chat_store';
import { AudioRenderer } from '../../utils/audio_renderer';
import { AvPlayer } from '../../utils/av_player';
import PreviewImag from './Components/previewDialog'
import Location from './Components/Location';
import { VoiceTransfer } from '../../utils/VoiceTransfer';

@Entry
@Component
struct ChatDetail {
  //////////////////////////////////////////图片预览
  showType: MessageTypeEnum = MessageTypeEnum.IMAGE
  previewUrl: string = ''
  previewController: CustomDialogController = new CustomDialogController({
    builder: PreviewImag({
      url: this.previewUrl,
      showTyPe: this.showType,

    }),
    customStyle: true,
    autoCancel: false
  })
  /////////////////////////////////////////////////////////////////
  @StorageProp(WeChat_CurrentUserKey)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo)
  @Provide talkUser: UserInfoModel = new UserInfoModel({} as UserInfo) //好友
  @State messageList: MessageInfoModel[] = []
  @State talkUserInputIng: boolean = false;
  scroller = new Scroller()
  player: AvPlayer = new AvPlayer() //初始化播放器

  aboutToAppear(): void {
    this.scroller.scrollEdge(Edge.End)
    this.getTalkUser()
    //   初始化音频播放
    AudioRenderer.init()
    this.player.init()
  }

  aboutToDisappear(): void {
    this.releaseAudio()
  }

  async releaseAudio() {
    await AudioRenderer.stop() //先暂停在释放
    AudioRenderer.release()
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

    // 发出声音提示
    this.player.play("send.wav")
    // 添加聊天记录到首选项中
    WeChatStore.addOneWeChatMessage(this.talkUser.user_id, newMessageInfoModel)
    //
    this.scroller.scrollEdge(Edge.Bottom)
    setTimeout(() => {
      this.getResponseMessage(content)
    }, 1000)

  }

  // 发送语音消息
  sendAudioMessage(message: MessageInfoModel) {
    this.messageList.push(message)

    this.scroller.scrollEdge(Edge.Bottom)
    // 写入首选项
    WeChatStore.addOneWeChatMessage(this.talkUser.user_id, message) //添加聊天记录
    // 发出声音提示
    this.player.play("send.wav")

  }

  //获取响应的消息
  async getResponseMessage(content: string) {
    this.talkUserInputIng = true
    // 根据输入内容发生请求
    const result = await getRequestMessage(content)
    let newMessageInfoModel = new MessageInfoModel({
      messageContent: result?.data?.info?.text,
      sendUser: this.talkUser,
      connectUser: this.talkUser,
    } as MessageInfo)
    this.messageList.push(newMessageInfoModel) // 添加到信息的底部
    // 添加聊天记录到首选项中
    WeChatStore.addOneWeChatMessage(this.talkUser.user_id, newMessageInfoModel)
    this.talkUserInputIng = false
    //滚动屏幕
    this.scroller.scrollEdge(Edge.Bottom)
    //   用小艺播出
    VoiceTransfer.textToVoice(result?.data?.info?.text) //
  }

  // 发送图片消息的方法
  sendImageMessage(list: MessageInfoModel[]) {
    this.messageList.push(...list) //将两个数组合并
    this.scroller.scrollEdge(Edge.Bottom) //滚动到底部
    list.forEach(item => {
      WeChatStore.addOneWeChatMessage(this.talkUser.user_id, item) //添加聊天记录
    })
    this.player.play('send.wav')
  }

  // 删除信息的方法
  delMessage(messId: string) {
    if (messId) {
      // 先移除当前组件的数据
      const index = this.messageList.findIndex(item => item.id === messId)
      if (index > -1) {
        this.messageList.splice(index, 1)
      }
      // 再移除首选项的数据
      WeChatStore.delOneWeChatMessage(this.talkUser.user_id, messId)
    }
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
                currentMessage: item,
                delMessage: (messId: string) => {
                  this.delMessage(messId)
                },
                previewImage: () => {
                  this.previewUrl = "file://" + item.sourceFilePath
                  this.previewController.open() //打开预览
                  this.showType = item.messageType
                }
              })
            }
          })
        }.onAppear(() => {
          this.scroller.scrollEdge(Edge.End)
        }).onAreaChange(()=>{
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
        },
        sendAudioMessage: (newMessage: MessageInfoModel) => {
          this.sendAudioMessage(newMessage)
        },
        sendImageMessage: (list: MessageInfoModel[]) => {
          this.sendImageMessage(list)
        }
      })
    }.justifyContent(FlexAlign.SpaceBetween)

  }
}