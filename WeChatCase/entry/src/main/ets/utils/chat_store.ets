import { weChat_StoreKey, WeChat_ConnectKey, WeChat_CurrentUserKey, WeChat_UserRecordKey,
  Record_Update_EventName, } from '../constant'
import preferences from '@ohos.data.preferences'
import { DefaultUserList, UserInfoModel, CurrentUser } from '../models/user'
import { MessageInfoModel } from '../models/message'
import { emitter } from '@kit.BasicServicesKit'

export class WeChatStore {
  static context: Context

  static getWeChatStore() {
    return preferences.getPreferences(WeChatStore.context || getContext(), weChat_StoreKey)
  }

  // 获取微信联系人
  static async getWeChatConnect() {
    const store = await WeChatStore.getWeChatStore()
    return JSON.parse(store.getSync(WeChat_ConnectKey, JSON.stringify(DefaultUserList)) as string) as UserInfoModel[]
  }

  // 获取当前用户信息
  static async getCurrentUser() {
    const store = await WeChatStore.getWeChatStore()
    return JSON.parse(store.getSync(WeChat_CurrentUserKey, JSON.stringify(CurrentUser)) as string) as UserInfoModel
  }

  static getWeChatMessageStore(userId: string) {
    return preferences.getPreferencesSync(getContext(), {
      name: `${WeChat_UserRecordKey}_${userId}`
    })
  }

  // 获取某个人的整个的聊天记录
  static getWeChatMessage(userId: string) {
    const store = WeChatStore.getWeChatMessageStore(userId)
    const allRecord = store.getAllSync() as object
    if (allRecord) {
      const list = Object.values(allRecord).map((item: string) => JSON.parse(item) as MessageInfoModel)
      list.sort((a, b) => a.sentTime - b.sentTime)
      return list
    }
    return []

  }

  // 删除某个人整个的聊天记录
  static async delWeChatMessage(userId: string) {
    preferences.deletePreferences(getContext(), {
      name: `${WeChat_UserRecordKey}_${userId}`
    })
  }

  // 添加某个人的一条聊天记录
  static async addOneWeChatMessage(userId: string, mess: MessageInfoModel) {
    const store = WeChatStore.getWeChatMessageStore(userId)
    store.putSync(mess.id, JSON.stringify(mess))
    await store.flush()
    emitter.emit(Record_Update_EventName)
  }

  // 删除某个人的一条聊天记录
  static async delOneWeChatMessage(userId: string, messId: string) {
    const store = WeChatStore.getWeChatMessageStore(userId)
    store.deleteSync(messId)
    await store.flush()
    emitter.emit(Record_Update_EventName)
  }

  // 获取所有人的聊天记录的最后一条
  static async getAllLastRecord() {
    const users = await WeChatStore.getWeChatConnect()
    let list: MessageInfoModel[] = []
    users.forEach(user => {
      const messList = WeChatStore.getWeChatMessage(user.user_id)
      if (messList && messList.length) {
        list.push(messList[messList.length - 1])
      }
    })

    // 对list进行排序
    list.sort((a: MessageInfoModel, b: MessageInfoModel) => {
      return b.sentTime - a.sentTime
    })
    return list
  }
}