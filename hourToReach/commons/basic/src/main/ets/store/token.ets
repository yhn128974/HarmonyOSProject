import { preferences } from '@kit.ArkData'
import { TOKEN_KEY, TOKEN_STORE_KEY } from '../constants'

export class TokenStore {
  static context: Context

  static  getStore() {
    return  preferences.getPreferencesSync(TokenStore.context || getContext(), { name: TOKEN_STORE_KEY })
  }

  static async getToken() {
    let store = await TokenStore.getStore()
    return store.getSync(TOKEN_KEY, "") as string
  }

  static async setToken(token: string) {
    let store = await TokenStore.getStore()
    store.putSync(TOKEN_KEY, token)
    store.flush()
  }
}