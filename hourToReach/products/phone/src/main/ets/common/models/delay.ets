export interface DelayParamsType {
  /** 延迟原因 */
  delayReason: string;
  /** 延迟时间，格式：yyyy-MM-dd HH:mm */
  delayTime: string;
  /** 司机作业单id */
  id: string;
}
export class DelayParamsTypeModel implements DelayParamsType {
  delayReason: string = ''
  delayTime: string = ''
  id: string = ''

  constructor(model: DelayParamsType) {
    this.delayReason = model.delayReason
    this.delayTime = model.delayTime
    this.id = model.id
  }
}
