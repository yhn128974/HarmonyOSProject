import { audio } from '@kit.AudioKit'
import { media } from '@kit.MediaKit'

export class AVplayer {
  avplayer: media.AVPlayer | null = null //初始属性
  count: number = 0

  async init() {
    this.avplayer = await media.createAVPlayer()
  }

  watchCallBack() {
    this.avplayer?.on("stateChange", (state: string) => {
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info('AVPlayer state idle called.');
          this.avplayer?.release(); // 调用release接口销毁实例对象
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报  ，要给avplayer的url或者fdsrc赋值就可以触发初始化
          console.info('AVPlayer state initialized called.');
          this.avplayer?.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          console.info('AVPlayer state prepared called.');
          this.avplayer?.play(); // 调用播放接口开始播放
          break;
        case 'playing': // play成功调用后触发该状态机上报
          console.info('AVPlayer state playing called.');

          break;
        case 'paused': // pause成功调用后触发该状态机上报
          console.info('AVPlayer state paused called.');

          break;
        case 'completed': // 播放结束后触发该状态机上报
          console.info('AVPlayer state completed called.');
          this.avplayer?.stop(); //调用播放结束接口
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          console.info('AVPlayer state stopped called.');
          this.avplayer?.reset(); // 调用reset接口初始化avplayer状态
          break;
        case 'released':
          console.info('AVPlayer state released called.');
          break;
        default:
          console.info('AVPlayer state unknown called.');
          break;
      }
    })
  }

  //   play 播放方法
  async play(fileName: string) {
    const fileDes = await getContext().resourceManager.getRawFd(fileName)
    //
    this.avplayer!.fdSrc = fileDes

  }
}