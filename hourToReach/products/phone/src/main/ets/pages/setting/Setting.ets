import { HMCard, HMCard_item, HmNavBar, HmConfirmModel, HMConfirm, TOKEN_KEY, TokenStore } from 'basic'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Setting {

  comfirm: CustomDialogController = new CustomDialogController({
    builder: HMConfirm(
      {
        message: '确定要退出登录吗',
        buttonList: [
          {
            text: '取消',
            fontSize: 14,
            fontColor: $r('app.color.text_secondary')
          },
          {
            text: '确定',
            fontSize: 14,
            fontColor: $r('app.color.primary'),
            action: () => {
              this.handleLoginOut()
            }
          }
        ]
      }
    ),
    customStyle: true,
    // 弹窗位置
    alignment:DialogAlignment.Center,
    autoCancel: false

  })


  handleLoginOut() {
    AppStorage.set(TOKEN_KEY, '')
    TokenStore.setToken('')
    router.replaceUrl({
      url: 'pages/Login/Login'
    })
  }

  build() {
    Column() {

      HmNavBar({ title: '系统设置' }).onClick(() => {
        router.back()
      })
      HMCard() {
        HMCard_item({ leftTitle: '换绑手机' })
        HMCard_item({ leftTitle: '修改密码' })
        HMCard_item({ leftTitle: '消息通知设置' })
        HMCard_item({ leftTitle: '清理缓存', showBottomBorder: false })
      }

      Row() {
        Button("退出", { type: ButtonType.Normal })
          .backgroundColor($r('app.color.white'))
          .fontColor($r("app.color.text_primary"))
          .width('100%')
          .borderRadius(8)
          .height(60)
          .onClick(() => {
            this.comfirm.open()
          })
      }.width('100%').padding({
        left: 15,
        right: 15
      })
      .justifyContent(FlexAlign.Center)
    }.width('100%')
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}