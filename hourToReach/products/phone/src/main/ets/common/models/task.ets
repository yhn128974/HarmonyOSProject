import { ImageUrl } from 'basic'
export interface TaskListParams {
  /** 结束时间 */
  endTime: string | null;

  /** 页码 */
  page: number;

  /** 页面大小 */
  pageSize: number;

  /** 开始时间 */
  startTime: string | null;

  /** 作业状态，1为待提货）、2为在途(在途和已交付)、3为改派、5为已作废、6为已完成（已回车登记） */
  status: number;

  /** 运输任务id */
  transportTaskId: string | null;
}

/** 响应数据，分页数据统一对象 */
export interface TaskListData {
  /** 总条目数 */
  counts: number;

  /** 数据列表 */
  items: TaskInfoItem[];

  /** 页码 */
  page: number;

  /** 总页数 */
  pages: number;

  /** 页尺寸 */
  pageSize: number;
}

export interface TaskInfoItem {
  /** 实际到达时间 */
  actualArrivalTime: string;

  /** 实际发车时间 */
  actualDepartureTime: string;

  /** 创建时间 */
  created: string;

  /** 司机id */
  driverId: string;

  /** 是否可提货 */
  enablePickUp: boolean;

  /** 目的机构地址 */
  endAddress: string;

  /** 目的机构id */
  endAgencyId: number;

  /** 交付对接人 */
  finishHandover: string;

  /** 司机作业单id */
  id: string;

  /** 计划到达时间 */
  planArrivalTime: string;

  /** 计划发车时间 */
  planDepartureTime: string;

  /** 起始机构地址 */
  startAddress: string;

  /** 起始机构id */
  startAgencyId: number;

  /** 提货对接人 */
  startHandover: string;

  /** 作业状态，作业状态，1为待提货）、2为在途）、3为改派）、4为已交付）、5为已作废 */
  status: string;

  /** 运输任务id */
  transportTaskId: string;
}

export class TaskListParamsModel implements TaskListParams {
  endTime: string | null = null
  page: number = 0
  pageSize: number = 0
  startTime: string | null = null
  status: number = 0
  transportTaskId: string | null = null

  constructor(model: TaskListParams) {
    this.endTime = model.endTime
    this.page = model.page
    this.pageSize = model.pageSize
    this.startTime = model.startTime
    this.status = model.status
    this.transportTaskId = model.transportTaskId
  }
}

export class TaskListDataModel implements TaskListData {
  counts: number = 0
  items: TaskInfoItem[] = []
  page: number = 0
  pages: number = 0
  pageSize: number = 0

  constructor(model: TaskListData) {
    this.counts = model.counts
    this.items = model.items
    this.page = model.page
    this.pages = model.pages
    this.pageSize = model.pageSize
  }
}

export class TaskInfoItemModel implements TaskInfoItem {
  actualArrivalTime: string = ''
  actualDepartureTime: string = ''
  created: string = ''
  driverId: string = ''
  enablePickUp: boolean = false
  endAddress: string = ''
  endAgencyId: number = 0
  finishHandover: string = ''
  id: string = ''
  planArrivalTime: string = ''
  planDepartureTime: string = ''
  startAddress: string = ''
  startAgencyId: number = 0
  startHandover: string = ''
  status: string = ''
  transportTaskId: string = ''

  constructor(model: TaskInfoItem) {
    this.actualArrivalTime = model.actualArrivalTime
    this.actualDepartureTime = model.actualDepartureTime
    this.created = model.created
    this.driverId = model.driverId
    this.enablePickUp = model.enablePickUp
    this.endAddress = model.endAddress
    this.endAgencyId = model.endAgencyId
    this.finishHandover = model.finishHandover
    this.id = model.id
    this.planArrivalTime = model.planArrivalTime
    this.planDepartureTime = model.planDepartureTime
    this.startAddress = model.startAddress
    this.startAgencyId = model.startAgencyId
    this.startHandover = model.startHandover
    this.status = model.status
    this.transportTaskId = model.transportTaskId
  }
}

// 查询状态的枚举
export enum TaskTypeEnum {
  Waiting = 1,
  Line = 2,
  Delivered=4,
  Finish = 6
}


