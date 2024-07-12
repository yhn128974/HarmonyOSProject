import { textToSpeech } from '@kit.CoreSpeechKit';
import { BusinessError } from '@kit.BasicServicesKit';

let ttsEngine: textToSpeech.TextToSpeechEngine;
@Entry
@Component
struct Index {
  @State createCount: number = 0;
  @State result: boolean = false;
  @State voiceInfo: string = "";
  @State text: string = "";
  @State textContent: string = "";
  @State utteranceId: string = "123456";
  @State originalText: string = "\n\t\t古人学问无遗力，少壮工夫老始成；\n\t\t" +
    "纸上得来终觉浅，绝知此事要躬行。\n\t\t";
  @State illegalText: string = "";

  build() {
    Column() {
      Scroll() {
        Column() {
          TextArea({ placeholder: 'Please enter tts original text', text: `${this.originalText}` })
            .margin(20)
            .focusable(false)
            .border({  width: 5, color: 0x317AE7, radius: 10, style: BorderStyle.Dotted })
            .onChange((value: string) => {
              this.originalText = value;
              console.info("original text: " + this.originalText);
            })

          Button() {
            Text("CreateEngineByCallback")
              .fontColor(Color.White)
              .fontSize(20)
          }
          .type(ButtonType.Capsule)
          .backgroundColor("#0x317AE7")
          .width("80%")
          .height(50)
          .margin(10)
          .onClick(() => {
            this.createCount++;
            console.info(`CreateTtsEngine:createCount:${this.createCount}`);
            this.createByCallback();
          })

          Button() {
            Text("speak")
              .fontColor(Color.White)
              .fontSize(20)
          }
          .type(ButtonType.Capsule)
          .backgroundColor("#0x317AE7")
          .width("80%")
          .height(50)
          .margin(10)
          .onClick(() => {
            this.createCount++;
            console.info(`CreateTtsEngine：createCount:${this.createCount}`)
            this.speak();
          })

          Button() {
            Text("listVoicesCallback")
              .fontColor(Color.White)
              .fontSize(20)
          }
          .type(ButtonType.Capsule)
          .backgroundColor("#0x317AE7")
          .width("80%")
          .height(50)
          .margin(10)
          .onClick(() => {
            this.listVoicesCallback();
          })

          Button() {
            Text("stop")
              .fontColor(Color.White)
              .fontSize(20)
          }
          .type(ButtonType.Capsule)
          .backgroundColor("#0x317AE7")
          .width("80%")
          .height(50)
          .margin(10)
          .onClick(() => {
            // 停止播报
            console.info("isSpeaking click:-->");
            ttsEngine.stop();
          })

          Button() {
            Text("isBusy")
              .fontColor(Color.White)
              .fontSize(20)
          }
          .type(ButtonType.Capsule)
          .backgroundColor("#0x317AE7")
          .width("80%")
          .height(50)
          .margin(10)
          .onClick(() => {
            console.info("isSpeaking click:-->");
            // 查询播报状态
            let isBusy = ttsEngine.isBusy();
            console.info('isBusy :' + isBusy);
          })

          Button() {
            Text("shutdown")
              .fontColor(Color.White)
              .fontSize(20)
          }
          .type(ButtonType.Capsule)
          .backgroundColor("#0x317AA7")
          .width("80%")
          .height(50)
          .margin(10)
          .onClick(() => {
            // 释放引擎
            ttsEngine.shutdown();
          })
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
  }

  // 创建引擎，通过callback形式返回
  // 当引擎不存在、引擎资源不存在、初始化超时，返回错误码1003400005，引擎创建失败
  private createByCallback() {
    // 设置创建引擎参数
    let extraParam: Record<string, Object> = {"style": 'interaction-broadcast', "locate": 'CN', "name": 'EngineName'};
    let initParamsInfo: textToSpeech.CreateEngineParams = {
      language: 'zh-CN',
      person: 0,
      online: 1,
      extraParams: extraParam
    };
    try {
      // 调用createEngine方法
      textToSpeech.createEngine(initParamsInfo, (err: BusinessError, textToSpeechEngine: textToSpeech.TextToSpeechEngine) => {
        if (!err) {
          console.info('createEngine is succeeded');
          // 接收创建引擎的实例
          ttsEngine = textToSpeechEngine;
        } else {
          // 创建引擎失败时返回错误码1003400005，可能原因：引擎不存在、资源不存在、创建引擎超时
          console.error("errCode is " + JSON.stringify(err.code));
          console.error("errMessage is " + JSON.stringify(err.message));
        }
      });
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      console.error(`createEngine failed, error code: ${code}, message: ${message}.`)
    }
  };

  // 调用speak播报方法
  // 未初始化引擎时调用speak方法，返回错误码1003400007，合成或播报失败
  private speak() {
    let speakListener: textToSpeech.SpeakListener = {
      // 开始合成或播报回调
      onStart(requestId: string, response: textToSpeech.StartResponse) {
        console.info('onStart: ' + 'requestId: ' + requestId + ' response: ' + JSON.stringify(response));
      },
      // 完成合成或播报回调
      onComplete(requestId: string, response: textToSpeech.CompleteResponse) {
        console.info('onComplete: ' + 'requestId: ' + requestId + ' response: ' + JSON.stringify(response));
      },
      // 停止合成或播报回调，调用stop方法并完成时会触发此回调
      onStop(requestId: string, response: textToSpeech.StopResponse) {
        console.info('onStop: ' + 'requestId: ' + requestId + ' response: ' + JSON.stringify(response));
      },
      // 返回音频流
      onData(requestId: string, audio: ArrayBuffer, response: textToSpeech.SynthesisResponse) {
        console.info('speakListener onData: ' + ' requestId: ' + requestId + ' sequence: ' + JSON.stringify(response) + ' audio: ' +   audio);
      },
      // 错误回调，播报过程发生错误时触发此回调
      // 未创建引擎时调用speak方法时返回错误码1003400007，合成或播报失败
      // 连续调用两次speak，第二次speak会返回错误码1003400006，服务正忙碌
      onError(requestId: string, errorCode: number, errorMessage: string) {
        console.error('OnError: ' + 'requestId: ' + requestId + ' errorCode: ' + errorCode + 'errorMessage: ' + errorMessage);
      }
    };
    // 设置回调
    ttsEngine.setListener(speakListener);
    // 设置播报相关参数
    let extraParam: Record<string, Object> = {"queueMode": 0, "speed": 1, "volume": 2, "pitch": 1, "languageContext": 'zh-CN', "audioType": "pcm", "soundChannel": 3, "playType":1}
    let speakParams: textToSpeech.SpeakParams = {
      requestId: '123456-a', // requestId在同一实例内仅能用一次，请勿重复设置
      extraParams: extraParam
    };
    // 调用speak播报方法
    ttsEngine.speak(this.originalText, speakParams);
  };

  // 查询语种音色信息，以callback形式返回
  private listVoicesCallback() {
    // 设置查询相关参数
    let voicesQuery: textToSpeech.VoiceQuery = {
      requestId: '123456-b', // requestId在同一实例内仅能用一次，请勿重复设置
      online: 1
    };

    // 调用listVoices方法，以callback返回语种音色查询结果
    ttsEngine.listVoices(voicesQuery, (err: BusinessError, voiceInfo: textToSpeech.VoiceInfo[]) => {
      if (!err) {
        // 接收目前支持的语种音色等信息
        this.voiceInfo = JSON.stringify(voiceInfo);
        console.info('voiceInfo is ' + JSON.stringify(voiceInfo));
      } else {
        console.error("errCode is " + JSON.stringify(err));
      }
    });
  };
}