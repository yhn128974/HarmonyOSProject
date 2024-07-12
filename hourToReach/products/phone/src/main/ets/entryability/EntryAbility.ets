import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Advert, USER_SETTING, USER_SETTING_AD, AdvertClass, defaultAdvert, TokenStore, TOKEN_KEY } from 'basic'
import { JSON } from '@kit.ArkTS';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';

export default class EntryAbility extends UIAbility {
  myWindowStage: window.WindowStage | undefined = undefined

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {

    const manger = abilityAccessCtrl.createAtManager()
    manger.requestPermissionsFromUser(this.context, [
      "ohos.permission.LOCATION",
      "ohos.permission.APPROXIMATELY_LOCATION"
    ])
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {

    //
    // windowStage.getMainWindow().then(window => {
    //   window.setWindowLayoutFullScreen(true)
    // })

    // 设置全局沉浸式
    // windowStage.getMainWindowSync().setWindowLayoutFullScreen(true)
    // AppStorage.setOrCreate("topHeight",px2vp(windowStage.getMainWindowSync().getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height))
    // AppStorage.setOrCreate("bottomHeight",px2vp(windowStage.getMainWindowSync().getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height))

    // 将windowStage对象复制到外层
    this.myWindowStage = windowStage
    //
    let AdvertStore = new Advert(this.context, USER_SETTING)

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

    TokenStore.context = this.context
    let token = await TokenStore.getToken()
    await AppStorage.setOrCreate(TOKEN_KEY, token)

    if (token) {
      // Main window is created, set main page for this ability
      windowStage.loadContent('pages/Index', (err) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }
        hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      });
    }
    else {
      windowStage.loadContent('pages/Login/Login', (err) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }
        hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      })
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
