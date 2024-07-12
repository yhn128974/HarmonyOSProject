import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct SpecifiedAbilityPage {
  @State message: string = 'SpecifiedAbilityPage';
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('terminateSelf').onClick((event: ClickEvent) => {
          let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
          // context为需要停止的UIAbility实例的AbilityContext
          context.terminateSelf((err) => {
            if (err.code) {
              promptAction.showToast({
                message:err.message
              })
            }
          });
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}

