@Preview
@CustomDialog
export struct CommonInputDialog {
  confirm?: (text: string) => void;
  inputText: string = '';
  placeholder: string = '';
  controller?: CustomDialogController;

  build() {
    Column() {
      TextInput({ placeholder: this.placeholder, text: this.inputText })
        .width('90%')
        .onChange((value: string) => {
          this.inputText = value;
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('CANCEL')
          .onClick(() => {
            this.controller?.close();
          })
        Button('CONFIRM')
          .onClick(() => {
            this.controller?.close();
            this.confirm?.(this.inputText);
          })
      }
      .margin({ top: 10 })
    }
    .padding(20)
  }

}