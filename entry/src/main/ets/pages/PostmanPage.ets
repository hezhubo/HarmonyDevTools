import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

interface KV {
  key: string,
  value: string,
  isOn: boolean,
}

@Entry
@Component
struct PostmanPage {

  methodArray: http.RequestMethod[] = [
    http.RequestMethod.GET,
    http.RequestMethod.POST,
    http.RequestMethod.PUT,
    http.RequestMethod.DELETE,
  ];
  @State methodSelectOption: SelectOption[] = [
    { value: this.methodArray[0] },
    { value: this.methodArray[1] },
    { value: this.methodArray[2] },
    { value: this.methodArray[3] },
  ];
  methodSelectedIndex: number = 0;
  method: http.RequestMethod = this.methodArray[this.methodSelectedIndex];

  @State url: string = '';
  @State paramsArray: KV[] = [
    { key: '', value: '', isOn: true },
  ];
  @State headersArray: KV[] = [
    { key: 'Accept', value: '*/*', isOn: true },
    { key: 'Accept-Encoding', value: 'gzip, deflate', isOn: true },
    { key: '', value: '', isOn: true },
  ];

  @State bodyType: number = 0;

  @State rawJsonStr: string = '';

  @State responseStr: string = 'Response';

  @State isLoading: boolean = false;

  build() {
    Column() {
      Text(`Postman`)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)

      Row() {
        Select(this.methodSelectOption)
          .width(100)
          .height(40)
          .font({ size: 12, weight: FontWeight.Bold })
          .backgroundColor(Color.White)
          .value(this.methodSelectOption[this.methodSelectedIndex].value)
          .onSelect((index, value) => {
            this.methodSelectedIndex = index;
            this.method = this.methodArray[index];
          })

        TextInput({ text: this.url, placeholder: 'input request url' })
          .backgroundColor(Color.White)
          .onChange((value) => {
            this.url = value;
          })
          .layoutWeight(1)
          .width('100%')
          .height('auto')

        Button("Send", { type: ButtonType.Normal })
          .stateEffect(true)
          .fontColor(Color.White)
          .borderRadius(4)
          .padding({ left: 8, right: 8, top: 0, bottom: 0 })
          .margin({ left: 5, right: 10 })
          .onClick(() => {
            this.send();
          })
      }

      Tabs() {
        TabContent() {
          Scroll() {
            Column({ space: 5 }) {
              Row() {
                Blank()
                  .margin({ left: '14px', top: '14px', right: 10, bottom: '14px' })
                  .width(20)
                  .height(20)
                Text('Key')
                  .fontColor(Color.Black)
                  .fontWeight(FontWeight.Bold)
                  .layoutWeight(1)
                Text('Value')
                  .fontColor(Color.Black)
                  .fontWeight(FontWeight.Bold)
                  .layoutWeight(1)
                  .margin({ left: 5 })
              }
              .width('100%')
              .height('auto')
              ForEach(this.paramsArray, (item: KV, index) => {
                Row() {
                  if (index != this.paramsArray.length - 1) {
                    Toggle({ type: ToggleType.Checkbox, isOn: item.isOn })
                      .margin({ right: 10 })
                      .onChange((isOn) => {
                        item.isOn = isOn;
                      })
                  } else {
                    Blank()
                      .margin({ left: '14px', top: '14px', right: 10, bottom: '14px' })
                      .width(20)
                      .height(20)
                  }
                  TextInput({ text: item.key, placeholder: 'Key' })
                    .backgroundColor(Color.White)
                    .onChange((value) => {
                      item.key = value;
                      if (index == this.paramsArray.length - 1) {
                        this.paramsArray.push({ key: '', value: '', isOn: true });
                      }
                    })
                    .padding(0)
                    .layoutWeight(1)
                    .width('100%')
                    .height('auto')
                  TextInput({ text: item.value, placeholder: 'Value' })
                    .backgroundColor(Color.White)
                    .onChange((value) => {
                      item.value = value;
                      if (index == this.paramsArray.length - 1) {
                        this.paramsArray.push({ key: '', value: '', isOn: true });
                      }
                    })
                    .margin({ left: 5 })
                    .padding(0)
                    .layoutWeight(1)
                    .width('100%')
                    .height('auto')
                }
                .width('100%')
                .height('auto')
              })
            }
            .justifyContent(FlexAlign.Start)
            .padding(5)
            .width('100%')
            .height('auto')
          }
          .align(Alignment.Top)
          .width('100%')
          .height('100%')
        }
        .tabBar('Params')

        TabContent() {
          Scroll() {
            Column({ space: 5 }) {
              Row() {
                Blank()
                  .margin({ left: '14px', top: '14px', right: 10, bottom: '14px' })
                  .width(20)
                  .height(20)
                Text('Key')
                  .fontColor(Color.Black)
                  .fontWeight(FontWeight.Bold)
                  .layoutWeight(1)
                Text('Value')
                  .fontColor(Color.Black)
                  .fontWeight(FontWeight.Bold)
                  .layoutWeight(1)
                  .margin({ left: 5 })
              }
              .width('100%')
              .height('auto')
              ForEach(this.headersArray, (item: KV, index) => {
                Row() {
                  if (index != this.headersArray.length - 1) {
                    Toggle({ type: ToggleType.Checkbox, isOn: item.isOn })
                      .margin({ right: 10 })
                      .onChange((isOn) => {
                        item.isOn = isOn;
                      })
                  } else {
                    Blank()
                      .margin({ left: '14px', top: '14px', right: 10, bottom: '14px' })
                      .width(20)
                      .height(20)
                  }
                  TextInput({ text: item.key, placeholder: 'Key' })
                    .backgroundColor(Color.White)
                    .onChange((value) => {
                      item.key = value;
                      if (index == this.headersArray.length - 1) {
                        this.headersArray.push({ key: '', value: '', isOn: true });
                      }
                    })
                    .padding(0)
                    .layoutWeight(1)
                    .width('100%')
                    .height('auto')
                  TextInput({ text: item.value, placeholder: 'Value' })
                    .backgroundColor(Color.White)
                    .onChange((value) => {
                      item.value = value;
                      if (index == this.headersArray.length - 1) {
                        this.headersArray.push({ key: '', value: '', isOn: true });
                      }
                    })
                    .margin({ left: 5 })
                    .padding(0)
                    .layoutWeight(1)
                    .width('100%')
                    .height('auto')
                }
                .width('100%')
                .height('auto')
              })
            }
            .justifyContent(FlexAlign.Start)
            .padding(5)
            .width('100%')
            .height('auto')
          }
          .align(Alignment.Top)
          .width('100%')
          .height('100%')
        }
        .tabBar('Headers')

        TabContent() {
          Column() {
            Scroll() {
              Row() {
                Radio({ value: 'from-data', group: 'bodyGroup', indicatorType: RadioIndicatorType.DOT })
                  .checked(true)
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.bodyType = 0;
                    }
                  })
                Text('from-data')

                Radio({ value: 'x-www-form-urlencoded', group: 'bodyGroup', indicatorType: RadioIndicatorType.DOT })
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.bodyType = 1;
                    }
                  })
                  .margin({ left: 10 })
                Text('x-www-form-urlencoded')

