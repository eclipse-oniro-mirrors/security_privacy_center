/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 路由地址配置
 */
export default class RouterConstant {
  //   首页
  static INDEX_URL = 'pages/Index'
  //   权限管理
  static PERMISSION_MANAGEMENT_URL = 'pages/PermissionManagementPage'
  //   权限访问记录
  static PERMISSION_ACCESS_RECORD_URL = 'pages/PermissionAccessRecordPage'
  //   应用权限访问记录
  static PERMISSION_CONTROL_AND_RECORD_URL = 'pages/PermissionControlAndRecordPage'
  //   外部模块条换路径对应表
  static OUTSIDE_ROUTE_PAGE_MAP = new Map([
    ['location_manager_settings', 'pages/PermissionManagementPage']
  ])
}

/**
 * 页面进入方式，需和设置保持一致
 * 当设置传入backMode为1时，点返回跳转到拉起页面
 */
export enum PageRouteMode {
  /**
   * 内部跳转
   */
  INSIDE,
  /**
   * 外部跳转
   */
  OUTSIDE
}