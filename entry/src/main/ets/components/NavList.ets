import { QuickEntry } from '../model/HomeData';

/**
 * 5.4 NavList 组件
 * 快捷导航入口列表（一行多个图标+文字）
 */
@Component
export struct NavList {
  @Prop items: QuickEntry[] = []
  @Prop columns: number = 4
  onItemClick?: (item: QuickEntry) => void

  build() {
    Grid() {
      ForEach(this.items, (item: QuickEntry) => {
        GridItem() {
          Column() {
            Image(item.icon)
              .width(40).height(40)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 6 })
            Text(item.name)
              .fontSize(12)
              .fontColor('#333333')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .padding({ top: 12, bottom: 8 })
          .onClick(() => {
            if (this.onItemClick) this.onItemClick(item);
          })
        }
      }, (item: QuickEntry) => item.name)
    }
    .columnsTemplate(this.buildColumnsTemplate())
    .columnsGap(0)
    .rowsGap(8)
    .width('100%')
    .padding({ left: 16, right: 16 })
    .visibility(this.items.length > 0 ? Visibility.Visible : Visibility.None)
  }

  private buildColumnsTemplate(): string {
    const template = Array(this.columns).fill('1fr').join(' ');
    return template;
  }
}