/** 响应数据，响应数据 */
export interface TaskDetailInfo {
  /** 实际到达时间 */
  actualArrivalTime: string;
  /** 实际发车时间 */
  actualDepartureTime: string;
  /** 提货凭证 */
  cargoPickUpPictureList: ImageUrl[];
  /** 提货图片 */
  cargoPictureList: ImageUrl[];
  /** 回单凭证 */
  certificatePictureList: ImageUrl[];
  /** 回单图片 */
  deliverPictureList: ImageUrl[];
  /** 司机id */
  driverId: string;
  /** 司机姓名 */
  driverName: string;
  /** 目的市 */
  endAddress: string;
  /** 目的机构id */
  endAgencyId: string;
  /** 目的机构详细地址 */
  endCity: string;
  /** 目的省份 */
  endProvince: string;
  exceptionList: ExceptionList[];
  /** 交付对接人 */
  finishHandoverName: string;
  /** 交付对接人电话 */
  finishHandoverPhone: string;
  /** 司机作业单id */
  id: string;
  /** 车牌号码 */
  licensePlate: string;
  /** 计划到达时间 */
  planArrivalTime: string;
  /** 计划发车时间 */
  planDepartureTime: string;
  /** 起始机构详细地址 */
  startAddress: string;
  /** 起始机构id */
  startAgencyId: string;
  /** 起始市 */
  startCity: string;
  /** 提货对接人 */
  startHandoverName: string;
  /** 提货对接人电话 */
  startHandoverPhone: string;
  /** 起始省份 */
  startProvince: string;
  /** 作业状态，1为待提货）、2为在途）、3为改派）、4为已交付）、5为已作废、6为已完成（已回车登记） */
  status: number;
  /** 运输任务id */
  transportTaskId: string;
}
export interface ExceptionList {
  /** 异常描述 */
  exceptionDescribe: string;
  /** 异常图片 */
  exceptionImagesList: ImageUrl[];
  /** 上报的位置 */
  exceptionPlace: string;
  /** 异常时间 */
  exceptionTime: string;
  /** 异常类型(中文) */
  exceptionType: string;
  /** 处理结果 */
  handleResult: string;
}
export class TaskDetailInfoModel implements TaskDetailInfo {
  actualArrivalTime: string = ''
  actualDepartureTime: string = ''
  cargoPickUpPictureList: ImageUrl[] = []
  cargoPictureList: ImageUrl[] = []
  certificatePictureList: ImageUrl[] = []
  deliverPictureList: ImageUrl[] = []
  driverId: string = ''
  driverName: string = ''
  endAddress: string = ''
  endAgencyId: string = ''
  endCity: string = ''
  endProvince: string = ''
  exceptionList: ExceptionList[] = []
  finishHandoverName: string = ''
  finishHandoverPhone: string = ''
  id: string = ''
  licensePlate: string = ''
  planArrivalTime: string = ''
  planDepartureTime: string = ''
  startAddress: string = ''
  startAgencyId: string = ''
  startCity: string = ''
  startHandoverName: string = ''
  startHandoverPhone: string = ''
  startProvince: string = ''
  status: number = 0
  transportTaskId: string = ''

  constructor(model: TaskDetailInfo) {
    this.actualArrivalTime = model.actualArrivalTime
    this.actualDepartureTime = model.actualDepartureTime
    this.cargoPickUpPictureList = model.cargoPickUpPictureList
    this.cargoPictureList = model.cargoPictureList
    this.certificatePictureList = model.certificatePictureList
    this.deliverPictureList = model.deliverPictureList
    this.driverId = model.driverId
    this.driverName = model.driverName
    this.endAddress = model.endAddress
    this.endAgencyId = model.endAgencyId
    this.endCity = model.endCity
    this.endProvince = model.endProvince
    this.exceptionList = model.exceptionList
    this.finishHandoverName = model.finishHandoverName
    this.finishHandoverPhone = model.finishHandoverPhone
    this.id = model.id
    this.licensePlate = model.licensePlate
    this.planArrivalTime = model.planArrivalTime
    this.planDepartureTime = model.planDepartureTime
    this.startAddress = model.startAddress
    this.startAgencyId = model.startAgencyId
    this.startCity = model.startCity
    this.startHandoverName = model.startHandoverName
    this.startHandoverPhone = model.startHandoverPhone
    this.startProvince = model.startProvince
    this.status = model.status
    this.transportTaskId = model.transportTaskId
  }
}
export class ExceptionListModel implements ExceptionList {
  exceptionDescribe: string = ''
  exceptionImagesList: ImageUrl[] = []
  exceptionPlace: string = ''
  exceptionTime: string = ''
  exceptionType: string = ''
  handleResult: string = ''

  constructor(model: ExceptionList) {
    this.exceptionDescribe = model.exceptionDescribe
    this.exceptionImagesList = model.exceptionImagesList
    this.exceptionPlace = model.exceptionPlace
    this.exceptionTime = model.exceptionTime
    this.exceptionType = model.exceptionType
    this.handleResult = model.handleResult
  }
}



