import { HMCard, HMCard_item, HmNavBar, HmCheckBox, transTimeFormat } from 'basic';
import { promptAction, router } from '@kit.ArkUI';
import dayjs from 'dayjs'
import {
  CarRecordType,
  CarRecordTypeModel,
  CommonRouterParams,
  TaskDetailInfo,
  TaskDetailInfoModel
} from '../../common/models';
import { getTaskDetail, carRecord } from '../../common/api';

@Entry
@Component
struct CarReCord {
  @State currentTaskDetailInfo: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  @State
  currentCarRecord: CarRecordTypeModel = new CarRecordTypeModel({} as CarRecordType)

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params.id) {
      this.handleTaskDetailInfo(params.id)
    }
  }

  async handleTaskDetailInfo(id: string) {
    this.currentTaskDetailInfo = await getTaskDetail(id)
  }



  //检测再提交
  async handleCarRecord() {
    if (!this.currentCarRecord.endTime) {
      promptAction.showToast({
        message: '请选择回车时间',
      })
      return
    }
    this.currentCarRecord.startTime = this.currentTaskDetailInfo.actualDepartureTime
    // 运输任务id
    this.currentCarRecord.id = this.currentTaskDetailInfo.transportTaskId

    await carRecord(this.currentCarRecord)

    promptAction.showToast({
      message: '回车登记成功'
    })
    router.clear()
    router.replaceUrl({
      url: 'pages/Index'
    })
  }

  build() {
    Column() {
      HmNavBar({ title: '回车登记' })
      Column() {
        HMCard() {
          HMCard_item({
            leftTitle: '出车时间',
            rightTitle: this.currentTaskDetailInfo.actualDepartureTime || "",
            showRightIcon: false
          })
          HMCard_item({
            leftTitle: '回车时间',
            rightTitle: '请选择',
            showBottomBorder: false,

            handleRightClick: () => {
              // 日期弹窗
              DatePickerDialog.show({
                showTime: true,
                useMilitaryTime: true,
                onDateAccept: (value: Date) => {
                  let str = dayjs(value).format('YYYY-MM-DD HH-mm')
                  promptAction.showToast({
                    message:str
                  })
                  this.currentCarRecord.endTime = str

                }
              })
            }

          })
          HmCheckBox({
            title: '车辆违章',
            value: !!this.currentCarRecord.isBreakRules,
            checkChange: (value) => {
              this.currentCarRecord.isBreakRules = value
            }

          })
          HmCheckBox({
            title: '车辆故障',
            value: !!this.currentCarRecord.isFault,
            checkChange: (value) => {
              this.currentCarRecord.isFault = value
            }
          })
          HmCheckBox({
            title: '车辆事故',
            value: !!this.currentCarRecord.isAccident,
            checkChange: (value) => {
              this.currentCarRecord.isAccident = value
            }
          })
        }
      }.layoutWeight(1)

      Row() {
        Button('交车').height(50).width('60%').backgroundColor($r('app.color.primary')).onClick(() => {
          this.handleCarRecord()
        })
      }.height(70).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}

