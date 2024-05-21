import { ImageUrl} from 'basic'
export interface CarRecordType {
  /** 事故说明，类型为“其他”时填写 */
  accidentDescription: string | null;
  /** 事故图片列表 */
  accidentImagesList: ImageUrl[] | null;
  /** 事故类型，1-直行事故，2-追尾事故，3-超车事故，4-左转弯事故，5-右转弯事故，6-弯道事故，7-坡道事故，8-会车事故，9-其他, */
  accidentType: string | null;
  /** 违章说明，类型为“其他”时填写 */
  breakRulesDescription: string | null;
  /** 违章类型，1-闯红灯，2-无证驾驶，3-超载，4-酒后驾驶，5-超速行驶，6-其他,可用 */
  breakRulesType: string | null;
  /** 扣分数据 */
  deductPoints: number | null;
  /** 回车时间，回车时间，格式yyyy-MM-dd HH:mm:ss，比如：2023-07-18 17:00:00 */
  endTime: string;
  /** 故障说明，类型为“其他”时填写 */
  faultDescription: string | null;
  /** 故障图片列表 */
  faultImagesList: ImageUrl[] | null;
  /** 故障类型，1-发动机启动困难，2-不着车，3-漏油，4-漏水，5-照明失灵，6-有异响，7-排烟异常，8-温度异常，9-其他,可用 */
  faultType: string | null;
  /** 运输任务id */
  id: string;
  /** 是否出现事故 */
  isAccident: boolean | null;
  /** 车辆是否可用 */
  isAvailable: boolean | null;
  /** 车辆是否违章 */
  isBreakRules: boolean | null;
  /** 车辆是否故障 */
  isFault: boolean | null;
  /** 罚款金额 */
  penaltyAmount: string | null;
  /** 出车时间，出车时间，格式yyyy-MM-dd HH:mm:ss，比如：2023-07-18 17:00:00 */
  startTime: string;
}
export class CarRecordTypeModel implements CarRecordType {
  accidentDescription: string | null = null
  accidentImagesList: ImageUrl[] | null = null
  accidentType: string | null = null
  breakRulesDescription: string | null = null
  breakRulesType: string | null = null
  deductPoints: number | null = null
  endTime: string = ''
  faultDescription: string | null = null
  faultImagesList: ImageUrl[] | null = null
  faultType: string | null = null
  id: string = ''
  isAccident: boolean | null = null
  isAvailable: boolean | null = null
  isBreakRules: boolean | null = null
  isFault: boolean | null = null
  penaltyAmount: string | null = null
  startTime: string = ''

  constructor(model: CarRecordType) {
    this.accidentDescription = model.accidentDescription
    this.accidentImagesList = model.accidentImagesList
    this.accidentType = model.accidentType
    this.breakRulesDescription = model.breakRulesDescription
    this.breakRulesType = model.breakRulesType
    this.deductPoints = model.deductPoints
    this.endTime = model.endTime
    this.faultDescription = model.faultDescription
    this.faultImagesList = model.faultImagesList
    this.faultType = model.faultType
    this.id = model.id
    this.isAccident = model.isAccident
    this.isAvailable = model.isAvailable
    this.isBreakRules = model.isBreakRules
    this.isFault = model.isFault
    this.penaltyAmount = model.penaltyAmount
    this.startTime = model.startTime
  }
}
