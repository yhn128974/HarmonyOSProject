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
import { PopupItem } from '../../../models/popup'
import { fileIo, picker } from '@kit.CoreFileKit'
import { util } from '@kit.ArkTS'
// 导入相机需要依赖
import cameraPicker from '@ohos.multimedia.cameraPicker';
import camera from '@ohos.multimedia.camera';
import { BusinessError } from '@ohos.base';
import Location from './Location'
import { VoiceTransfer } from '../../../utils/VoiceTransfer'

let mContext = getContext(this) as common.Context;

@Preview
@Component
struct BottomInput {
  @Provide asrResult:string=''
  @StorageProp(WeChat_CurrentUserKey)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo)
  @Consume talkUser: UserInfoModel
  @State showVoice: boolean = false //是否显示语音输入
  @State showLoaction: boolean = false
  @State content: string = '' //输入内容
  @State isShowVoiceBuilder: boolean = false
  @Provide
  voiceState: VoiceRecordEnum = VoiceRecordEnum.Recording
  // 需要知道整体的屏幕宽度
  screenWidth: number = 0
  screenHeight: number = 0
  tempAudioPath: string = ""
  duration: number = 0 //音频的秒数
  timer: number = -1 //定时器的标记
  @State currentAddress: string = ""
  @State
  bottomList: PopupItem[] = [
    {
      icon: $r('app.media.ic_public_photo'),
      title: '照片',
      //   发送照片,打开相册 发送照片
      itemClick: () => {
        this.sendPhoto()
      }

    },
    {
      icon: $r('app.media.ic_public_carema'),
      title: '拍摄',
      itemClick: () => {
        this.openCamera()
      }
    },
    {
      icon: $r('app.media.ic_statusbar_gps'),
      title: '位置',
      // 弹出一个地图组件
      itemClick: () => {
        this.showLoaction = true

      }


    },
    {
      icon: $r('app.media.ic_public_voice'),
      title: '语音输入',

    },
    {
      icon: $r("app.media.ic_public_collect"),
      title: '收藏',

    },
    {
      icon: $r("app.media.ic_public_contacts_filled"),
      title: '个人名片',

    },
    {
      icon: $r("app.media.ic_public_folder_filled"),
      title: '文件',

    },
    {
      icon: $r("app.media.ic_public_music_filled"),
      title: '音乐',
    }]
  @State
  showBottomCard: boolean = false // 显示底部


  // 发送文本
  sentTextMessage: (content: string) => void = () => {
  }
  // 发送音频消息的方法
  sendAudioMessage: (message: MessageInfoModel) => void = () => {
  }
  // 发送图片消息
  sendImageMessage: (list: MessageInfoModel[]) => void = () => {
  }
  // 文本控制器
  textController: TextInputController = new TextInputController() //文本控制器

  // 显示语音输入组件
  @Builder
  VoiceBuilder() {
    Column() {
      VoiceInput()
    }
  }

  @Builder
  getLocation() {
    // 放置地图组件
    Stack({
      alignContent: Alignment.Top
    }) {
      Location({
        currentAddress: this.currentAddress
      })
      Row() {
        Text('取消').fontColor($r('app.color.text_second')).onClick(() => {
          this.showLoaction = false
        })
        Button('确定')
          .type(ButtonType.Normal)
          .borderRadius(4)
          .backgroundColor($r('app.color.primary'))
          .height(30)
          .width(60)
          .onClick(() => {
            //   拿到子组件的值 ,将这个值传递发送消息
            if (this.currentAddress) {
              this.sentTextMessage(this.currentAddress)
            }
            this.currentAddress = ""
            this.showLoaction = false
          })

      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({
        left: 20,
        right: 20
      })
      .height(60)
      .margin({
        top: 50
      })
    }

  }

  @Builder
  getBottomCard(item: PopupItem) {
    Column() {
      Column() {
        Image(item.icon)
          .width(30)
          .height(30)
          .fillColor("#4c4c4c")
      }
      .backgroundColor(Color.White)
      .width(56)
      .aspectRatio(1)
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Text(item.title)
        .fontSize(12)
        .fontColor($r('app.color.text_second'))
        .margin({
          top: 10
        })
    }.layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      item.itemClick && item.itemClick()
    })

  }

  // 打开相机
  async openCamera() {
    const result = await cameraPicker.pick(getContext(), [
      cameraPicker.PickerMediaType.PHOTO,
      cameraPicker.PickerMediaType.VIDEO
    ], {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK//后置摄像头
    })

    const filePath = getContext().filesDir + '/' + util.generateRandomUUID()
    const file = fileIo.openSync(result.resultUri, fileIo.OpenMode.READ_ONLY)
    let extendName = 'jpg'
    let messTpye = MessageTypeEnum.IMAGE
    let messContent = '[图片]'
    // 注意系统GUB,类型判断不上
    if (result.mediaType === 'video') {
      extendName = 'mp4'
      messTpye = MessageTypeEnum.VIDEO
      messContent = '[视频]'
    }
    // 考培文件
    fileIo.copyFileSync(file.fd, filePath + extendName)
    fileIo.closeSync(file.fd)
    this.sendImageMessage([new MessageInfoModel({
      connectUser: this.talkUser,
      sendUser: this.currentUser,
      sourceFilePath: filePath + extendName,
      messageType: messTpye,
      messageContent: messContent
    } as MessageInfo)])

    AlertDialog.show({
      message: JSON.stringify(result)
    })
  }

  // 发送图片
  async sendPhoto() {
    //   打开相册
    const photo = new picker.PhotoViewPicker()
    let result = await photo.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: 9
    })

    AlertDialog.show({ message: JSON.stringify(result.photoUris) })
    let messList: MessageInfoModel[] = []

    result.photoUris.forEach(url => {
      const file = fileIo.openSync(url, fileIo.OpenMode.READ_ONLY)
      const newFileName = getContext().filesDir + "/" + util.generateRandomUUID() + '.jpg'
      fileIo.copyFileSync(file.fd, newFileName)
      // 发了一张图片，一个消息
      messList.push(
        new MessageInfoModel({
          connectUser: this.talkUser,
          sendUser: this.currentUser,
          sourceFilePath: newFileName,
          messageType: MessageTypeEnum.IMAGE,
          messageContent: "[图片]"
        } as MessageInfo)
      )
      fileIo.closeSync(file.fd) //关闭相册的读取
      //   循环结束之后 发送消息 发送一个列表
      this.sendImageMessage(messList)
      animateTo({ duration: 150 }, () => {
        this.showBottomCard = false
      })

    })
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
      this.duration = 0
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
    Column() {
      Row() {
        Image(this.showVoice ? $r('app.media.ic_public_keyboard') : $r('app.media.ic_public_sound'))
          .width(25)
          .aspectRatio(1)
          .onClick(() => {
            this.showVoice = !this.showVoice
            animateTo({
              duration: 100
            }, () => {
              this.showBottomCard = false
            })
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
                      VoiceTransfer.VoiceToText(this.tempAudioPath,(res)=>{
                        this.asrResult=res.result //

                      })
                    }
                  }
                })
              )
            )
        } else {
          TextInput({
            text: $$this.content,
            controller: this.textController
          })
            .onClick(() => {
              animateTo({
                duration: 150
              }, () => {
                this.showBottomCard = false
              })
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
          .onClick(() => {
            animateTo({
              duration: 100
            }, () => {
              this.showBottomCard = !this.showBottomCard
              if (this.showBottomCard) {
                this.textController.stopEditing() //关闭编辑
              }
            })
          })
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
        { modalTransition: ModalTransition.NONE }
      )

      if (this.showBottomCard) {
        Column() {
          // 底部结构
          GridRow({ columns: 4 }) {
            ForEach(this.bottomList, (item: PopupItem) => {
              GridCol() {
                this.getBottomCard(item)
              }.height(100)
            })
          }
          .width('100%')
        }.backgroundColor($r('app.color.second_back_color'))
      }

    }.bindContentCover(this.showLoaction, this.getLocation())
  }
}

export default BottomInput