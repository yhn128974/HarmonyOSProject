// 用来播放音乐 切换音乐 暂停音乐 进度调整 后台播放音乐
import media from '@ohos.multimedia.media'
import { SONG_KEY } from '../constants'
import { songItemType, PlayStateType } from '../models'
import { router } from '@kit.ArkUI'
import { backgroundTaskManager } from '@kit.BackgroundTasksKit'
import { wantAgent } from '@kit.AbilityKit'
import FormIdManager from './FormIdManager'
import { formBindingData, formProvider } from '@kit.FormKit'
import ImageSave from './ImageSave'
import { fileIo } from '@kit.CoreFileKit'
import SongManager from './SongManager'
import AvSessionManager from './AvSessionManager'

export class AvPlayerManager {
  static player: media.AVPlayer | null = null // 播放器对象
  static currentSong: PlayStateType = new PlayStateType() // 记录当前的歌曲
  // 初始化播放器
  static async init() {
    // 保证当前只有一个播放器 不重复创建不浪费资源
    if (!AvPlayerManager.player) {
      AvPlayerManager.player = await media.createAVPlayer()
    }
    AvPlayerManager.player.on("stateChange", (state) => {
      switch (state) {
        case "initialized":
          AvPlayerManager.player?.prepare() // 准备
          break;
        case "prepared":
          if(AppStorage.get("firstplay") === 1) {
            // 说明上次的直接来播放了// 只会进来一次
            AppStorage.setOrCreate("firstplay", 0)
          }else {
            AvPlayerManager.currentSong.isPlay = true // 表示正在播放
            AvPlayerManager.player?.play() // 播放
          }

          break;
        case "completed":
          AvPlayerManager.nextPlay(AvPlayerManager.currentSong.playMode === "repeat") // 直接调用下一首播放
          break
      }
    })
    // 播放器可以监听播放时长的变化
    AvPlayerManager.player.on("durationUpdate", (duration) => {
      AvPlayerManager.currentSong.duration = duration // 记录当前歌曲的时长
      AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong) // 将状态设置到全局
      AvSessionManager.setAvMetaData(AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex])
    })
    // 需要知道歌曲播到哪里了
    AvPlayerManager.player.on("timeUpdate", (time) => {
      AvPlayerManager.currentSong.time = time
      AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong) // 将状态设置到全局
      AvSessionManager.setAVPlayBackState() // 设置状态
    })
    AvPlayerManager.player.on("error", (error) => {
      AlertDialog.show({ message: error.message })
    })
  }

  // 点击某个歌曲播放
  static singlePlay(song: songItemType) {
    AvPlayerManager.startBackgroundTask() // 开启后台任务
    // AvPlayerManager.player!.url = song.url // 赋值
    // 做判断
    // 判断歌曲在不在播放列表里
    const inList = AvPlayerManager.currentSong.playList.some(item => item.id === song.id)
    if (inList) {
      // 在列表里
      if (AvPlayerManager.currentSong.url === song.url) {
        // 如果点的和当前播的是同一个
        AvPlayerManager.player?.play() // 播放
        AvPlayerManager.currentSong.isPlay = true // 正在播放
      } else {
        // 点的和正在播的不是同一个
        AvPlayerManager.currentSong.playIndex =
          AvPlayerManager.currentSong.playList.findIndex(item => item.id === song.id)
        AvPlayerManager.changePlay() // 切换播放
      }
    } else {
      AvPlayerManager.currentSong.playList.unshift(song) // 在顶部追加
      AvPlayerManager.currentSong.playIndex = 0 // 播第一个
      AvPlayerManager.changePlay() // 切换播放
    }
    AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong) // 将状态设置到全局
    AvSessionManager.setAVPlayBackState() // 设置状态
  }

  // 切换播放的方法
  static async changePlay() {
    // 重置播放
    await AvPlayerManager.player?.reset() // 重置播放器 会将当前的音乐暂停
    AvPlayerManager.currentSong.duration = 0 // 归零
    AvPlayerManager.currentSong.time = 0 // 归零
    AvPlayerManager.currentSong.img = AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex].img
    AvPlayerManager.currentSong.name = AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex].name
    AvPlayerManager.currentSong.url = AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex].url
    AvPlayerManager.currentSong.author =
      AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex].author
    AvPlayerManager.player!.url = AvPlayerManager.currentSong.url // 之所以能播放 就是因为设置了地址

    // 只要切歌就应该推送图片
    AvPlayerManager.pushImage() // 这里就需要推送图片
    SongManager.updateSong(JSON.stringify(AvPlayerManager.currentSong))

  }
  // 推送图片
  static  pushImage () {
    ImageSave.saveFile(AvPlayerManager.currentSong.name+".jpg", AvPlayerManager.currentSong.img, (filePath) => {
      // filePath就是文件的路径
      // 下载成功  并不是每次都下载
      const formIdList =  FormIdManager.getFormIdList()
      let fileInfo: Record<string, number> = {} // 定义健值对类型
      fileInfo[filePath] = fileIo.openSync(filePath).fd // { key(沙箱路径): 沙箱文件对应的fd的值  }
      formIdList.forEach(formId => {
        formProvider.updateForm(formId, formBindingData.createFormBindingData({
          song: AvPlayerManager.currentSong,
          formImages: fileInfo,  // 这个是必须要写的
          fileName: filePath // 传递需要的路径
          // 需要把filePath给到卡片
          // formImages: { key(沙箱路径): 沙箱文件对应的fd的值  }
        }))
      })
    })

  }
  // 暂停
  static pause() {
    AvPlayerManager.player?.pause() // 播放器暂停
    AvPlayerManager.currentSong.isPlay = false // 状态更新
    AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong) // 将状态设置到全局
    AvSessionManager.setAVPlayBackState() // 设置状态
  }

  // 上一首播放
  static prePlay() {
    // 判断一个情况 当前的播放模式
    if (AvPlayerManager.currentSong.playMode === "random") {
      // 通过随机数找一个歌曲
      AvPlayerManager.currentSong.playIndex = Math.floor(Math.random() * AvPlayerManager.currentSong.playList.length)
    } else {
      // 除了随机播放之外 都是要切到前一个
      AvPlayerManager.currentSong.playIndex--
      // 要知道 有可能为-1
      // 保证要有数据
      AvPlayerManager.currentSong.playIndex =
        (AvPlayerManager.currentSong.playIndex + AvPlayerManager.currentSong.playList.length) %
        AvPlayerManager.currentSong.playList.length
    }
    AvPlayerManager.singlePlay(AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex])
    // 播放当前歌曲

  }

  // 下一首播放
  static nextPlay(repeat?: boolean) {
    if (!repeat) {
      // 这个逻辑是 不是单曲循环的自动播放
      // 如果不是单曲循环 就需要切下一首
      if (AvPlayerManager.currentSong.playMode === "random") {
        // 通过随机数找一个歌曲
        AvPlayerManager.currentSong.playIndex = Math.floor(Math.random() * AvPlayerManager.currentSong.playList.length)
      } else {
        // 除了随机播放之外 都是要切到前一个
        AvPlayerManager.currentSong.playIndex++
        // 要知道 有可能为-1
        // 保证要有数据
        AvPlayerManager.currentSong.playIndex =
          (AvPlayerManager.currentSong.playIndex + AvPlayerManager.currentSong.playList.length) %
          AvPlayerManager.currentSong.playList.length
      }
    }
    AvPlayerManager.singlePlay(AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex])
    // 播放当前歌曲
  }

  // 删除歌曲
  static remove(index: number) {
    // 如果删除的是正在播的歌曲
    if (index === AvPlayerManager.currentSong.playIndex) {
      if (AvPlayerManager.currentSong.playList.length > 1) {
        AvPlayerManager.currentSong.playList.splice(index, 1) // 先删除
        // 说明至少还有一个
        AvPlayerManager.currentSong.playIndex =
          (AvPlayerManager.currentSong.playIndex + AvPlayerManager.currentSong.playList.length) %
          AvPlayerManager.currentSong.playList.length
        AvPlayerManager.singlePlay(AvPlayerManager.currentSong.playList[AvPlayerManager.currentSong.playIndex])
      } else {
        // 说明已经删除干净了
        router.back()
        AvPlayerManager.currentSong = new PlayStateType() // 因为歌曲都删除光了
        AvPlayerManager.player?.reset() // 因为歌曲都没有了 直接重置
      }
    } else {
      // 如果删除的歌曲的索引小于 正在播的歌曲
      if (AvPlayerManager.currentSong.playIndex > index) {
        AvPlayerManager.currentSong.playIndex--
      }
      AvPlayerManager.currentSong.playList.splice(index, 1) // 删除掉这个选项
    }
    AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AvPlayerManager.currentSong) // 将状态设置到全局
    // 更新全局状态
  }

  // 开启后台长时任务
  static async startBackgroundTask() {
    // 会话对象只要有就说明不用开启了
    if (AvSessionManager.session.sessionId) {
      // 如果已经有会话了那就不用开启了
      return
    }
    try {
      // want的信息组成 目的是点击播控中心的时候 可以进入应用
      let wantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            bundleName: 'com.example.heimacloudmusic',
            abilityName: 'EntryAbility'
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      }
      const want = await wantAgent.getWantAgent(wantAgentInfo) // 申请want信息

      // 申请长时任务
      await backgroundTaskManager.startBackgroundRunning(getContext(),
        backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK,
        want
      )
    }catch (error) {
      AlertDialog.show({ message: error.message })
    }

  }
}