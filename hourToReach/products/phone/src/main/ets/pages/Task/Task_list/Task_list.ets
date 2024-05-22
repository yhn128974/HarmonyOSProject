import { HMList } from 'basic'
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
  @Prop currentTaskType: TaskTypeEnum
  @State currentTaskListData: TaskListDataModel = new TaskListDataModel({} as TaskListData)
  @State currentTaskInfoItems: TaskInfoItemModel[] = [new TaskInfoItemModel({} as TaskInfoItem)]
  @State currentTaskListParams: TaskListParamsModel = new TaskListParamsModel({} as TaskListParams)

  aboutToAppear(): void {
    this.handleTaskListData()
  }

  async handleTaskListData() {
    let firstTaskListParams: TaskListParamsModel = new TaskListParamsModel({
      status: this.currentTaskType,
      page: 1,
      pageSize: 5,
    } as TaskListParams)
    this.currentTaskListParams = firstTaskListParams
    const res = await getTaskList(firstTaskListParams)
    this.currentTaskListData = res
    this.currentTaskInfoItems = res.items as TaskInfoItemModel[]
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
    this.currentTaskInfoItems.push(...newCurrentTaskInfoItems||[])
  }



  @Builder
  TaskItemCardBuilder(item: TaskInfoItemModel) {
    TaskItemCard({ item })
  }

  build() {
    Column() {

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


      // List({
      // }) {
      //   ForEach(this.currentTaskInfoItems, (item: TaskInfoItem, index: number) => {
      //     ListItem() {
      //       TaskItemCard({ item })
      //     }
      //     //  指定list的更新监听模式
      //   }, (item: TaskInfoItem) => item.id)
      //
      // }

    }

  }
}
