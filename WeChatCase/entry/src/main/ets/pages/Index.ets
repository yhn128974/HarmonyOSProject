import { TabBarClass } from '../models/tab'
import { UserInfo, UserInfoModel, DefaultUserList } from '../models/user'
import Location from './ChatDetail/Components/Location'
import { Connect } from './Connect/Connect'
import WeChat from './WeChat/WeChat'

class person {
  name: string = '234'
  age: number = 20
}

@Entry
@Component
struct Index {
  aboutToAppear(): void {

  }

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
          if (item.name == 'wechat') {
            WeChat()
          } else if (item.name == 'connect') {
            Connect()
          } else if (item.name == 'discover') {

          } else {

          }
        }.tabBar(this.CommonTabBar(item))
      })
    }.barPosition(BarPosition.End).animationDuration(100)
  }
}