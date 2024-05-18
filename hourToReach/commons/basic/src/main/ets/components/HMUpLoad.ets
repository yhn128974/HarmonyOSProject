import { picker } from '@kit.CoreFileKit'
import { ImageUrl } from '../models'
import { HmPreview } from './HMPreview'

@Component
struct HmUpload {
  @Prop
  title: string = "请拍照上传回单凭证"
  @Prop maxNumber: number = 3
  @State currentImageList: ImageUrl[] = []
  @State clickedImageIndex: number = -1
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

export { HmUpload }