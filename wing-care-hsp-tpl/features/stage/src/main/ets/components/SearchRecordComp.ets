import { ResManager } from '@hm/basic/Index'

@Component
export struct SearchRecordComp {
  // 搜索关键词
  @State
  keyword: string = ''
  // 联想词列表
  @State
  suggestList:string[] = []

  // 搜索回调


  // 获取联想提示词列表



  build() {
    // Text(this.keyword)
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Search({
          value: $$this.keyword, // $$双向绑定
          placeholder: '请输入老人姓名'
        })
          .backgroundColor('#fff')
          .onSubmit(() => {
            // 输入搜索

          })
          .onChange(() => {
            // 获取联想词
          })
        // 3. 联想提示词列表
        if (this.suggestList.length) {
          Column() {
            List() {
              ForEach(this.suggestList, (item: string, i: number) => {
                ListItem() {
                  Row() {
                    Text() {
                      Span('谢')
                        .fontColor(ResManager.EC_MAIN_COLOR)
                      Span('安' + i)
                    }
                    .fontColor(ResManager.EC_MID_BLACK)
                    .fontWeight(500)
                    .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  }
                  .padding(20)
                  .onClick(() => {
                    // 点击联想词搜索

                  })
                }
              })
            }
            .width('100%')
            .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
          }
          .margin({ top: 50 })
          .padding({ bottom: 50 })
          .width('100%')
          .height('100%')
        }
      }
    }
    .padding({ left: 24, right: 24 })

  }
}
