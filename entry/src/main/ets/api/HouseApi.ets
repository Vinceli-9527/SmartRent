import { get } from '../utils/http/Index';
import { HouseDetail } from '../model/HouseData';
import { RoomRecommendData } from '../model/RoomRecommendData';
import { HttpResult } from '../utils/http/Index';

export class HouseApi {
  static async getHouseDetail(id: string): Promise<HttpResult<HouseDetail>> {
    return get<HouseDetail>(`/house/detail/${id}`);
  }

  static async getHouseList(params: Record<string, string | number>): Promise<HttpResult<RoomRecommendData[]>> {
    return get<RoomRecommendData[]>('/house/list', params);
  }
}
