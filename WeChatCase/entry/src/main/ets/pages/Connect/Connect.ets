import { promptAction } from '@kit.ArkUI'
import { UserInfoModel } from '../../models/user'
import { WeChatStore } from '../../utils/chat_store'

@Component
export struct Connect {
  @State userList: UserInfoModel[] = []

  aboutToAppear(): void {
    this.getUserList()
    promptAction.showToast({
      message: '联系人即将渲染'
    })
  }

  getUserList() {
    this.userList = WeChatStore.getWeChatConnect()
  }

  build() {
    Column() {
      Row() {
        Search({
          placeholder: '搜索'
        }).height(30).borderRadius(4).padding({
          left: 10,
          right: 10
        }).backgroundColor($r('app.color.white'))
      }.width('100%')

      List() {
        ForEach(this.userList, (item: UserInfoModel) => {
          ListItem() {
            Row({
              space: 10
            }) {
              Image(item.avatar).width(30).aspectRatio(1).borderRadius(4)
              Text(item.username).fontSize(14).fontColor($r('app.color.text_primary'))
            }
            .height(60).width('100%').padding({
              left: 10,
              right: 10
            })
          }.stateStyles({
            pressed: {
              .backgroundColor($r('app.color.back_color'))
            },
            normal: {
              .backgroundColor($r('app.color.white'))
            }
          })
        })
      }.backgroundColor($r('app.color.white'))
      .divider({
        strokeWidth: 1,
        color: $r('app.color.border_color')
      })
    }.backgroundColor($r('app.color.back_color')).height('100%')

  }
}