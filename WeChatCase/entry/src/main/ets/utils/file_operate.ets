import { fileIo } from '@kit.CoreFileKit'
import { util } from '@kit.ArkTS'

export class FileCommon {
  //   创建文件的方法
  static createAudioFile() {
    // 生成文件路径
    const path = getContext().filesDir + '/' + util.generateRandomUUID() + ".wav"
    const file = fileIo.openSync(path, fileIo.OpenMode.CREATE) //创建模式来打开文件
    fileIo.close(file) //关闭文件
    return path //录音会存入文件

  }

  static delFilePath(path: string) {
    if (path) {
      fileIo.unlinkSync(path)
    }
  }
}