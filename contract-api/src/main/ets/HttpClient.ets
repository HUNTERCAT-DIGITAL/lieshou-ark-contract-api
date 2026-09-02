/**
 * HttpClient —— @ohos.net.http 封装
 * - baseUrl（纯域名，禁止带 /api；path 以 /api 开头，与后端 gateway 对齐）
 * - 自动注入 Authorization: Bearer <token>（tokenProvider）
 * - 2xx → 解析 JSON 返回；非 2xx → 解析 body {message,error} 抛 ApiError
 */
import { http } from '@kit.NetworkKit';
import { ApiError } from './ApiError';

export interface QueryParam {
  key: string;
  value: string;
}

export interface RequestOptions {
  method: string;              // 'GET' | 'POST' | 'PUT' | 'DELETE'
  path: string;                // 如 /api/auth/login
  query?: QueryParam[];
  body?: Object;
}

export class HttpClient {
  private baseUrlValue: string = '';
  private tokenFn: () => string = () => '';
  private unauthorizedFn: (() => void) | null = null;

  setBaseUrl(url: string): void {
    this.baseUrlValue = url;
  }

  setTokenProvider(fn: () => string): void {
    this.tokenFn = fn;
  }

  setUnauthorizedHandler(fn: () => void): void {
    this.unauthorizedFn = fn;
  }

  private toHttpMethod(method: string): http.RequestMethod {
    switch (method) {
      case 'POST': return http.RequestMethod.POST;
      case 'PUT': return http.RequestMethod.PUT;
      case 'DELETE': return http.RequestMethod.DELETE;
      default: return http.RequestMethod.GET;
    }
  }

  private buildUrl(opts: RequestOptions): string {
    let url = this.baseUrlValue + opts.path;
    if (opts.query && opts.query.length > 0) {
      const parts: string[] = [];
      for (const p of opts.query) {
        parts.push(`${encodeURIComponent(p.key)}=${encodeURIComponent(p.value)}`);
      }
      url = url + (url.includes('?') ? '&' : '?') + parts.join('&');
    }
    return url;
  }

  async request<T extends Object>(opts: RequestOptions): Promise<T> {
    const httpRequest = http.createHttp();
    try {
      const headers: Record<string, string> = { 'Content-Type': 'application/json' };
      const token = this.tokenFn();
      if (token !== '') {
        headers['Authorization'] = `Bearer ${token}`;
      }
      const reqOptions: http.HttpRequestOptions = {
        method: this.toHttpMethod(opts.method),
        header: headers,
        connectTimeout: 15000,
        readTimeout: 20000,
      };
      if (opts.body !== undefined) {
        reqOptions.extraData = JSON.stringify(opts.body);
      }
      const resp = await httpRequest.request(this.buildUrl(opts), reqOptions);
      const status = resp.responseCode;
      const text: string = typeof resp.result === 'string' ? resp.result : '';

      if (status >= 200 && status < 300) {
        // 空响应（如 204）按空对象处理（当前业务接口均有 JSON body）
        return JSON.parse(text === '' ? '{}' : text) as T;
      }

      // 非 2xx：解析业务错误体
      let msg = `请求失败（HTTP ${status}）`;
      let bizCode = '';
      if (text !== '') {
        try {
          const obj = JSON.parse(text) as Record<string, Object>;
          const m = obj['message'];
          const e = obj['error'];
          if (typeof m === 'string' && m !== '') msg = m;
          if (typeof e === 'string') bizCode = e;
        } catch (err) {
          // body 非 JSON，保留默认文案
        }
      }
      if (status === 401 && this.unauthorizedFn !== null) {
        this.unauthorizedFn();
      }
      throw new ApiError(status, msg, bizCode);
    } finally {
      httpRequest.destroy();
    }
  }
}
