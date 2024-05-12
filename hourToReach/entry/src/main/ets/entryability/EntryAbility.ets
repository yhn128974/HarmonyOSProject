import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Advert, USER_SETTING, USER_SETTING_AD, AdvertClass, defaultAdvert,TokenStore, TOKEN_KEY } from 'basic'
import { JSON } from '@kit.ArkTS';

export default class EntryAbility extends UIAbility {
  myWindowStage: window.WindowStage | undefined = undefined

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // 将windowStage对象复制到外层
    this.myWindowStage = windowStage
    //
    let AdvertStore = new  Advert(this.context, USER_SETTING)
    let resDefaultAdvert = await new Promise<AdvertClass>((resolve, reject) => {
      setTimeout(() => {
        resolve(defaultAdvert)
      }, 500)
    })


    await AdvertStore.setUserAdvert(USER_SETTING_AD, resDefaultAdvert)
    let myAdvert: AdvertClass = await AdvertStore.getUserAdvert(USER_SETTING_AD) as AdvertClass
    if (myAdvert.showAd) {
      const advertWindow = await windowStage.createSubWindow('ad_window') //创建一个子窗口
      await advertWindow.showWindow()
      advertWindow.setUIContent("pages/Advert/start")
    }

    const token=await TokenStore.getToken()
    if (token) {
      AppStorage.setOrCreate(TOKEN_KEY,token)
      // Main window is created, set main page for this ability
      hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
      windowStage.loadContent('pages/Index', (err) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }
        hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      });
    }else {
      windowStage.loadContent('pages/Login/index')
    }


  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  async onForeground(): Promise<void> {
    // let AdvertStore = new Advert(this.context, USER_SETTING)
    // let myAdvert: AdvertClass = await AdvertStore.getUserAdvert(USER_SETTING_AD) as AdvertClass
    //
    // if (myAdvert.showAd) {
    //   const advertWindow = await this.myWindowStage?.createSubWindow('ad_window')
    //   await advertWindow?.showWindow()
    //   advertWindow?.setUIContent("pages/Advert/start")
    // }

    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {

    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
