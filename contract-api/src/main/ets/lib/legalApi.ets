/**
 * legalmind 业务 API —— 法律工作台 + 案件（对位 contract-types business/legal）
 */
import { apiClient } from './ApiClient';
import { QueryParam } from './HttpClient';
import {
  WorkbenchSummary,
  RecentWorkItem,
  LegalCase,
  LegalPage,
  CaseEvent,
  MatterSchedule,
  TimeEntrySummary,
  LegalDocument,
  ExpenseSummary,
} from '@huntercat/ark-contract-types';

/** 工作台统计 */
export async function getWorkbenchSummary(): Promise<WorkbenchSummary> {
  return apiClient.request<WorkbenchSummary>({
    method: 'GET',
    path: '/api/legal/workbench/summary',
  });
}

/** 最近动态（案件/文书/工时混合流） */
export async function getWorkbenchRecent(): Promise<RecentWorkItem[]> {
  return apiClient.request<RecentWorkItem[]>({
    method: 'GET',
    path: '/api/legal/workbench/recent',
  });
}

/** 案件分页查询（支持筛选） */
export async function listCases(opts: CaseQuery): Promise<LegalPage<LegalCase>> {
  const params: QueryParam[] = [
    { key: 'page', value: `${opts.page ?? 0}` },
    { key: 'size', value: `${opts.size ?? 50}` },
  ];
  if (opts.keyword !== undefined && opts.keyword !== '') {
    params.push({ key: 'keyword', value: opts.keyword });
  }
  if (opts.status !== undefined && opts.status !== '') {
    params.push({ key: 'status', value: opts.status });
  }
  if (opts.stage !== undefined && opts.stage !== '') {
    params.push({ key: 'stage', value: opts.stage });
  }
  return apiClient.request<LegalPage<LegalCase>>({
    method: 'GET',
    path: '/api/legal/cases',
    query: params,
  });
}

export interface CaseQuery {
  keyword?: string;
  status?: string;
  stage?: string;
  page?: number;
  size?: number;
}

/** 案件详情 */
export async function getCase(id: number): Promise<LegalCase> {
  return apiClient.request<LegalCase>({
    method: 'GET',
    path: `/api/legal/cases/${id}`,
  });
}

/** 案件时间线（升序事件流） */
export async function listCaseEvents(caseId: number): Promise<CaseEvent[]> {
  return apiClient.request<CaseEvent[]>({
    method: 'GET',
    path: `/api/legal/cases/${caseId}/events`,
  });
}

/** 日程列表 */
export async function listSchedules(): Promise<MatterSchedule[]> {
  return apiClient.request<MatterSchedule[]>({
    method: 'GET',
    path: '/api/legal/schedules',
  });
}

/** 案件工时统计 */
export async function getCaseTimeSummary(caseId: number): Promise<TimeEntrySummary> {
  return apiClient.request<TimeEntrySummary>({
    method: 'GET',
    path: `/api/legal/cases/${caseId}/time-entries/summary`,
  });
}

/** 案件文书列表 */
export async function listCaseDocuments(caseId: number): Promise<LegalDocument[]> {
  return apiClient.request<LegalDocument[]>({
    method: 'GET',
    path: `/api/legal/cases/${caseId}/documents`,
  });
}

/** 案件费用统计 */
export async function getCaseExpenseSummary(caseId: number): Promise<ExpenseSummary> {
  return apiClient.request<ExpenseSummary>({
    method: 'GET',
    path: `/api/legal/cases/${caseId}/expenses/summary`,
  });
}
