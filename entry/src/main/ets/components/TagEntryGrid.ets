import { TagEntry } from '../model/TagEntryData';
import { router } from '@kit.ArkUI';

/**
 * 标签入口网格 — 点击跳转到带预设标签的列表页
 */
@Component
export struct TagEntryGrid {
  @Prop items: TagEntry[] = []

  build() {
    Grid() {
      ForEach(this.items, (item: TagEntry) => {
        GridItem() {
          Column() {
            Row() {
              Image(item.icon)
                .width(28).height(28)
                .fillColor(item.color)
            }
            .width(48).height(48)
            .borderRadius(12)
            .backgroundColor('#F5F7FA')
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: 6 })

            Text(item.title)
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
              .maxLines(1)

            Text(item.subtitle)
              .fontSize(11)
              .fontColor('#999999')
              .maxLines(1)
              .margin({ top: 2 })
          }
          .width('100%')
          .padding({ top: 10, bottom: 10 })
          .onClick(() => {
            const params: Record<string, string> = {};
            params['tag'] = item.tag;
            router.pushUrl({ url: 'pages/RentListPage', params: params });
          })
        }
      }, (item: TagEntry) => item.id)
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .columnsGap(8)
    .rowsGap(8)
    .width('100%')
    .padding({ left: 8, right: 8 })
  }
}
