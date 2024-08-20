@Preview
@CustomDialog
export struct CommonDialog {
  confirm?: () => void;
  title: string = '';
  tips: string = '';
  controller?: CustomDialogController;

  build() {
    Column() {
      if (this.title.length > 0) {
        Text(this.title)
          .textAlign(TextAlign.Center)
          .width('90%')
      }
      if (this.tips.length > 0) {
        Text(this.tips)
          .textAlign(TextAlign.Center)
          .width('90%')
      }
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('CANCEL')
          .onClick(() => {
            this.controller?.close();
          })
        Button('CONFIRM')
          .onClick(() => {
            this.controller?.close();
            this.confirm?.();
          })
      }
      .margin({ top: 10 })
    }
    .padding(20)
  }
}