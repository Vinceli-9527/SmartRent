import { get } from '../utils/http/Index';
import { ServiceData } from '../model/ServiceData';
import { HttpResult } from '../utils/http/Index';

export class ServiceApi {
  static async getServices(): Promise<HttpResult<ServiceData>> {
    return get<ServiceData>('/service/index');
  }
}
