import { RoomRecommendData } from '../model/RoomRecommendData';
import { router } from '@kit.ArkUI';

@Component
export struct RoomRecommend {
  @Prop list: RoomRecommendData[] = []
  @Prop title: string = '为你推荐'
  @Prop loading: boolean = false
  @Prop hasMore: boolean = false
  @Prop favoriteIds: string[] = []
  onLoadMore?: () => void
  onRefresh?: () => void
  onFavorite?: (item: RoomRecommendData) => void

  build() {
    Column() {
      if (this.title) {
        Row() {
          Text(this.title)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#202733')
          Blank()
          Row() {
            Text('更多')
              .fontSize(12)
              .fontColor('#8A94A6')
            Image($r('app.media.ic_arrow_right'))
              .width(12)
              .height(12)
              .fillColor('#8A94A6')
              .margin({ left: 2 })
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/RentListPage' });
          })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 12 })
      }

      if (this.list.length === 0 && !this.loading) {
        Column() {
          Image($r('app.media.ic_empty'))
            .width(104)
            .height(104)
            .margin({ top: 40, bottom: 12 })
          Text('暂无推荐房源')
            .fontSize(14)
            .fontColor('#8A94A6')
        }
        .width('100%')
        .padding({ top: 20, bottom: 40 })
      } else {
        Grid() {
          ForEach(this.list, (item: RoomRecommendData) => {
            GridItem() {
              this.RoomCard(item)
            }
          }, (item: RoomRecommendData) => item.id)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(12)
        .rowsGap(14)
        .width('100%')
        .padding({ left: 20, right: 20 })

        Row() {
          if (this.loading) {
            LoadingProgress()
              .width(18)
              .height(18)
            Text('加载中...')
              .fontSize(12)
              .fontColor('#8A94A6')
              .margin({ left: 8 })
          } else if (!this.hasMore) {
            Text('已展示全部推荐')
              .fontSize(12)
              .fontColor('#C0C7D2')
          } else {
            Text('点击加载更多')
              .fontSize(12)
              .fontColor('#8A94A6')
              .onClick(() => {
                if (this.onLoadMore) this.onLoadMore();
              })
          }
        }
        .width('100%')
        .height(52)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
  }

  @Builder RoomCard(item: RoomRecommendData) {
    Column() {
      Stack() {
        Image(item.coverUrl)
          .width('100%')
          .height(118)
          .borderRadius({ topLeft: 18, topRight: 18 })
          .objectFit(ImageFit.Cover)
        if (item.isNew) {
          Text('新上')
            .fontSize(10)
            .fontColor('#FFFFFF')
            .backgroundColor('#2E6FDC')
            .padding({ left: 7, right: 7, top: 3, bottom: 3 })
            .borderRadius(8)
            .position({ x: 8, y: 8 })
        }
      }
      .width('100%')
      .height(118)

      Column() {
        Text(item.title)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#202733')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Row() {
          if (item.roomType) {
            Text(item.roomType)
              .fontSize(11)
              .fontColor('#8A94A6')
              .maxLines(1)
          }
          if (item.area > 0) {
            Text(' | ')
              .fontSize(11)
              .fontColor('#E1E6EF')
            Text(`${item.area}m\u00B2`)
              .fontSize(11)
              .fontColor('#8A94A6')
          }
        }
        .margin({ top: 6 })

        Text(item.address)
          .fontSize(11)
          .fontColor('#8A94A6')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 4 })
          .width('100%')

        if (item.tags.length > 0) {
          Row() {
            ForEach(item.tags.slice(0, 2), (tag: string) => {
              Text(tag)
                .fontSize(9)
                .fontColor('#2E6FDC')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .backgroundColor('#EEF5FF')
                .borderRadius(6)
                .margin({ right: 4 })
                .maxLines(1)
            })
          }
          .margin({ top: 7 })
        }

        Row() {
          Text(`\u00A5${item.price}`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#D94A3A')
          Text('/月')
            .fontSize(10)
            .fontColor('#8A94A6')
          Blank()
          Image(this.favoriteIds.indexOf(item.id) >= 0 ? $r('app.media.ic_fav_filled') : $r('app.media.ic_fav'))
            .width(18)
            .height(18)
            .fillColor(this.favoriteIds.indexOf(item.id) >= 0 ? '#2E6FDC' : '#A8B0BD')
            .onClick(() => {
              if (this.onFavorite) this.onFavorite(item);
            })
        }
        .width('100%')
        .margin({ top: 8 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 10, right: 10, top: 10, bottom: 12 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(18)
    .shadow({ radius: 16, color: '#18000000', offsetX: 0, offsetY: 8 })
    .onClick(() => {
      const detailParams: Record<string, Object> = {};
      detailParams['id'] = item.id;
      detailParams['title'] = item.title;
      detailParams['price'] = item.price;
      detailParams['area'] = item.area;
      detailParams['roomType'] = item.roomType;
      detailParams['floor'] = item.floor;
      detailParams['address'] = item.address;
      detailParams['coverUrl'] = item.coverUrl;
      detailParams['tags'] = item.tags;
      router.pushUrl({ url: 'pages/RentDetailPage', params: detailParams });
    })
  }
}
