import { fileIo, picker } from '@kit.CoreFileKit'
import { ImageUrl } from '../models'
import { HmPreview } from './HMPreview'
import { JSON, util } from '@kit.ArkTS'
import { request } from '@kit.BasicServicesKit'
import { uploadImageUrl } from '../api'

@Component
export struct HmUpload {
  @Prop
  title: string = "请拍照上传回单凭证"
  @Prop maxNumber: number = 3
  // 当前的图片列表
  @Prop currentImageList: ImageUrl[] = []
  @State clickedImageIndex: number = -1
  @Prop canUpload: boolean = true
  // 给父组件同步数据
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
      //标题
      Text(this.title).fontSize(14).fontColor($r("app.color.text_secondary")).margin({
        top: 16,
        bottom: 16
      })
      //图片展示
      Grid() {
        ForEach(this.currentImageList, (item: ImageUrl, index: number) => {
          GridItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(item.url).width(100).aspectRatio(1).borderRadius(4).onClick(() => {
                this.clickedImageIndex = index;
                this.preview.open()
              })
              if (this.canUpload) {
                Image($r('app.media.ic_btn_delete')).width(30).height(30)
                  .onClick(() => {
                    this.currentImageList.splice(index, 1) //移除索引
                    this.handleCurrentImageListChange(this.currentImageList)
                  })
              }
            }
          }
        })

        GridItem() {
          //添加图标
          if (this.currentImageList.length < this.maxNumber && this.canUpload) {
            Row() {
              Image($r("app.media.ic_add_img")).width(30).height(30)
            }
            .width(100)
            .height(100)
            .borderRadius(4)
            .backgroundColor('#F2F2F2')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.selectImg()
            })
          }
        }
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')
      .height(Math.ceil(this.maxNumber / 3) * 110)
    }.alignItems(HorizontalAlign.Start).width('100%')
  }
}


export async function UploadFile(list: ImageUrl[]) {
  let saveDir = getContext().cacheDir //存储的目录
  //要提交的参数
  const fileParams: request.File[] = []
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
  // 返回本地文件
  return await uploadImageUrl(getContext(), fileParams) // 调用上传接口 // 将上传的结果再返回上一层
}