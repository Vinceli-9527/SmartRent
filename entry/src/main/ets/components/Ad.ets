/**
 * 5.7 Ad 组件
 * Banner 轮播广告组件
 */
@Component
export struct Ad {
  @Prop banners: Array<string | Resource> = []
  @Prop bannerHeight: number = 150
  @Prop autoPlay: boolean = true
  @Prop interval: number = 3000
  @Prop radius: number = 22
  @Prop indicatorColor: string = '#2E6FDC'
  @Prop indicatorBgColor: string = '#D0D0D0'
  onBannerClick?: (index: number) => void

  build() {
    Column() {
      Swiper() {
        ForEach(this.banners, (url: string | Resource, index: number) => {
          Image(url)
            .width('100%')
            .height(this.bannerHeight)
            .borderRadius(this.radius)
            .objectFit(ImageFit.Cover)
            .onClick(() => {
              if (this.onBannerClick) this.onBannerClick(index);
            })
        }, (url: string | Resource, index: number) => `${index}`)
      }
      .width('100%')
      .height(this.bannerHeight)
      .autoPlay(this.autoPlay)
      .interval(this.interval)
      .indicatorStyle({
        selectedColor: this.indicatorColor,
        color: this.indicatorBgColor
      })
      .borderRadius(this.radius)
      .padding({ left: 20, right: 20 })
    }
    .width('100%')
    .visibility(this.banners.length > 0 ? Visibility.Visible : Visibility.None)
  }
}
