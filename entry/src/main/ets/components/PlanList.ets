import { PlanStep } from '../model/PlanData';

@Component
export struct PlanList {
  @Prop steps: PlanStep[] = []
  @Prop title: string = '看房流程'
  onStepClick?: (step: PlanStep, index: number) => void

  build() {
    Column() {
      if (this.title.length > 0) {
        Row() {
          Text(this.title)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#202733')
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 12 })
      }

      Column() {
        ForEach(this.steps, (step: PlanStep, index: number) => {
          Row() {
            Column() {
              Text(`${index + 1}`)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .width(28)
                .height(28)
                .backgroundColor('#2E6FDC')
                .borderRadius(14)
                .textAlign(TextAlign.Center)

              if (index < this.steps.length - 1) {
                Column()
                  .width(2)
                  .height(28)
                  .backgroundColor('#E1E6EF')
              }
            }
            .alignItems(HorizontalAlign.Center)
            .margin({ right: 12 })

            Column() {
              Text(step.title)
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .fontColor('#202733')
              Text(step.desc)
                .fontSize(13)
                .fontColor('#8A94A6')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Image($r('app.media.ic_arrow_right'))
              .width(14)
              .height(14)
              .fillColor('#A8B0BD')
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
          .onClick(() => {
            if (this.onStepClick) this.onStepClick(step, index);
          })
        }, (step: PlanStep, index: number) => step.title)
      }
      .width('100%')
      .padding({ left: 22, right: 18 })
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .backgroundColor('#FFFFFF')
    .borderRadius(18)
    .margin({ left: 20, right: 20 })
    .shadow({ radius: 14, color: '#12000000', offsetX: 0, offsetY: 7 })
    .visibility(this.steps.length > 0 ? Visibility.Visible : Visibility.None)
  }
}
