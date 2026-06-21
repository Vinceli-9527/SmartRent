import { get } from '../utils/http/Index';
import { DiscoverData, DiscoverArticle } from '../model/DiscoverData';
import { HttpResult } from '../utils/http/Index';

export class DiscoverApi {
  static async getDiscoverList(page: number = 1): Promise<HttpResult<DiscoverData>> {
    const params: Record<string, number> = { 'page': page };
    return get<DiscoverData>('/discover/list', params);
  }

  static async getArticleDetail(id: string): Promise<HttpResult<DiscoverArticle>> {
    return get<DiscoverArticle>(`/discover/detail/${id}`);
  }
}
