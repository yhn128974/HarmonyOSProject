import { getMessage, readAllMessage, readMessage } from '../../common/api'
import { MessageQueryTypeModel, MessageItemModel } from '../../common/models'
import router from '@ohos.router';

import promptAction from '@ohos.promptAction';
import { HMList } from 'basic/Index';

@Component
struct MessageTemplate {
  @Prop
  type: string
  @State
  queryParams: MessageQueryTypeModel = new MessageQueryTypeModel({
    page: 1,
    pageSize: 10,
    contentType: this.type === "information" ? 200 : 201
  })
  @State
  allPage: number = 1
  @State
  messageList: MessageItemModel[] = []

  async getMessage(append: boolean) {
    if (this.allPage < this.queryParams.page) {
      return
    }
    const result = await getMessage(this.queryParams)
    if (append) {
      this.messageList = this.messageList.concat(result.items) // 追加数据
    } else {
      this.messageList = result.items // 覆盖数据
    }
    this.queryParams.page++
    this.allPage = result.pages
  }

  async refreshData() {
    this.allPage = 1 // 只要下拉就默认有一页
    this.queryParams.page = 1
    await this.getMessage(false)
    promptAction.showToast({ message: '刷新成功' })
  }

  @Builder
  renderItem(item: object) {
    if (this.type === "information") {
      this.renderInformationItem(item as MessageItemModel)
    }
    if (this.type === "notice") {
      this.renderNoticeItem(item as MessageItemModel)
    }
  }

  // 读取
  readSuccess() {
    this.messageList = this.messageList.map(item => {
      item.isRead = 1
      return item
    })
  }

  @Builder
  renderInformationItem(item: MessageItemModel) {
    Row() {
      Row() {
        if (item.isRead === 0) {
          Text("").width(8).height(8).backgroundColor($r('app.color.primary')).borderRadius(4)
        }
        Text(item.content)
          .fontSize(14)
          .fontColor($r("app.color.text_primary"))
          .margin({ left: 6 })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }.width(230)

      Text(item.created).fontSize(12).fontColor($r("app.color.text_secondary"))
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .padding({ left: 22, right: 22 })
    .height(60)
    .backgroundColor($r('app.color.white'))
    .border({ width: { bottom: 1 }, color: $r("app.color.background_page") })
    .width('100%')
    .onClick(() => {
      // 先更改数据状态
      item.isRead = 1
      this.messageList = [...this.messageList]
      router.pushUrl({
        url: 'pages/Message/MessageDetail',
        params: {
          content: item.content,
          created: item.created,
          id: item.id
        }
      })
    })
  }

  @Builder
  renderNoticeItem(message: MessageItemModel) {
    Column() {
      Row() {
        Text("您有新的运输任务")
        if (message.isRead === 0) {
          Text("")
            .width(8)
            .height(8)
            .backgroundColor($r('app.color.primary'))
            .borderRadius(4)
            .margin({ left: 10 })
        }
      }

      Divider().color($r('app.color.background_page')).margin({ top: 13 })
      Text(message.content.replace(new RegExp("/\/n/"), ""))
        .margin({ top: 11, bottom: 22.5 })
        .fontSize(13)
        .fontColor($r('app.color.text_secondary'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .lineHeight(22)
      Row() {
        Text(message.updated).fontSize(12).fontColor($r('app.color.text_secondary'))
        Button("查看详情", { type: ButtonType.Capsule })
          .fontColor($r('app.color.primary'))
          .border({ width: 1, color: $r('app.color.primary') })
          .height(24)
          .width(76)
          .backgroundColor('#fff')
          .onClick(() => {
            readMessage(message.id + "")
            // 跳转到任务详情
            router.pushUrl({
              url: 'pages/TaskDetail/TaskDetail',
              params: {
                id: message.relevantId
              }
            })
          })
      }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Center).width('100%')
    }
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .borderRadius(10)
    .padding(16)
    .margin({ bottom: 15 })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      Row() {
        Image($r("app.media.ic_yidu")).width(16).height(16)
        Text("全部已读").fontSize(14).fontColor($r('app.color.text_secondary')).margin({
          left: 9
        }).onClick(async () => {
          this.queryParams.contentType && await readAllMessage(this.queryParams.contentType.toString())
          promptAction.showToast({ message: '全部已读' })
          this.readSuccess && this.readSuccess()
        })
      }.padding({
        left: 17,
        right: 17,
        top: 14,
        bottom: 14
      }).width('100%') // 全部已读
      // 公告内容
      HMList({
        finished: this.allPage < this.queryParams.page,
        objectList: this.messageList,
        upDate: async () => {
          await this.refreshData()
        },
        getMoreDate: async () => {
          await this.getMessage(true)
        },
        ListBuilder: (item: object) => {
          this.renderItem(item)
        }
      })
    }.height('100%')
  }
}

export default MessageTemplate