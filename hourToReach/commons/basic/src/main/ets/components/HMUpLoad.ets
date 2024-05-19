import { fileIo, picker } from '@kit.CoreFileKit'
import { ImageUrl } from '../models'
import { HmPreview } from './HMPreview'
import { JSON, util } from '@kit.ArkTS'
import { Request } from '../api'
import { request } from '@kit.BasicServicesKit'
import { promptAction } from '@kit.ArkUI'

@Component
export struct HmUpload {
  @Prop
  title: string = "请拍照上传回单凭证"
  @Prop maxNumber: number = 3
  @Prop currentImageList: ImageUrl[] = []
  @State clickedImageIndex: number = -1
  handleCurrentImageListChange: (list: ImageUrl[]) => void = () => {
  }
  preview: CustomDialogController = new CustomDialogController({
    builder: HmPreview({
      urls: this.currentImageList.map(item => item.url),
      selectIndex: this.clickedImageIndex
    }),
    customStyle: true
  })

  async selectImg() {
    const photo = new picker.PhotoViewPicker() //图片选择对象

    const result = await photo.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: this.maxNumber - this.currentImageList.length
    })
    if (result.photoUris.length > 0) {

      let newImageList = result.photoUris.map(item => ({ url: item }) as ImageUrl)
      this.currentImageList.push(...newImageList)
      this.handleCurrentImageListChange(this.currentImageList)
    }

  }

  build() {
    Column() {
      //
      Text(this.title).fontSize(14).fontColor($r("app.color.text_secondary")).margin({
        top: 16,
        bottom: 16
      })
      //图片展示
      Grid() {
        ForEach(this.currentImageList, (item: ImageUrl, index: number) => {
          GridItem() {
            Image(item.url).width(100).aspectRatio(1).borderRadius(4).onClick(() => {
              this.clickedImageIndex = index;
              this.preview.open()

            })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')
      .height(Math.ceil(this.maxNumber / 3) * 110)

      //
      if (this.currentImageList.length < this.maxNumber) {
        Row() {
          Image($r("app.media.ic_add_img")).width(30).height(30)
        }
        .width(95)
        .height(95)
        .backgroundColor('#F2F2F2')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.selectImg()
        })
      }


    }.alignItems(HorizontalAlign.Start).width('100%')
  }
}

export function UploadFile(list: ImageUrl[]) {

  let saveDir = getContext().cacheDir //存储的目录
  const fileParams: request.File[] = [] //要提交的参数
  // 因为上传文件需要从沙箱选择文件,所以需要先把相册的文件拷贝到沙箱
  list.forEach(item => {
    const file = fileIo.openSync(item.url, fileIo.OpenMode.READ_ONLY) //读取相册的文件
    //   相册地址
    const uniqueName = util.generateRandomUUID() + '.jpg'
    fileIo.copyFileSync(file.fd, saveDir + "/" + uniqueName)
    fileParams.push({
      filename: uniqueName,
      name: 'file', //接口参数名称
      type: 'jpg', //文件类型后缀
      uri: `internal://cache/${uniqueName}` //应该是文件放在cache目录下,如果是cache协议 它会自动找到这个文件
    })
    fileIo.closeSync(file.fd)
  })
  promptAction.showToast({
    message: JSON.stringify(fileParams)
  })

}


