import { promptAction } from '@kit.ArkUI';
import { AVPlayerClass } from '@itheima/wing-care';
import { ResManager } from '@hm/basic/Index';

@Entry
@Component
struct RemoteOpenPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 进度条
  @State
  progress: number = 0
  intervalId: number = -1
  duration = 3000; // 3秒(执行时长)
  interval = 50; // 更新间隔时间(按需调整)
  // 记录长按次数
  @State
  pressCount: number = 0

  // 进度动画
  run() {
    // 防止重复点击
    if (this.intervalId !== -1) {
      return;
    }
    const steps = this.duration / this.interval;
    // 间隔时间每次进度数据
    const stepSize = 100 / steps;

    this.intervalId = setInterval(() => {
      // console.info('进度和步长：', this.progress, stepSize)
      if (this.progress < 100) {
        this.progress += stepSize;
      } else {
        // 保证最终值为100%(精度修正)
        this.progress = 100;
        // 清除interval
        clearInterval(this.intervalId);
        this.intervalId = -1;
      }
    }, this.interval);
  }

  reset() {
    clearInterval(this.intervalId)
    this.pressCount = 0
    this.progress = 0
    this.intervalId = -1
  }

  // 开门逻辑
  openDoor() {
    promptAction.showToast({ message: '开门成功' })
    setTimeout(() => {
      this.reset()
    }, 3600)
  }

  build() {
    Navigation() {
      Column() {
        Stack({ alignContent: Alignment.Top }) {
          Stack({ alignContent: Alignment.Center }) {
            Progress({ value: this.progress, total: 100, type: ProgressType.Ring })
              .color(ResManager.EC_MAIN_COLOR)
              .width(216)// 进度环显隐控制
              .aspectRatio(1)// .backgroundColor(this.pressCount > 0 ? '#EEF7F6' : '#fff')
              .style({ strokeWidth: 10, scaleCount: 60 })
              .opacity(this.pressCount > 0 ? 1 : 0)// 重置回退效果处理
              .animation({ duration: 100 })
            Column() {
              // Image($r('app.media.ic_kaimen'))
              //   .width(50)
              //   .aspectRatio(1)
              Column()
                .width(50)
                .aspectRatio(1)
                .backgroundImage($r('app.media.ic_kaimen'))
                .backgroundImageSize({ width: 50 })
              Text('开门')
                .fontColor('#fff')
                .fontSize(23)
                .fontWeight(500)
            }
            .width(156)
            .aspectRatio(1)
            .justifyContent(FlexAlign.Center)
            .borderRadius(78)
            .linearGradient({
              angle: 180,
              // 按下之后变色
              colors: [['#07E4DA', this.pressCount > 0 ? 100 : 0], ['#03C4B3', 100]]
            })
            .gesture(
              LongPressGesture({ repeat: true })// 由于repeat设置为true，长按动作存在时会连续触发，触发间隔为duration（默认值500ms）
                .onAction((event?: GestureEvent) => {
                  // 500ms 计算一次
                  if (event && event.repeat) {

                  }
                })// 长按动作一结束触发
                .onActionEnd(() => {


                })
            )
          }
          .margin({ top: 58 })

          if (this.pressCount === 6) {
            Image($r('app.media.pic_sh'))
              .width('100%')
              .aspectRatio(1)
          }
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff')
    }
    .title('远程开门')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}