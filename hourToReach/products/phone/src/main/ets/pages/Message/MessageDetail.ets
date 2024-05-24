import { HmNavBar } from 'basic'
import router from '@ohos.router';
import { readMessage } from '../../common/api/message'
import { DetailTypeModel } from '../../common/models'

@Entry
@Component
struct MessageDetail {
  @State detailForm: DetailTypeModel = new DetailTypeModel({
    content: '',
    created: '',
    id: ''
  })

  async aboutToAppear() {
    const params = router.getParams()
    this.detailForm = params as DetailTypeModel
    readMessage(this.detailForm.id)
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      HmNavBar({ title: '详情' })
      Column() {
        Text("系统公告").fontSize(16).fontColor($r('app.color.text_primary')).lineHeight(22)
        Text(this.detailForm.created).fontSize(12).fontColor($r('app.color.text_secondary')).lineHeight(17).margin({
          top: 7,
          bottom: 17
        })
        Text(this.detailForm.content).fontSize(14).lineHeight(22)
      }.alignItems(HorizontalAlign.Start).padding({
        top: 20,
        left: 16,
        right: 16
      })
    }.height('100%').backgroundColor($r('app.color.white'))
  }
}

export default MessageDetail
