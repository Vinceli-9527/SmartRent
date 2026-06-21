import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

/**
 * 成为房东 — 申请页面
 */
@Entry
@Component
struct LandlordPage {
  @State name: string = ''
  @State phone: string = ''
  @State address: string = ''
  @State houseType: string = ''
  @State roomCount: string = ''
  @State area: string = ''
  @State price: string = ''
  @State remark: string = ''
  @State loading: boolean = false
  @State submitted: boolean = false

  private houseTypes: string[] = ['普通住宅', '公寓', '别墅', 'loft', '四合院']

  submit() {
    if (!this.name.trim()) {
      promptAction.showToast({ message: '请输入姓名' });
      return;
    }
    if (!this.phone.trim() || this.phone.length !== 11) {
      promptAction.showToast({ message: '请输入正确的手机号' });
      return;
    }
    if (!this.address.trim()) {
      promptAction.showToast({ message: '请输入房源地址' });
      return;
    }
    if (!this.houseType) {
      promptAction.showToast({ message: '请选择房源类型' });
      return;
    }

    this.loading = true;
    setTimeout(() => {
      this.loading = false;
      this.submitted = true;
    }, 1200);
  }

  build() {
    Column() {
      // Nav
      Row() {
        Image($r('app.media.ic_back'))
          .width(24).height(24)
          .onClick(() => { router.back() })
        Text('成为房东')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Row().width(24).height(24)
      }
      .width('100%')
      .height(44)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      if (this.submitted) {
        // 提交成功
        Column() {
          Image($r('app.media.ic_service_default'))
            .width(80).height(80)
            .margin({ top: 80, bottom: 20 })
            .fillColor('#52C41A')
          Text('提交成功！')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
          Text('我们将在 1-2 个工作日内联系您')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 8, bottom: 32 })
          Button('返回首页')
            .width(200)
            .height(44)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor('#1677FF')
            .borderRadius(22)
            .onClick(() => {
              router.back();
            })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            // Hero banner
            Row() {
              Column() {
                Text('发布房源，轻松收租')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                Text('加入智慧租房，让您的房源被更多人看到')
                  .fontSize(13)
                  .fontColor('rgba(255,255,255,0.8)')
                  .margin({ top: 6 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              Image($r('app.media.ic_home_search'))
                .width(48).height(48)
                .fillColor('rgba(255,255,255,0.4)')
            }
            .width('100%')
            .padding(20)
            .borderRadius(12)
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [['#1677FF', 0], ['#722ED1', 1]]
            })
            .margin({ left: 16, right: 16, top: 12, bottom: 20 })

            // Form
            Column() {
              this.FormItem('姓名', '请输入您的姓名', (v: string) => { this.name = v })
              this.FormDivider()
              this.FormItem('手机号', '请输入手机号', (v: string) => { this.phone = v }, true)
              this.FormDivider()
              this.FormItem('房源地址', '请输入房源详细地址', (v: string) => { this.address = v })
              this.FormDivider()

              // 房源类型选择
              Row() {
                Text('房源类型').fontSize(15).fontColor('#333333').width(76)
                Scroll() {
                  Row() {
                    ForEach(this.houseTypes, (t: string) => {
                      Text(t)
                        .fontSize(13)
                        .padding({ left: 14, right: 14, top: 8, bottom: 8 })
                        .borderRadius(18)
                        .fontColor(this.houseType === t ? '#FFFFFF' : '#666666')
                        .backgroundColor(this.houseType === t ? '#1677FF' : '#F5F7FA')
                        .margin({ right: 8 })
                        .onClick(() => { this.houseType = t })
                    })
                  }
                }
                .scrollable(ScrollDirection.Horizontal)
                .scrollBar(BarState.Off)
                .layoutWeight(1)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 14, bottom: 14 })

              this.FormDivider()

              Row() {
                Text('户型').fontSize(15).fontColor('#333333').width(76)
                TextInput({ placeholder: '如: 2室1厅', text: this.roomCount })
                  .layoutWeight(1)
                  .height(44)
                  .fontSize(14)
                  .backgroundColor(Color.Transparent)
                  .onChange((v: string) => { this.roomCount = v })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 4, bottom: 4 })

              this.FormDivider()

              Row() {
                Text('面积').fontSize(15).fontColor('#333333').width(76)
                TextInput({ placeholder: '如: 85m²', text: this.area })
                  .layoutWeight(1)
                  .height(44)
                  .fontSize(14)
                  .backgroundColor(Color.Transparent)
                  .type(InputType.Number)
                  .onChange((v: string) => { this.area = v })
                Text('m²').fontSize(14).fontColor('#999999').margin({ left: 8 })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 4, bottom: 4 })

              this.FormDivider()

              Row() {
                Text('租金').fontSize(15).fontColor('#333333').width(76)
                TextInput({ placeholder: '月租金（元）', text: this.price })
                  .layoutWeight(1)
                  .height(44)
                  .fontSize(14)
                  .backgroundColor(Color.Transparent)
                  .type(InputType.Number)
                  .onChange((v: string) => { this.price = v })
                Text('元/月').fontSize(14).fontColor('#999999').margin({ left: 8 })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 4, bottom: 4 })

