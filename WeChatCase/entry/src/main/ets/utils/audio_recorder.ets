import { audio } from '@kit.AudioKit'
import { fileIo } from '@kit.CoreFileKit'

export default class AudioCapturer {
  // 声明一个采音对象的单例对象
  static audioCapturer: audio.AudioCapturer
  // 录用配置
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_44100,
    channels: audio.AudioChannel.CHANNEL_1,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  }
  static audioCapturerInfo: audio.AudioCapturerInfo = {
    source: audio.SourceType.SOURCE_TYPE_MIC, // 音源类型
    capturerFlags: 0 // 音频采集器标志
  }
  static recordIng: boolean = false

  // 是否正在录制
  // 初始化录音采集器
  static async init() {
    AudioCapturer.audioCapturer = await audio.createAudioCapturer({
      streamInfo: AudioCapturer.audioStreamInfo,
      capturerInfo: AudioCapturer.audioCapturerInfo
    });
  }

  static async start(filePath: string) {
    try {
      if (!AudioCapturer.audioCapturer) return
      AudioCapturer.recordIng = true
      await AudioCapturer.audioCapturer.start()

      // 开始录音
      let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE); // 如果文件不存在则创建文件
      let fd = file.fd;
      let statFile = fileIo.statSync(fd)
      let bufferSize: number = statFile.size
      while (AudioCapturer.recordIng) {

        let size = await AudioCapturer.audioCapturer.getBufferSize();
        let buffer = await AudioCapturer.audioCapturer.read(size, true);
        let options: FileOptions = {
          offset: bufferSize,
          length: buffer.byteLength
        };
        fileIo.writeSync(fd, buffer, options) // 写入文件
        bufferSize += buffer.byteLength//偏移量
      }
    } catch (error) {
      AlertDialog.show({
        message: JSON.stringify(error)
      })
    }

  }

  static async stop() {
    AudioCapturer.recordIng = false
    if (AudioCapturer.audioCapturer) {
      // 只有采集器状态为STATE_RUNNING或STATE_PAUSED的时候才可以停止
      if (AudioCapturer.audioCapturer.state === audio.AudioState.STATE_RUNNING ||
        AudioCapturer.audioCapturer.state === audio.AudioState.STATE_PAUSED
      ) {

        await AudioCapturer.audioCapturer.stop(); // 停止采集
      }

    }
  }

  // 释放资源
  static async release() {
    if (AudioCapturer.audioCapturer) {
      AudioCapturer.recordIng = false
      await AudioCapturer.audioCapturer.release()
    }
  }
}

export class FileOptions {
  offset: number = 0;
  length: number = 0
}