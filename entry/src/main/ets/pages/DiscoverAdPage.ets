import { router } from '@kit.ArkUI';
import { NavBar } from '../components/NavBar';

@Entry
@Component
struct DiscoverAdPage {
  private primaryColor: string = '#2E6FDC'

  build() {
    Column() {
      NavBar({ title: '会员服务', showBack: true, onBack: () => { router.back() } })
      Column() {
        Image($r('app.media.ic_service_housekeeper'))
          .width(64)
          .height(64)
          .fillColor(this.primaryColor)
          .margin({ bottom: 18 })
        Text('会员服务')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
        Text('这是会员服务广告的预设空白页面，后续可接入会员活动、权益配置和开通流程。')
          .fontSize(14)
          .fontColor('#6D7B8F')
          .lineHeight(22)
          .textAlign(TextAlign.Center)
          .margin({ top: 10 })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 34, right: 34 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }
}
