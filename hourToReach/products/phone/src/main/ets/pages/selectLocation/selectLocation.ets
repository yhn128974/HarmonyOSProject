import { HmNavBar, HMCard, HMCard_item } from 'basic'
import { MapComponent } from '@hms.core.map.MapComponent'
import { geoLocationManager } from '@kit.LocationKit'
import { map, mapCommon, site } from '@kit.MapKit'
import { router } from '@kit.ArkUI'

class SiteClass {
  name: string = ''
  distance: number = 0
}

@Entry
@Component
struct SelectLocation {
  @State currentList: SiteClass[] = []
  mapController: map.MapComponentController = new map.MapComponentController()

  aboutToAppear(): void {
    this.getLocation()
  }

  async getLocation() {
    const res = await geoLocationManager.getCurrentLocation()

    // let wgs84Position: mapCommon.LatLng = {
    //   longitude: res.longitude,
    //   latitude: res.latitude
    // }
    // // 将WGS84转化为GCJ02
    // const rightResult = await map.convertCoordinate(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, wgs84Position)


    // 将相机挪动到具体的位置
    this.mapController.moveCamera(
      map.newCameraPosition({
        target: {
          longitude: res.longitude,
          latitude: res.latitude
        },
        zoom: 16
      })
    )
    //   添加标记
    this.mapController.addPointAnnotation({
      position: {
        longitude: res.longitude,
        latitude: res.latitude
      },
      titles: [
        {
          content: '您当前的位置'
        }
      ]
    })

    // site.nearbySearch获取当前位置附近
    const resNearby = await site.nearbySearch({
      location: {
        longitude: res.longitude,
        latitude: res.latitude
      },
      pageSize: 4,
      pageIndex: 1,
      radius: 50
    })

    this.currentList = resNearby.sites?.slice(0, 3) as SiteClass[]
  }

  build() {
    Column() {
      HmNavBar({ title: '当前位置' })
      Stack({ alignContent: Alignment.Bottom }) {
        //  地图区域
        MapComponent({
          mapOptions: {
            position: {
              target: {
                latitude: 39.9,
                longitude: 116.4
              },
              zoom: 10
            }
          },
          mapCallback: () => {
          }
        })
          .width('100%')
          .height('100%')
        // 配置区域
        Column() {
          HMCard() {
            ForEach(this.currentList, (item: SiteClass) => {
              HMCard_item({
                leftTitle: item.name,
                rightTitle: `${item.distance.toString()}m以内`,
                handleRightClick: () => {
                  router.back({
                    url: "pages/ExceptionReport/ExceptionReport",
                    params: {
                      location: item.name,
                    }
                  })
                }
              })
            })
          }
        }
        .padding({
          bottom: 60
        })
      }
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}