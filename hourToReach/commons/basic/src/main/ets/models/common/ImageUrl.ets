// 后续上传 basic模块也需要类型
export interface ImageUrl {
  /** 图片url */
  url: string;
}
export class ImageUrlModel implements ImageUrl {
  url: string = ''

  constructor(model: ImageUrl) {
    this.url = model.url
  }
}