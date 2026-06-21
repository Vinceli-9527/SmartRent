import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';

const BASE_URL = 'https://api.smartrent.com/api/v1';
const TIMEOUT = 15000;

export class HttpResult<T> {
  code: number = 0
  message: string = ''
  data: T | null = null
}

export async function get<T>(url: string, params?: Record<string, string | number | boolean>): Promise<HttpResult<T>> {
  let fullUrl = BASE_URL + url;
  if (params) {
    const query = Object.keys(params).map(k => `${k}=${encodeURIComponent(String(params[k]))}`).join('&');
    fullUrl += '?' + query;
  }
  return request<T>(fullUrl, http.RequestMethod.GET);
}

export async function post<T>(url: string, body?: Object): Promise<HttpResult<T>> {
  return request<T>(BASE_URL + url, http.RequestMethod.POST, body);
}

async function request<T>(url: string, method: http.RequestMethod, body?: Object): Promise<HttpResult<T>> {
  const httpRequest = http.createHttp();
  try {
    const response = await httpRequest.request(url, {
      method: method,
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer mock-token'
      },
      extraData: body ? JSON.stringify(body) : undefined,
      connectTimeout: TIMEOUT,
      readTimeout: TIMEOUT
    });
    if (response.responseCode === 200) {
      const result = JSON.parse(response.result as string) as HttpResult<T>;
      return result;
    }
    return { code: response.responseCode, message: '请求失败', data: null };
  } catch (err) {
    const e = err as BusinessError;
    return { code: -1, message: e.message || '网络错误', data: null };
  } finally {
    httpRequest.destroy();
  }
}
