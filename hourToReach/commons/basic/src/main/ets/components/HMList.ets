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
    Row() {
      if (this.finished) {

        Text(this.loadingFinishedText).fontSize(14).fontColor($r('app.color.text_secondary'))

      }
      else {

        Text(this.loadingText).fontSize(14).fontColor($r('app.color.text_secondary'))
        LoadingProgress().width(20).aspectRatio(1).color($r('app.color.text_secondary'))

      }
    }.width('100%').height(50).justifyContent(FlexAlign.Center)
  }

  @State currentRefreshStatus: RefreshStatus = RefreshStatus.Inactive

  handleRefreshText(): string {
    if (this.currentRefreshStatus === RefreshStatus.Inactive) {
      return ''
    }
    else if (this.currentRefreshStatus === RefreshStatus.Drag) {
      return '继续下拉'
    }
    else if (this.currentRefreshStatus === RefreshStatus.OverDrag) {
      return '松手加载'
    }
    else if (this.currentRefreshStatus === RefreshStatus.Refresh) {
      return '加载中'
    }
    else {
      return ''
    }
  }

  @Builder
  RefreshDisplayBuilder() {
    Row({
      space: 10
    }) {
      LoadingProgress().width(40).aspectRatio(1).color($r('app.color.primary'))
      Text(this.handleRefreshText()).fontSize(14).fontColor($r('app.color.text_secondary'))
    }
  }

  build() {
    Refresh({ refreshing: $$this.refreshing, builder: this.RefreshDisplayBuilder() }) {
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
    }.onStateChange((state: RefreshStatus) => {
      // 保存当前RefreshStatus
      this.currentRefreshStatus = state
      //上拉刷新
      if (state === RefreshStatus.Refresh) {
        this.upDate()
      }
    })
  }
}