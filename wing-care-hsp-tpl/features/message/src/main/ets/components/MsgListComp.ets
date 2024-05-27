import { EcDialogTips, EcList } from '@itheima/wing-care'
import promptAction from '@ohos.promptAction'
import { ResManager } from '@hm/basic/Index'
import { MsgItemComp } from './MsgItemComp'

class Params {
  page: number = 1
  pageSize: number = 10
}

@Component
export struct MsgListComp {
  // 消息类型: 0 老人报警 ｜ 1 任务提醒
  @Prop
  type: number = 0
  // 1. 列表
  @State
  list: number[] = []
  // 请求参数
  params: Params = { page: 1, pageSize: 10 }
  // 加载状态
  @State
  finished: boolean = false
  // 加载中loading
  @State
  loading: boolean = false
  // 刷新中
  @State
  isRefreshing: boolean = false
  // 触底加载数据
  load = () => {
    if (this.loading || this.finished) return
    this.loading = true
    // 请求数据
    setTimeout(() => {
      for (let index = 0; index < this.params.pageSize; index++) {
        this.list.push(this.list.length + 1)
      }
      this.loading = false
      // 判断是否还有更多
      if (this.list.length === 30) {
        this.finished = true
      } else {
        this.params.page++
      }

    }, 1000)
  }
  // 刷新列表
  refresh = () => {
    setTimeout(() => {
      //  重置列表和状态
      this.loading = false
      this.finished = false
      // 重置请求参数
      this.params.page = 1
      this.list = Array.from(new Array(10))
        .map((item: null, i: number) => i + 1)
      // 关闭刷新状态
      this.isRefreshing = false
    }, 2000)
  }

  // 2. 滑块操作:删除
  delMsg(item: number) {
    AlertDialog.show({
      title: '删除确认',
      message: '确定要删除该内容吗？',
      secondaryButton: {
        value: '确定',
        fontColor: ResManager.EC_MAIN_COLOR,
        action: () => {
          let index = this.list.indexOf(item)
          this.list.splice(index, 1)
          promptAction.showToast({ message: '删除成功' })
        }
      },
      primaryButton: {
        value: '取消',
        fontColor: ResManager.EC_MID_59,
        action: () => {
          console.info('Callback when the second button is clicked')
        }
      },
      alignment: DialogAlignment.Center
    })

  }

  // 自定义划开内容
  @Builder
  itemEnd(item: number) {
    Row() {
      Button() {
        Image(ResManager.IC_WOD_DEL)
          .width(30)
          .aspectRatio(1)
      }
      .backgroundColor(ResManager.EC_SUB_RED)
      .onClick(() => {
        this.delMsg(item)
      })
    }
    .margin({ right: 10 })
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    // 列表
    EcList({
      loading: this.loading,
      finished: this.finished,
      isRefreshing: $isRefreshing,
      load: this.load,
      refresh: this.refresh
    }) {
      ForEach(this.list, (item: number) => {
        ListItem() {
          MsgItemComp({ type: this.type, item: item })
        }
        .swipeAction({
          end: () => {
            this.itemEnd(item)
          }
        })
      })
    }
  }
}