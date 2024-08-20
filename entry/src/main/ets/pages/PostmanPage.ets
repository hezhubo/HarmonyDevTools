import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { PreferencesUtils } from '../utils/PreferencesUtils';
import { CommonInputDialog } from '../widget/CommonInputDialog';
import { CommonDialog } from '../widget/CommonDialog';
import { RequestInfo, KV } from '../model/RequestInfo';

@Entry
@Component
struct PostmanPage {

  @State currentKey: string = `Postman`;
  @State requestKeySelect: SelectOption[] = [];

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
  @State methodSelectedIndex: number = 0;
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
  @State fromDataArray: KV[] = [
    { key: '', value: '', isOn: true },
  ];
  @State fromUrlEncodedArray: KV[] = [
    { key: '', value: '', isOn: true },
  ];
  @State rawJsonStr: string = '';
  @State usingCache: boolean = true;
  @State connectTimeout: number = 10000;
  @State readTimeout: number = 10000;

  @State responseStr: string = 'Response';

  @State isLoading: boolean = false;

  @State inputValue: string = 'click me'
  inputDialogController: CustomDialogController = new CustomDialogController({
    builder: CommonInputDialog({
      placeholder: 'input save key',
      confirm: (text: string) => {
        if (this.requestKeySelect.length > 0) {
          for (let i = 0; i < this.requestKeySelect.length; i++) {
            if (this.requestKeySelect[i].value == text) {
              // 提示已存在，是否覆盖
              this.toReplaceKey = text;
              this.dialogController.open();
              return;
            }
          }
        }
        this.save(text, false);
      }
    }),
  });
  toReplaceKey: string = '';
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CommonDialog({
      tips: "确定要覆盖已保存的请求吗？",
      confirm: () => {
        this.save(this.toReplaceKey, true);
      }
    }),
  });

  build() {
    Column() {
      Row() {
        if (this.requestKeySelect.length == 0) {
          Text(this.currentKey)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Black)
        } else {
          Select(this.requestKeySelect)
            .value(this.currentKey)
            .font({ size: 30, weight: FontWeight.Bold })
            .fontColor(Color.Black)
            .backgroundColor(Color.White)
            .onSelect((index, value) => {
              this.currentKey = value;
              this.loadLocalRequestParams(index);
            })
        }
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('auto')

      Row() {
        Select(this.methodSelectOption)
          .width(100)
          .height(40)
          .font({ size: 12, weight: FontWeight.Bold })
          .backgroundColor(Color.White)
          .selected(this.methodSelectedIndex)
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
                  .checked(this.bodyType == 0)
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.bodyType = 0;
                    }
                  })
                Text('from-data')

                Radio({ value: 'x-www-form-urlencoded', group: 'bodyGroup', indicatorType: RadioIndicatorType.DOT })
                  .checked(this.bodyType == 1)
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.bodyType = 1;
                    }
                  })
                  .margin({ left: 10 })
                Text('x-www-form-urlencoded')

                Radio({ value: 'raw', group: 'bodyGroup', indicatorType: RadioIndicatorType.DOT })
                  .checked(this.bodyType == 2)
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
            .align(Alignment.Start)
            .width('100%')

            if (this.bodyType == 0) {
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
                  ForEach(this.fromDataArray, (item: KV, index) => {
                    Row() {
                      if (index != this.fromDataArray.length - 1) {
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
                          if (index == this.fromDataArray.length - 1) {
                            this.fromDataArray.push({ key: '', value: '', isOn: true });
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
                          if (index == this.fromDataArray.length - 1) {
                            this.fromDataArray.push({ key: '', value: '', isOn: true });
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

            } else if (this.bodyType == 1) {
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
                  ForEach(this.fromUrlEncodedArray, (item: KV, index) => {
                    Row() {
                      if (index != this.fromUrlEncodedArray.length - 1) {
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
                          if (index == this.fromUrlEncodedArray.length - 1) {
                            this.fromUrlEncodedArray.push({ key: '', value: '', isOn: true });
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
                          if (index == this.fromUrlEncodedArray.length - 1) {
                            this.fromUrlEncodedArray.push({ key: '', value: '', isOn: true });
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
          Scroll() {
            Column({ space: 5 }) {
              Row() {
                Text('usingCache')
                  .layoutWeight(1)
                Toggle({ type: ToggleType.Switch, isOn: this.usingCache })
                  .onChange((isOn) => {
                    this.usingCache = isOn;
                  })
              }
              .padding({ left: 5, right: 5 })
              .width('100%')
              .height('auto')

              Row() {
                Text('connectTimeout')
                  .layoutWeight(1)
                TextInput({ text: this.connectTimeout.toString(), placeholder: 'ms' })
                  .backgroundColor(Color.White)
                  .type(InputType.Number)
                  .textAlign(TextAlign.End)
                  .onChange((value) => {
                    this.connectTimeout = Number.parseInt(value);
                  })
                  .width(100)
                  .height('auto')
              }
              .padding({ left: 5, right: 5 })
              .width('100%')
              .height('auto')

              Row() {
                Text('readTimeout')
                  .layoutWeight(1)
                TextInput({ text: this.readTimeout.toString(), placeholder: 'ms' })
                  .backgroundColor(Color.White)
                  .type(InputType.Number)
                  .textAlign(TextAlign.End)
                  .onChange((value) => {
                    this.readTimeout = Number.parseInt(value);
                  })
                  .width(100)
                  .height('auto')
              }
              .padding({ left: 5, right: 5 })
              .width('100%')
              .height('auto')
            }
            .width('100%')
            .height('100%')
          }
          .width('100%')
          .height('100%')
        }
        .tabBar('Settings')
      }
      .width('100%')
      .height(300)

      Divider()
        .width('100%')
        .height(0.5)
        .backgroundColor(Color.Gray)

      Stack() {
        Scroll() {
          Text(this.responseStr)
            .fontSize(14)
            .copyOption(CopyOptions.LocalDevice)
            .padding(10)
            .width('100%')
            .height('auto')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .align(Alignment.TopStart)
        .width('100%')
        .height('100%')

        LoadingProgress()
          .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
          .width(80)
          .height(80)

        Stack({ alignContent: Alignment.BottomEnd }) {
          Button("Save", { type: ButtonType.Normal })
            .stateEffect(true)
            .fontColor(Color.White)
            .borderRadius(4)
            .padding({ left: 8, right: 8, top: 0, bottom: 0 })
            .margin({ left: 5, right: 10 })
            .onClick(() => {
              this.inputDialogController.open();
            })
        }
        .width('100%')
        .height('100%')

      }
      .layoutWeight(1)
      .width('100%')
      .height('100%')

    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    let requestKeyArrayStr = PreferencesUtils.getString("REQUEST_KEY_ARRAY");
    if (requestKeyArrayStr.length > 0) {
      let localKey: string[] = JSON.parse(requestKeyArrayStr);
      localKey.forEach((key) => {
        this.requestKeySelect.push({ value: key })
      });
    }
  }

  save(key: string, isReplace: boolean) {
    if (key.length == 0) {
      promptAction.showToast({ message: "保存失败" });
      return;
    }
    let requestInfo = new RequestInfo();
    requestInfo.method = this.method;
    requestInfo.url = this.url;
    requestInfo.params = this.paramsArray;
    requestInfo.headers = this.headersArray;
    requestInfo.bodyType = this.bodyType;
    requestInfo.fromData = this.fromDataArray;
    requestInfo.fromUrlEncoded = this.fromUrlEncodedArray;
    requestInfo.rawJsonStr = this.rawJsonStr;
    PreferencesUtils.put(key, JSON.stringify(requestInfo));
    if (!isReplace) {
      this.requestKeySelect.push({ value: key });
      let localKey: string[] = [];
      this.requestKeySelect.forEach((selectOption) => {
        localKey.push(selectOption.value as string);
      })
      PreferencesUtils.put("REQUEST_KEY_ARRAY", JSON.stringify(localKey));
    }
    promptAction.showToast({ message: "保存成功" });
  }

  loadLocalRequestParams(index: number) {
    let key = this.requestKeySelect[index].value as string;
    let requestJsonStr = PreferencesUtils.getString(key);
    try {
      let requestInfo = JSON.parse(requestJsonStr) as RequestInfo;
      this.method = requestInfo.method;
      for (let i = 0; i < this.methodArray.length; i++) {
        if (this.method == this.methodArray[i]) {
          this.methodSelectedIndex = i;
          break;
        }
      }
      this.url = requestInfo.url;
      this.paramsArray = requestInfo.params;
      this.headersArray = requestInfo.headers;
      this.bodyType = requestInfo.bodyType;
      this.fromDataArray = requestInfo.fromData;
      this.fromUrlEncodedArray = requestInfo.fromUrlEncoded;
      this.rawJsonStr = requestInfo.rawJsonStr;
    } catch (e) {
      promptAction.showToast({ message: "加载失败" });
    }
  }

  send() {
    if (this.url.length == 0) {
      promptAction.showToast({ message: "请求地址不能为空" });
      return;
    }
    let requestUrl = this.url;
    let paramsStr: string = '';
    this.paramsArray.forEach((param) => {
      if (param.isOn && param.key.length > 0 && param.value.length > 0) {
        paramsStr += `&${param.key}=${param.value}`;
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

    let multiFormDataList: http.MultiFormData[] | null = null;
    let extraData: object | string | null = null;
    if (this.bodyType == 0) {
      if (this.fromDataArray.length > 1) {
        headerObj["Content-Type"] = "from-data";
        multiFormDataList = [];
        this.fromDataArray.forEach((data) => {
          if (data.isOn && data.key.length > 0) {
            multiFormDataList!!.push({
              name: data.key,
              contentType: 'text/plain',
              data: data.value,
            });
          }
        });
      }
    } else if (this.bodyType == 1) {
      if (this.fromUrlEncodedArray.length > 1) {
        headerObj["Content-Type"] = "application/x-www-form-urlencoded";
        extraData = new Object();
        this.fromUrlEncodedArray.forEach((data) => {
          if (data.isOn && data.key.length > 0) {
            extraData!![data.key] = data.value;
          }
        });
      }

    } else {
      if (this.rawJsonStr.length > 0) {
        try {
          let jsonObj: Record<string, object> = JSON.parse(this.rawJsonStr);
          headerObj["Content-Type"] = "application/json";
          this.rawJsonStr = JSON.stringify(jsonObj, null, 2); // 格式化显示
          extraData = this.rawJsonStr;
        } catch (e) {
          promptAction.showToast({ message: "Json不合法" })
        }
      }
    }

    this.isLoading = true;
    let request = http.createHttp();
    let options : http.HttpRequestOptions = {
      method: method,
      header: headerObj,
      usingCache: this.usingCache,
      connectTimeout: this.connectTimeout,
      readTimeout: this.readTimeout,
    }
    if (extraData != null) {
      options.extraData = extraData;
    }
    if (multiFormDataList != null) {
      options.multiFormDataList = multiFormDataList;
    }
    let response = request.request(requestUrl, options);
    response.then((data)=> {
      this.responseStr = JSON.stringify(data, null, 2);

    }).catch((e: BusinessError) => {
      this.responseStr = JSON.stringify(e, null, 2);
    }).finally(()=> {
      this.isLoading = false;
      request.destroy();
    });
  }

}