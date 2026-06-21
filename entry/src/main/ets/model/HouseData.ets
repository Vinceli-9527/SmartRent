export class HouseImage {
  id: string = ''
  url: string | Resource = ''
  isCover: boolean = false
}

export class HouseDetail {
  id: string = ''
  title: string = ''
  images: HouseImage[] = []
  price: number = 0
  originalPrice: number = 0
  priceUnit: string = '元/月'
  area: number = 0
  roomType: string = ''
  floor: string = ''
  orientation: string = ''
  decoration: string = ''
  address: string = ''
  community: string = ''
  longitude: number = 0
  latitude: number = 0
  facilities: string[] = []
  description: string = ''
  contactPhone: string = ''
  landlordName: string = ''
  tags: string[] = []
  publishTime: string = ''
  viewCount: number = 0
  isFavorite: boolean = false
}
