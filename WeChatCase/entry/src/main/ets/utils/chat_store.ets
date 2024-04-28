//用户首选项为应用提供Key-Value键值型的数据处理能力，支持应用持久化轻量级数据，并对其修改和查询。
import { preferences } from '@kit.ArkData'
import { weChat_StoreKey, WeChat_ConnectKey, WeChat_CurrentUserKey } from '../constant'
import { CurrentUser, DefaultUserList, UserInfoModel } from '../models/user'

// 当用户希望有一个全局唯一存储的地方，可以采用用户首选项来进行存储。Preferences会将该数据缓存在内存中，
// 当用户读取的时候，能够快速从内存中获取数据，当需要持久化时可以使用flush接口将内存中的数据写入持久化文件中。
// Preferences会随着存放的数据量越多而导致应用占用的内存越大，因此，Preferences不适合存放过多的数据，适用的场景一般为应用保存用户的个性化设置（字体大小，是否开启夜间模式）等。
//实现单例
export class WeChatStore {
  static context: Context;

  // 获取一个仓库
  static getWeChatStore() {
    return preferences.getPreferencesSync(WeChatStore.context || getContext(),
      { name: weChat_StoreKey })
  }

  // 获取微信联系人
  static getWeChatConnect(): UserInfoModel[] {
    const store = WeChatStore.getWeChatStore()
    return JSON.parse(store.getSync(WeChat_ConnectKey, JSON.stringify(DefaultUserList)) as string) as UserInfoModel[]
  }

  // 获取当前用户信息
  static getCurrentUser(): UserInfoModel {
    const store = WeChatStore.getWeChatStore()
    return JSON.parse(store.getSync(WeChat_CurrentUserKey, JSON.stringify(CurrentUser)) as string) as UserInfoModel
  }
}
