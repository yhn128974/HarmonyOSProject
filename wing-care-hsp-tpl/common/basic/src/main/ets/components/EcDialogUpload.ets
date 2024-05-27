import picker from '@ohos.file.picker'
import cameraPicker from '@ohos.multimedia.cameraPicker';
import camera from '@ohos.multimedia.camera';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';

@CustomDialog
export struct EcDialogUpload {
  // 控制器
  controller: CustomDialogController

  build() {
    Column() {
      // 选项列表
      List() {
        ListItem() {
          Text('拍照')
            .fontColor($r('app.color.ec_main_color'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }

        ListItem() {
          Text('从相册选择')
            .fontColor($r('app.color.ec_main_color'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }

        ListItem() {
          Text('取消')
            .fontColor($r('app.color.ec_mid_59'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
      }
      .width('100%')
      .height('auto')
      .divider({ strokeWidth: 0.5, color: $r('app.color.ec_mid_line') })
      .padding($r('app.float.ec_content_space'))
      .backgroundColor('#fff')
      .borderRadius($r('app.float.ec_normal_radius'))

    }
  }
}
