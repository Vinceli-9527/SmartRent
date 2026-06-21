@Component
export struct NavBar {
  @Prop title: string = ''
  @Prop showBack: boolean = true
  onBack?: () => void

  build() {
    Row() {
      if (this.showBack) {
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .margin({ right: 12 })
          .onClick(() => {
            if (this.onBack) {
              this.onBack();
            }
          })
      }
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
      if (this.showBack) {
        Row().width(24).height(24)
      }
    }
    .width('100%')
    .height(44)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
  }
}
