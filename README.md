# lieshou-ark-contract-api

鸿蒙 REST 客户端 HAR —— `@ohos.net.http` 实现（对位 React 的 lieshou-contract-api）。

## 结构

```
contract-api/src/main/ets/
  http/HttpClient.ets     # http 封装（baseUrl/token 注入/JSON/错误解析）
  http/ApiError.ets       # 业务错误统一形态（status/code/message）
  ApiClient.ets           # apiClient 模块级单例（setBaseUrl/setTokenProvider/...）
  api/authApi.ets         # 登录/租户
  api/legalApi.ets        # legalmind 法律工作台 API
open/ark-contract-types/  # submodule：ArkTS 契约类型（类型来源）
```

## 消费方初始化（一次）

```ts
import { apiClient } from '@huntercat/ark-contract-api';
apiClient.setBaseUrl('https://legalmind.lieshou.huntercat.cn'); // 纯域名，禁止 /api
apiClient.setTokenProvider(() => session.accessToken);
apiClient.setUnauthorizedHandler(() => { /* 登出跳登录 */ });
```

## 规则

- path 一律带 `/api` 前缀（gateway 路由）；baseUrl 纯域名（三层一致原则）
- 非 2xx：解析 body `{message, error}` 抛 `ApiError`；HTTP 401 触发 unauthorized 回调
- 全部 async/await + Promise
