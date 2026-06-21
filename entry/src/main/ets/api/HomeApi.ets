import { get } from '../utils/http/Index';
import { HomeData } from '../model/HomeData';
import { RoomRecommendData } from '../model/RoomRecommendData';
import { HttpResult } from '../utils/http/Index';

export class HomeApi {
  static async getHomeData(): Promise<HttpResult<HomeData>> {
    return get<HomeData>('/home/index');
  }

  static async getRecommendList(page: number = 1, pageSize: number = 10): Promise<HttpResult<RoomRecommendData[]>> {
    const params: Record<string, number> = { 'page': page, 'pageSize': pageSize };
    return get<RoomRecommendData[]>('/home/recommend', params);
  }
}
