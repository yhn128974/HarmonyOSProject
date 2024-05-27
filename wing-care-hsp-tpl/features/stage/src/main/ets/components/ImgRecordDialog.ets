@CustomDialog
export struct ImgRecordDialog  {

  controller: CustomDialogController
  build() {
    Column(){
      Image('https://p3.itc.cn/images01/20210302/4ffe526e31724d88bea813d0f9ce31a6.jpeg')
        .width('100%')
        .aspectRatio(1.3)
    }
  }
}