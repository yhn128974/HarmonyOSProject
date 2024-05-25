import { Head, add } from '@hm/basic/Index';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Head()
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('add').onClick((event: ClickEvent) => {
          this.message = add(1, 1).toString()
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}