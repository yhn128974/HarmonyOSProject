import { ResManager } from '@hm/basic/Index'

export interface FloorItem {
  id: string
  name: string
  children: FloorItem[]
}

export interface  FloorTree {
  floors: FloorItem[]
  rooms: FloorItem[]
  beds: FloorItem[]
}
export type OnConfirm = (currentStep: number, selectedFloor?: FloorItem | null, selectedRoom?: FloorItem | null,
  selectedBed?: FloorItem | null) => void

@Component
@CustomDialog
export struct FloorSelDialog {
  // 控制器
  controller: CustomDialogController
  // 0-选择楼层 ｜ 1-选择房间 ｜ 2-选择床位
  @State
  currentStep: number = 0
  /**
   * 需求：
   * 1. 获取楼层数据渲染
   * 2. 联动数据处理，例如：选择了楼层，要获取对应楼层房间列表
   * 3. 实现选中
   * 4. 处理上次选择数据联动
   */
  // 1. 楼层选择数据源
  @Prop
  data: FloorTree = {
    floors: [],
    rooms: [],
    beds: []
  }
  // 2. 选中楼层数据（回显）
  @Prop
  selectedFloor: FloorItem | null = null
  @Prop
  selectedRoom: FloorItem | null = null
  @Prop
  selectedBed: FloorItem | null = null
  // 3. 确认选择
  onConfirm: () => void = () => {
  }

  @Builder
  floorList(type: 'floor' | 'room' | 'bed', title: string) {
    Column({ space: 15 }) {
      Text(title)
        .fontColor(ResManager.EC_MID_99)
        .fontSize(ResManager.EC_NORMAL_FS)
      List({ space: 15 }) {
        ForEach(Array.from(Array(6)), (item: number, i: number) => {
          ListItem() {
            Row() {
              Text(i + 1 + '')
              // == 选中处理 ==
              Image(ResManager.IC_JRWZ_GX)
                .width(14)
                .aspectRatio(1)

            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              // 处理选中数据保存
            })
          }
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .padding({ left: 37, bottom: 15, right: 15 })
    // .margin({ left: 37 })
    .alignItems(HorizontalAlign.Start)
  }

  // 获取联动选择容器高度
  getSelHeight() {
    // 最后一次选择优先处理
    if (this.selectedRoom) {
      return 100
    }
    if (!this.selectedFloor) {
      return 20
    } else if (this.selectedFloor) {
      return 60
    } else {
      return 100
    }
  }
  build() {
    Column() {
      //  dialog标题
      Row() {
        Text('取消')
          .fontColor(ResManager.EC_MID_59)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
          .onClick(() => this.controller.close())
        Text('接入位置')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
        Text('确定')
          .fontColor(ResManager.EC_MAIN_COLOR)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
          .onClick(() => {
            // 确认选择
            // this.onConfirm()
            this.controller.close()
          })

      }
      .width('100%')
      .padding({ left: 15, right: 15 })
      .height(50)
      .justifyContent(FlexAlign.SpaceBetween)
      .linearGradient({
        angle: 180,
        colors: [['#fff', 0], ['#fafafa', 100]]
      })

      // 1. 联动选项
      Row({ space: 12 }) {
        // 进度条
        Column() {
          // 第一步
          Circle({
            width: 10,
            height: 10
          })
            .fill(this.selectedFloor ? ResManager.EC_MAIN_COLOR : '#fff')
            .strokeWidth(1)
            .stroke(ResManager.EC_MAIN_COLOR)
          if (this.selectedFloor) {
            // 线
            Divider()
              .color(ResManager.EC_MAIN_COLOR)
              .vertical(true)
              .height(30)
            // 第二步
            Circle({
              width: 10,
              height: 10
            })
              .fill(this.selectedRoom ? ResManager.EC_MAIN_COLOR : '#fff')
              .strokeWidth(1)
              .stroke(ResManager.EC_MAIN_COLOR)
          }
          if (this.selectedRoom) {
            // 线
            Divider()
              .color(ResManager.EC_MAIN_COLOR)
              .vertical(true)
              .height(30)
            // 第三步
            Circle({
              width: 10,
              height: 10
            })
              .fill(this.selectedBed ? ResManager.EC_MAIN_COLOR : '#fff')
              .strokeWidth(1)
              .stroke(ResManager.EC_MAIN_COLOR)
          }
        }

        // .height(100)
        // .justifyContent(FlexAlign.Start)

        // 选择
        Column({ space: 15 }) {
          Row() {
            Text('选择楼层')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
            Row() {
              Image($r('app.media.ic_arrow_black'))
                .width(7)
                .height(16)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .onClick(() => {
            this.currentStep = 0
          })

          if (this.selectedFloor) {
            Row() {
              Text('选择房间')
                .fontColor(ResManager.EC_MID_19)
                .fontSize(ResManager.EC_MODULE_TITLE_FS)
              Row() {
                Image($r('app.media.ic_arrow_black'))
                  .width(7)
                  .height(16)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              this.currentStep = 1
            })
          }
          if (this.selectedRoom) {
            Row() {
              Text('选择床位')
                .fontColor(ResManager.EC_MID_19)
                .fontSize(ResManager.EC_MODULE_TITLE_FS)
              Row() {
                Image($r('app.media.ic_arrow_black'))
                  .width(7)
                  .height(16)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              this.currentStep = 2
            })
          }
        }
        .layoutWeight(1)
        .height(this.getSelHeight())
        .justifyContent(FlexAlign.SpaceBetween)

      }
      .width('100%')
      .padding(15)
      .linearGradient({
        angle: 180,
        colors: [['#fff', 0], ['rgba(255,255,255,0)', 100]]
      })

      // 分割线
      Divider()
        .padding({ left: 15, top: 10, right: 15, bottom: 16 })

      // 2. 联动内容
      Row() {
        if (this.currentStep === 0) {
          this.floorList('floor', '请选择楼层')
        }
        if (this.currentStep === 1) {
          this.floorList('room', '请选择房间')
        }
        if (this.currentStep === 2) {
          this.floorList('bed', '请选择床位')
        }
      }
      .width('100%')
      .layoutWeight(1)
    }
    .height(410)
  }
}