import { User, UserModel } from '../../common/models'

@Entry
@Component
struct Login {
  @State loading: boolean = false
  @State thisUserCount: UserModel = new UserModel({} as User)

  @Styles
  loginStyle() {
    .backgroundColor('#fff')
    .border({ color: $r('app.color.background_divider'), width: { bottom: 1 } })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }

  build() {
    Column() {
      // 顶部标题
      Text("小时达").fontColor($r('app.color.text_primary')).fontSize(18).height(25)
      // 账号登录
      Row() {
        Text('账号登录').fontColor($r('app.color.text_primary')).fontSize(24).fontWeight(FontWeight.Bold)
        Row() {
          Text("账号登录").fontColor($r('app.color.primary')).fontSize(16).fontWeight(FontWeight.Bold)
          Image($r("app.media.ic_angle")).width(10).height(10).margin({ left: 5 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 50, bottom: 50 })

      // 用户名输入框
      TextInput({ placeholder: '请输入账号', text: this.thisUserCount.account })
        .onChange(value => this.thisUserCount.account = value)
        .loginStyle()

      // 密码框
      TextInput({ placeholder: '请输入密码', text: this.thisUserCount.password })
        .onChange(value => this.thisUserCount.password = value)
        .loginStyle()
        .type(InputType.Password)// 密码框
        .showPasswordIcon(true) // 显示密码按钮

      // 登录按钮
      Button({ type: ButtonType.Capsule }) {
        Row() {
          if (this.loading) {
            LoadingProgress().width(20).height(20).margin({ right: 12 }).color($r('app.color.white'))
          }
          Text('登录').fontColor($r('app.color.white'))
        }
      }
      .backgroundColor( $r('app.color.primary') )
      .width('100%')
      .height(50)
      .margin({ top: 50 })
      .enabled((!!this.thisUserCount.account && !!this.thisUserCount.password))
    }
    .padding({ left: 32, right: 32 })
    .margin({ top: 40 })
  }
}