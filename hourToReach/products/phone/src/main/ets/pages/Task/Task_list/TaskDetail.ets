import { HmLoading, HmNavBar, HmSkeleton, HmToggleCard, HmUpload, ImageUrl, UploadFile } from 'basic'
import { promptAction, router } from '@kit.ArkUI'
import {
  CommonRouterParams,
  TaskDetailInfo,
  TaskDetailInfoModel,
  PickUpParamsModel
} from '../../../common/models'

import { getTaskDetail } from '../../../common/api'
import { JSON } from '@kit.ArkTS'
import { pickUp } from '../../../common/api/task'

class BaseBuilderClass {
  title: string = ""
  value: string = ""
  icon?: ResourceStr = ""
}

@Entry
@Component
struct TaskDetail {
  scroller: Scroller = new Scroller()

  @State currentTaskDetailInfo: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  // 定义一个弹出层控制器
  loadingDialog: CustomDialogController = new CustomDialogController({
    builder: HmLoading(),
    customStyle: true
  })

  // @State currentExceptionList: ExceptionListModel = new ExceptionListModel({} as ExceptionList)

  aboutToAppear(): void {
    let currentTaskParams: CommonRouterParams = router.getParams() as object as CommonRouterParams
    if (currentTaskParams && currentTaskParams.id) {
      this.handleTaskDetailInfo(currentTaskParams.id)
    }
  }

  // 获取当前任务信息
  async handleTaskDetailInfo(id: string) {

    this.currentTaskDetailInfo = await getTaskDetail(id)

  }

  // 获取提货的状态
  getPickUpState() {
    if (
      this.currentTaskDetailInfo.cargoPickUpPictureList?.length > 0
        && this.currentTaskDetailInfo.cargoPictureList?.length > 0
        && this.currentTaskDetailInfo.cargoPickUpPictureList.every(item =>!!item.url)
        && this.currentTaskDetailInfo.cargoPictureList.every(item =>!!item.url)) {
      return true
    } else {
      return false
    }
  }

  // 提货操作
  async btnPick() {
    this.loadingDialog.open()
    // 相册路径转为本地路径
    const cargoPickUpPictureList = await UploadFile(this.currentTaskDetailInfo.cargoPickUpPictureList)
    const cargoPictureList = await UploadFile(this.currentTaskDetailInfo.cargoPictureList)

    // (提货)上传图片
    await pickUp(new PickUpParamsModel({
      id: this.currentTaskDetailInfo.id,
      cargoPickUpPictureList,
      cargoPictureList
    }))
    this.handleTaskDetailInfo(this.currentTaskDetailInfo.id) // 重新拉取数据
    // 滚动到顶部
    this.scroller.scrollEdge(Edge.Top)

    this.loadingDialog.close()
    promptAction.showToast({ message: '提货成功' })
  }

