import { router } from '@kit.ArkUI'
import { generateBarcode, scanCore } from '@kit.ScanKit';
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct PayQrCode {
  // 二维码内容
  @State PayParms: string = Math.random().toString()
  timer: number = -1 //用来记录轮训
  // 二维码 条形码对象
  @State barCodeImage: PixelMap | null = null;

  aboutToAppear(): void {

    this.crateQrCodeValue() //二维码
    this.createBarCode() //条形码

  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  crateQrCodeValue() {
    this.timer = setInterval(() => {
      this.PayParms = Math.random().toString()
    }, 10000)
  }

  createBarCode() {
    try {
      let options: generateBarcode.CreateOptions = {
        scanType: scanCore.ScanType.CODE128_CODE,
        height: 200, //xp像素值
        width: 800
      }
      // 真机才能展示
      generateBarcode.createBarcode(this.PayParms, options, (error: BusinessError, pixelMap: image.PixelMap) => {
        this.barCodeImage = pixelMap;
      })
    } catch (error) {
      console.log("Qrmessage", JSON.stringify(error.message!))
    }

  }

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.ic_public_arrow_left'))
            .width(30)
            .height(30)
            .fillColor($r("app.color.white"))
            .onClick(() => {
              router.back()
            })
            .zIndex(2)

          Text("收付款")
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontColor($r('app.color.white'))
        }
        .height(50)
      }
      .padding({
        left: 10,
        right: 10
      })

      Row() {
        Column() {
          Row({ space: 10 }) {
            Image($r("app.media.ic_public_scan"))
              .width(20)
              .height(20)
              .fillColor($r("app.color.pay_back"))
            Text("付款码")
              .fontColor($r("app.color.pay_back"))
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .height(60)
          .border({
            width: {
              bottom: 0.5
            },
            color: $r("app.color.border_color")
          })

          // 显示码
          Image(this.barCodeImage).width(280).width(100)

          Column({ space: 20 }) {
            Text("优先使用xx银行储蓄卡付款")
              .fontColor($r("app.color.text_second"))
              .fontSize(12)

            //   展示一个二维码 PixelMap可以展示在Image上
            QRCode(this.PayParms).width(140).aspectRatio(1)
          }
          .margin({
            top: 10,
            bottom: 10
          })
        }
        .padding(10)
        .borderRadius(4)
        .width("100%")
        .backgroundColor($r("app.color.white"))
      }
      .padding({
        left: 10,
        right: 20
      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.pay_back"))
  }
}
