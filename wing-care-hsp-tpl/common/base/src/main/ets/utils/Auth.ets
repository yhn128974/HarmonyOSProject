import { preferences } from '@kit.ArkData'
import { USER_SRORE } from '../constants'


interface UserToken {
  token: string
}

let defaultUserToken: UserToken = {
  token: ''
}

export class UserSore {
  static context: Context

  static getStore() {
    return preferences.getPreferences(getContext() || UserSore.context, { name: USER_SRORE })
  }

  static async setUserInfo(data: UserToken) {
    let currentStore = await UserSore.getStore()
    currentStore.putSync(`${USER_SRORE}001`, JSON.stringify(data))
    currentStore.flush()
  }

  static async getUserInfo() {
    let currentStore = await UserSore.getStore()
    return JSON.parse(currentStore.getSync(`${USER_SRORE}001`, JSON.stringify(defaultUserToken)) as string) as UserToken
  }

  static async delUser() {
    let currentStore = await UserSore.getStore()
    await currentStore.delete(USER_SRORE)
    await currentStore.flush()
  }
}

