import preferences from '@ohos.data.preferences'
import { Context } from '@ohos.abilityAccessCtrl'
import { Constants } from '../common'
import cloud, { VerifyCodeAction } from '@hw-agconnect/cloud'

export class UserSetting {
  static context?: Context

  static getUserStore() {
    return preferences.getPreferencesSync(getContext() || UserSetting.context, {
      name: 'UserStore'
    })
  }

  static getUserAuth() {


    let res = UserSetting.getUserStore().getSync(Constants.USER_AUTH_KEY, '') as string

    return !!res
  }

  static async setUserAuth(authValue: string) {
    UserSetting.getUserStore().putSync(Constants.USER_AUTH_KEY, authValue)
    await UserSetting.getUserStore().flush()
  }
}