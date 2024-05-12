
import  {getRenderItem} from '../ComPonents'
@Component
export default struct DisCover {


  build() {
    Column() {
      Row() {
        Text("发现")
      }
      .justifyContent(FlexAlign.Center)
      .height(40)
      .width('100%')

      Scroll() {
        Column() {
          // 顶部
          getRenderItem("朋友圈")
          Row().height(10)
          getRenderItem("视频号")
          getRenderItem("直播")
          Row().height(10)
          getRenderItem("扫一扫")
          getRenderItem("摇一摇")
          Row().height(10)
          getRenderItem("看一看")
          getRenderItem("搜一搜")
          Row().height(10)
          getRenderItem("附近")
          Row().height(10)
          getRenderItem("购物")
          getRenderItem("游戏")
          Row().height(10)
          getRenderItem("小程序")
          Row().height(10)
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
  }
}