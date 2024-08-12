import { deviceInfo } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';

interface DeviceItem {
  title: string,
  key: string,
  value: string,
}

@Entry
@Component
struct DeviceInfoPage {
  listScroller: Scroller = new Scroller();

  @State deviceItems: DeviceItem[] = [
    { title: '品牌', key: 'brand', value: deviceInfo.brand },
    { title: '设备类型', key: 'deviceType', value: deviceInfo.deviceType },
    { title: '厂家', key: 'manufacture', value: deviceInfo.manufacture },
    { title: '外部产品系列', key: 'marketName', value: deviceInfo.marketName },
    { title: '产品系列', key: 'productSeries', value: deviceInfo.productSeries },
    { title: '认证型号', key: 'productModel', value: deviceInfo.productModel },
    { title: '内部软件子型号', key: 'softwareModel', value: deviceInfo.softwareModel },
    { title: '硬件版本号', key: 'hardwareModel', value: deviceInfo.hardwareModel },
    // { title: '设备序列号', key: 'serial', value: deviceInfo.serial }, // 仅限系统应用使用，可作为设备唯一识别码。需要权限：ohos.permission.sec.ACCESS_UDID
    { title: 'Bootloader', key: 'bootloaderVersion', value: deviceInfo.bootloaderVersion },
    { title: '应用二进制接口', key: 'abiList', value: deviceInfo.abiList },
    { title: '安全补丁级别', key: 'securityPatchTag', value: deviceInfo.securityPatchTag },
    { title: '产品版本', key: 'displayVersion', value: deviceInfo.displayVersion },
    { title: '差异版本号', key: 'incrementalVersion', value: deviceInfo.incrementalVersion },
    { title: '发布类型', key: 'osReleaseType', value: deviceInfo.osReleaseType },
    { title: '系统版本', key: 'osFullName', value: deviceInfo.osFullName },
    { title: 'Major版本号', key: 'majorVersion', value: deviceInfo.majorVersion + '' },
    { title: 'Senior版本号', key: 'seniorVersion', value: deviceInfo.seniorVersion + '' },
    { title: 'Feature版本号', key: 'featureVersion', value: deviceInfo.featureVersion + '' },
    { title: 'Build版本号', key: 'buildVersion', value: deviceInfo.buildVersion + '' },
    { title: 'API版本', key: 'sdkApiVersion', value: deviceInfo.sdkApiVersion + '' },
    { title: '首个API版本', key: 'firstApiVersion', value: deviceInfo.firstApiVersion + '' },
    { title: '版本ID', key: 'versionId', value: deviceInfo.versionId },
    { title: '构建类型', key: 'buildType', value: deviceInfo.buildType },
    { title: '构建用户', key: 'buildUser', value: deviceInfo.buildUser },
    { title: '构建主机', key: 'buildHost', value: deviceInfo.buildHost },
    { title: '构建时间', key: 'buildTime', value: deviceInfo.buildTime },
    { title: '构建版本Hash', key: 'buildRootHash', value: deviceInfo.buildRootHash },
    // { title: '设备Udid', key: 'udid', value: deviceInfo.udid }, // 仅限系统应用使用。数据长度为65字节。可作为设备唯一识别码。需要权限：ohos.permission.sec.ACCESS_UDID
    { title: '发行版系统名称', key: 'distributionOSName', value: deviceInfo.distributionOSName },
    { title: '发行版系统版本号', key: 'distributionOSVersion', value: deviceInfo.distributionOSVersion },
    { title: '发行版系统API版本', key: 'distributionOSApiVersion', value: deviceInfo.distributionOSApiVersion + '' },
    { title: '发行版系统类型', key: 'distributionOSReleaseType', value: deviceInfo.distributionOSReleaseType + '' },
    { title: '开发者匿名设备标识符', key: 'ODID', value: deviceInfo.ODID + '' }, // 数据长度为37字节。同一设备上运行的同一个开发者的应用，ODID相同。同一个设备上不同开发者的应用，ODID不同。不同设备上同一个开发者的应用，ODID不同。不同设备上不同开发者的应用，ODID不同。
  ];

  build() {
    Column() {
      Text(`设备信息`)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)

      List({ scroller: this.listScroller }) {
        ForEach(this.deviceItems, (item: DeviceItem) => {
          ListItem() {
            Row() {
              Text(item.title)
                .width(120)
              Text(item.value)
                .layoutWeight(1)
            }
            .margin({ left: 10, top: 5, right: 10, bottom: 5 })
          }
        })
      }
      .padding({ top: 5, bottom: 5 })
      .width('100%')
      .height('100%')

    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    let deviceItem: DeviceItem = {
      title: '显示屏类型',
      key: 'displayType',
      value: `是否为折叠屏:${display.isFoldable()}`
    };
    this.deviceItems.push(deviceItem);
    display.getAllDisplays().then((displays) => {
      if (displays && displays.length > 0) {
        displays.forEach((item) => {
          let deviceItem: DeviceItem = {
            title: `显示屏(${item.id})`,
            key: item.id.toString(),
            value: `分辨率:${item.width}*${item.height} 密度:${item.densityDPI} 缩放系数:${item.densityPixels}`
          };
          this.deviceItems.push(deviceItem);
        });
      }
    });
  }

}