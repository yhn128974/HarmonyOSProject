import { display, promptAction } from '@kit.ArkUI'
import { VoiceRecordEnum } from '../../../models/voice'
import VoiceInput from './VoiceInput'
import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit'
import { constant } from '@kit.ConnectivityKit'

@Preview
@Component
struct BottomInput {
  @State showVoice: boolean = false //是否显示语音输入
  @State content: string = '' //输入内容
  sentTextMessage: (content: string) => void = () => {

  }
  @State isShowVoiceBuilder: boolean = false
  @Provide
  voiceState: VoiceRecordEnum = VoiceRecordEnum.Recording
  // 需要知道整体的屏幕宽度
  screenWidth: number = 0
  screenHeight: number = 0

  // 显示语音输入组件
  @Builder
  VoiceBuilder() {
    Column() {
      VoiceInput()
    }

  }

  aboutToAppear(): void {
    this.getScreenWidth()
  }

  async getScreenWidth() {
    const result = await display.getAllDisplays()
    if (result && result.length) {
      this.screenWidth = px2vp(result[0].width) //记录宽度
      this.screenHeight = px2vp(result[0].height) //记录高度
    }
  }

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
    }
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
                  this.isShowVoiceBuilder = false
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