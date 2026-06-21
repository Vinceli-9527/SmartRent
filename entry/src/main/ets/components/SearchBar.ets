@Component
export struct SearchBar {
  @Prop placeholder: string = '搜索小区、商圈、地铁'
  @Prop showMsg: boolean = true
  @Prop searchText: string = ''
  @Prop editable: boolean = false
  onSearch?: () => void
  onMsg?: () => void
  onChange?: (value: string) => void

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_search'))
          .width(16)
          .height(16)
          .fillColor('#8A94A6')
          .margin({ left: 12, right: 6 })

        if (this.editable) {
          TextInput({ placeholder: this.placeholder, text: this.searchText })
            .layoutWeight(1)
            .height(40)
            .fontSize(14)
            .backgroundColor(Color.Transparent)
            .onChange((value: string) => {
              if (this.onChange) this.onChange(value);
            })
            .onSubmit(() => {
              if (this.onSearch) this.onSearch();
            })

          if (this.searchText.length > 0) {
            Image($r('app.media.ic_back'))
              .width(16)
              .height(16)
              .margin({ right: 10 })
              .fillColor('#8A94A6')
              .onClick(() => {
                if (this.onChange) this.onChange('');
              })
          }
        } else {
          Text(this.placeholder)
            .fontSize(14)
            .fontColor('#A8B0BD')
            .layoutWeight(1)
        }
      }
      .layoutWeight(1)
      .height(44)
      .backgroundColor('#F7F9FC')
      .borderRadius(22)
      .border({ width: 1, color: '#EEF2F7' })
      .onClick(() => {
        if (!this.editable && this.onSearch) this.onSearch();
      })

      if (this.showMsg) {
        Image($r('app.media.ic_msg'))
          .width(22)
          .height(22)
          .fillColor('#8A94A6')
          .margin({ left: 12 })
          .onClick(() => {
            if (this.onMsg) this.onMsg();
          })
      }

      if (this.editable && this.searchText.length > 0) {
        Text('取消')
          .fontSize(14)
          .fontColor('#2E6FDC')
          .margin({ left: 12 })
          .onClick(() => {
            if (this.onChange) this.onChange('');
          })
      }
    }
    .width('100%')
    .height(64)
    .padding({ left: 20, right: 20 })
  }
}
