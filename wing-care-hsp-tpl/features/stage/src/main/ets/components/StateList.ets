import { EcList, EcDialogTips } from '@itheima/wing-care'
import dayjs from 'dayjs'
import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import { ResManager } from '@hm/basic/Index'

class Params {
  page: number = 1
  pageSize: number = 10
}

@Component
export struct StateList {
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
  // 2. 取消原因
  // controller: TextAreaController = new TextAreaController()
  @State reason: string = ''

  @Builder
  tipsContent() {
    Column() {
      // Text(this.reason)
      TextArea({ text: this.reason, placeholder: '请输入备注信息' })
        .onChange(val => {
          this.reason = val
        })
        .height(132)
        .fontSize(13)
        .placeholderColor(ResManager.EC_MID_99)
        .placeholderFont({ size: 13 })
        .maxLength(100)
        .showCounter(true)
        .borderRadius(4)
    }
    .padding({ left: 15, right: 15, top: 0 })
  }

  reasonDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips({
      title: '取消原因',
      // 解决 this 指向问题
      tipsContent: () => {
        this.tipsContent()
      },
      confirmButton: {
        text: '确定',
        // color:ResManager.EC_MAIN_COLOR,
        cb: () => {

        }
      },
      cancelButton: {
        text: '取消',
        // color:'red',
        // cb:()=>{
        //
        // }
      }
    }),
    alignment: DialogAlignment.Center
  })
  // 3. 改期
  // 选中日期时间
  selectedDate: Date = new Date()

  changeDate() {
    DatePickerDialog.show({
      start: new Date(),
      end: dayjs()
        .add(3, 'months')
        .toDate(),
      selected: this.selectedDate,
      showTime: true,
      useMilitaryTime: true,
      // disappearTextStyle: { color: Color.Pink, font: { size: '22fp', weight: FontWeight.Bold } },
      // textStyle: { color: '#ff00ff00', font: { size: '18fp', weight: FontWeight.Normal } },
      selectedTextStyle: {
        color: ResManager.EC_MAIN_COLOR,
        font: { size: ResManager.EC_MODULE_TITLE_FS, weight: FontWeight.Regular }
      },
      onDateAccept: (value: Date) => {
        const now: Date = new Date()
        if (value.getTime() < now.getTime()) {
          setTimeout(() => {
            promptAction.showToast({
              message: '选择日期时间必须大于当前时间！'
            })
            this.selectedDate = now
          })
          return this.changeDate()
        }
        this.selectedDate = value
      },
      // onCancel: () => {
      //   console.info("DatePickerDialog:onCancel()")
      // },
      // onDateChange: (value: Date) => {
      //   // console.info("DatePickerDialog:onDateChange()" + value.toString())
      //   // const now:Date = new Date()
      //   // if(value.getTime() < now.getTime()) {
      //   //   promptAction.showToast({
      //   //     message:value.getTime()+''
      //   //   })
      //   //   this.selectedDate = now
      //   // }
      //   // promptAction.showToast({
      //   //   message:value.getTime()+''
      //   // })
      // }
    })
  }

  aboutToAppear() {
    // this.reasonDialog.open()
  }

  build() {
    Column() {
      EcList({
        loading: this.loading,
        finished: this.finished,
        isRefreshing: $isRefreshing,
        load: this.load,
        refresh: this.refresh
      }) {
        ForEach(this.list, (item: number) => {
          ListItem() {
            Column({ space: 14 }) {
              Row() {
                Text('李玉虎')
                  .fontColor(ResManager.EC_MID_BLACK)
                  .fontSize(ResManager.EC_PAGE_TITLE_FS)
                  .fontWeight(500)
                  .margin({ bottom: 5 })

                Button('护理计划内')
                  .height(20)
                  .borderRadius(10)// 计划外 bg：#FFF0D9
                  .backgroundColor('#DBF0FF')
                  .fontColor(ResManager.EC_SUB_BLUE)
                  .fontSize(ResManager.EC_SMALL_FS)
                  .padding({ left: 6, right: 6 })

              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)

              Row() {
                Text('期望服务时间：2023年8月2日14:00')
                  .fontColor(ResManager.EC_MID_59)
                  .fontSize(13)
              }
              .width('100%')

              // 备注
              Row() {
                Text('喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具')
                  .fontSize(ResManager.EC_SMALL_FS)
                  .fontColor('#50A0D8')
                  .lineHeight(20)
              }
              .width('100%')
              .backgroundColor('#E9F6FF')
              .borderRadius(5)
              .padding({ left: 10, right: 10, top: 5, bottom: 8 })


              Row() {
                Button('取消')
                  .height(28)
                  .fontSize(ResManager.EC_SMALL_FS)
                  .fontColor(ResManager.EC_MAIN_COLOR)
                  .backgroundColor('#fff')
                  .onClick(() => {
                    this.reasonDialog.open()
                  })
                Button('改期')
                  .height(28)
                  .fontSize(ResManager.EC_SMALL_FS)
                  .fontColor(ResManager.EC_MAIN_COLOR)
                  .backgroundColor('#fff')
                  .onClick(() => this.changeDate())
                Button('执行')
                  .height(28)
                  .fontSize(ResManager.EC_SMALL_FS)
                  .fontColor('#fff')
                  .backgroundColor(ResManager.EC_MAIN_COLOR)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/stage/ExecutePage'
                    })
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.End)
            }
            .width('100%')
            .borderRadius(ResManager.EC_NORMAL_RD)
            .backgroundColor(ResManager.EC_MID_WHITE)
            .padding({ left: 14, right: 14, top: 10, bottom: 10 })
          }
        })
      }
    }
    .layoutWeight(1)
    .padding({ left: 15, right: 15 })
  }
}