import { get, post } from '../utils/http/Index';
import { OrderData, BookingParams } from '../model/OrderData';
import { HttpResult } from '../utils/http/Index';

export class OrderApi {
  static async createOrder(params: BookingParams): Promise<HttpResult<OrderData>> {
    return post<OrderData>('/order/create', params);
  }

  static async getOrderList(page: number = 1, status?: number): Promise<HttpResult<OrderData[]>> {
    const params: Record<string, number> = { 'page': page };
    if (status !== undefined) {
      params['status'] = status;
    }
    return get<OrderData[]>('/order/list', params);
  }

  static async cancelOrder(id: string): Promise<HttpResult<null>> {
    return post<null>(`/order/cancel/${id}`);
  }
}
