// 1. list
// import { EcList } from '@itheima/wing-care'
//
// class Params {
//   page: number = 1
//   pageSize: number = 10
// }
//
// @Entry
// @Component
// export struct ListDemo {
//   // 1. 列表
//   @State
//   list: number[] = []
//   // 请求参数
//   params: Params = { page: 1, pageSize: 10 }
//   // 加载状态
//   @State
//   finished: boolean = false
//   // 加载中loading
//   @State
//   loading: boolean = false
//   // 刷新中
//   @State
//   isRefreshing: boolean = false
//   // 触底加载数据
//   load = () => {
//     if (this.loading || this.finished) return
//     this.loading = true
//     // 请求数据
//     setTimeout(() => {
//       for (let index = 0; index < this.params.pageSize; index++) {
//         this.list.push(this.list.length + 1)
//       }
//       this.loading = false
//       // 判断是否还有更多
//       if (this.list.length === 30) {
//         this.finished = true
//       } else {
//         this.params.page++
//       }
//
//     }, 1000)
//   }
//   // 刷新列表
//   refresh = () => {
//     setTimeout(() => {
//       //  重置列表和状态
//       this.loading = false
//       this.finished = false
//       this.list = []
//       // 重置请求参数
//       this.params.page = 1
//       this.list = Array.from(new Array(10))
//         .map((item: null, i: number) => i + 1)
//       // 关闭刷新状态
//       this.isRefreshing = false
//     }, 2000)
//   }
//
//   build() {
//     Column() {
//       EcList({
//         loading: this.loading,
//         finished: this.finished,
//         isRefreshing: $isRefreshing,
//         load: this.load,
//         refresh: this.refresh
//       }) {
//         ForEach(this.list, (item: number) => {
//           ListItem() {
//             Column({ space: 14 }) {
//               Row() {
//                 Text('李玉虎')
//                   .fontColor($r('app.color.ec_mid_black'))
//                   .fontSize($r('app.float.ec_page_title_font_size'))
//                   .fontWeight(500)
//                   .margin({ bottom: 5 })
//
//                 Button('护理计划内')
//                   .height(20)
//                   .borderRadius(10)// 计划外 bg：#FFF0D9
//                   .backgroundColor('#DBF0FF')
//                   .fontColor($r('app.color.ec_sub_blue'))
//                   .fontSize($r('app.float.ec_small_font_size'))
//               }
//               .width('100%')
//               .justifyContent(FlexAlign.SpaceBetween)
//
//               Row() {
//                 Text('期望服务时间：2023年8月2日14:00')
//                   .fontColor($r('app.color.ec_mid_59'))
//                   .fontSize(13)
//               }
//               .width('100%')
//
//               // 备注
//               Row() {
//                 Text('喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具')
//                   .fontSize($r('app.float.ec_small_font_size'))
//                   .fontColor('#50A0D8')
//                   .lineHeight(20)
//               }
//               .width('100%')
//               .backgroundColor('#E9F6FF')
//               .borderRadius(5)
//               .padding({ left: 10, right: 10, top: 5, bottom: 8 })
//
//
//               Row() {
//                 Button('取消')
//                   .height(28)
//                   .fontSize($r('app.float.ec_small_font_size'))
//                   .fontColor($r('app.color.ec_main_color'))
//                   .backgroundColor('#fff')
//                 Button('改期')
//                   .height(28)
//                   .fontSize($r('app.float.ec_small_font_size'))
//                   .fontColor($r('app.color.ec_main_color'))
//                   .backgroundColor('#fff')
//                 Button('执行')
//                   .height(28)
//                   .fontSize($r('app.float.ec_small_font_size'))
//                   .fontColor('#fff')
//                   .backgroundColor($r('app.color.ec_main_color'))
//               }
//               .width('100%')
//               .justifyContent(FlexAlign.End)
//             }
//             .width('100%')
//             .borderRadius($r('app.float.ec_normal_radius'))
//             .backgroundColor($r('app.color.ec_mid_white'))
//             .padding({ left: 14, right: 14, top: 10, bottom: 10 })
//           }
//         })
//       }
//     }
//     .layoutWeight(1)
//     .padding({ left: 15, right: 15 })
//   }
// }

