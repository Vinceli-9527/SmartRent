import { router } from '@kit.ArkUI';
import { NavBar } from '../components/NavBar';

@Entry
@Component
struct VipDetailPage {
  @State level: string = '黄金会员'
  @State validUntil: string = '2026.12.31'
  @State address: string = '阳光花园 12 号楼'
  private primaryColor: string = '#2E6FDC'

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (!params) return;
    if (params['level']) this.level = params['level'] as string;
    if (params['validUntil']) this.validUntil = params['validUntil'] as string;
    if (params['address']) this.address = params['address'] as string;
  }

  @Builder InfoRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(13)
        .fontColor('#8A94A6')
      Blank()
      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#202733')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(46)
  }

  @Builder BenefitItem(title: string, desc: string) {
    Row() {
      Image($r('app.media.ic_service_housekeeper'))
        .width(22)
        .height(22)
        .fillColor(this.primaryColor)
        .margin({ right: 10 })
      Column() {
        Text(title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#202733')
        Text(desc)
          .fontSize(12)
          .fontColor('#8A94A6')
          .margin({ top: 3 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
  }

  build() {
    Column() {
      NavBar({ title: '会员详情', showBack: true, onBack: () => { router.back() } })

      Scroll() {
        Column() {
          Column() {
            Text(this.level)
              .fontSize(26)
              .fontWeight(FontWeight.Bold)
              .fontColor('#202733')
            Text(`有效期至 ${this.validUntil}`)
              .fontSize(13)
              .fontColor('#6D7B8F')
              .margin({ top: 8 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(22)
          .backgroundColor('#FFFFFF')
          .borderRadius(22)
          .shadow({ radius: 22, color: '#16000000', offsetX: 0, offsetY: 10 })
          .margin({ left: 20, right: 20, top: 16, bottom: 14 })

          Column() {
            this.InfoRow('服务地址', this.address)
            this.InfoRow('会员等级', this.level)
            this.InfoRow('到期时间', this.validUntil)
          }
          .width('100%')
          .padding({ left: 18, right: 18 })
          .backgroundColor('#FFFFFF')
          .borderRadius(20)
          .shadow({ radius: 18, color: '#10000000', offsetX: 0, offsetY: 8 })
          .margin({ left: 20, right: 20, bottom: 14 })

          Column() {
            Text('会员权益')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#202733')
              .width('100%')
              .margin({ bottom: 6 })
            this.BenefitItem('专属服务响应', '家庭服务优先排期，减少等待时间')
            this.BenefitItem('精选服务商', '默认匹配平台认证服务人员')
            this.BenefitItem('入住养护提醒', '按服务地址生成周期性养护建议')
          }
          .width('100%')
          .padding(18)
          .backgroundColor('#FFFFFF')
          .borderRadius(20)
          .shadow({ radius: 18, color: '#10000000', offsetX: 0, offsetY: 8 })
          .margin({ left: 20, right: 20, bottom: 24 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }
}
