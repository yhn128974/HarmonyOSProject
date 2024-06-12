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

  // 设置媒体资源(封面信息)
  static async setAvMetaData(song: songItemType) {
    console.log("SystemCapability.Multimedia.AVSession.Core:", canIUse('SystemCapability.Multimedia.AVSession.Core'))

    await AvSessionManager.session.setAVMetadata({
      assetId: song.id,
      title: song.name,
      artist: song.author,
      mediaImage: song.img,
      duration: AvPlayerManager.currentSong.duration
    })
  }

  static async setAVPlayBackState() {
    AvSessionManager.session.setAVPlaybackState({
      state: AvPlayerManager.currentSong.isPlay ? AvSession.PlaybackState.PLAYBACK_STATE_PLAY :
      AvSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      position: {
        elapsedTime: AvPlayerManager.currentSong.time,
        updateTime: new Date().getTime()
      },
      speed: 1,
      duration: AvPlayerManager.currentSong.duration
    })
  }

  // 注册 AvSession.AVSession的监听事件
  static registerEvent() {
    AvSessionManager.session.on('play', () => {
      AvPlayerManager.singlePlay(AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex])
    })
    AvSessionManager.session.on('pause', () => {
      AvPlayerManager.pause()
    })
    AvSessionManager.session.on('playPrevious', () => {
      AvPlayerManager.prePlay()
    })
    AvSessionManager.session.on('playNext', () => {
      AvPlayerManager.nextPlay()
    })
    AvSessionManager.session.on('seek', (time) => {
      AvPlayerManager.player?.seek(time)

    })
    AvSessionManager.session.activate(()=>{

    })

  }
}