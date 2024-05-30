import router from '@ohos.router'
import { EcDialogUpload, ResManager, RouterConfig, UserData, uploadApi } from '@hm/basic'
import { Log } from '@abner/log'
import { EcLoading } from '@itheima/wing-care'
import fs from '@ohos.file.fs'
import { FormData } from '@ohos/axios'
import { updateUserPhotoApi } from '../api'
import { promptAction } from '@kit.ArkUI'

interface cellItemParam {
  title: string,
  rightContent?: string
}

@Entry
@Component
struct MinePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 1. 获取用户信息
  @StorageProp('UserInfo')
  user: UserData | null = null
  // 全屏 loading 弹层
  loading: CustomDialogController = new CustomDialogController({
    builder: EcLoading({ tip: '上传中...' }),
    customStyle: true,
    autoCancel: false,
    alignment: DialogAlignment.Center
  })
  // 上传弹层控制
  uploadDialog: CustomDialogController = new CustomDialogController({
    // 使用自定义弹层组件
    builder: EcDialogUpload({
      getPhotoUrl: async (uri: string) => {
        Log.info(uri)
        await this.handleAvatarUpload(uri)
        this.uploadDialog.close()
      }
    }),
    alignment: DialogAlignment.Bottom
  })

  async handleAvatarUpload(uri: string) {
    try {
      this.loading.open()
      // 将文件保存到沙箱
      let currentContext = getContext()
      // 1. 读取 uri
      // 打开文件指定打开模式
      let file = fs.openSync(uri, fs.OpenMode.READ_ONLY)

      let copyFilePath = currentContext.cacheDir + '/' + file.name

      // fs.copyFileSync (原始路径,新路径)
      fs.copyFileSync(file.fd, copyFilePath)

      // 生成formData格式
      let formData = new FormData()
      formData.append('file', `internal://cache/${file.name}`)

      // 上传文件
      const newAvatarUrl = await uploadApi(formData, currentContext)
      // 后台更新用户图片
      this.user!.avatar = newAvatarUrl
      await updateUserPhotoApi(newAvatarUrl)


      this.loading.close()
      promptAction.showToast({ message: '修改成功' })
    } catch (e) {
      this.loading.close()
      Log.error(e)
    }

  }

  @Builder
  cellItem(currentParam: cellItemParam) {
    Row() {
      Text(currentParam.title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_MODULE_TITLE_FS)
        .fontWeight(500)
      Row({ space: 10 }) {
        if (!!currentParam.rightContent) {
          // 昵称修改
          Text(currentParam.rightContent)
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_NORMAL_FS)
            .onClick(() => {
              router.pushUrl({
                url: RouterConfig.USER_NAME_URL
              })
            })
        } else {
          // 上传
          Image(this.user?.avatar)
            .width(34)
            .aspectRatio(1)
            .borderRadius(17)
            .onClick(() => {
              this.uploadDialog.open()
            })
        }
        Image($r('app.media.ic_arrow_black'))
          .width(7)
          .height(16)
      }
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Navigation() {
      Column() {
        Column() {
          List() {
            ListItem() {
              this.cellItem({ title: '头像' })
            }

            ListItem() {
              this.cellItem({ title: '昵称', rightContent: this.user?.nickName })
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
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title('个人设置')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
  }
}