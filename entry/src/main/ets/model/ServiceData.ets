export class ServiceItem {
  id: string = ''
  icon: Resource = $r('app.media.ic_service_default')
  name: string = ''
  desc: string = ''
  route: string = ''
}

export class ServiceData {
  services: ServiceItem[] = []
  banners: string[] = []
}
