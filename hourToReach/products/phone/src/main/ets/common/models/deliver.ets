import { ImageUrl } from 'basic'

export interface DeliverParamsType {
  /** 交付凭证列表 */
  certificatePictureList: ImageUrl[];

  /** 交付图片列表 */
  deliverPictureList: ImageUrl[];

  /** 司机作业id */
  id: string;
}

export class DeliverParamsTypeModel implements DeliverParamsType {
  certificatePictureList: ImageUrl[] = []
  deliverPictureList: ImageUrl[] = []
  id: string = ''

  constructor(model: DeliverParamsType) {
    this.certificatePictureList = model.certificatePictureList
    this.deliverPictureList = model.deliverPictureList
    this.id = model.id
  }
}
