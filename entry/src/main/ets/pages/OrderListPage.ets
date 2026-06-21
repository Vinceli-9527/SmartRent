import { OrderApi } from '../api/OrderApi';
import { OrderData } from '../model/OrderData';
import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { NavBar } from '../components/NavBar';

@Entry
@Component
struct OrderListPage {
  @State orders: OrderData[] = []
  @State loading: boolean = true
  @State activeTab: number = 0
  private tabs: string[] = ['全部', '待确认', '已确认', '已完成', '已取消']

  aboutToAppear() { this.loadOrders() }

  loadOrders() {
    this.loading = true;
    const status = this.activeTab === 0 ? undefined : this.activeTab - 1;
    OrderApi.getOrderList(1, status).then(res => {
      this.loading = false;
      if (res.code === 0 && res.data) {
        this.orders = res.data.map(o => {
          o.statusText = this.getStatusText(o.status);
          return o;
        });
      }
    });
  }

  getStatusText(status: number): string {
    const map: Record<number, string> = { 0: '待确认', 1: '已确认', 2: '已完成', 3: '已取消' };
    return map[status] || '未知';
  }

  cancelOrder(order: OrderData) {
    promptAction.showDialog({
      title: '确认取消',
      message: `确定要取消「${order.houseTitle}」的预约吗？`,
      buttons: [
        { text: '再想想', color: '#999999' },
        { text: '确定取消', color: '#FF4D4F' }
      ]
    }).then((result) => {
      if (result.index === 1) {
        OrderApi.cancelOrder(order.id).then(res => {
          if (res.code === 0) {
            promptAction.showToast({ message: '已取消' });
            this.loadOrders();
          } else {
            promptAction.showToast({ message: res.message || '取消失败' });
          }
        });
      }
    });
  }

  build() {
    Column() {
      NavBar({ title: '我的预约', showBack: true, onBack: () => { router.back() } })

      // Tab bar
      Scroll() {
        Row() {
          ForEach(this.tabs, (tab: string, idx: number) => {
            Text(tab)
              .fontSize(14)
              .fontWeight(this.activeTab === idx ? FontWeight.Bold : FontWeight.Normal)
              .fontColor(this.activeTab === idx ? '#1677FF' : '#666666')
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .onClick(() => { this.activeTab = idx; this.loadOrders() })
          })
        }
      }
      .scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off).height(44)
      .backgroundColor('#FFFFFF').margin({ bottom: 8 })

      if (this.loading) {
        Column() {
          LoadingProgress().width(36).height(36)
          Text('加载中...').fontSize(14).fontColor('#999999').margin({ top: 12 })
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      } else if (this.orders.length === 0) {
        Column() {
          Image($r('app.media.ic_empty_order')).width(120).height(120).margin({ top: 100, bottom: 16 })
          Text('暂无预约记录').fontSize(16).fontColor('#999999')
          Text('去首页看看心仪的房子吧').fontSize(14).fontColor('#CCCCCC').margin({ top: 8 })
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.orders, (item: OrderData) => {
            ListItem() { this.OrderCard(item) }.margin({ bottom: 12 })
          })
        }
        .layoutWeight(1).padding({ left: 16, right: 16, top: 8 })
      }
    }
    .width('100%').height('100%').backgroundColor('#F5F5F5')
  }

  @Builder OrderCard(order: OrderData) {
    Column() {
      // Header
      Row() {
        Text(`预约时间：${order.createTime}`).fontSize(12).fontColor('#999999')
        Blank()
        Text(order.statusText).fontSize(12).fontWeight(FontWeight.Medium)
          .fontColor(order.status === 0 ? '#FA8C16' : (order.status === 3 ? '#FF4D4F' : '#52C41A'))
      }.width('100%').padding({ left: 12, right: 12, top: 10, bottom: 10 })
      .backgroundColor('#FAFAFA')

      // Content
      Row() {
        Image(order.houseCover).width(80).height(60).borderRadius(6).objectFit(ImageFit.Cover)
        Column() {
          Text(order.houseTitle).fontSize(14).fontWeight(FontWeight.Medium).fontColor('#333333')
            .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
          Text(order.houseAddress).fontSize(12).fontColor('#999999').maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%').margin({ top: 2 })
          Row() {
            Text(`${order.bookingDate}`).fontSize(12).fontColor('#666666')
            Text(` ${order.bookingTimeSlot}`).fontSize(12).fontColor('#666666')
          }.margin({ top: 4 })
        }
        .layoutWeight(1).height(60).alignItems(HorizontalAlign.Start).margin({ left: 10 })
        .justifyContent(FlexAlign.SpaceBetween)
      }.width('100%').padding(12)

      // Footer
      Row() {
        Text(`联系人：${order.name}  ${order.phone}`).fontSize(12).fontColor('#999999').layoutWeight(1)
        if (order.status === 0) {
          Button('取消预约').fontSize(12).height(28).fontColor('#FF4D4F')
            .backgroundColor('#FFF2F0').border({ width: 1, color: '#FF4D4F' }).borderRadius(14)
            .padding({ left: 12, right: 12 })
            .onClick(() => { this.cancelOrder(order) })
        }
        if (order.status === 1) {
          Button('联系房东').fontSize(12).height(28).fontColor('#1677FF')
            .backgroundColor('#E6F0FF').border({ width: 1, color: '#1677FF' }).borderRadius(14)
            .padding({ left: 12, right: 12 })
        }
      }.width('100%').padding({ left: 12, right: 12, bottom: 10 })
    }
    .width('100%').backgroundColor('#FFFFFF').borderRadius(12)
    .shadow({ radius: 4, color: '#10000000', offsetX: 0, offsetY: 2 })
  }
}
