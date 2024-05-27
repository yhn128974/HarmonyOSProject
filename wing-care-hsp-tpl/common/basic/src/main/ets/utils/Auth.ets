import { preferences } from '@kit.ArkData'
import { USER_SRORE } from '../constants'

interface UserToken {
  token: string
}

export class UserSore {
  static getStore() {
    return preferences.getPreferences(getContext(), { name: USER_SRORE })
  }

  static async setUserInfo(data: UserToken) {
    let currentStore = await UserSore.getStore()
    currentStore.putSync(`${USER_SRORE}001`, JSON.stringify(data))
    currentStore.flush()
  }

  static async getUserInfo() {
    let currentStore = await UserSore.getStore()
    return JSON.parse(currentStore.getSync(`${USER_SRORE}001`, '{}') as string) as UserToken
  }
}