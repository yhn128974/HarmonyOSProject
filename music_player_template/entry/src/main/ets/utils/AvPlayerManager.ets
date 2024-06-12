import { media } from '@kit.MediaKit'
import { PlayStateType, songItemType } from '../models'
import { JSON } from '@kit.ArkTS'
import { SONG_KEY } from '../constants'
import { promptAction, router } from '@kit.ArkUI'
import AvSessionManager from './AvSessionManager'
import { backgroundTaskManager } from '@kit.BackgroundTasksKit'
import { wantAgent } from '@kit.AbilityKit'
import FormIdManager from './FormIdManager'
import { formBindingData, formProvider } from '@kit.FormKit'

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
        case "completed":

          AvPlayerManager.nextPlay(AvPlayerManager.currentSong.playMode === 'repeat') //播放完毕直接调用下一首播放
          break;
      }
    })

    // 播放器可以监听播放时长的变化
    AvPlayerManager.player.on("durationUpdate", (duration) => {
      AvPlayerManager.currentSong.duration = duration
      AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong)
      //歌曲发生变化时给播控中心赋值
      AvSessionManager.setAvMetaData(AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex])

    })

    // 记录播放当前的时间
    AvPlayerManager.player.on("timeUpdate", (time) => {
      AvPlayerManager.currentSong.time = time
      AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong) //将状态分享到全局
      AvSessionManager.setAVPlayBackState() //同步状态

    })

    AvPlayerManager.player.on("error", (error) => {
      promptAction.showToast({
        message: JSON.stringify(error)
      })
    })


  }

  //传入歌曲对象
  static singlePlay(song: songItemType) {
    AvPlayerManager.startBackGroundTask() //开启后台

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

      AvPlayerManager.currentSong.isPlay = true //更新播放状态

      AvPlayerManager.changePlay()

    }
    // 全局对象存贮
    AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong)
    AvSessionManager.setAVPlayBackState() //
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

    //获取卡牌id列表
    const formList = FormIdManager.getFormIdList()
    formList.forEach(formID => {
      formProvider.updateForm(formID, formBindingData.createFormBindingData({
        song: AvPlayerManager.currentSong
      }))
    })
  }

  //   播放暂停
  static async pause() {
    await AvPlayerManager.player?.pause()

    AvPlayerManager.currentSong.isPlay = false;

    AppStorage.set<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong) // 更新到
    AvSessionManager.setAVPlayBackState() //

  }

  static prePlay() {
    if (AvPlayerManager.currentSong.playMode === 'random') {
      //   建立一个范围内的随机数
      AvPlayerManager.currentSong.playIndex = Math.floor(Math.random() * AvPlayerManager.currentSong.playList.length)
    } else {
      AvPlayerManager.currentSong.playIndex--

      AvPlayerManager.currentSong.playIndex =
        (AvPlayerManager.currentSong.playIndex + AvPlayerManager.currentSong.playList.length) %
        AvPlayerManager.currentSong.playList.length
    }
    AvPlayerManager.singlePlay(AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex])
  }

  static nextPlay(repeat?: boolean) {
    if (!AvPlayerManager.currentSong.playList.length) {
      return
    }
    if (!repeat) {
      if (AvPlayerManager.currentSong.playMode === "random" && AvPlayerManager.currentSong.playList.length) {

        AvPlayerManager.currentSong.playIndex = Math.floor(Math.random() * AvPlayerManager.currentSong.playList.length)

      } else {
        AvPlayerManager.currentSong.playIndex++

        AvPlayerManager.currentSong.playIndex =
          (AvPlayerManager.currentSong.playIndex + AvPlayerManager.currentSong.playList.length) %
          AvPlayerManager.currentSong.playList.length
      }
    }

    AvPlayerManager.singlePlay(AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex])
  }

  static remove(index: number) {
    if (AvPlayerManager.currentSong.playIndex === index) {

      if (AvPlayerManager.currentSong.playList.length > 1) {
        AvPlayerManager.currentSong.playList.splice(index, 1)

        // 至少有一个
        AvPlayerManager.currentSong.playIndex =
          (AvPlayerManager.currentSong.playIndex + AvPlayerManager.currentSong.playList.length) %
          AvPlayerManager.currentSong.playList.length

      } else {
        // 列表已经没有音乐
        router.back()
        AvPlayerManager.currentSong = new PlayStateType() //初始化
        AvPlayerManager.player?.reset() //重置
      }
    } else {
      // 如果删除歌曲的索引大于正在播的歌曲
      if (AvPlayerManager.currentSong.playIndex > index) {
        AvPlayerManager.currentSong.playIndex--
      }
      AvPlayerManager.currentSong.playList.splice(index, 1)
    }
  }

  //   开启后台长时任务
  static async startBackGroundTask() {
    // 会话对象只要有就不需要开启了

    if (!!AvSessionManager.session.sessionId) {
      return
    }

    try {
      // want的作用是点击播控中心的时候可以进入应用
      let wantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            bundleName: "com.example.heimacloudmusic",
            abilityName: "EntryAbility"
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITY,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      // 获得want代理
      const want = await wantAgent.getWantAgent(wantAgentInfo) // 获取want信息

      //申请长时任务
      await backgroundTaskManager.startBackgroundRunning(
        getContext(),
        backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK,
        want
      )
    } catch (error) {
      // 错误消息
      AlertDialog.show({ message: error.message })
    }


  }
}