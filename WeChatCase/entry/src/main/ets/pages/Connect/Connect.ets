import { promptAction, router } from '@kit.ArkUI'
import { UserInfoModel } from '../../models/user'
import { WeChatStore } from '../../utils/chat_store'

@Component
export struct Connect {
  @State userList: UserInfoModel[] = []
  @State filterList: UserInfoModel[] = []
  @Watch('updateFilterList')
  @State searchName: string = ''

  aboutToAppear(): void {
    this.getUserList()

  }

  updateFilterList() {

    if (this.searchName) {
      this.filterList = this.userList.filter(item => item.username.includes(this.searchName))
    }else{
      this.filterList = this.userList
    }

  }

  getUserList() {
    this.userList = WeChatStore.getWeChatConnect()
    this.updateFilterList()
  }

  build() {
    Column() {
      Row() {
        Search({
          placeholder: '搜索',
          value: $$this.searchName
        }).height(30).borderRadius(4).padding({
          left: 10,
          right: 10
        }).backgroundColor($r('app.color.white'))
      }.width('100%')

      List() {
        ForEach(this.filterList, (item: UserInfoModel) => {
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
          }).onClick(() => {
            router.pushUrl({ url: 'pages/ChatDetail/ChatDetail',params:item })

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