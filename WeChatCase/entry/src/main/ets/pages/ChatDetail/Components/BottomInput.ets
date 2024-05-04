import { display, promptAction } from '@kit.ArkUI'

import VoiceInput from './VoiceInput'
import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit'
import { constant } from '@kit.ConnectivityKit'
import AudioCapturer from '../../../utils/audio_recorder'
import { FileCommon } from '../../../utils/file_operate'
import { VoiceRecordEnum } from '../../../models/voice'
import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../../models/message'
import { WeChat_CurrentUserKey } from '../../../constant'
import { UserInfo, UserInfoModel } from '../../../models/user'

@Preview
@Component
struct BottomInput {
  @StorageProp(WeChat_CurrentUserKey)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo)
  @Consume talkUser: UserInfoModel
  @State showVoice: boolean = false //是否显示语音输入
  @State content: string = '' //输入内容
  // 发送文本
  sentTextMessage: (content: string) => void = () => {
  }
  // 发送音频消息的方法
  sendAudioMessage: (message: MessageInfoModel) => void = () => {
  }
  @State isShowVoiceBuilder: boolean = false
  @Provide
  voiceState: VoiceRecordEnum = VoiceRecordEnum.Recording
  // 需要知道整体的屏幕宽度
  screenWidth: number = 0
  screenHeight: number = 0
  tempAudioPath: string = ""
  duration: number = 0 //音频的秒数
  timer: number = -1 //定时器的标记

  // 显示语音输入组件
  @Builder
  VoiceBuilder() {
    Column() {
      VoiceInput()
    }

  }

  aboutToAppear(): void {
    this.getScreenWidth()
    AudioCapturer.init()
  }

  aboutToDisappear(): void {
    AudioCapturer.release()
  }

  async getScreenWidth() {
    const result = await display.getAllDisplays()
    if (result && result.length) {
      this.screenWidth = px2vp(result[0].width) //记录宽度
      this.screenHeight = px2vp(result[0].height) //记录高度
    }
  }

  // 检查权限
  checkPermission() {
    const result = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    const manger = abilityAccessCtrl.createAtManager() //创建一个manger
    const status = manger.checkAccessTokenSync(result.appInfo.accessTokenId, "ohos.permission.MICROPHONE")
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      promptAction.showToast({ message: '状态是拒绝' })
      //无法再次申请因而无法录音，需要手动打开权限
      // ability 传参 打开设置页面
      const context = getContext() as common.UIAbilityContext
      context.startAbility({
        bundleName: "com.huawei.hmos.settings",
        abilityName: "com.huawei.hmos.settings.MainAbility",
        uri: "application_info_entry",
        parameters: {
          pushParams: result.name //打开具体设置
        }
      })

    } else {
      this.isShowVoiceBuilder = true
      this.beginCollectVoice()

    }
  }

  // 开始录音
  beginCollectVoice() {
    this.tempAudioPath = FileCommon.createAudioFile() //创建音频文件
    AudioCapturer.start(this.tempAudioPath) //开始录音了
    this.startTime()
  }

  // 松手逻辑
  releaseFinger() {
    this.isShowVoiceBuilder = false
    this.endTime()
    AudioCapturer.stop()
    if (this.voiceState === VoiceRecordEnum.Cancel) {
      //   取消发生
      FileCommon.delFilePath(this.tempAudioPath) //删除文件
    }
    if (this.voiceState === VoiceRecordEnum.Recording) {
      FileCommon.delFilePath(this.tempAudioPath) //删除文件
      if (this.duration < 1) {
        promptAction.showToast({
          message: '音频时长过短'
        })
        return
      }
      // 发送语音
      this.sendAudio()
    }
    if (this.voiceState === VoiceRecordEnum.Transfer) {
      // 转化文本
    }
    // 无论是什么状态，最终到要回到正常状态
    this.voiceState = VoiceRecordEnum.Recording
    promptAction.showToast({ message: '计时' + this.duration })
    //  该发消息了

  }

  //发送语音
  sendAudio() {
    let newMessage = new MessageInfoModel({
      sourceDuration: this.duration, //时长
      messageContent: `[语音]${this.duration}'`,
      messageType: MessageTypeEnum.AUDIO,
      sendUser: this.currentUser,
      connectUser: this.talkUser,
      sourceFilePath: this.tempAudioPath,
    } as MessageInfo)
    this.sendAudioMessage(newMessage)
    this.duration = 0 //重置时长
    this.tempAudioPath = '' //清除路径
  }

  startTime() {
    this.timer = setInterval(() => {
      this.duration++
    }, 1000)
  }

  endTime() {
    clearInterval(this.timer)
  }

  build() {
    Row() {
      Image(this.showVoice ? $r('app.media.ic_public_keyboard') : $r('app.media.ic_public_sound'))
        .width(25)
        .aspectRatio(1)
        .onClick(() => {
          this.showVoice = !this.showVoice
        })
      if (this.showVoice) {
        Button('按住说话')
          .type(ButtonType.Normal)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .height(35)
          .borderRadius(2)
          .backgroundColor($r('app.color.white'))
          .margin({
            left: 10,
            right: 10
          })
          .gesture(
            GestureGroup(GestureMode.Parallel,
              LongPressGesture()
                .onAction(() => {
                  // 进行权限检查
                  this.checkPermission()
                  // this.isShowVoiceBuilder = true
                })
                .onActionEnd(() => {
                  this.releaseFinger()

                }),
              PanGesture().onActionUpdate((event) => {

                if (event.fingerList[0].globalY > this.screenHeight - 120) {
                  // 没有出录音
                  this.voiceState = VoiceRecordEnum.Recording

                } else {
                  if (event.fingerList[0].globalX <= this.screenWidth / 2) {
                    this.voiceState = VoiceRecordEnum.Cancel
                  } else {
                    this.voiceState = VoiceRecordEnum.Transfer
                  }
                }
              })
            )
          )
      } else {
        TextInput({
          text: $$this.content
        })
          .onSubmit(() => {
            if (this.content) {
              this.sentTextMessage(this.content)
              this.content = ''
            }
          })
          .layoutWeight(1)
          .height(35)
          .borderRadius(2)
          .backgroundColor($r('app.color.white'))
          .margin({
            left: 10,
            right: 10
          })
      }
      Image($r('app.media.ic_public_add_norm')).width(25).aspectRatio(1)

    }
    .width('100%')
    .padding({
      left: 10,
      right: 10
    })
    .height(60)
    .backgroundColor($r('app.color.second_back_color'))
    .bindContentCover(
      this.isShowVoiceBuilder,
      this.VoiceBuilder(),
      // 配置参数
      { modalTransition: ModalTransition.NONE })
  }
}

export default BottomInput