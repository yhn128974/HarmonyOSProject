import { UserInfo, UserInfoModel } from './user'
import { util } from '@kit.ArkTS'

export interface MessageInfo {
  id: string
  sendUser: UserInfo
  connectUser: UserInfo
  messageContent: string
  sentTime: number
  //   消息类型
  messageType: MessageTypeEnum
  sourceFilePath: string //音频地址
  sourceDuration: number //音频的长度


}

export enum MessageTypeEnum {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
  LOCATION, //定位
  LINK,
}

export class MessageInfoModel implements MessageInfo {
  id: string = ''
  sendUser: UserInfo = new UserInfoModel({} as UserInfo)
  connectUser: UserInfo = new UserInfoModel({} as UserInfo)
  messageContent: string = ''
  sentTime: number = 0
  messageType: MessageTypeEnum = MessageTypeEnum.TEXT
  sourceFilePath: string = ''
  sourceDuration: number = 0

  constructor(model: MessageInfo) {
    this.id = model.id || util.generateRandomUUID() //生成uuid
    this.sendUser = model.sendUser
    this.connectUser = model.connectUser
    this.messageContent = model.messageContent
    this.sentTime = model.sentTime || Date.now() //发送时间
    this.messageType = model.messageType || MessageTypeEnum.TEXT
    this.sourceFilePath = model.sourceFilePath
    this.sourceDuration = model.sourceDuration
  }
}
