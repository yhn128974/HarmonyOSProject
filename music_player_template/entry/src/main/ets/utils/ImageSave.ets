import { request } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';

export default class ImageSave {
  static async saveFile(fileName: string, url: string, callBack: (path: string) => void) {
    try {
      let tempDir = getContext().getApplicationContext().tempDir;

      if (fileIo.listFileSync(tempDir).includes(fileName)) {
        return callBack(tempDir + "/" + fileName)
      }

      const task = await request.downloadFile(getContext(), {
        filePath: tempDir + "/" + fileName, //接受路径
        url//上传路径
      })

      task.on("complete", () => {
        let newPath = tempDir + "/" + fileName
        callBack(newPath)
      })
      task.on("fail", () => {
        AlertDialog.show({
          message: "下载异常"
        })
      })
    } catch (error) {
      AlertDialog.show({
        message: error.message
      })
    }

  }
}