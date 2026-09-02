/**
 * 认证 API —— 对位 contract-api auth 模块
 */
import { apiClient } from './ApiClient';
import {
  LoginRequest,
  TokenResponse,
  TenantOption,
} from '@huntercat/ark-contract-types';

/** 登录（租户 + 账号密码）→ TokenResponse */
export async function login(req: LoginRequest): Promise<TokenResponse> {
  return apiClient.request<TokenResponse>({
    method: 'POST',
    path: '/api/auth/login',
    body: req as Object,
  });
}

/** 当前用户可选租户列表（先登录后选租户场景；body 可缺省） */
export async function fetchTenantOptions(): Promise<TenantOption[]> {
  return apiClient.request<TenantOption[]>({
    method: 'POST',
    path: '/api/auth/tenant-options',
  });
}
