import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, util, worker } from '@kit.ArkTS';
import { ImageUrl } from 'basic/Index';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

class PostParams {
  files: ImageUrl[] = []
  filePath: string = '' //沙箱目录
}

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = async (e: MessageEvents) => {
  //   耗时任务
  const res = e.data as PostParams
  if (res.files && res.filePath) {

    const currentImageUrlList: ImageUrl[] = res.files as ImageUrl[]
    const currentFilePath: string = res.filePath
    // 创建一个图片编码器
    const currentImagePacker = image.createImagePacker()
    // 打包选项
    let packOption: image.PackingOption = { format: "image/jpeg", quality: 20 }
    // 存储压缩文件
    let finalImageUrlList: ImageUrl[] = []

    while (currentImageUrlList.length > 0) {
      // 截取一个路径
      // pop() 删除并返回数组最后一个元素（每次都会减少一个）
      const ImageUrl = currentImageUrlList.pop()
      // 打开文件资源,获得文件对象
      const sourceFile = fileIo.openSync(ImageUrl?.url, fileIo.OpenMode.READ_ONLY)
      // 建立文件路径
      const newFileName = currentFilePath + "/" + util.generateRandomUUID() + 'jpg'
      // 创打开文件资源
      const targetFile = fileIo.openSync(newFileName, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
      // 将文件压缩到新路径 image.createImagePacker().packToFile(old.fd,new.fd,选项)
      await currentImagePacker.packToFile(image.createImageSource(sourceFile.fd), targetFile.fd, packOption)

      fileIo.closeSync(sourceFile.fd)
      fileIo.closeSync(targetFile.fd)

      finalImageUrlList.push({
        url: newFileName
      })
    }

    // 返回压缩图片列表
    // 这里不需要序列化
    workerPort.postMessage({
      files: finalImageUrlList
    })
    workerPort.close()
  }

  //   对原图进行压缩
  //   将原图压缩为新图存贮到沙箱

}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {

}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
}