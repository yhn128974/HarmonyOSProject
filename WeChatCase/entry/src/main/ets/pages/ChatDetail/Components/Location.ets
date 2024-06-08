import { MapComponent, mapCommon, map } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { geoLocationManager } from '@kit.LocationKit';


@Component
export default struct Location {
  // 初始属性
  private mapOption?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  @Link currentAddress: string

  aboutToAppear(): void {

    // 地图初始化参数，设置地图中心点坐标及层级
    this.mapOption = {
      position: {
        target: {
          latitude: 39.9,
          longitude: 116.4
        },
        zoom: 10
      }
    };

    // 地图初始化的回调
    this.callback = async (err, mapController) => {
      if (!err) {
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        this.mapController.setMyLocationEnabled(true) //允许我的定位
        this.mapController.setMyLocationControlsEnabled(true) //允许我的定位组件显示
        // 此时此刻就可以拿到定位
        this.getLocation()


      }
    };
  }

  async getLocation() {
    try {
      const result = await geoLocationManager.getCurrentLocation()
      this.mapController?.setMyLocation({

        latitude: result.latitude,

        longitude: result.longitude,

        // 高度
        altitude: result.altitude,
        //准确性
        accuracy: result.accuracy,
        //
        speed: result.speed,
        // 时间戳
        timeStamp: result.timeStamp,
        //
        direction: result.direction,
        // 通用场景
        timeSinceBoot: result.timeSinceBoot


      })
      // AlertDialog.show({
      //   message: JSON.stringify(result)
      // })

      //  地图上的位置实际上是照相机的位置
      let cameraUpdate: map.CameraUpdate = map.newCameraPosition({
        target: {
          latitude: result.latitude,
          longitude: result.longitude,
        },
        zoom: 10
      })

      this.mapController?.moveCamera(cameraUpdate)

      //   利用花瓣地图的浮层
      this.mapController?.addMarker({
        position: {
          latitude: result.latitude,
          longitude: result.longitude,
        },
        title: '您当前的位置',
        clickable: true
      })
      // 添加一个圆圈
      this.mapController?.addCircle({
        radius: 500,
        center: {
          latitude: result.latitude,
          longitude: result.longitude,
        },
        fillColor: Color.Gray
      })

      // 要拿到经纬度的具体的街道的位置
      const res =await geoLocationManager.getAddressesFromLocation({
        latitude: result.latitude,
        longitude: result.longitude,
      })
      if (res.length) {
        this.currentAddress=res[0].placeName as string
      }
      AlertDialog.show({
        message: JSON.stringify(res)
      })
    }

    catch (error) {
      AlertDialog.show({
        message: JSON.stringify(error.message)
      })
    }

  }

  build() {
    Stack() {
      // 调用MapComponent组件初始化地图
      MapComponent({ mapOptions: this.mapOption, mapCallback: this.callback })
        .width('100%')
        .height('100%');

    }.height('100%').width('100%')
  }
}
