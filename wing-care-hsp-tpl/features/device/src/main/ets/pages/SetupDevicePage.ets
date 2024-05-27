import { EcDialogTips } from '@itheima/wing-care'
import { FloorSelDialog } from './components/FloorSelDialog'
import router from '@ohos.router'
import { ResManager } from '@hm/basic/Index'

class FormData {
  /**
   * 位置类型 0：随身设备 1：固定设备
   */
  locationType: number = 0
}

@Entry
@Component
struct SetupDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 表单
  @State
  formData: FormData = {
    locationType: 1
  }

  // 1. 查看字段填写说明
  @Builder
  lookTips() {
    Column() {
      Text('设备标识为设备的 mac 地址\n' +
        '例如：48-BC-73-A7-BB-B5')
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_CARD_FS)
        .lineHeight(18)
    }
    .width('100%')
    .padding({ left: 18, bottom: 18 })
    .alignItems(HorizontalAlign.Start)
  }
  lookDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips({
      title: '输入规则',
      // 解决 this 指向问题
      tipsContent: () => {
        this.lookTips()
      },
      cancelButton: {
        text: '我知道了',
        color: ResManager.EC_MAIN_COLOR,
        cb: () => {

        }
      }
    }),
    alignment: DialogAlignment.Center
  })

  // 2. 选择接入位置-楼层
  floorSelDialog: CustomDialogController = new CustomDialogController({
    builder: FloorSelDialog({
      onConfirm: () => {

      }
    })
  })
  selLocation() {
    if (this.formData.locationType === 0) {
      // 选择老人
      router.pushUrl({
        url: 'pages/device/ElderSelPage'
      })
    } else {
      // 选择楼层-房间-床位
      this.floorSelDialog.open()
    }
  }

  // 3. 提交绑定
  bindDevice() {
    router.pushUrl({
      url: 'pages/device/SetupTipPage'
    })
  }

  build() {
    Navigation() {
      // 1. 设备安装表单
      Column() {
        // Text(this.formData.type)
        List() {
          ListItem() {
            Row() {
              Row({ space: 10 }) {
                Text('设备标识码')
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)
                Image(ResManager.IC_SBAZ_XQ)
                  .width(14)
                  .aspectRatio(1)
                  .onClick(() => {
                    this.lookDialog.open()
                  })
              }

              Row() {
                TextInput({ placeholder: '请输入设备标识码' })
                  .placeholderColor(ResManager.EC_MID_99)
                  .placeholderFont({ size: ResManager.EC_NORMAL_FS })
                  .backgroundColor('#fff')
                  .width('70%')
                  .textAlign(TextAlign.End)
                  .padding({ right: 20 })
                // Image($r('app.media.ic_arrow_black'))
                //   .width(7)
                //   .height(16)
              }
            }
            .width('100%')
            .padding({ top: 5, bottom: 5 })
            .justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Row({ space: 10 }) {
                Text('设备名称')
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)
                // Image(ResManager.IC_SBAZ_XQ)
                //   .width(14)
                //   .aspectRatio(1)
              }

              Row() {
                TextInput({ placeholder: '请输入设备名称' })
                  .placeholderColor(ResManager.EC_MID_99)
                  .placeholderFont({ size: ResManager.EC_NORMAL_FS })
                  .backgroundColor('#fff')
                  .width('70%')
                  .textAlign(TextAlign.End)
                  .padding({ right: 20 })
              }
            }
            .width('100%')
            .padding({ top: 5, bottom: 5 })
            .justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Row({ space: 10 }) {
                Text('设备类型')
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)
                // Image(ResManager.IC_SBAZ_XQ)
                //   .width(14)
                //   .aspectRatio(1)
              }

              Row() {
                Row() {
                  Radio({ value: '0', group: 'radioGroup' })
                    .checked(this.formData.locationType === 0)
                    .width(20)
                    .aspectRatio(1)
                    .radioStyle({
                      checkedBackgroundColor: ResManager.EC_MAIN_COLOR
                    })
                    .onChange((isChecked: boolean) => {
                      console.log('Radio1 status is ' + isChecked)
                      if (isChecked) {
                        this.formData.locationType = 0
                      }
                    })
                    .margin({ right: 8 })
                  Text('随身设备')
                    .fontColor(ResManager.EC_MID_59)
                    .fontSize(ResManager.EC_NORMAL_FS)
                }
                .margin({ right: 18 })
                .height(40)

                Row() {
                  Radio({ value: '1', group: 'radioGroup' })
                    .checked(this.formData.locationType === 1)
                    .width(20)
                    .aspectRatio(1)
                    .radioStyle({
                      checkedBackgroundColor: ResManager.EC_MAIN_COLOR
                    })
                    .onChange((isChecked: boolean) => {
                      console.log('Radio2 status is ' + isChecked)
                      if (isChecked) {
                        this.formData.locationType = 1
                      }
                    })
                    .margin({ right: 8 })
                  Text('固定设备')
                    .fontColor(ResManager.EC_MID_59)
                    .fontSize(ResManager.EC_NORMAL_FS)
                }
                .height(40)
              }
            }
            .width('100%')
            .padding({ top: 5, bottom: 5 })
            .justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Row({ space: 10 }) {
                Text('接入位置')
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)
                // Image(ResManager.IC_SBAZ_XQ)
                //   .width(14)
                //   .aspectRatio(1)
              }

              Row() {
                Text('请选择接入位置')
                  .fontColor(true ? ResManager.EC_MID_19 : ResManager.EC_MID_99)
                  .fontSize(ResManager.EC_NORMAL_FS)
                  .width(150)
                  .height(40)
                  .textAlign(TextAlign.End)
                  .margin({ right: 14 })
                Image($r('app.media.ic_arrow_black'))
                  .width(7)
                  .height(16)
                  .margin({ right: 4 })
              }
              .onClick(() => {
                this.selLocation()
              })
            }
            .width('100%')
            .padding({ top: 5, bottom: 5 })
            .justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Row({ space: 10 }) {
                Text('所属产品')
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)
                // Image(ResManager.IC_SBAZ_XQ)
                //   .width(14)
                //   .aspectRatio(1)
              }

              Row() {
                Text('请选择产品')
                  .fontColor(ResManager.EC_MID_99)
                  .fontSize(ResManager.EC_NORMAL_FS)
                  .width(150)
                  .height(40)
                  .textAlign(TextAlign.End)
                  .margin({ right: 14 })
                Image($r('app.media.ic_arrow_black'))
                  .width(7)
                  .height(16)
                  .margin({ right: 4 })
              }
              .onClick(() => router.pushUrl({ url: 'pages/device/ProductDevicePage' }))
            }
            .width('100%')
            .padding({ top: 5, bottom: 5 })
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .height('auto')
        .padding({ left: 14, right: 18, })
        .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
      }
      .margin({ left: ResManager.EC_CONTENT_SPACE, right: ResManager.EC_CONTENT_SPACE })
      // .width('100%')
      .backgroundColor('#fff')
      .borderRadius(ResManager.EC_NORMAL_RD)

      // 2. 提交
      Button('提交')
        .margin({ top: 50 })
        .width(230)
        .backgroundColor(ResManager.EC_MAIN_COLOR)
        .onClick(() => {
          this.bindDevice()
        })
    }
    .title('设备安装')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}