import { abilityAccessCtrl, AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';

import { WeChat_CurrentUserKey } from '../constant';
import { UserInfo, UserInfoModel } from '../models/user';
import { WeChatStore } from '../store/chat_store';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    const manger = abilityAccessCtrl.createAtManager() //得到管理对象
    // 第一道防线.申请权限，无论过还是不过
    manger.requestPermissionsFromUser(this.context, [
      "ohos.permission.MICROPHONE",
      "ohos.permission.LOCATION",
      "ohos.permission.APPROXIMATELY_LOCATION"]
    )
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');


    WeChatStore.context = this.context //
    const userList = WeChatStore.getWeChatConnect()

    //将当前用户放入内存中
    const user = await WeChatStore.getCurrentUser()


    AppStorage.setOrCreate<UserInfoModel>(WeChat_CurrentUserKey, user)

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');

      // 设置键盘避让为压缩
      windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
    });

  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');

  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