//2. chart
// import {
//   ChartView,
//   TimeNavView,
//   ValueView,
//   legendItem,
//   TimeMode,
//   ChartData,
//   handleChartData,
//   getSelectIndexBySelectData
// } from '@itheima/wing-care'
//
// @Entry
// @Component
// export struct HealthChartComp {
//   // 图表数据
//   @State dataSource: ChartData = new ChartData()
//   // 单位
//   @State unit: string = ''
//   // 图表显示模式
//   @Prop timeMode: TimeMode = 0
//   // 当前选中时间时间戳
//   @Provide curTimeStamp: number = new Date().getTime()
//   // 日期联动
//   @Provide selectedDate: Date = new Date()
//   // 当前选中数据项索引
//   @State curIndex: number = 0
//   // 根据日期，计算出折线图默认选中的竖线索引
//   @Provide selectedIndex: number = 0
//   // 图例
//   tipsDesc: string = '正常值：收缩压 90-139mmHg      舒张压 60-89mmHg   '
//   // 前端传值： 折线图底部-图例对象
//   legend: legendItem[] = [{ name: '收缩压', color: '#F9365B' }, { name: '舒张压', color: '#02C4B3' }]
//   /**
//    * 折线图选中后回调函数
//    * */
//   onSelected = (index: number) => {
//     this.curIndex = index
//   }
//   /**
//    * @param
//    * time 当前选中时间时间戳
//    * startTime 开始
//    * endTime 结束
//    */
//   onTimeChange = (time: number, startTime: string, endTime: string) => {
//     console.info('mgx', '时间变化：' + time + '-' + startTime + '~' + endTime)
//   }
//
//   build() {
//     Column() {
//       TimeNavView({ timeMode: this.timeMode, onTimeChange: this.onTimeChange })
//       ValueView({ dataSource: $dataSource, index: $curIndex, unitDesc: this.unit })
//       ChartView({
//         dataSource: $dataSource,
//         onSelected: this.onSelected,
//         selectedIndex: this.selectedIndex,
//         tipsDesc: this.tipsDesc,
//         legend: this.legend
//       })
//     }
//     .backgroundColor('#fff')
//   }
// }

//3. 血糖记录表格
// import { EcHealthRecord, TableDateType } from '@itheima/wing-care';
//
// @Entry
// @Component
// struct HealthRecordPage {
//   @State TableDate: string = '2024-03'
//   @State data: TableDateType[] = []
//
//   aboutToAppear(): void {
//     setTimeout(() => {
//       // value 是血糖值  type是否偏高偏低  1 偏低  2 正常  3 偏高
//       this.data = [{
//         date: '2024-03-06',
//         value: [
//           { value: 0, type: 1 },
//           { value: 0, type: 1 },
//           { value: 0, type: 1 },
//           { value: 5.2, type: 2 },
//           { value: 0, type: 1 },
//           { value: 0, type: 1 },
//           { value: 0, type: 1 },
//           { value: 0, type: 1 }
//         ]
//       },
//         {
//           date: '2024-03-08',
//           value: [
//             { value: 0, type: 1 },
//             { value: 1, type: 1 },
//             { value: 0, type: 1 },
//             { value: 7.8, type: 3 },
//             { value: 0, type: 1 },
//             { value: 0, type: 1 },
//             { value: 0, type: 1 },
//             { value: 0, type: 1 }
//           ]
//         }
//       ]
//     })
//   }
//
//   build() {
//     Column() {
//       // 血糖表格
//       EcHealthRecord({ TableDate: this.TableDate, data: $data })
//     }
//   }
// }

//4. 消息提示
// import { EcDialogTips, EcLoading } from '@itheima/wing-care';
//
// @Entry
// @Component
// struct TestPage {
//   lookDialog: CustomDialogController = new CustomDialogController({
//     builder: EcDialogTips({
//       title: '取消原因',
//       // 自定义消息提示内容
//       // tipsContent: () => {
//       //   this.tipsContent()
//       // },
//       confirmButton: {
//         text: '确定',
//         color: $r('app.color.ec_main_color'),
//         cb: () => {
//           this.lookDialog.close()
//         }
//       },
//       cancelButton: {
//         text: '取消',
//         color: 'red',
//         cb: () => {
//           this.lookDialog.close()
//         }
//       }
//     }),
//     alignment: DialogAlignment.Center
//   })
//   // 全屏 loading 弹层
//   @State
//   tip: string = '上传中...'
//   loading: CustomDialogController = new CustomDialogController({
//     builder: EcLoading({ tip: this.tip }),
//     customStyle: true,
//     autoCancel: true,
//     alignment: DialogAlignment.Center
//     // isModal: false
//   })
//
//   aboutToAppear(): void {
//     this.loading.open()
//   }
//
//   build() {
//     Column() {
//       Button('消息提示')
//         .onClick(() => {
//           this.lookDialog.open()
//         })
//     }
//   }
// }

//5.0 提示和404组件
// import { EcNotFound, EcDeviceTip } from '@itheima/wing-care';
//
// @Entry
// @Component
// struct TestPage {
//   build() {
//     Column({ space: 20 }) {
//       EcNotFound({ tip: '暂无内容~' })
//
//       EcDeviceTip({ type: 'success' })
//
//       EcDeviceTip({ type: 'fail' })
//     }
//     .width('100%')
//     .alignItems(HorizontalAlign.Center)
//   }
// }
import { currentAxios, request } from '@hm/basic'
import { AxiosResponse } from '@ohos/axios';
import { Log } from '@abner/log';

export interface User {
  code?: number;
  data?: UserData;
  msg?: string;
}

export interface UserData {
  /**
   * 头像
   */
  avatar: null | string;

  /**
   * 用户id
   */
  id: string;

  /**
   * 用户昵称
   */
  nickName: string;

  /**
   * 用户账号，即邮箱
   */
  username: string;

}

@Entry
@Component
struct TestPage {
  async getUser() {
    // const res = await currentAxios<null, AxiosResponse<null, null>, null>({ url: '/employee/user', method: 'get' })

    const data = await request<UserData, null>({
      url: '/employee/user', method: 'get'
    })
    Log.info("data", JSON.stringify(data))
  }

  aboutToAppear(): void {
    this.getUser()
  }

  build() {
    Column({ space: 20 }) {
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}