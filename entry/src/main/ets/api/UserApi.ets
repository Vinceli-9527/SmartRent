import { get, post } from '../utils/http/Index';
import { LoginParams, LoginResult, UserData } from '../model/UserData';
import { HttpResult } from '../utils/http/Index';

export class UserApi {
  static async sendCode(phone: string): Promise<HttpResult<null>> {
    const body: Record<string, string> = { 'phone': phone };
    return post<null>('/user/sendCode', body);
  }

  static async login(params: LoginParams): Promise<HttpResult<LoginResult>> {
    const loginBody: Record<string, string> = { 'phone': params.phone, 'code': params.code };
    return post<LoginResult>('/user/login', loginBody);
  }

  static async getUserInfo(): Promise<HttpResult<UserData>> {
    return get<UserData>('/user/info');
  }

  static async updateProfile(data: Partial<UserData>): Promise<HttpResult<null>> {
    return post<null>('/user/update', data);
  }
}
