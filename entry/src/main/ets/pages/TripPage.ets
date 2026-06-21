import { router } from '@kit.ArkUI';
import { NavBar } from '../components/NavBar';

@Entry
@Component
struct TripPage {
  @State destination: string = '望京 SOHO'
  @State favoriteCount: number = 0
  @State latestFavoriteTitle: string = '暂无最近收藏'
  @State averageRent: number = 0
  private primaryColor: string = '#2E6FDC'

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (!params) return;
    if (params['destination']) this.destination = params['destination'] as string;
    if (params['latestFavoriteTitle']) this.latestFavoriteTitle = params['latestFavoriteTitle'] as string;
    if (params['favoriteCount'] !== undefined) this.favoriteCount = params['favoriteCount'] as number;
    if (params['averageRent'] !== undefined) this.averageRent = params['averageRent'] as number;
  }

  @Builder RouteStep(index: string, title: string, desc: string) {
    Row() {
      Text(index)
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .width(28)
        .height(28)
        .textAlign(TextAlign.Center)
        .backgroundColor(this.primaryColor)
        .borderRadius(14)
      Column() {
        Text(title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#202733')
        Text(desc)
          .fontSize(12)
          .fontColor('#6D7B8F')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
  }

  @Builder InfoPill(label: string, value: string) {
    Column() {
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.primaryColor)
      Text(label)
        .fontSize(11)
        .fontColor('#8A94A6')
        .margin({ top: 3 })
    }
    .layoutWeight(1)
    .height(72)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F6F9FD')
    .borderRadius(16)
    .margin({ right: 8 })
  }

  build() {
    Column() {
      NavBar({ title: '通勤行程', showBack: true, onBack: () => { router.back() } })

      Scroll() {
        Column() {
          Column() {
            Text('目的地')
              .fontSize(12)
              .fontColor('#6D7B8F')
            Text(this.destination)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#202733')
              .margin({ top: 6 })
            Text('当前为本地模拟行程，后续可接入真实路线与用户接口。')
              .fontSize(12)
              .fontColor('#6D7B8F')
              .lineHeight(18)
              .margin({ top: 8 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(20)
          .shadow({ radius: 18, color: '#12000000', offsetX: 0, offsetY: 8 })
          .margin({ left: 20, right: 20, top: 16, bottom: 14 })

          Row() {
            this.InfoPill('收藏数量', `${this.favoriteCount}`)
            this.InfoPill('平均租金', this.averageRent > 0 ? `${this.averageRent}` : '--')
          }
          .width('100%')
          .padding({ left: 20, right: 12 })
          .margin({ bottom: 14 })

          Column() {
            Text('模拟行程建议')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#202733')
              .width('100%')
              .margin({ bottom: 8 })
            this.RouteStep('1', '从收藏房源出发', this.latestFavoriteTitle)
            this.RouteStep('2', '优先地铁或公交换乘', '预计 35-45 分钟，避开高峰拥堵路段')
            this.RouteStep('3', '抵达通勤目的地', this.destination)
          }
          .width('100%')
          .padding(18)
          .backgroundColor('#FFFFFF')
          .borderRadius(20)
          .shadow({ radius: 18, color: '#12000000', offsetX: 0, offsetY: 8 })
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