              this.FormDivider()

              Row() {
                Text('备注').fontSize(15).fontColor('#333333').width(76)
                TextInput({ placeholder: '补充说明（选填）', text: this.remark })
                  .layoutWeight(1)
                  .height(60)
                  .fontSize(14)
                  .backgroundColor(Color.Transparent)
                  .textAlign(TextAlign.Start)
                  .onChange((v: string) => { this.remark = v })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 4, bottom: 4 })

            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .margin({ left: 16, right: 16 })

            // 优势说明
            Column() {
              Text('为什么选择智慧租房？')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .width('100%')
                .margin({ bottom: 12 })

              this.BenefitRow('千万级流量曝光', '精准匹配租客，快速出租')
              this.BenefitRow('智能定价建议', '大数据分析，帮您定出最优价格')
              this.BenefitRow('专业管家服务', '代看代管，省心省力')
              this.BenefitRow('免费发布', '0元发布，成交后仅收1%服务费')
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .margin({ left: 16, right: 16, top: 12, bottom: 100 })
          }
          .width('100%')
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        // 提交按钮
        Row() {
          Button() {
            if (this.loading) {
              LoadingProgress().width(20).height(20).color('#FFFFFF')
            } else {
              Text('提交申请').fontSize(16).fontColor('#FFFFFF')
            }
          }
          .width('100%')
          .height(48)
          .backgroundColor('#1677FF')
          .borderRadius(24)
          .enabled(!this.loading)
          .onClick(() => { this.submit() })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 10, bottom: 10 })
        .backgroundColor('#FFFFFF')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder FormItem(label: string, placeholder: string, onChange: (v: string) => void, isPhone: boolean = false) {
    Row() {
      Text(label).fontSize(15).fontColor('#333333').width(76)
      TextInput({ placeholder: placeholder })
        .layoutWeight(1)
        .height(44)
        .fontSize(14)
        .backgroundColor(Color.Transparent)
        .type(isPhone ? InputType.PhoneNumber : InputType.Normal)
        .maxLength(isPhone ? 11 : 50)
        .onChange(onChange)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 4, bottom: 4 })
  }

  @Builder FormDivider() {
    Divider().margin({ left: 16 })
  }

  @Builder BenefitRow(title: string, desc: string) {
    Row() {
      Text('✓')
        .fontSize(16)
        .fontColor('#52C41A')
        .fontWeight(FontWeight.Bold)
        .margin({ right: 10 })
      Column() {
        Text(title).fontSize(14).fontWeight(FontWeight.Medium).fontColor('#333333')
        Text(desc).fontSize(12).fontColor('#999999').margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }
}
