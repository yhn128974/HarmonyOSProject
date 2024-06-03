import { ResManager } from '@hm/basic'
import { AVPlayerClass } from '@itheima/wing-care'
import { sensor } from '@kit.SensorServiceKit'
import { Log } from '@abner/log'
import { EcBlueDevice } from '../../utils/EcBlueDevice'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct BluetoothOpenPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State angle: number = 0
  timer: number = -1
  /////////////////////////
  //摇一摇参数
  startRange: number = 50 // 两次加速度差值大于阈值，判定进行了摇一摇
  endRange: number = 10 // 两次加速度差值小于阈值，停止摇动手机
  @State
  isShake: boolean = false // 是否摇动手机
  lastX: number = 0
  lastY: number = 0
  lastZ: number = 0

  ///////////////////////////
  // 1. 摇一摇动画
  run() {
    this.timer = setInterval(() => {
      if (this.angle !== 30) {
        this.angle = 30
      } else {
        this.angle = 0
      }
    }, 200)
  }

  stop() {
    setTimeout(() => {
      // 关闭动画
      clearInterval(this.timer)
    }, 600)
  }

  onSensor() {
    try {
      // (传感器类型 ,回调函数,可选参数列表?)
      sensor.on(sensor.SensorId.ACCELEROMETER, (data: sensor.AccelerometerResponse) => {
        Log.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
        Log.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
        Log.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
        // 摇一摇检测...
        this.handleShake(data)
      }, { interval: 1e8 });
    } catch (error) {
      Log.error(error)
    }
  }

  handleShake(data: sensor.AccelerometerResponse) {
    /**
     1. 获取手机两次加速度差值range
     a. Math.abs(data.x - this.lastX) + Math.abs(data.y - this.lastY) + Math.abs(data.z - this.lastZ)
     2. range 大于startRange阈值，开始摇动手机了
     a. isShake：true
     3. range 小于endRange同时上一次已经开始摇动手机了=> 摇一摇完成，执行业务
     a. isShake：false
     4. 记录最后一次摇一摇加速度
     */
    let range = Math.abs(data.x - this.lastX) + Math.abs(data.y - this.lastY) + Math.abs(data.z - this.lastZ)
    if (range > this.startRange) {
      // 播放音频
      AVPlayerClass.playAudio("audio_shake.mp3")
      // 开始摇一摇
      this.isShake = true
      this.openDoor()
    }
    if (range < this.endRange && this.isShake) {
      // 结束摇一摇,执行业务
      this.isShake = false
      AlertDialog.show({ message: '摇一摇了！' })
    }
    // 记录最后一次摇一摇加速度
    this.lastX = data.x
    this.lastY = data.y
    this.lastZ = data.z
  }

  // 3. 蓝牙开门
  async openDoor() {
    // 开始动画
    this.run()
    const res = await EcBlueDevice.sendWifiData({
      //  蓝牙开门
      command: 'open'
    })
    if (res) {
      this.stop()
      promptAction.showToast({
        message: '开门成功'
      })

    } else {
      this.stop()
      promptAction.showToast({
        message: '开门失败'

      })

    }

  }

  aboutToAppear(): void {
    this.onSensor()
  }

  aboutToDisappear(): void {
    sensor.off(sensor.SensorId.ACCELEROMETER);
  }

  build() {
    Navigation() {
      Column() {
        Text('摇一摇开门')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(18)
          .fontWeight(600)
          .margin({ top: 94, bottom: 58 })
        Image($r('app.media.ic_lykm_yyy'))
          .width(126)
          .aspectRatio(1)
          .rotate({
            angle: this.angle
          })
          .animation({ duration: 200 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff')
    }
    .title('蓝牙开门')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}