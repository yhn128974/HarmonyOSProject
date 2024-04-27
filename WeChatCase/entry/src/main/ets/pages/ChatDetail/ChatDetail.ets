import router from '@ohos.router';

@Entry
@Component
struct ChatDetail {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Row() {
        Stack({
          alignContent: Alignment.Start
        }) {
          Image($r('app.media.ic_public_arrow_left')).width(30).aspectRatio(1).onClick(() => {
            router.back();
          }).zIndex(2)
          Text('小乖乖').fontSize($r('app.color.text_primary')).width('100%').textAlign(TextAlign.Center)
        }
      }
    }
  }
}