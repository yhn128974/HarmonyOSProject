import { preferences } from '@kit.ArkData'
import { AdvertClass } from '../models'
import { JSON } from '@kit.ArkTS'
import { promptAction } from '@kit.ArkUI'

export let defaultAdvert: AdvertClass = {
  showAd: true,
  adTime: 5,
  adImg: $r('app.media.start')
}

export class Advert {
  context: Context
  storeName: string

  constructor(context: Context, storeName: string) {
    this.context = context
    this.storeName = storeName
  }

  getStore() {
    return preferences.getPreferencesSync(this.context, { name: this.storeName })
  }

  //设置用户的广告配置
  async setUserAdvert(key: string, value: AdvertClass) {
    let store = this.getStore()
    store.putSync(key, JSON.stringify(value))
    await store.flush(() => {
      promptAction.showToast({
        message: `Advert was accomplishded,key:${key}  `
      })
    })
  }

  getUserAdvert(key: string) {
    let store = this.getStore()
    return JSON.parse(store.getSync(key, JSON.stringify(defaultAdvert)) as string) as AdvertClass
  }

  getAllUserAdvert() {
    let store = this.getStore()
    let UserAdvertsObject = store.getAllSync() as object
    if (UserAdvertsObject) {
      let UserAdvertsList: AdvertClass[] = Object.values(UserAdvertsObject)
        .map((item: string) => JSON.parse(item) as AdvertClass)
      return UserAdvertsList
    } else {
      return []
    }
  }
}