
@Entry
@Component
struct Count {
  // 接收来自entryFromAbility的值
  @Watch('handleIDChange')
  //formBindingData.createFormBindingData
  @LocalStorageProp('formId')
  formId: string = ''

  @LocalStorageProp('num') num: number = 0

  // 说明拿到id
  handleIDChange() {
    // 应用=>卡片
    postCardAction(this, {
      action: 'call',
      abilityName: 'EntryAbility',
      params: {
        method: 'updateID', //
        formId: this.formId
      }
    })
  }

  build() {
    Column() {
      Row({
        space: 10
      }) {
        Button('- ').onClick((event: ClickEvent) => {
          if (this.num > 0) {
            this.num--
            postCardAction(this, {
              action: 'call',
              abilityName: 'EntryAbility',
              params: {
                method: 'updateNum', //
                num: this.num
              }
            })
          }
        }).type(ButtonType.Circle).width(20).aspectRatio(1)
        Text(this.num.toString())
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('+ ').onClick((event: ClickEvent) => {
          this.num++
          postCardAction(this, {
            action: 'call',
            abilityName: 'EntryAbility',
            params: {
              method: 'updateNum', //
              num: this.num
            }
          })
        }).type(ButtonType.Circle).width(20).aspectRatio(1)
      }

      Text(this.formId).width('100%')

    }
    .width('100%').height('100%').onClick(() => {
      postCardAction(this, {
        action: 'router',
        abilityName: 'EntryAbility'
      })
    })

  }
}

