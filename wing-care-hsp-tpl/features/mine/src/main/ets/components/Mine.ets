import router from '@ohos.router'
import { ResManager, RouterConfig, UserData, UserSore } from '@hm/basic/Index'
import { getUserApi } from '../api'
import { promptAction } from '@kit.ArkUI'
import { preferences } from '@kit.ArkData'

@Component
export struct Mine {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageLink('UserInfo')
  user: UserData | null = null

  async getUser() {
    const data = await getUserApi()
    this.user = data
    AppStorage.setOrCreate('UserInfo', data)
  }

  aboutToAppear(): void {
    this.getUser()
  }

  async logOut() {
    const checkedRes = await promptAction.showDialog({
      title: '提示',
      message: "确定退出等于吗",
      buttons: [
        {
          text: '取消',
          color: '#ccc'
        }, {
        text: '确定',
        color: '#000'
      }
      ]
    })
    if (checkedRes.index === 1) {
      UserSore.delUser()
      router.replaceUrl({
        url: RouterConfig.LOGIN_URL
      }, () => {
        // 清除路由历史记录
        router.clear()
        
      })
    }

  }

  @Builder
  cellItem(title: string, url: string = '') {
    Row() {
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_MODULE_TITLE_FS)
        .fontWeight(500)
      Row() {
        Image($r('app.media.ic_arrow_black'))
          .width(7)
          .height(16)
      }
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(() => router.pushUrl({ url }))
  }

  build() {
    Column() {
      // 1. 头部
      Column() {
        Text('我的')
          .width('100%')
          .fontColor(ResManager.EC_MID_BLACK)
          .fontSize(ResManager.EC_BIG_TITLE_FS)
          .fontWeight(500)
          .margin({ top: 12, left: 24 })
          .padding({ top: this.topHeight })
        // 个人信息

        Column({ space: 5 }) {
          Image(this.user?.avatar || 'https://img2.baidu.com/it/u=130573784,2479509663&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=534')
            .width(74)
            .aspectRatio(1)
            .borderRadius(37)
            .border({ width: 5, color: '#AEE8E4' })
            .shadow({ offsetX: 0, offsetY: 2, radius: 21, color: '#0aa9941f' })
            .onClick(() => {
              router.pushUrl({
                url: RouterConfig.USER_SET_URL
              })
            })
          Text(this.user?.nickName)
            .fontSize(ResManager.EC_PAGE_TITLE_FS)
            .fontColor(ResManager.EC_MID_BLACK)
            .fontWeight(500)
          Text(this.user?.username)
            .fontSize(13)
            .fontColor(ResManager.EC_MID_59)
        }
        .margin({ top: 64 - this.topHeight })
      }
      .width('100%')
      .height(330)
      .backgroundImage($r('app.media.pic_wd_bj'))
      .backgroundImageSize(ImageSize.Cover)

      // 2. 快捷导航1
      Column() {
        Row({ space: 5 }) {
          Text('设备管理')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
          // Image($r('app.media.ic_arrow_black'))
          //   .width(7)
          //   .height(16)


        }
        .width('100%')

        // 导航：设备管理
        Row({ space: 10 }) {

        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

      }
      .margin({ top: -80, left: ResManager.EC_CONTENT_SPACE, right: ResManager.EC_CONTENT_SPACE })
      // .width('100%')
      .padding({
        top: ResManager.EC_CONTENT_SPACE,
        left: ResManager.EC_CONTENT_SPACE,
        right: ResManager.EC_CONTENT_SPACE
      })
      .backgroundColor('rgba(255,255,255, 0.6)')
      .borderRadius(ResManager.EC_NORMAL_RD)

      // 3. 快捷导航2
      Column() {
        List() {
          ListItem() {
            this.cellItem('我的消息', 'pages/message/MsgPage')
          }
        }
        .width('100%')
        .height('auto')
        .padding({ left: 14, right: 18, })
        .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
      }
      .margin({
        top: ResManager.EC_CONTENT_SPACE,
        left: ResManager.EC_CONTENT_SPACE,
        right: ResManager.EC_CONTENT_SPACE
      })
      // .width('100%')
      .backgroundColor('#fff')
      .borderRadius(ResManager.EC_NORMAL_RD)

      Button('退出')
        .fontColor(ResManager.EC_MID_19)
        .width(230)
        .height(40)
        .borderRadius(28)
        .backgroundColor('#fff')
        .margin({ top: 50 })
        .onClick(() => {
          this.logOut()

        })


    }
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)

  }
}