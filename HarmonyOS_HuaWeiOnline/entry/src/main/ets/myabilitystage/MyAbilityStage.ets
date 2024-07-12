import { AbilityStage, Want } from '@kit.AbilityKit';

export default class MyAbilityStage extends AbilityStage {
  onCreate(): void {

  }

  onAcceptWant(want: Want): string {
    if (want.abilityName = 'Specifiedbility') {
      return want.parameters!.instanceKey.toString()
    }
    return ''
  }

  onConfigurationUpdated() {

  }

  onMemoryLevel() {

  }
}