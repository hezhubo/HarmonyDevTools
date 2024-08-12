import { BaseButtonModifier } from '../widget/BaseButtonModifier';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State buttonModifier: BaseButtonModifier = new BaseButtonModifier();

  build() {
    Column() {
      Column() {
        Text(`鸿蒙开发工具`)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text(`by Hezb`)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .padding({ top: 40, bottom: 20 })
      .backgroundColor(Color.Blue)
      .width('100%')
      // 设置顶部绘制延伸到状态栏
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap, alignContent: FlexAlign.Start }) {
        Button("设备信息")
          .attributeModifier(this.buttonModifier)
          .onClick(() => {
            router.pushUrl({ url: 'pages/DeviceInfoPage' });
          })

        Button("Postman")
          .attributeModifier(this.buttonModifier)
          .onClick(() => {
            router.pushUrl({ url: 'pages/PostmanPage' });
          })

      }
      .padding({ left: 10, top: 10, right: 10, bottom: 10 })
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}