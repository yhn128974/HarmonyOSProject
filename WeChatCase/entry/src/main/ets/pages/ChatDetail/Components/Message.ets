import { WeChat_CurrentUserKey } from '../../../constant'
import { MessageInfo, MessageInfoModel } from '../../../models/message'
import { UserInfo, UserInfoModel } from '../../../models/user'

@Preview
@Component
export struct Message {
  @StorageProp(WeChat_CurrentUserKey)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo)
  @Require
  @Prop currentMessage: MessageInfoModel = new MessageInfoModel({} as MessageInfo)
  // 判断消息的主体是否为自己
  @State isOwnMessage: boolean = this.currentUser.user_id === this.currentMessage?.sendUser?.user_id

  build() {
    Row() {
      Image(this.currentMessage.sendUser.avatar).width(40).aspectRatio(1).borderRadius(4)
      Row() {
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
      .layoutWeight(6)
      .justifyContent(this.isOwnMessage ? FlexAlign.End : FlexAlign.Start)


      Row().layoutWeight(1)
    }.padding({
      left: 20,
      right: 20
    })
    .direction(this.isOwnMessage ? Direction.Rtl : Direction.Ltr)
  }
}