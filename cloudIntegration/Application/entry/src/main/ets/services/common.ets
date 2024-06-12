import cloud, { Database, ObjectTypeInfo } from '@hw-agconnect/cloud'
import { buffer } from '@kit.ArkTS'
import { promptAction } from '@kit.ArkUI'

// 数据库的导出类
export class CloudDataBase {
  // 云数据库操作类
  static currentDataBase: Database | null

  // 获取云数据库的方法
  static async getCloudDataBase() {
    if (!CloudDataBase.currentDataBase) {
      try {
        const context = getContext()
        const value = await context.resourceManager.getRawFileContent("schema.json")
        let json = buffer.from(value as ArrayBufferLike).toString("utf-8")
        // schema的转化得来的
        CloudDataBase.currentDataBase = cloud.database({
          objectTypeInfo: JSON.parse(json) as ObjectTypeInfo,
          zoneName: "question"
        })
        // 赋值云数据库
      }catch(error) {
        promptAction.showToast({ message: error.message })
      }

    }
    return CloudDataBase.currentDataBase
  }
}