import { HmNavBar, ImageUrl  } from 'basic'
import { getUserCarInfo } from '../../common/api'
import { UserCarDataTypeModel, UserCarDataType,  } from '../../common/models'
@Entry
@Component
struct Car {
  @State
  userCarInfo: UserCarDataTypeModel = new UserCarDataTypeModel({} as UserCarDataType)
  aboutToAppear() {
    this.getUserCarInfo()
  }
  async getUserCarInfo() {
    this.userCarInfo = await getUserCarInfo()
  }
  @Builder
  getContentItem (item: CarItem) {
    Row() {
      Text(item.leftTitle).fontSize(14).fontWeight(400).fontColor($r('app.color.text_secondary'))
      Text(item.rightValue).fontSize(14).fontColor($r('app.color.text_primary')).fontWeight(400)
    }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Center).width('100%').height(40)
  }
  build() {
    Column() {
      HmNavBar({ title: '车辆信息' })
      Swiper(new SwiperController()) {
        ForEach(this.userCarInfo.pictureList, (item: ImageUrl) => {
          Row() {
            Image(item.url).width('100%').height('100%').objectFit(ImageFit.Cover).
            borderRadius(8)
          }.height(201).padding({ left: 15, right: 15, top: 15  })
        })
      }
      .loop(false)
      .cachedCount(3)
      .indicator(true)
      .curve(Curve.Linear)

      // 信息列表
      Column() {
        this.getContentItem({ leftTitle: '车辆编号', rightValue: this.userCarInfo.id })
        this.getContentItem({ leftTitle: '车辆号牌', rightValue: this.userCarInfo.licensePlate })
        this.getContentItem( { leftTitle: '车型', rightValue: this.userCarInfo.truckType })
        this.getContentItem({ leftTitle: '所属机构', rightValue: this.userCarInfo.currentOrganName })
        this.getContentItem({ leftTitle: '载重', rightValue: this.userCarInfo.allowableLoad })
      }
      .padding({
        top: 19.5,
        bottom: 19.5,
        left: 20,
        right: 20
      })
      .backgroundColor($r('app.color.white'))
      .margin(15)
      .borderRadius(8)
    }.height('100%').backgroundColor($r('app.color.background_page')).width('100%')
  }
}


class  CarItem {
  leftTitle: string = ""
  rightValue: string = ""
}
export default Car