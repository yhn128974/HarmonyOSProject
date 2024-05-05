// 用来播放pcm音频
import { audio } from '@kit.AudioKit'
import { fileIo } from '@kit.CoreFileKit';

export class AudioRenderer {
  // 实例
  static renderModel: audio.AudioRenderer
  // 采样配置
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
    channels: audio.AudioChannel.CHANNEL_2,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  };
  static audioRendererInfo: audio.AudioRendererInfo = {
    rendererFlags: 0, // 音频渲染器 0 普通  1 低时延 (不支持)
    usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION
    // 场景
  }
  // 创建播放器的参数准备好了
  static audioRendererOptions: audio.AudioRendererOptions = {
    streamInfo: AudioRenderer.audioStreamInfo,
    rendererInfo: AudioRenderer.audioRendererInfo
  }
  // 初始化方法
  static async init() {
    if (!AudioRenderer.renderModel) {
      // 创建实例
      AudioRenderer.renderModel = await audio.createAudioRenderer(AudioRenderer.audioRendererOptions)
    }
  }
  // 音频的释放和暂停
  static async stop() {
    if (AudioRenderer.renderModel) {
      await AudioRenderer.renderModel.stop() // 通知方法
    }
  }
  // 开始语音播放
  static async start(filePath: string, callback?: () => void) {
    if (AudioRenderer.renderModel && filePath) {
      // 先管一下状态
      // 如果你在播的情况下 还能播吗？
      // 什么情况下能播？ 暂停 停止 准备
      let stateList: audio.AudioState [] = [
        audio.AudioState.STATE_PREPARED,
        audio.AudioState.STATE_PAUSED,
        audio.AudioState.STATE_STOPPED
      ]
      if (!stateList.includes(AudioRenderer.renderModel.state)) {
        // 不包含的情况下 此时就不能播了
        return
      }
      // 此时可以播
      await AudioRenderer.renderModel.start() // 启动播放
      // 读写文件 filePath的文件 一段段的读取 读完拉到 关闭文件 停止播放
      const file = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY) // 读这个文件的buffer  一段段的读取 1280

      const stat = fileIo.statSync(file.fd) // 详细信息
      const bufferSize = await AudioRenderer.renderModel.getBufferSize() // 获取缓冲区的长度
      let buf = new ArrayBuffer(bufferSize) // 创建一个缓冲区对象 长度是音频采集器长度的长度
      let totalSize = 0 // 总量值
      while (totalSize < stat.size) {
        fileIo.readSync(file.fd, buf, {
          offset: totalSize,
          length: bufferSize
        })
        // 坑点- write是个异步方法  需要一段段的去播放 需要写入完这一段以后 再去写入下一段
        await AudioRenderer.renderModel.write(buf) // 往音频采集器写入缓冲区内容  播完再下一段
        if (AudioRenderer.renderModel!.state.valueOf() === audio.AudioState.STATE_RELEASED) { // 如果渲染器状态为released，关闭资源
          fileIo.close(file);
        }
        // 此时要继续
        totalSize += bufferSize
      }
      // 关闭文件
      fileIo.closeSync(file.fd)
      AudioRenderer.stop() // 关闭
      callback && callback()
    }
  }

  // 释放
  static async release() {
    if (AudioRenderer.renderModel) {
      await AudioRenderer.renderModel.release() // 释放方法
    }
  }
}