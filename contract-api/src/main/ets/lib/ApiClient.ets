/**
 * ApiClient —— 模块级单例配置 + 快捷方法
 *
 * 用法（消费端初始化一次）：
 *   apiClient.setBaseUrl('https://<域名>')
 *   apiClient.setTokenProvider(() => session.accessToken)
 *   apiClient.setUnauthorizedHandler(() => { ... 登出 })
 */
import { HttpClient } from './HttpClient';

export const apiClient: HttpClient = new HttpClient();
