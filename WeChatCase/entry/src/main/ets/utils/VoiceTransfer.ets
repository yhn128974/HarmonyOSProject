
import { speechRecognizer, textToSpeech } from '@kit.CoreSpeechKit';
import { util } from '@kit.ArkTS';
import fileIo from '@ohos.file.fs';


export class VoiceTransfer {
  // 语音识别成文字
  private static asrEngine: speechRecognizer.SpeechRecognitionEngine;
  // 文字转语音
  private static ttsEngine: textToSpeech.TextToSpeechEngine
  private static voiceExtraParam: Record<string, Object> = {
    "style": 'interaction-broadcast',
    "locate": 'CN',
    "name": 'EngineName'
  };
  private static voiceInitParamsInfo: textToSpeech.CreateEngineParams = {
    language: 'zh-CN',
    person: 0,
    online: 1,
    extraParams: VoiceTransfer.voiceExtraParam
  };

  // 文本转语音
  static async textToVoice(speakText: string) {
    if (!VoiceTransfer.ttsEngine) {
      // 文本转语音引擎创建
      VoiceTransfer.ttsEngine = await textToSpeech.createEngine(VoiceTransfer.voiceInitParamsInfo)
    }
    let extraParam: Record<string, Object> = {
      "speed": 1,
      "volume": 1,
      "pitch": 1,
      "languageContext": 'zh-CN',
      "audioType": "pcm"
    }
    let speakParams: textToSpeech.SpeakParams = {
      requestId: util.generateRandomUUID(),
      extraParams: extraParam
    }
    VoiceTransfer.ttsEngine.speak(speakText, speakParams)
  }

  // 设置创建引擎参数
  private static textExtraParams: Record<string, Object> = { "locate": "CN", "recognizerMode": "short" }
  private static textInitParamsInfo: speechRecognizer.CreateEngineParams = {
    language: 'zh-CN',
    online: 1,
    extraParams: VoiceTransfer.textExtraParams
  };
  private static sessionId: string = "" // 会话id
  static async VoiceToText(path: string, call: (result: speechRecognizer.SpeechRecognitionResult) => void) {
    try {
      if (!VoiceTransfer.asrEngine) {
        VoiceTransfer.asrEngine = await speechRecognizer.createEngine(VoiceTransfer.textInitParamsInfo)
      }
      if (VoiceTransfer.asrEngine.isBusy()) return // 说明正在识别不用处理a
      // 创建回调对象
      let setListener: speechRecognizer.RecognitionListener = {
        // 开始识别成功回调
        onStart(sessionId: string, eventMessage: string) {
          console.info("onStart sessionId: " + sessionId + "eventMessage: " + eventMessage);
        },
        // 事件回调
        onEvent(sessionId: string, eventCode: number, eventMessage: string) {
          console.info("onEvent sessionId: " + sessionId + "eventCode: " + eventCode + "eventMessage: " + eventMessage);
        },
        // 识别结果回调，包括中间结果和最终结果
        onResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult) {
          call(result) // 返回语音识别内容
          if(result.isLast) {
            VoiceTransfer.asrEngine.finish(sessionId) // 结束
          }
        },
        // 识别完成回调
        onComplete(sessionId: string, eventMessage: string) {
          // VoiceTransfer.asrEngine.finish(sessionId) // 结束
          console.info("onComplete sessionId: " + sessionId + "eventMessage: " + eventMessage);

        },
        // 错误回调，错误码通过本方法返回
        // 返回错误码1002200002，开始识别失败，重复启动startListening方法时触发
        // 更多错误码请参考错误码参考
        onError(sessionId: string, errorCode: number, errorMessage: string) {
          console.error("onError sessionId: " + sessionId + "errorCode: " + errorCode + "errorMessage: " + errorMessage);
        },
      }
      // 设置回调
      VoiceTransfer.asrEngine.setListener(setListener);

      let audioParam: speechRecognizer.AudioInfo = {
        audioType: 'pcm',
        sampleRate: 16000,
        soundChannel: 1,
        sampleBit: 16
      };
      let extraParam: Record<string, Object> = { "vadBegin": 2000, "vadEnd": 3000, "maxAudioDuration": 60000 };
      let recognizerParams: speechRecognizer.StartParams = {
        sessionId: util.generateRandomUUID(),
        audioInfo: audioParam,
        extraParams: extraParam
      };
      VoiceTransfer.sessionId = recognizerParams.sessionId
      // 调用开始识别方法
      VoiceTransfer.asrEngine.startListening(recognizerParams);
      VoiceTransfer.writeAudio(path)
    } catch (error) {
      // AlertDialog.show({
      //   message: JSON.stringify(error)
      // })
    }

  }

  // 写音频流
  static async writeAudio(path: string) {

    let file = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE); // 读文件
    // let stat = fileIo.statSync(file.fd)
    try {
      let buf: ArrayBuffer = new ArrayBuffer(1280);
      let totalSize: number = 0
      while (totalSize < fileIo.statSync(file.fd).size)  {
        fileIo.readSync(file.fd, buf, {
          offset: totalSize,
          length: 1280
        })
        let unit8Array: Uint8Array = new Uint8Array(buf);
        VoiceTransfer.asrEngine.writeAudio(VoiceTransfer.sessionId, unit8Array);
        // 这里必须加延迟才可以
        await new Promise<boolean>((resolve) => {
          setTimeout(() => resolve(true), 40)
        })
        // 延迟时间
        totalSize = totalSize + 1280;
      }
    } catch (e) {
      console.error("read file error " + e);
    } finally {
      fileIo.closeSync(file)
      VoiceTransfer.stopTransfer()
    }
  }
  // 停止转换文字
  static async stopTransfer() {
    if (VoiceTransfer.asrEngine && VoiceTransfer.asrEngine.isBusy() && VoiceTransfer.sessionId) {
      VoiceTransfer.asrEngine.finish(VoiceTransfer.sessionId)
    }
  }
}