                Radio({ value: 'raw', group: 'bodyGroup', indicatorType: RadioIndicatorType.DOT })
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.bodyType = 2;
                    }
                  })
                  .margin({ left: 10 })
                Text('raw')
              }
              .margin({ left: 10, right: 10 })
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
            .width('100%')

            if (this.bodyType == 0) {
              // TODO from-data UI
            } else if (this.bodyType == 1) {
              // TODO x-www-form-urlencoded UI
            } else {
              TextArea({ text: this.rawJsonStr, placeholder: 'input json' })
                .backgroundColor(Color.White)
                .onChange((value) => {
                  this.rawJsonStr = value;
                })
                .width('100%')
                .height('100%')
            }
          }
          .width('100%')
          .height('100%')
        }
        .tabBar('Body')

        TabContent() {
          // TODO settings UI
        }
        .tabBar('Settings')
      }
      .width('100%')
      .height(300)

      Divider()
        .width('100%')
        .height(0.5)
        .backgroundColor(Color.Gray)

      Scroll() {
        Text(this.responseStr)
          .fontSize(14)
          .copyOption(CopyOptions.LocalDevice)
          .margin(10)
          .width('100%')
          .height('auto')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .align(Alignment.TopStart)
      .layoutWeight(1)
      .width('100%')
      .height('100%')

    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
  }

  send() {
    if (this.url.length == 0) {
      promptAction.showToast({ message: "请求地址不能为空" });
      return;
    }
    let requestUrl = this.url;
    let paramsStr: string = '';
    this.paramsArray.forEach((value) => {
      if (value.isOn && value.key.length > 0 && value.value.length > 0) {
        paramsStr += `&${value.key}=${value.value}`;
      }
    });
    if (paramsStr.length > 0) {
      if (requestUrl.includes('?')) {
        requestUrl = `${requestUrl}${paramsStr.substring(1)}`;
      } else {
        requestUrl = `${requestUrl}?${paramsStr.substring(1)}`;
      }
    }

    let method: http.RequestMethod = this.methodArray[this.methodSelectedIndex];

    let headerObj: Record<string, string> = {};
    this.headersArray.forEach((header) => {
      if (header.isOn && header.key.length > 0 && header.value.length > 0) {
        headerObj[header.key] = header.value;
      }
    });
    // TODO
    if (this.bodyType == 0) {
      headerObj["Content-Type"] = "from-data";
    } else if (this.bodyType == 1) {
      headerObj["Content-Type"] = "application/x-www-form-urlencoded";
    } else {
      if (this.rawJsonStr.length > 0) {
        headerObj["Content-Type"] = "application/json";
      }
    }

    // TODO REQUEST
  }

}