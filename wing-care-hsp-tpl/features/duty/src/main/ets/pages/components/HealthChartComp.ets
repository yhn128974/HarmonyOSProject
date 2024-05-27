@Component
export struct HealthChartComp {
  @Prop
  timeMode: number = 0

  build() {
      // 图表
      Column() {
        Text('图表-' + this.timeMode)
      }
      .margin(60)

  }
}