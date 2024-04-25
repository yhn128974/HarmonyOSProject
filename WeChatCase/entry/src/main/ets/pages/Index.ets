import { TabBarClass } from '../models/tab'

@Entry
@Component
struct Index {
  @State tabList: TabBarClass[] = [
    {
      icon: $r('app.media.ic_public_message'),
      name: 'wechat',
      title: '微信',
      selectIcon: $r('app.media.ic_public_message_filled')
    }, {
    icon: $r('app.media.ic_public_contacts_group'),
    name: 'connect',
    title: '联系人',
    selectIcon: $r('app.media.ic_public_contacts_group_filled')
  }, {
    icon: $r('app.media.ic_gallery_discover'),
    name: 'discover',
    title: '发现',
    selectIcon: $r('app.media.ic_gallery_discover_filled')
  }, {
    icon: $r('app.media.ic_public_contacts'),
    name: 'my',
    title: '我的',
    selectIcon: $r('app.media.ic_public_contacts_filled')
  }]
  @State currentIndex: number = 0

  @Builder
  CommonTabBar(item: TabBarClass) {
    Column() {
      Image(item.name === this.tabList[this.currentIndex].name ? item.selectIcon : item.icon).width(20).aspectRatio(1)
      Text(item.title)
        .fontColor(item.name === this.tabList[this.currentIndex].name ? $r('app.color.primary') : '')
        .fontSize(12)
        .margin({
          top: 4
        })
    }
  }

  build() {
    Tabs({ index: $$this.currentIndex }) {
      ForEach(this.tabList, (item: TabBarClass) => {
        TabContent() {
          Text(item.title)
        }.tabBar(this.CommonTabBar(item))
      })
    }.barPosition(BarPosition.End).animationDuration(100)
  }
}