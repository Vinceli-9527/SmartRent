import { router } from '@kit.ArkUI';
import { NavBar } from '../components/NavBar';

@Entry
@Component
struct MapSearchPage {
  @State destination: string = '望京 SOHO'
  @State scene: string = 'map'
  @State favoriteCount: number = 0
  @State averageRent: number = 0
  private primaryColor: string = '#2E6FDC'

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (!params) return;
    if (params['destination']) this.destination = params['destination'] as string;
    if (params['scene']) this.scene = params['scene'] as string;
    if (params['favoriteCount'] !== undefined) this.favoriteCount = params['favoriteCount'] as number;
    if (params['averageRent'] !== undefined) this.averageRent = params['averageRent'] as number;
  }

  getSceneTitle(): string {
    if (this.scene === 'amenities') return '周边配套';
    if (this.scene === 'subway') return '地铁沿线';
    if (this.scene === 'community') return '热门社区';
    return '地图找房';
  }

  @Builder MapPin(left: number, top: number, price: string) {
    Text(price)
      .fontSize(11)
      .fontWeight(FontWeight.Medium)
      .fontColor('#FFFFFF')
      .padding({ left: 9, right: 9, top: 5, bottom: 5 })
      .backgroundColor(this.primaryColor)
      .borderRadius(14)
      .position({ x: left, y: top })
  }

  @Builder FilterChip(label: string, selected: boolean) {
    Text(label)
      .fontSize(12)
      .fontColor(selected ? '#FFFFFF' : '#5B6678')
      .padding({ left: 12, right: 12, top: 7, bottom: 7 })
      .backgroundColor(selected ? this.primaryColor : '#F4F7FB')
      .borderRadius(14)
      .margin({ right: 8 })
  }

  build() {
    Column() {
      NavBar({ title: this.getSceneTitle(), showBack: true, onBack: () => { router.back() } })

      Column() {
        Row() {
          Image($r('app.media.ic_location'))
            .width(18)
            .height(18)
            .fillColor(this.primaryColor)
            .margin({ right: 8 })
          Text(this.destination)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#202733')
          Blank()
          Text('模拟地图')
            .fontSize(11)
            .fontColor('#6D7B8F')
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 14, bottom: 12 })

        Row() {
          this.FilterChip('周边配套', this.scene === 'amenities')
          this.FilterChip('地铁沿线', this.scene === 'subway')
          this.FilterChip('热门社区', this.scene === 'community')
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 12 })

        Stack() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#EDF4FB')
            .borderRadius(22)
          Divider()
            .width('74%')
            .color('#D8E4F0')
            .strokeWidth(2)
            .rotate({ angle: -20 })
          Divider()
            .width('86%')
            .color('#D8E4F0')
            .strokeWidth(2)
            .rotate({ angle: 16 })
          Circle()
            .width(90)
            .height(90)
            .fill('#33FFFFFF')
            .border({ width: 1, color: '#D7E6F4' })
          this.MapPin(42, 56, '3200')
          this.MapPin(182, 92, '2800')
          this.MapPin(112, 174, '4100')
        }
        .width('100%')
        .height(310)
        .padding(14)
        .margin({ left: 20, right: 20, bottom: 16 })

        Column() {
          Text('筛选摘要')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#202733')
            .width('100%')
          Text(`已参考 ${this.favoriteCount} 套收藏房源，平均租金 ${this.averageRent > 0 ? this.averageRent : '--'} 元/月。`)
            .fontSize(13)
            .fontColor('#6D7B8F')
            .lineHeight(20)
            .margin({ top: 8 })
          Text('当前页面为地图找房基础 UI，后续可接入地图 SDK、POI、路线与真实房源接口。')
            .fontSize(12)
            .fontColor('#8A94A6')
            .lineHeight(18)
            .margin({ top: 8 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(18)
        .backgroundColor('#FFFFFF')
        .borderRadius(20)
        .shadow({ radius: 18, color: '#12000000', offsetX: 0, offsetY: 8 })
        .margin({ left: 20, right: 20 })
      }
      .layoutWeight(1)
      .backgroundColor('#F6F8FB')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }
}
