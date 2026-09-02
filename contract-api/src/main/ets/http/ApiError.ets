/**
 * API 错误（业务错误/网络错误统一形态）
 * - status: HTTP 状态码（0 = 网络层失败）
 * - code: 业务错误码（后端 body.error，如 USER_NOT_FOUND）
 * - message: 可展示文案（后端 body.message 或网络错误描述）
 */
export class ApiError extends Error {
  status: number;
  code: string;
  message: string;

  constructor(status: number, message: string, code: string = '') {
    super(message);
    this.status = status;
    this.message = message;
    this.code = code;
  }
}
