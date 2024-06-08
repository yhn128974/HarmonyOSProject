import cloud, { Database, ObjectTypeInfo } from '@hw-agconnect/cloud'
import buffer from '@ohos.buffer'
import promptAction from '@ohos.promptAction'

export class CloudDataBase {
  static currentDataBase: Database | null

  static async getCloudDataBase() {
    if (!CloudDataBase.currentDataBase) {
      try {
        // 获取schema的JSON对象
        const currentContext = getContext()
        const res = await currentContext.resourceManager.getRawFileContent('schema.json')
        let json:string = buffer.from(res as ArrayBufferLike).toString('utf-8')

        //   获取数据库对象
         CloudDataBase.currentDataBase = cloud.database({
          objectTypeInfo: JSON.parse(json) as ObjectTypeInfo,
          zoneName: 'question'
        })

      } catch (error) {
        promptAction.showToast({ message: error.message })
      }

    }
      return CloudDataBase.currentDataBase
  }
}