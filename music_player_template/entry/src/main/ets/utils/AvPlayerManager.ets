import { media } from '@kit.MediaKit'
import { PlayStateType, songItemType } from '../models'
import { JSON } from '@kit.ArkTS'
import { SONG_KEY } from '../constants'

export class AvPlayerManager {
  static player: media.AVPlayer | null = null //播放器的实例对象
  static currentSong: PlayStateType = new PlayStateType() //记录当前歌曲


  //   初始化并监听播放器状态
  static async init() {

    if (!AvPlayerManager.player) {
      AvPlayerManager.player = await media.createAVPlayer()
    }

    AvPlayerManager.player.on("stateChange", (state) => {
      switch (state) {
        case "initialized":
          AvPlayerManager.player?.prepare()
        case "prepared":
          AvPlayerManager.player?.play()
          AvPlayerManager.currentSong.isPlay = true
          break;
      }
    })
    // 播放器可以监听播放时长的变化
    AvPlayerManager.player.on("durationUpdate", (duration) => {
      AvPlayerManager.currentSong.duration = duration
      AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong)

    })

    // 记录播放当前的时间
    AvPlayerManager.player.on("timeUpdate", (time) => {
      AvPlayerManager.currentSong.time = time
      AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong)
    })

    AvPlayerManager.player.on("error", (error) => {
      AlertDialog.show({
        message: JSON.stringify(error.message)
      })
    })
  }

  //传入歌曲对象
  static singlePlay(song: songItemType) {

    // 点击的是不是在播放列表中
    const inList = AvPlayerManager.currentSong.playList.some(item => item.id === song.id)

    if (inList) {
      // 点击的是不是当前播放的
      if (AvPlayerManager.currentSong.url === song.url) {
        // 如果点的和当前播的是同一个
        AvPlayerManager.player?.play() //播放
        AvPlayerManager.currentSong.isPlay = true //更新播放状态

      } else {
        AvPlayerManager.currentSong.playIndex =
          AvPlayerManager.currentSong.playList.findIndex(item => item.id === song.id)
        AvPlayerManager.currentSong.isPlay = true //更新播放状态
        AvPlayerManager.changePlay()

      }
      AvPlayerManager.player!.url = song.url
    } else {
      AvPlayerManager.currentSong.playList.unshift(song)
      AvPlayerManager.currentSong.playIndex = 0
      AvPlayerManager.changePlay()
    }
    // 全局对象存贮
    AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong)
  }

  // 改变播放曲目
  static async changePlay() {
    await AvPlayerManager.player?.reset()
    AvPlayerManager.currentSong.duration = 0 //归零
    AvPlayerManager.currentSong.time = 0

    AvPlayerManager.currentSong.img = AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex].img
    AvPlayerManager.currentSong.name = AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex].name
    AvPlayerManager.currentSong.url = AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex].url
    AvPlayerManager.currentSong.author =
      AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex].author

    // 播放器初始化地址
    AvPlayerManager.player!.url = AvPlayerManager.currentSong.url
  }

//   播放暂停
  static pause(){
    AvPlayerManager.player?.pause()
    AvPlayerManager.currentSong.isPlay=false;
    AppStorage.setOrCreate(SONG_KEY,AvPlayerManager.currentSong)//将暂停状态更新到全局

  }
}