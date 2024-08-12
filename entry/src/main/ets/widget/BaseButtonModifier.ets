/**
 * 统一风格的按钮
 */
export class BaseButtonModifier implements AttributeModifier<ButtonAttribute> {

  applyNormalAttribute(instance: ButtonAttribute): void {
    let colorRandom = Math.ceil(Math.random() * 100) % 4;
    let color: Color;
    switch (colorRandom) {
      case 0:
        color = Color.Green;
        break;
      case 1:
        color = Color.Gray;
        break;
      case 2:
        color = Color.Orange;
        break;
      default:
        color = Color.Red;
        break;
    }

    instance
      .type(ButtonType.Normal)
      .stateEffect(true)
      .fontColor(Color.White)
      .borderRadius(4)
      .padding({ left: 8, right: 8, top: 0, bottom: 0 })
      .margin(5)
      .backgroundColor(color);
  }
}