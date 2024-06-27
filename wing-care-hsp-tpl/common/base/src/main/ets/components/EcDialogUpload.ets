import picker from '@ohos.file.picker'
import cameraPicker from '@ohos.multimedia.cameraPicker';
import camera from '@ohos.multimedia.camera';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { Log } from '@abner/log';

@CustomDialog
export struct EcDialogUpload {
  // 控制器
  controller: CustomDialogController
  getPhotoUrl: (uri: string) => void = () => {
  }

  async takePhoto() {
    let mContext = getContext(this) as common.Context;
    try {
      let pickerProfile: cameraPicker.PickerProfile = {
        // 相机位置
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      // cameraPicker.pick拍照返回相机结果对象 类型为<cameraPicker.PickerResult>
      let pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(mContext,
        [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO], pickerProfile);
      console.log("the pick pickerResult is:" + JSON.stringify(pickerResult));
      // cameraPicker.PickerResult.resultUri 拍照获得的对象存放位置
      Log.info(pickerResult.resultUri)
      // 回传数据
      this.getPhotoUrl(pickerResult.resultUri as string)
    } catch (error) {
      let err = error as BusinessError;
      console.error(`the pick call failed. error code: ${err.code}`);
    }
  }

  selectPhoto() {
    // picker.PhotoSelectOptions 配置相册选择参数
    const photoSelectOptions = new picker.PhotoSelectOptions
    photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
    photoSelectOptions.maxSelectNumber = 1
    // picker.PhotoViewPicker相测选择执行对象
    const photoViewPicker = new picker.PhotoViewPicker
    photoViewPicker.select(photoSelectOptions)
      .then(result => {
        // 得到文件路径


        this.getPhotoUrl(result.photoUris[0] as string)

      })
  }

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
            .onClick(() => {
              this.takePhoto()
            })
        }

        ListItem() {
          Text('从相册选择')
            .fontColor($r('app.color.ec_main_color'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
            .onClick(() => {
              this.selectPhoto()
            })
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
