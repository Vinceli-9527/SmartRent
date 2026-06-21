export class OrderData {
  id: string = ''
  houseId: string = ''
  houseTitle: string = ''
  houseCover: string = ''
  houseAddress: string = ''
  price: number = 0
  bookingDate: string = ''
  bookingTimeSlot: string = ''
  name: string = ''
  phone: string = ''
  remark: string = ''
  status: number = 0   // 0-待确认 1-已确认 2-已完成 3-已取消
  statusText: string = ''
  createTime: string = ''
}

export class BookingParams {
  houseId: string = ''
  bookingDate: string = ''
  bookingTimeSlot: string = ''
  name: string = ''
  phone: string = ''
  remark: string = ''
}
