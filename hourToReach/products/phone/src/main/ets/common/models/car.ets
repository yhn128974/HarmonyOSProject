import { ImageUrl } from 'basic'
/** 响应数据 */
export interface UserCarDataType {
  /** 载重 */
  allowableLoad: string;
  /** 所属机构名称 */
  currentOrganName: string;
  /** 车辆编号 */
  id: string;
  /** 车牌号码 */
  licensePlate: string;
  /** 图片 */
  pictureList: ImageUrl[];
  /** 车辆类型名称 */
  truckType: string;
}
export class UserCarDataTypeModel implements UserCarDataType {
  allowableLoad: string = ''
  currentOrganName: string = ''
  id: string = ''
  licensePlate: string = ''
  pictureList: ImageUrl[] = []
  truckType: string = ''

  constructor(model: UserCarDataType) {
    this.allowableLoad = model.allowableLoad
    this.currentOrganName = model.currentOrganName
    this.id = model.id
    this.licensePlate = model.licensePlate
    this.pictureList = model.pictureList
    this.truckType = model.truckType
  }
}
