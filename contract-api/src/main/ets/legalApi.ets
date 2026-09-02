/**
 * legalmind 业务 API —— 法律工作台（对位 contract-types business/legal）
 */
import { apiClient } from './ApiClient';
import {
  WorkbenchSummary,
  RecentWorkItem,
  LegalCase,
  LegalPage,
} from '@huntercat/ark-contract-types';
import { QueryParam } from './HttpClient';

/** 工作台统计 */
export async function getWorkbenchSummary(): Promise<WorkbenchSummary> {
  return apiClient.request<WorkbenchSummary>({
    method: 'GET',
    path: '/api/legal/workbench/summary',
  });
}

/** 最近动态（案件/文档/工时混合流） */
export async function getWorkbenchRecent(): Promise<RecentWorkItem[]> {
  return apiClient.request<RecentWorkItem[]>({
    method: 'GET',
    path: '/api/legal/workbench/recent',
  });
}

/** 案件分页列表 */
export async function listCases(page: number, size: number): Promise<LegalPage<LegalCase>> {
  const params: QueryParam[] = [
    { key: 'page', value: `${page}` },
    { key: 'size', value: `${size}` },
  ];
  return apiClient.request<LegalPage<LegalCase>>({
    method: 'GET',
    path: '/api/legal/cases',
    query: params,
  });
}
