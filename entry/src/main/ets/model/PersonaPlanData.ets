import { PlanStep } from './PlanData';

export class PersonaPlan {
  personaName: string = ''
  personaIcon: Resource = $r('app.media.ic_service_default')
  personaDesc: string = ''
  steps: PlanStep[] = []
  color: string = '#2E6FDC'
}
