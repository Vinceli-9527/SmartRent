import { TileItem } from '../model/TileData';

/**
 * 5.5 TileList 组件
 * 服务磁贴列表（带副标题，用于服务页）
 */
@Component
export struct TileList {
  @Prop items: TileItem[] = []
  @Prop columns: number = 3
  @Prop showSubtitle: boolean = true
  onItemClick?: (item: TileItem) => void

  build() {
    Grid() {
      ForEach(this.items, (item: TileItem) => {
        GridItem() {
          Column() {
            Image(item.icon)
              .width(36).height(36)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 6 })
            Text(item.title)
              .fontSize(13)
              .fontColor('#333333')
              .maxLines(1)
              .fontWeight(FontWeight.Medium)
            if (this.showSubtitle && item.subtitle.length > 0) {
              Text(item.subtitle)
                .fontSize(11)
                .fontColor('#999999')
                .maxLines(1)
                .margin({ top: 2 })
            }
          }
          .width('100%')
          .padding({ top: 14, bottom: 12 })
          .borderRadius(8)
          .backgroundColor('#FFFFFF')
          .onClick(() => {
            if (this.onItemClick) this.onItemClick(item);
          })
        }
      })
    }
    .columnsTemplate(this.buildTemplate())
    .columnsGap(10)
    .rowsGap(10)
    .width('100%')
    .padding({ left: 16, right: 16 })
    .visibility(this.items.length > 0 ? Visibility.Visible : Visibility.None)
  }

  private buildTemplate(): string {
    const cols: string[] = [];
    for (let i = 0; i < this.columns; i++) {
      cols.push('1fr');
    }
    return cols.join(' ');
  }
}
