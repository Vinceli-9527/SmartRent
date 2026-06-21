export class RoomRecommendData {
  id: string = ''
  title: string = ''
  coverUrl: string | Resource = ''
  price: number = 0
  priceUnit: string = '元/月'
  address: string = ''
  area: number = 0
  roomType: string = ''
  floor: string = ''
  tags: string[] = []
  isNew: boolean = false
  isFavorite: boolean = false
}
