import AvSession from '@ohos.multimedia.avsession'
import { songItemType } from '../models'
import { AvPlayerManager } from './AvPlayerManager'

export default class AvSessionManager {
  static session: AvSession.AVSession
  static controller: AvSession.AVSessionController

  static async init(context: Context) {
    // 获取会话对象
    AvSessionManager.session = await AvSession.createAVSession(context, 'bgPlay', 'audio')

    //得到控制器
    AvSessionManager.controller = await AvSessionManager.session.getController()

  }

  // 设置媒体资源
  static async setAvMetaData (song: songItemType) {
    await AvSessionManager.session.setAVMetadata({
      assetId: song.id,
      title: song.name,
      artist: song.author,
      mediaImage: song.img,
      duration:  AvPlayerManager.currentSong.duration
    })
  }
}