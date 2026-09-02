/**
 * lieshou-ark-contract-api 导出入口（HAR）
 * - HttpClient / ApiError（基础）
 * - apiClient（模块级单例配置）
 * - authApi / legalApi（业务 API）
 */
export { HttpClient, RequestOptions } from './src/main/ets/http/HttpClient';
export { ApiError } from './src/main/ets/http/ApiError';
export { apiClient } from './src/main/ets/ApiClient';
export { login, fetchTenantOptions } from './src/main/ets/api/authApi';
export { getWorkbenchSummary, getWorkbenchRecent, listCases } from './src/main/ets/api/legalApi';
