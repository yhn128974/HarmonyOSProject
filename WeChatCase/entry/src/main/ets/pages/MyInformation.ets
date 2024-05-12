import { WeChat_CurrentUserKey } from '../constant'
import { UserInfoModel, UserInfo } from '../models/user'
import  {getRenderItem} from '../ComPonents'
@Preview
@Component
struct MyInformation {
  @StorageProp(WeChat_CurrentUserKey)
  CurrentUser: UserInfoModel = new UserInfoModel({} as UserInfo)

  build() {
    Column() {
      // 顶部
      Row() {
        Row({ space: 10 }) {
          Image(this.CurrentUser.avatar)
            .width(60)
            .height(60)
            .borderRadius(6)
          Column({ space: 10 }) {
            Text(this.CurrentUser.username).fontSize(18).fontColor($r('app.color.text_primary'))
            Text(`微信号:${this.CurrentUser.user_id}`).fontColor($r('app.color.text_second')).fontSize(14)
          }.alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)

        Image($r("app.media.ic_public_right"))
          .width(16)
          .height(16)
          .fillColor($r('app.color.text_second'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(30)
      .width('100%')
      .backgroundColor($r("app.color.white"))

      Row().height(10)
      getRenderItem("服务")
      Row().height(10)
      getRenderItem("收藏")
      getRenderItem("朋友圈")
      getRenderItem("卡包")
      getRenderItem("表情")
      Row().height(10)
      getRenderItem("设置")
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
  }
}

export default MyInformation