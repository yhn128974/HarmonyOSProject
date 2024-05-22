import { ImageUrl } from 'basic'

export interface ExceptionParamsType {
  /** 异常描述，200字以内 */
  exceptionDescribe: string | null;
  /** 异常图片 */
  exceptionImagesList: ImageUrl[] | null;
  /** 上报异常位置 */
  exceptionPlace: string;
  /** 异常时间，精确到分钟 */
  exceptionTime: string;
  /** 异常类型(传中文)，发动机启动困难，不着车，漏油，漏水，照明失灵，有异响，排烟异常，温度异常，其他 */
  exceptionType: string;
  /** 运输任务id */
  transportTaskId: string;
}
export class ExceptionParamsTypeModel implements ExceptionParamsType {
  exceptionDescribe: string | null = null
  exceptionImagesList: ImageUrl[] | null = null
  exceptionPlace: string = ''
  exceptionTime: string = ''
  exceptionType: string = ''
  transportTaskId: string = ''

  constructor(model: ExceptionParamsType) {
    this.exceptionDescribe = model.exceptionDescribe
    this.exceptionImagesList = model.exceptionImagesList
    this.exceptionPlace = model.exceptionPlace
    this.exceptionTime = model.exceptionTime
    this.exceptionType = model.exceptionType
    this.transportTaskId = model.transportTaskId
  }
}
