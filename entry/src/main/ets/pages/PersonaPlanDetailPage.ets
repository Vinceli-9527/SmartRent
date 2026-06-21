import { router } from '@kit.ArkUI';
import { PlanStep } from '../model/PlanData';

/**
 * 画像租房计划详情页 — 点击画像图标后进入
 */
@Entry
@Component
struct PersonaPlanDetailPage {
  @State personaName: string = ''
  @State personaDesc: string = ''
  @State personaColor: string = '#2E6FDC'
  @State steps: PlanStep[] = []

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      this.personaName = (params['personaName'] as string) || '';
      this.personaDesc = (params['personaDesc'] as string) || '';
      this.personaColor = (params['personaColor'] as string) || '#2E6FDC';
      if (params['stepCount']) {
        const count = params['stepCount'] as number;
        for (let i = 0; i < count; i++) {
          const s = new PlanStep();
          s.title = (params[`stepTitle${i}`] as string) || '';
          s.desc = (params[`stepDesc${i}`] as string) || '';
          this.steps.push(s);
        }
      }
    }
  }

  build() {
    Column() {
      // Nav
      Row() {
        Image($r('app.media.ic_back'))
          .width(24).height(24)
          .onClick(() => { router.back() })
        Text(this.personaName)
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

      Scroll() {
        Column() {
          // 顶部画像卡片
          Column() {
            Text(this.personaName)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
            Text(this.personaDesc)
              .fontSize(14)
              .fontColor('rgba(255,255,255,0.8)')
              .margin({ top: 8 })
          }
          .width('100%')
          .height(140)
          .justifyContent(FlexAlign.Center)
          .borderRadius(12)
          .linearGradient({
            direction: GradientDirection.Bottom,
            colors: [[this.personaColor, 0], [this.lightenColor(this.personaColor), 1]]
          })
          .margin({ left: 16, right: 16, top: 12, bottom: 20 })

          // 步骤流程
          Text('租房步骤')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .width('100%')
            .padding({ left: 16, bottom: 12 })

          Column() {
            ForEach(this.steps, (step: PlanStep, index: number) => {
              Row() {
                // 序号 + 线
                Column() {
                  Text(`${index + 1}`)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#FFFFFF')
                    .width(30).height(30)
                    .backgroundColor(this.personaColor)
                    .borderRadius(15)
                    .textAlign(TextAlign.Center)
                  if (index < this.steps.length - 1) {
                    Column()
                      .width(2).height(30)
                      .backgroundColor('#E8E8E8')
                  }
                }
                .alignItems(HorizontalAlign.Center)
                .margin({ right: 14 })

                Column() {
                  Text(step.title)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                  Text(step.desc)
                    .fontSize(13)
                    .fontColor('#999999')
                    .lineHeight(20)
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding({ top: 6, bottom: 6 })
            }, (step: PlanStep, index: number) => step.title)
          }
          .width('100%')
          .padding({ left: 24, right: 16 })
          .margin({ bottom: 24 })

          // 推荐房源入口
          Row() {
            Text('查看更多适合您的房源')
              .fontSize(14)
              .fontColor(this.personaColor)
            Image($r('app.media.ic_arrow_right'))
              .width(14).height(14)
              .fillColor(this.personaColor)
              .margin({ left: 4 })
          }
          .width('100%')
          .height(44)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ left: 16, right: 16 })
          .onClick(() => { router.back() })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  lightenColor(hex: string): string {
    // 简单变亮：在后面加透明度
    if (hex.startsWith('#') && hex.length === 7) {
      return hex + '99';
    }
    return hex;
  }
}
