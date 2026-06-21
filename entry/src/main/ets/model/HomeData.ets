export class BannerData {
  id: string = ''
  imageUrl: string = ''
  title: string = ''
  linkType: string = ''
  linkValue: string = ''
}

export class QuickEntry {
  id: string = ''
  icon: Resource = $r('app.media.ic_home_search')
  name: string = ''
  route: string = ''
}

export class HomeData {
  banners: BannerData[] = []
  quickEntries: QuickEntry[] = []
  hotCities: string[] = []
}