  @Builder
  getBaseContentItem(item: BaseBuilderClass) {
    Row() {
      Text(item.title).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Row() {
        Text(item.value).fontSize(14).fontColor($r('app.color.text_secondary'))
        if (item.icon) {
          Image(item.icon).width(24).height(24)
        }
      }
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })
  }

  // 获取基础信息
  @Builder
  getBaseContent() {
    Row() {
      Column() {
        Row() {
          Text("起").baseTextOneStyle()
          Text(this.currentTaskDetailInfo.startAddress).baseTextTwoStyle()
        }.margin({ top: 21 })

        Row() {
          Text("止").baseTextOneStyle().backgroundColor($r('app.color.primary'))
          Text(this.currentTaskDetailInfo.endAddress).baseTextTwoStyle()
        }.margin({ top: 14.5 })
      }.alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({
        right: 20
      })

      Column() {
        Image($r("app.media.ic_navigation")).width(22).height(22)
        Text("开始导航").fontSize(14).margin({ top: 10, bottom: 10 })
      }.justifyContent(FlexAlign.SpaceBetween)
      .margin({
        top: 20
      })

    }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Center).width('100%')

    Divider().vertical(false).height(2).color($r('app.color.background_divider')).margin({ left: 8, right: 8, top: 21 })

    this.getBaseContentItem({
      title: '任务编号',
      value: this.currentTaskDetailInfo.transportTaskId
    })
    this.getBaseContentItem({
      title: '联系人',
      value: this.currentTaskDetailInfo.startHandoverName
    })
    this.getBaseContentItem({
      title: '联系电话',
      value: this.currentTaskDetailInfo.startHandoverPhone,
      icon: $r('app.media.ic_phone')
    })
    this.getBaseContentItem({
      title: '提货时间',
      value: this.currentTaskDetailInfo.planDepartureTime
    })
    this.getBaseContentItem({
      title: '预计送达时间',
      value: this.currentTaskDetailInfo.planArrivalTime
    })

  }

  // 司机信息
  @Builder
  getDriverContent() {
    Row() {
      Text(`车牌号`).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Text(this.currentTaskDetailInfo.licensePlate).fontSize(14).fontColor($r('app.color.text_secondary'))
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })

    Row() {
      Text(`司机姓名`).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Text(this.currentTaskDetailInfo.driverName).fontSize(14).fontColor($r('app.color.text_secondary'))
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })
  }

  // 运输路线
  @Builder
  getTransLineContent() {
    Row() {
      Column() {
        Text(this.currentTaskDetailInfo.startProvince)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(22)
          .fontWeight(600)
        Text(this.currentTaskDetailInfo.startCity).fontSize(14).lineHeight(22)
      }.width(50)

      Image($r("app.media.ic_right_arrow")).width(36).height(16)
      Column() {
        Text(this.currentTaskDetailInfo.endProvince)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(22)
          .fontWeight(600)
        Text(this.currentTaskDetailInfo.endCity).fontSize(14).lineHeight(22)
      }.width(50)
    }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Center).width('100%').padding({
      left: 60,
      right: 60
    })
  }

  // 提货信息内容
  @Builder
  getPickUpContent() {
    HmUpload({
      title: '请拍照上传回单凭证',
      currentImageList: this.currentTaskDetailInfo.cargoPickUpPictureList || [],
      handleCurrentImageListChange: (list: ImageUrl[]) => {
        this.currentTaskDetailInfo.cargoPickUpPictureList = list
        // promptAction.showToast({
        //   message: JSON.stringify(list)
        // })
      }
    })
    HmUpload({
      title: '请拍照上传货品照片',
      currentImageList: this.currentTaskDetailInfo.cargoPictureList || [],
      handleCurrentImageListChange: (list: ImageUrl[]) => {
        this.currentTaskDetailInfo.cargoPictureList = list
        // promptAction.showToast({
        //   message: JSON.stringify(list)
        // })
      }

    })
  }

  // 底部按钮结构
  @Builder
  getBottomBtn() {
    //已完成不显示任何按钮
    Row() {
      Button("延迟收货", { type: ButtonType.Capsule })
        .backgroundColor($r('app.color.btn_gray'))
        .fontColor($r('app.color.text_primary'))
        .fontSize(16)
        .height(50)
        .width(125)
      Button("提货", { type: ButtonType.Capsule })
        .backgroundColor($r('app.color.primary'))
        .fontColor($r('app.color.white'))
        .height(50)
        .flexGrow(1)
        .margin({ left: 13 })
        .enabled(this.getPickUpState())
        .onClick(() => {
          this.btnPick()
        })
    }
    .width('100%')
    .padding({ left: 15, right: 15 })
    .height(70)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.white'))
  }

  build() {

    Column() {
      if (this.currentTaskDetailInfo.id) {
        //
        HmNavBar({ title: '任务详情' })
        //
        Column() {
          Scroll(this.scroller) {
            Column() {
              HmToggleCard({
                title: '基本信息'
              }) {
                this.getBaseContent()
              }

              HmToggleCard({
                title: '车辆司机信息'
              }) {
                this.getDriverContent()
              }

              HmToggleCard({
                title: '运输路线'
              }) {
                this.getTransLineContent()
              }

              HmToggleCard({
                title: '提货信息'
              }) {
                this.getPickUpContent()
              }

            }
          }
        }
        .layoutWeight(1)

        // 底部按钮
        this.getBottomBtn()

      } else {
        HmSkeleton()
      }

    }.backgroundColor($r('app.color.background_page')).height('100%')

  }
}


@Extend(Text)
function baseTextOneStyle() {
  .fontSize(12)
  .fontColor($r('app.color.white'))
  .backgroundColor($r('app.color.text_primary'))
  .width(22)
  .height(22)
  .borderRadius(11)
  .textAlign(TextAlign.Center)
}

@Extend(Text)
function baseTextTwoStyle() {
  .margin({ left: 11.5 }).fontColor($r('app.color.text_secondary')).fontSize(14).lineHeight(20)
}