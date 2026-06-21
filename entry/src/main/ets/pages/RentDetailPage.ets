import { HouseApi } from '../api/HouseApi';
import { HouseDetail, HouseImage } from '../model/HouseData';
import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct RentDetailPage {
  @State house: HouseDetail = new HouseDetail()
  @State loading: boolean = false
  private houseId: string = ''
  private primaryColor: string = '#2E6FDC'

  aboutToAppear() {
    const routerParams = router.getParams() as Record<string, Object>;
    if (routerParams && routerParams['id']) {
      this.houseId = routerParams['id'] as string;
      this.applyPreviewData(routerParams);
      this.loadDetail();
    }
  }

  applyPreviewData(params: Record<string, Object>) {
    if (params['title']) this.house.title = params['title'] as string;
    if (params['price']) {
      this.house.price = params['price'] as number;
      this.house.originalPrice = 0;
    }
    if (params['roomType']) this.house.roomType = params['roomType'] as string;
    if (params['area']) this.house.area = params['area'] as number;
    if (params['floor']) this.house.floor = params['floor'] as string;
    if (params['address']) this.house.address = params['address'] as string;
    if (params['coverUrl']) {
      const img = new HouseImage();
      img.url = params['coverUrl'] as string | Resource;
      img.isCover = true;
      this.house.images = [img];
    }
    if (params['tags']) {
      const tags = params['tags'] as string[];
      if (tags) this.house.tags = tags;
    }
    if (params['orientation']) this.house.orientation = params['orientation'] as string;
    if (params['decoration']) this.house.decoration = params['decoration'] as string;
    if (params['community']) this.house.community = params['community'] as string;
    if (params['description']) this.house.description = params['description'] as string;
    if (params['landlordName']) this.house.landlordName = params['landlordName'] as string;
    if (params['contactPhone']) this.house.contactPhone = params['contactPhone'] as string;
    if (params['facilities']) {
      const facs = params['facilities'] as string[];
      if (facs) this.house.facilities = facs;
    }
  }

  loadDetail() {
    if (!this.houseId) return;
    this.loading = true;
    HouseApi.getHouseDetail(this.houseId).then((res) => {
      this.loading = false;
      if (res.code === 0 && res.data) {
        this.house = res.data;
      }
    }).catch(() => {
      this.loading = false;
    });
  }

  bookNow() {
    const bookingParams: Record<string, Object> = {};
    bookingParams['houseId'] = this.houseId;
    bookingParams['title'] = this.house.title;
    bookingParams['price'] = this.house.price;
    router.pushUrl({ url: 'pages/BookingPage', params: bookingParams });
  }

  toggleFavorite() {
    this.house.isFavorite = !this.house.isFavorite;
    promptAction.showToast({ message: this.house.isFavorite ? '已收藏' : '已取消收藏' });
  }

  build() {
    Column() {
      Stack() {
        Scroll() {
          Column() {
            if (this.house.images.length > 0) {
              Swiper() {
                ForEach(this.house.images, (img: HouseImage) => {
                  Image(img.url)
                    .width('100%')
                    .height(300)
                    .objectFit(ImageFit.Cover)
                })
              }
              .width('100%')
              .height(300)
              .autoPlay(true)
              .interval(4000)
              .indicatorStyle({ selectedColor: this.primaryColor, color: '#FFFFFF' })
            } else {
              Row()
                .width('100%')
                .height(260)
                .backgroundColor('#E9EEF5')
            }

            Row() {
              Image($r('app.media.ic_back_white'))
                .width(24)
                .height(24)
                .onClick(() => { router.back() })
            }
            .width(40)
            .height(40)
            .borderRadius(20)
            .backgroundColor('rgba(0,0,0,0.28)')
            .justifyContent(FlexAlign.Center)
            .position({ x: 16, y: 48 })

            Column() {
              Row() {
                Text(`\u00A5${this.house.price}`)
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#D94A3A')
                Text('/月')
                  .fontSize(14)
                  .fontColor('#8A94A6')
                if (this.house.originalPrice > this.house.price) {
                  Text(`\u00A5${this.house.originalPrice}`)
                    .fontSize(14)
                    .fontColor('#C0C7D2')
                    .decoration({ type: TextDecorationType.LineThrough })
                    .margin({ left: 8 })
                }
                Blank()
                if (this.house.tags.length > 0) {
                  ForEach(this.house.tags.slice(0, 2), (tag: string) => {
                    Text(tag)
                      .fontSize(11)
                      .fontColor(this.primaryColor)
                      .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                      .backgroundColor('#EEF5FF')
                      .borderRadius(8)
                      .margin({ left: 4 })
                  })
                }
              }
              .width('100%')
              .margin({ bottom: 8 })

              if (this.house.title) {
                Text(this.house.title)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#202733')
                  .width('100%')
                  .margin({ bottom: 14 })
              }

              if (this.house.address) {
                Row() {
                  Image($r('app.media.ic_location'))
                    .width(18)
                    .height(18)
                    .fillColor(this.primaryColor)
                  Text(this.house.address)
                    .fontSize(14)
                    .fontColor('#667085')
                    .margin({ left: 6 })
                    .layoutWeight(1)
                }
                .width('100%')
                .margin({ bottom: 16 })
              }

              if (this.house.roomType || this.house.area || this.house.floor ||
                  this.house.orientation || this.house.decoration || this.house.community) {
                Grid() {
                  if (this.house.roomType) {
                    GridItem() { this.InfoItem('户型', this.house.roomType) }
                  }
                  if (this.house.area > 0) {
                    GridItem() { this.InfoItem('面积', `${this.house.area}m\u00B2`) }
                  }
                  if (this.house.floor) {
                    GridItem() { this.InfoItem('楼层', this.house.floor) }
                  }
                  if (this.house.orientation) {
                    GridItem() { this.InfoItem('朝向', this.house.orientation) }
                  }
                  if (this.house.decoration) {
                    GridItem() { this.InfoItem('装修', this.house.decoration) }
                  }
                  if (this.house.community) {
                    GridItem() { this.InfoItem('小区', this.house.community) }
                  }
                }
                .columnsTemplate('1fr 1fr 1fr')
                .columnsGap(8)
                .rowsGap(8)
                .margin({ bottom: 18 })
              }

              if (this.house.facilities.length > 0) {
                this.SectionTitle('配套设施')
                Flex({ wrap: FlexWrap.Wrap }) {
                  ForEach(this.house.facilities, (item: string) => {
                    Text(item)
                      .fontSize(12)
                      .fontColor('#667085')
                      .padding({ left: 12, right: 12, top: 7, bottom: 7 })
                      .backgroundColor('#F2F6FC')
                      .borderRadius(10)
                      .margin({ right: 8, bottom: 8 })
                  })
                }
                .width('100%')
                .margin({ bottom: 18 })
              }

              if (this.house.description) {
                this.SectionTitle('房源描述')
                Text(this.house.description)
                  .fontSize(14)
                  .fontColor('#667085')
                  .lineHeight(22)
                  .width('100%')
                  .margin({ bottom: 18 })
              }

              this.SectionTitle('联系房东')
              Row() {
                Image($r('app.media.ic_landlord'))
                  .width(48)
                  .height(48)
                  .fillColor(this.primaryColor)
                  .borderRadius(24)
                  .backgroundColor('#EEF5FF')
                Column() {
                  Text(this.house.landlordName || '房东')
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#202733')
                  Text(this.house.contactPhone || '预约后可查看联系方式')
                    .fontSize(13)
                    .fontColor('#8A94A6')
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 10 })
                Blank()
                Image($r('app.media.ic_phone_call'))
                  .width(34)
                  .height(34)
                  .fillColor(this.primaryColor)
              }
              .width('100%')
              .margin({ bottom: 88 })
            }
            .width('100%')
            .padding(18)
            .backgroundColor('#FFFFFF')
            .borderRadius({ topLeft: 22, topRight: 22 })
            .margin({ top: -20 })
          }
          .width('100%')
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)

        if (this.loading) {
          Row() {
            LoadingProgress().width(28).height(28)
          }
          .width('100%')
          .height(48)
          .position({ x: 0, y: 310 })
          .justifyContent(FlexAlign.Center)
        }

        Row() {
          Column() {
            Image(this.house.isFavorite ? $r('app.media.ic_fav_filled') : $r('app.media.ic_fav'))
              .width(24)
              .height(24)
              .fillColor(this.house.isFavorite ? this.primaryColor : '#8A94A6')
            Text('收藏')
              .fontSize(10)
              .fontColor(this.house.isFavorite ? this.primaryColor : '#8A94A6')
              .margin({ top: 2 })
          }
          .onClick(() => { this.toggleFavorite() })
          .margin({ right: 20 })

          Button('预约看房')
            .width('100%')
            .height(44)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor(this.primaryColor)
            .borderRadius(22)
            .layoutWeight(1)
            .onClick(() => { this.bookNow() })
        }
        .width('100%')
        .height(66)
        .padding({ left: 18, right: 18 })
        .backgroundColor('#FFFFFF')
        .position({ x: 0, y: '100%' })
        .translate({ x: 0, y: -66 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }

  @Builder SectionTitle(title: string) {
    Text(title)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .fontColor('#202733')
      .width('100%')
      .margin({ bottom: 10 })
  }

  @Builder InfoItem(label: string, value: string) {
    Column() {
      Text(label)
        .fontSize(12)
        .fontColor('#8A94A6')
        .margin({ bottom: 4 })
      Text(value)
        .fontSize(14)
        .fontColor('#202733')
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(58)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F7F9FC')
    .borderRadius(12)
  }
}
