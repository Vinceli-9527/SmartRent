import { OrderApi } from '../api/OrderApi';
import { BookingParams } from '../model/OrderData';
import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { NavBar } from '../components/NavBar';

@Entry
@Component
struct BookingPage {
  @State houseTitle: string = ''
  @State price: number = 0
  @State name: string = ''
  @State phone: string = ''
  @State remark: string = ''
  @State selectedDate: string = ''
  @State selectedTimeSlot: string = ''
  @State loading: boolean = false
  private houseId: string = ''

  private timeSlots: string[] = ['09:00-10:00', '10:00-11:00', '11:00-12:00', '14:00-15:00', '15:00-16:00', '16:00-17:00', '17:00-18:00', '18:00-19:00']
  private dates: string[] = []

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      this.houseId = params['houseId'] as string;
      this.houseTitle = params['title'] as string;
      this.price = params['price'] as number;
    }
    // Generate 7 dates
    const today = new Date();
    for (let i = 0; i < 7; i++) {
      const d = new Date(today);
      d.setDate(d.getDate() + i);
      const m = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      const week = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'][d.getDay()];
      this.dates.push(`${m}月${day}日 ${week}`);
    }
  }

  submitBooking() {
    if (!this.selectedDate) { promptAction.showToast({ message: '请选择日期' }); return; }
    if (!this.selectedTimeSlot) { promptAction.showToast({ message: '请选择时间段' }); return; }
    if (!this.name.trim()) { promptAction.showToast({ message: '请输入姓名' }); return; }
    if (!this.phone.trim() || this.phone.length !== 11) { promptAction.showToast({ message: '请输入正确的手机号' }); return; }

    this.loading = true;
    const params = new BookingParams();
    params.houseId = this.houseId;
    params.bookingDate = this.selectedDate;
    params.bookingTimeSlot = this.selectedTimeSlot;
    params.name = this.name;
    params.phone = this.phone;
    params.remark = this.remark;

    OrderApi.createOrder(params).then(res => {
      this.loading = false;
      if (res.code === 0) {
        promptAction.showToast({ message: '预约成功' });
        router.back();
      } else {
        promptAction.showToast({ message: res.message || '预约失败' });
      }
    });
  }

  build() {
    Column() {
      NavBar({ title: '预约看房', showBack: true, onBack: () => { router.back() } })

      Scroll() {
        Column() {
          // House info card
          Row() {
            Column() {
              Text(this.houseTitle).fontSize(16).fontWeight(FontWeight.Bold).fontColor('#333333').maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(`¥${this.price}/月`).fontSize(14).fontColor('#FF4D4F').margin({ top: 4 })
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            Image($r('app.media.ic_arrow_right')).width(16).height(16)
          }
          .width('100%').padding(16).backgroundColor('#FFFFFF').borderRadius(12)
          .margin({ left: 16, right: 16, top: 12, bottom: 12 })

          // Date selection
          Text('选择日期').fontSize(15).fontWeight(FontWeight.Medium).fontColor('#333333')
            .width('100%').padding({ left: 16, bottom: 10 })
          Scroll() {
            Row() {
              ForEach(this.dates, (date: string, idx: number) => {
                Column() {
                  Text(date.split(' ')[0]).fontSize(13).fontWeight(FontWeight.Medium)
                    .fontColor(this.selectedDate === date ? '#FFFFFF' : '#333333')
                  Text(date.split(' ')[1]).fontSize(11)
                    .fontColor(this.selectedDate === date ? '#FFFFFF' : '#999999').margin({ top: 2 })
                }
                .width(72).height(54).borderRadius(8)
                .backgroundColor(this.selectedDate === date ? '#1677FF' : '#F5F7FA')
                .justifyContent(FlexAlign.Center).margin({ right: 8 })
                .onClick(() => { this.selectedDate = date })
              })
            }.padding({ left: 16 })
          }.scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off).height(60).margin({ bottom: 16 })

          // Time slot selection
          Text('选择时间段').fontSize(15).fontWeight(FontWeight.Medium).fontColor('#333333')
            .width('100%').padding({ left: 16, bottom: 10 })
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.timeSlots, (slot: string) => {
              Text(slot).fontSize(13)
                .fontColor(this.selectedTimeSlot === slot ? '#FFFFFF' : '#666666')
                .padding({ left: 16, right: 16, top: 10, bottom: 10 })
                .backgroundColor(this.selectedTimeSlot === slot ? '#1677FF' : '#F5F7FA')
                .borderRadius(8).margin({ right: 10, bottom: 10 })
                .onClick(() => { this.selectedTimeSlot = slot })
            })
          }.padding({ left: 16, right: 16 }).margin({ bottom: 16 })

          // Form
          Column() {
            this.FormItem('姓名', '请输入您的姓名', (v: string) => { this.name = v })
            Divider().margin({ left: 56 })
            this.FormItem('手机号', '请输入手机号', (v: string) => { this.phone = v }, true)
            Divider().margin({ left: 56 })
            Row() {
              Text('备注').fontSize(14).fontColor('#333333').width(56)
              TextInput({ placeholder: '有什么需要特别说明的？（选填）', text: this.remark })
                .layoutWeight(1).height(80).fontSize(14)
                .onChange((v: string) => { this.remark = v })
                .textAlign(TextAlign.Start)
            }.width('100%').padding({ top: 12, bottom: 12, left: 16, right: 16 })
          }
          .width('100%').backgroundColor('#FFFFFF').borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 100 })
        }.width('100%')
      }
      .layoutWeight(1).scrollBar(BarState.Off)

      // Bottom submit bar
      Row() {
        Column() {
          Text('合计').fontSize(12).fontColor('#999999')
          Text('免费预约').fontSize(16).fontWeight(FontWeight.Bold).fontColor('#FF4D4F')
        }.margin({ right: 16 })
        Button() {
          if (this.loading) {
            LoadingProgress().width(20).height(20).color('#FFFFFF')
          } else {
            Text('提交预约').fontSize(16).fontColor('#FFFFFF')
          }
        }
          .width('100%').height(44)
          .backgroundColor('#1677FF').borderRadius(22).layoutWeight(1)
          .enabled(!this.loading)
          .onClick(() => { this.submitBooking() })
      }
      .width('100%').height(64).padding({ left: 16, right: 16 }).backgroundColor('#FFFFFF')
    }
    .width('100%').height('100%').backgroundColor('#F5F5F5')
  }

  @Builder FormItem(label: string, placeholder: string, onChange: (v: string) => void, isPhone: boolean = false) {
    Row() {
      Text(label).fontSize(14).fontColor('#333333').width(56)
      TextInput({ placeholder: placeholder })
        .layoutWeight(1).height(44).fontSize(14).backgroundColor(Color.Transparent)
        .type(isPhone ? InputType.PhoneNumber : InputType.Normal)
        .maxLength(isPhone ? 11 : 20)
        .onChange(onChange)
    }
    .width('100%').padding({ left: 16, right: 16 })
  }
}
