import preferences from '@ohos.data.preferences'
import { Constants } from '../common'

export class UserSetting {
  static context?: Context

  // 获取用户首选项的仓库
  static getUserStore() {
    return preferences.getPreferencesSync(UserSetting.context || getContext(), {
      name: Constants.USER_STORE_KEY
    })
  }

  // 获取用户是否认证  布尔值
  static getUserAuth() {
    const store = UserSetting.getUserStore()
    const key = store.getSync(Constants.USER_AUTH_KEY, "") as string
    return !!key
  }
  // 设置用户auth
  static async setUserAuth (authValue: string) {
    const store = UserSetting.getUserStore()
    store.putSync(Constants.USER_AUTH_KEY, authValue)
    await store.flush()
  }
}