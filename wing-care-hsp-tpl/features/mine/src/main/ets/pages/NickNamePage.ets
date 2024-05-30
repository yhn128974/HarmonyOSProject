import { ResManager, UserData } from '@hm/basic/Index';
import { updateUserNameApi } from '../api';
import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct NickNamePage {
  @State currentNickName: string = ''
  @StorageLink('UserInfo')
  user: UserData | null = null
  @StorageProp('topHeight')
  topHeight: number = 0

  // 提交
  async save() {
    if (this.user?.nickName) {

      await updateUserNameApi(this.currentNickName)
      this.user.nickName = this.currentNickName
      promptAction.showToast({
        message: '昵称修改成功'
      })
      router.back()

    }


  }

  enableSave(): boolean {
    if (this.currentNickName) {
      return true
    } else {
      return false
    }
  }

  build() {
    Navigation() {
      Column() {
        // Text(this.nickname)
        TextInput({ text: $$this.currentNickName, placeholder: '请输入昵称' })
          .height(50)
          .borderRadius(ResManager.EC_NORMAL_RD)
          .backgroundColor('#fff')
          .placeholderColor(ResManager.EC_MID_99)
        //   提交
        Button('保存', { type: ButtonType.Capsule })
          .margin({ top: 50 })
          .width(230)
          .enabled(false)
          .onClick(() => {
            this.save()
          })
          .enabled(this.enableSave())
      }
      .margin({ left: 15, right: 15 })

    }
    .title('昵称')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor(ResManager.EC_MID_BG)
  }
}