import { ResManager, UserSore } from '@hm/basic/Index';
import { authentication } from '@kit.AccountKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { util } from '@kit.ArkTS';
import { Log } from '@abner/log';
import { getToken } from '../api';
import { router } from '@kit.ArkUI';


@Entry
@Component
struct LoginPage {
  async handLogining() {

    //////////////////////////////////////////////////////////
    // Log.info('请求登录', "start")
    // // 创建授权请求，并设置参数
    // let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // // 获取手机号需要传如下scope，传参数之前需要先申请对应scope权限,才能返回对应数据
    // authRequest.scopes = ['phone'];
    // // 获取code需传如下permission
    // authRequest.permissions = ['serviceauthcode'];
    // // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    // authRequest.forceAuthorization = true;
    // // 用于防跨站点请求伪造，非空字符串即可
    // authRequest.state = util.generateRandomUUID();
    //
    // // 执行请求
    // try {
    //   let controller = new authentication.AuthenticationController(getContext(this));
    //
    //   controller.executeRequest(authRequest, async (err, data) => {
    //     if (err) {
    //       Log.error('auth fail,error: %{public}s', JSON.stringify(err));
    //       return;
    //     }
    //     let authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
    //     let state = authorizationWithHuaweiIDResponse.state;
    //     if (state != undefined && authRequest.state != state) {
    //       Log.error('auth fail,The state is different: %{public}s',
    //         JSON.stringify(authorizationWithHuaweiIDResponse));
    //       return;
    //     }
    //     Log.debug('auth success: %{public}s',
    //       JSON.stringify(authorizationWithHuaweiIDResponse));
    //     let authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse.data!;
    //     let code = authorizationWithHuaweiIDCredential.authorizationCode as string;
    //     Log.warn(`华为授权码:${code}`)
    //     // 开发者处理code 获取一键登录的授权码 code=>调用后台 api获取token
    //     const token = await getToken({
    //       clientId: '111108285',
    //       //华为应用秘钥
    //       clientSecret: '80feb85b07f3a86274a763f6c2ac045afafac3a538274b9bee7bb4b35fb299f4',
    //       //华为账号授权码
    //       code: code
    //     })
    //     Log.info("token", token)
    //     // 持久化
    //     let context = getContext()
    //     UserSore.context = context
    //     await UserSore.setUserInfo({ token })
    //     router.replaceUrl({
    //       url: 'pages/Index'
    //     })
    //   });
    // } catch (error) {
    //   Log.error('auth failed: %{public}s', JSON.stringify(error));
    // }
    //////////////////////////////////////////////////////////////////

    // 持久化
    let context = getContext()
    UserSore.context = context
    await UserSore.setUserInfo({
      token: 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw'
    })
    router.replaceUrl({
      url: 'pages/Index'
    })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        // app 信息
        Column() {
          Image($r("app.media.pic_login_icon"))
            .width(124)
            .height(76)
            .margin({ bottom: 20 })
          Text() {
            Span('翼康养老')
              .fontColor('#000')
              .fontSize(24)
              .fontWeight(700)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#fff')

        Button({ stateEffect: true }) {
          Row({ space: 6.5 }) {
            Image(ResManager.IC_HUAWEI)
              .width(24)
              .aspectRatio(1)
            Text('华为登录')
              .fontColor('#fff')
              .fontWeight(500)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
          }
        }
        .onClick(() => {
          this.handLogining()
        })
        .margin({ top: 150 })
        .width(250)
        .height(40)
        .backgroundColor(ResManager.EC_MAIN_COLOR)
      }
    }
    .width('100%')
    .height('100%')
  }
}