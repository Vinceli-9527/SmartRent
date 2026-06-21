import { router } from '@kit.ArkUI';

/**
 * 消息中心 — 从首页搜索栏消息图标进入
 */
export class MessageItem {
  id: string = ''
  title: string = ''
  content: string = ''
  time: string = ''
  isRead: boolean = false
  type: string = ''  // system, booking, activity, service
}

@Entry
@Component
struct MessagePage {
  @State messages: MessageItem[] = []
  @State loading: boolean = true

  aboutToAppear() {
    this.loadMessages();
  }

  loadMessages() {
    // 示例消息数据
    setTimeout(() => {
      const list: MessageItem[] = [];

      const m1 = new MessageItem();
      m1.id = '1';
      m1.title = '预约确认通知';
      m1.content = '您预约的「阳光花园 2室1厅」看房已确认，请于2026-06-07 14:00准时到达。';
      m1.time = '2026-06-05 10:30';
      m1.isRead = false;
      m1.type = 'booking';
      list.push(m1);

      const m2 = new MessageItem();
      m2.id = '2';
      m2.title = '系统通知';
      m2.content = '智慧租房 App 已更新至 v1.0.0，新增房源推荐算法，优化看房预约流程。';
      m2.time = '2026-06-04 09:15';
      m2.isRead = false;
      m2.type = 'system';
      list.push(m2);

      const m3 = new MessageItem();
      m3.id = '3';
      m3.title = '优惠活动';
      m3.content = '限时特惠！本月签约可享首月租金8折优惠，推荐好友租房双方各得200元红包。';
      m3.time = '2026-06-03 14:00';
      m3.isRead = true;
      m3.type = 'activity';
      list.push(m3);

      const m4 = new MessageItem();
      m4.id = '4';
      m4.title = '看房提醒';
      m4.content = '您明天（6/6）有一场看房预约：「翠苑新村 3室1厅」14:00-15:00，请提前规划行程。';
      m4.time = '2026-06-02 18:30';
      m4.isRead = true;
      m4.type = 'booking';
      list.push(m4);

      const m5 = new MessageItem();
      m5.id = '5';
      m5.title = '服务通知';
      m5.content = '您提交的维修工单已受理，维修师傅将于6/5上午上门，请保持电话畅通。';
      m5.time = '2026-06-01 11:00';
      m5.isRead = true;
      m5.type = 'service';
      list.push(m5);

      const m6 = new MessageItem();
      m6.id = '6';
      m6.title = '欢迎使用智慧租房';
      m6.content = '欢迎加入智慧租房！在这里你可以轻松找房、预约看房、在线签约。有任何问题请联系客服。';
      m6.time = '2026-05-28 08:00';
      m6.isRead = true;
      m6.type = 'system';
      list.push(m6);

      this.messages = list;
      this.loading = false;
    }, 500);
  }

  getTypeLabel(type: string): string {
    const map: Record<string, string> = {
      'system': '系统',
      'booking': '预约',
      'activity': '活动',
      'service': '服务'
    };
    return map[type] || '通知';
  }

  getTypeColor(type: string): string {
    const map: Record<string, string> = {
      'system': '#1677FF',
      'booking': '#52C41A',
      'activity': '#FA8C16',
      'service': '#722ED1'
    };
    return map[type] || '#999999';
  }

  build() {
    Column() {
      // Nav bar
      Row() {
        Image($r('app.media.ic_back'))
          .width(24).height(24)
          .onClick(() => { router.back() })
        Text('消息中心')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('全部已读')
          .fontSize(13)
          .fontColor('#1677FF')
          .onClick(() => {
            this.messages.forEach((m: MessageItem) => { m.isRead = true; });
          })
      }
      .width('100%')
      .height(44)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      if (this.loading) {
        Column() {
          LoadingProgress().width(36).height(36)
          Text('加载中...').fontSize(14).fontColor('#999999').margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.messages, (item: MessageItem) => {
            ListItem() {
              Column() {
                Row() {
                  // Type badge
                  Text(this.getTypeLabel(item.type))
                    .fontSize(10)
                    .fontColor('#FFFFFF')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .backgroundColor(this.getTypeColor(item.type))
                    .borderRadius(3)

                  Text(item.time)
                    .fontSize(12)
                    .fontColor('#CCCCCC')
                    .layoutWeight(1)
                    .textAlign(TextAlign.End)

                  if (!item.isRead) {
                    Circle()
                      .width(8).height(8)
                      .fill('#FF4D4F')
                      .margin({ left: 8 })
                  }
                }
                .width('100%')
                .margin({ bottom: 8 })

                Text(item.title)
                  .fontSize(15)
                  .fontWeight(item.isRead ? FontWeight.Normal : FontWeight.Bold)
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: 4 })

                Text(item.content)
                  .fontSize(13)
                  .fontColor('#999999')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('100%')
                  .lineHeight(20)
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#FFFFFF')
              .margin({ left: 16, right: 16, bottom: 8 })
              .borderRadius(12)
              .onClick(() => {
                item.isRead = true;
              })
            }
          })
        }
        .layoutWeight(1)
        .padding({ top: 8 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
