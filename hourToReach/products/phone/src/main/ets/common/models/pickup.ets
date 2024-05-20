
import {ImageUrl} from 'basic'
export interface PickUpParams {
  /** 提货凭证照片数组 */
  cargoPickUpPictureList: ImageUrl[];
  /** 提货照片数组 */
  cargoPictureList: ImageUrl[];
  /** 司机作业id */
  id: string;
}
export class PickUpParamsModel implements PickUpParams {
  cargoPickUpPictureList: ImageUrl[] = []
  cargoPictureList: ImageUrl[] = []
  id: string = ''

  constructor(model: PickUpParams) {
    this.cargoPickUpPictureList = model.cargoPickUpPictureList
    this.cargoPictureList = model.cargoPictureList
    this.id = model.id
  }
}
