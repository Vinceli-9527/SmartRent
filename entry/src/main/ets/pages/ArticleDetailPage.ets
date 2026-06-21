import { router } from '@kit.ArkUI';
import { NavBar } from '../components/NavBar';

@Entry
@Component
struct ArticleDetailPage {
  @State title: string = '城市生活'
  @State summary: string = '租住生活灵感'
  @State tag: string = '发现'
  @State cover: Resource | string = $r('app.media.sr_discover_banner_01')
  private primaryColor: string = '#2E6FDC'

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (!params) return;
    if (params['title']) this.title = params['title'] as string;
    if (params['summary']) this.summary = params['summary'] as string;
    if (params['tag']) this.tag = params['tag'] as string;
    if (params['cover']) this.cover = params['cover'] as Resource;
  }

  build() {
    Column() {
      NavBar({ title: '文章详情', showBack: true, onBack: () => { router.back() } })
      Scroll() {
        Column() {
          Image(this.cover)
            .width('100%')
            .height(230)
            .objectFit(ImageFit.Cover)
          Column() {
            Text(this.tag)
              .fontSize(12)
              .fontColor(this.primaryColor)
              .padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .backgroundColor('#EEF5FF')
              .borderRadius(13)
            Text(this.title)
              .fontSize(25)
              .fontWeight(FontWeight.Bold)
              .fontColor('#202733')
              .lineHeight(32)
              .margin({ top: 14 })
            Text('住研编辑部 · 2026-06-13 · 6 分钟阅读')
              .fontSize(12)
              .fontColor('#8A94A6')
              .margin({ top: 10 })
            Text(this.summary)
              .fontSize(15)
              .fontColor('#4E5C6E')
              .lineHeight(24)
              .margin({ top: 20 })
            Text('这里是文章详情页的预设内容区域，后续可以接入真实文章接口、富文本内容和相关推荐。当前页面用于承接发现页 Banner 跳转，保持与应用整体的温暖居家和低饱和蓝风格一致。')
              .fontSize(14)
              .fontColor('#5F6D7E')
              .lineHeight(24)
              .margin({ top: 16 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius({ topLeft: 24, topRight: 24 })
          .margin({ top: -18 })
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
