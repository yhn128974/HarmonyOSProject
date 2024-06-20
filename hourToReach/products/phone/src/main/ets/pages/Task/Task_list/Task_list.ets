import { HMList, transTimeFormat, HmLoading } from 'basic'
import { getTaskList } from '../../../common/api'
import { TaskItemCard } from '../../../common/components'
import {
  TaskListParams,
  TaskListData,
  TaskInfoItem,
  TaskListParamsModel,
  TaskListDataModel,
  TaskInfoItemModel,
  TaskTypeEnum,
} from '../../../common/models'
import { promptAction } from '@kit.ArkUI'

@Preview
@Component
export struct Task_list {
  @State reset: boolean = false
  loading: CustomDialogController = new CustomDialogController({
    builder: HmLoading(),
    customStyle: true
  })
  // 类型
  @Prop currentTaskType: TaskTypeEnum
  // 请参数
  @State currentTaskListParams: TaskListParamsModel = new TaskListParamsModel({} as TaskListParams)
  //res数据
  @State currentTaskListData: TaskListDataModel = new TaskListDataModel({} as TaskListData)
  // res.data数据
  @State currentTaskInfoItems: TaskInfoItemModel[] = [new TaskInfoItemModel({} as TaskInfoItem)]

  aboutToAppear(): void {
    this.handleTaskListData()
  }

  async handleTaskListData() {

    let firstTaskListParams: TaskListParamsModel = new TaskListParamsModel({
      status: this.currentTaskType,
      page: 1,
      pageSize: 5,
      startTime: this.currentTaskListParams.startTime || "",
      endTime: this.currentTaskListParams.endTime || "",
      transportTaskId:this.currentTaskListParams.transportTaskId||""
    } as TaskListParams)

    this.currentTaskListParams = firstTaskListParams
    this.loading.open()
    const res = await getTaskList(this.currentTaskListParams)
    this.currentTaskListData = res
    this.currentTaskInfoItems = res.items as TaskInfoItemModel[]
    this.loading.close()
  }

  async getMoreListDate() {
    this.currentTaskListParams = new TaskListParamsModel({
      status: this.currentTaskType,
      page: this.currentTaskListParams.page + 1,
      pageSize: 5,
    } as TaskListParams)

    const res = await getTaskList(this.currentTaskListParams)
    this.currentTaskListData = res
    let newCurrentTaskInfoItems: TaskInfoItemModel[] = res.items as TaskInfoItemModel[]
    this.currentTaskInfoItems.push(...newCurrentTaskInfoItems || [])
  }

  // 日期补零
  addZero(value: number) {
    return value.toString().padStart(2, "0")
  }

  @Builder
  TaskItemCardBuilder(item: TaskInfoItemModel) {
    TaskItemCard({ item })
  }

  @Builder
  getSearchForm() {
    Column() {
      Row() {
        Search({ placeholder: '请输入任务编号', value: this.currentTaskListParams.transportTaskId || "" })
          .backgroundColor($r('app.color.background_page'))
          .height(32)
          .onChange((value) => {
            this.currentTaskListParams.transportTaskId = value
          })
          .onSubmit((value) => {
            this.currentTaskListParams.transportTaskId = value
            this.currentTaskListParams.startTime = ""
            this.currentTaskListParams.endTime = ""
            this.handleTaskListData()
          })
      }
      .justifyContent(FlexAlign.Center)
      .padding({ left: 15, right: 15, bottom: 5 })


      Row() {
        // 完成搜索页需要测试点击之后键盘和弹层同时弹出的情况
        Button(this.currentTaskListParams.startTime || '开始时间')
          .fontSize(14)
          .width(106)
          .height(32)
          .padding({ left: 0, right: 0 })
          .fontColor('#999')
          .backgroundColor($r('app.color.background_page'))
          .onClick(() => {
            DatePickerDialog.show({
              selected: new Date(),
              onDateAccept: ((value) => {

                this.currentTaskListParams.startTime = `${value.getFullYear()}-${this.addZero(value.getMonth()! + 1)}-${this.addZero(value.getDate())}`
              })
            })
          })

        Text("至")
        Button(this.currentTaskListParams.endTime || '结束时间')
          .fontSize(14)
          .width(110)
          .height(32)
          .padding({ left: 0, right: 0 })
          .fontColor('#999')
          .backgroundColor($r('app.color.background_page'))
          .onClick(() => {
            DatePickerDialog.show({
              selected: new Date(),
              onDateAccept: ((value: Date) => {
                this.currentTaskListParams.endTime = `${value.getFullYear()}-${this.addZero(value.getMonth()! + 1)}-${this.addZero(value.getDate())}`
              })
            })
          })
        Button(this.reset ? "重置" : "筛选")
          .backgroundColor($r('app.color.primary'))
          .height(32)
          .width(60)
          .onClick((event: ClickEvent) => {

            if (this.reset) {
              this.currentTaskListParams.startTime = ''
              this.currentTaskListParams.endTime = ''
              this.handleTaskListData()
              this.reset = false
            } else {
              this.handleTaskListData()
              this.reset = true
            }


          })
          .enabled(!!this.currentTaskListParams.startTime && !!this.currentTaskListParams.endTime)
      }.width('100%').alignItems(VerticalAlign.Center).justifyContent(FlexAlign.SpaceAround)
    }
    .backgroundColor($r('app.color.white'))
    .padding(15)
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }

  build() {
    Column() {

      if (this.currentTaskType === TaskTypeEnum.Finish) {
        this.getSearchForm()
      }

      HMList({
        objectList: this.currentTaskInfoItems,
        upDate: async () => {
          await this.handleTaskListData()
          promptAction.showToast({
            message: '数据更新完毕'
          })
        },
        getMoreDate: async () => {
          this.getMoreListDate()
        },
        ListBuilder: (item) => {
          this.TaskItemCardBuilder(item as TaskInfoItemModel)
        },
        loadingText: "数据加载中",
        loadingFinishedText: "数据全部加载完毕",
        finished: !!(this.currentTaskListData.page == this.currentTaskListData.pages)
      }).height('100%')


    }

  }
}
