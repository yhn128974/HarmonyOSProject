import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Log } from '@abner/log'
import dayjs from 'dayjs';
import 'dayjs/locale/zh-cn'
import { RouterConfig, UserSore, } from '@hm/basic/Index';

// 设置语言为中文
dayjs.locale('zh-cn');

Log.init({
  tag: "ECX",
  domain: 0xEC00,
  close: false,
  isHilog: true,
  showLogLocation: true,
  logSize: 200
})

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Log.info('Ability onCreate');
  }

  onDestroy(): void {
    Log.info('Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    Log.info('Ability onWindowStageCreate');
    //
    // let FirstUrl: string = ''
    // UserSore.context = this.context
    // let token = await UserSore.getUserInfo()
    //
    // if (token.token) {
    //   FirstUrl = RouterConfig.SPLASH_URL
    // } else {
    //   FirstUrl = RouterConfig.LOGIN_URL
    // }

    windowStage.loadContent(RouterConfig.DEVICE_DOOR_BLUE_OPEN_URL, (err, data) => {
      if (err.code) {
        Log.error('Failed to load the content. Cause: %{public}s' + JSON.stringify(err) ?? '');
        return;
      }
      Log.info('Succeeded in loading the content. Data: %{public}s' + JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Log.info('Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Log.info('Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Log.info('Ability onBackground');
  }
}