import { Advert, USER_SETTING, USER_SETTING_AD, AdvertClass } from 'basic'
import { window } from '@kit.ArkUI'


@Entry
@Component
struct Start {
  @State
  myAdvert: AdvertClass = {
    showAd: false,
    adTime: 0
  }
  timer: number = -1

  closeAdvertWindow() {
    window.findWindow('ad_window').destroyWindow() //销毁窗口
  }

  async aboutToAppear() {

    // 开启沉浸式广告
    window.getLastWindow(getContext()).then((win) => {
      win.setWindowLayoutFullScreen(true)
    })

    const AdvertStore: Advert = new Advert(getContext(this), USER_SETTING)

    this.myAdvert = await AdvertStore.getUserAdvert(USER_SETTING_AD)


    this.timer = setInterval(() => {
      if (this.myAdvert.adTime === 0) {
        clearInterval(this.timer)
        this.closeAdvertWindow()
        return
      }
      this.myAdvert.adTime--
    }, 1000)
  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
    this.closeAdvertWindow()
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {

      Image(this.myAdvert?.adImg).objectFit(ImageFit.Cover)

      Text(`${this.myAdvert.adTime}秒后跳过`)
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: 20 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r("app.color.background_page"))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          clearInterval(this.timer)
          this.closeAdvertWindow()
        })

    }.height('100%').width('100%')

  }
}
