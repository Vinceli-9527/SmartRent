import { PersonaPlan } from '../model/PersonaPlanData';
import { PlanStep } from '../model/PlanData';

/**
 * 画像化租房计划组件 — 一个人物画像对应一组步骤
 */
@Component
export struct PersonaPlanList {
  @Prop plan: PersonaPlan = new PersonaPlan()
  onStepClick?: (step: PlanStep, index: number) => void

  build() {
    Column() {
      // 人物画像头部
      Row() {
        Image(this.plan.personaIcon)
          .width(40).height(40)
          .borderRadius(20)
          .backgroundColor('#F5F7FA')
        Column() {
          Text(this.plan.personaName)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
          Text(this.plan.personaDesc)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 10 })
        .layoutWeight(1)
        Image($r('app.media.ic_arrow_right'))
          .width(14).height(14)
          .fillColor('#CCCCCC')
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 8 })

      // 步骤列表
      Column() {
        ForEach(this.plan.steps, (step: PlanStep, index: number) => {
          Row() {
            Column() {
              Text(`${index + 1}`)
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .width(22).height(22)
                .backgroundColor(this.plan.color)
                .borderRadius(11)
                .textAlign(TextAlign.Center)

              if (index < this.plan.steps.length - 1) {
                Column()
                  .width(2).height(22)
                  .backgroundColor('#E8E8E8')
              }
            }
            .alignItems(HorizontalAlign.Center)
            .margin({ right: 10 })

            Column() {
              Text(step.title)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              Text(step.desc)
                .fontSize(12)
                .fontColor('#999999')
                .margin({ top: 2 })
            }
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding({ top: 4, bottom: 4 })
          .onClick(() => {
            if (this.onStepClick) this.onStepClick(step, index);
          })
        }, (step: PlanStep, index: number) => step.title)
      }
      .width('100%')
      .padding({ left: 24, right: 16 })
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
  }
}
