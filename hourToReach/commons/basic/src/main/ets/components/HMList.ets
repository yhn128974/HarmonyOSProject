@Component
export struct HMList {
  @State refreshing: boolean = false
  @Prop objectList: object[] = []
  upDate: () => void = () => {
  }
  getMoreDate: () => void = () => {
  }
  @BuilderParam ListBuilder: (item: object) => void
  @Prop finished: boolean = false

  @State loading: boolean = false //显示加载中的文本,并且用来做阀门
  @Prop
  loadingText: string
  @Prop
  loadingFinishedText: string

  @Builder
  onReachEndBuilder() {
    Row(){
      if (this.finished ) {

         Text(this.loadingFinishedText).fontSize(14).fontColor($r('app.color.text_secondary'))

      }
      else{

        Text(this.loadingText).fontSize(14).fontColor($r('app.color.text_secondary'))
        LoadingProgress().width(20).aspectRatio(1).color($r('app.color.text_secondary'))

      }
    }.width('100%').height(50).justifyContent(FlexAlign.Center)
  }

  build() {
    Refresh({ refreshing: $$this.refreshing }) {
      List() {
        ForEach(this.objectList, (item: object) => {
          if (this.ListBuilder) {
            this.ListBuilder(item)
          }
        })
        ListItem() {
          this.onReachEndBuilder()
        }
      }.onReachEnd(async () => {
        // 下拉加载
        if (!this.finished && !this.loading) {
          this.loading = true
          await this.getMoreDate()
          this.loading = false
        }
      })
    }.onStateChange(() => {
      //上拉刷新
      this.upDate()
    })

  }
}